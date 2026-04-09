# Docker 部署指南

> 本文档指导你在本机用 Docker 运行知识星球采集器，并将部署迁移到 VPS。
> 适合 Docker 初学者，每一步都有详细说明。

---

## 目录

- [Docker 部署指南](#docker-部署指南)
  - [目录](#目录)
  - [整体架构](#整体架构)
  - [前置条件](#前置条件)
    - [本机需要安装](#本机需要安装)
  - [第一步：本机 Docker 部署](#第一步本机-docker-部署)
    - [1.1 创建 Dockerfile.backend](#11-创建-dockerfilebackend)
    - [1.2 创建 Dockerfile.frontend](#12-创建-dockerfilefrontend)
    - [1.3 创建 docker-compose.yml](#13-创建-docker-composeyml)
    - [1.4 启动服务](#14-启动服务)
    - [1.5 验证运行](#15-验证运行)
    - [1.6 常用管理命令](#16-常用管理命令)
  - [第二步：迁移到 VPS](#第二步迁移到-vps)
    - [2.1 VPS 环境准备](#21-vps-环境准备)
    - [2.2 迁移方案选择](#22-迁移方案选择)
    - [2.3 方案 A：推送到 Docker Hub（推荐）](#23-方案-a推送到-docker-hub推荐)
    - [2.4 方案 B：直接在 VPS 上构建](#24-方案-b直接在-vps-上构建)
    - [2.5 迁移已有数据](#25-迁移已有数据)
    - [2.6 配置域名和 HTTPS（可选）](#26-配置域名和-https可选)
  - [注意事项](#注意事项)
    - [数据安全](#数据安全)
    - [端口说明](#端口说明)
    - [SQLite 限制](#sqlite-限制)
    - [时区](#时区)
  - [常见问题 FAQ](#常见问题-faq)
  - [总结](#总结)

---

## 整体架构

```
┌─────────────────────────────────────────────────┐
│                Docker Compose                    │
│                                                  │
│   ┌───────────────┐     ┌──────────────────┐    │
│   │   frontend    │     │     backend      │    │
│   │   (Next.js)   │────→│   (FastAPI)      │    │
│   │   端口: 3060   │     │   端口: 8208      │    │
│   └───────────────┘     └────────┬─────────┘    │
│                                  │               │
│                       ┌──────────▼──────────┐   │
│                       │  Volume: ./output    │   │
│                       │  (SQLite + 下载文件)  │   │
│                       └─────────────────────┘   │
└─────────────────────────────────────────────────┘
```

两个容器通过 Docker 内部网络通信。`output` 目录挂载到宿主机，数据不会因容器重启丢失。

---

## 前置条件

### 本机需要安装

| 软件 | 检查命令 | 说明 |
|------|---------|------|
| Docker | `docker --version` | [Docker Desktop 下载](https://www.docker.com/products/docker-desktop/)（Windows/Mac 安装 Desktop 版即可） |
| Docker Compose | `docker compose version` | Docker Desktop 自带，无需单独安装 |

> **Windows 用户**：安装 Docker Desktop 后重启电脑，确保 Docker 正在运行（任务栏右下角有鲸鱼图标）。

---

## 第一步：本机 Docker 部署

在项目根目录下创建以下文件。

### 1.1 创建 Dockerfile.backend

在项目根目录创建 `Dockerfile.backend` 文件：

```dockerfile
# ---- 后端 Dockerfile ----
# 基于精简版 Python 镜像
FROM python:3.11-slim

# 设置时区为上海（项目使用北京时间）
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

WORKDIR /app

# 安装 Python 依赖
COPY pyproject.toml .
RUN pip install --no-cache-dir requests tomli fastapi uvicorn pydantic loguru

# 复制后端源代码
COPY *.py .
COPY config.toml* ./

# 创建数据目录
RUN mkdir -p /app/output

EXPOSE 8208

# 启动后端服务
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8208"]
```

### 1.2 创建 Dockerfile.frontend

在项目根目录创建 `Dockerfile.frontend` 文件：

```dockerfile
# ---- 前端 Dockerfile ----
# 第一阶段：构建
FROM node:20-alpine AS builder

WORKDIR /app

# 安装依赖
COPY frontend/package*.json ./
RUN npm ci

# 复制源代码并构建
COPY frontend/ .
RUN npm run build

# 第二阶段：运行（只保留构建产物，镜像更小）
FROM node:20-alpine

WORKDIR /app
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./
COPY --from=builder /app/public ./public

EXPOSE 3000

# 使用生产模式启动（比 dev 模式更快更稳定）
CMD ["npm", "start"]
```

### 1.3 创建 docker-compose.yml

在项目根目录创建 `docker-compose.yml` 文件：

```yaml
services:
  backend:
    build:
      context: .
      dockerfile: Dockerfile.backend
    ports:
      - "8208:8208"
    volumes:
      # 关键：把 output 目录挂载到宿主机，数据不会丢失
      - ./output:/app/output
    environment:
      - OUTPUT_DIR=/app/output
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "python", "-c", "import urllib.request; urllib.request.urlopen('http://localhost:8208/api/health')"]
      interval: 30s
      timeout: 10s
      retries: 3

  frontend:
    build:
      context: .
      dockerfile: Dockerfile.frontend
    ports:
      - "3060:3000"
    environment:
      # 前端通过 Docker 内部网络访问后端
      # 本机访问用 http://localhost:8208
      # VPS 部署时改为你的域名或公网 IP
      - NEXT_PUBLIC_API_BASE_URL=http://localhost:8208
    depends_on:
      - backend
    restart: unless-stopped
```

### 1.4 启动服务

```bash
# 在项目根目录下执行（第一次会构建镜像，需要几分钟）
docker compose up -d

# 查看构建和启动日志（如果有报错在这里看）
docker compose logs -f
```

> **注意**：如果用老版本的 Docker（< 20.10），命令是 `docker-compose`（带横杠），新版本统一用 `docker compose`（空格）。

### 1.5 验证运行

启动成功后，打开浏览器测试：

| 服务 | 地址 | 预期结果 |
|------|------|---------|
| 后端 API | http://localhost:8208/api/health | 返回 `{"status":"healthy",...}` |
| 后端文档 | http://localhost:8208/docs | 显示 Swagger API 文档页面 |
| 前端界面 | http://localhost:3060 | 显示知识星球采集器界面 |

如果都能正常访问，说明部署成功！

### 1.6 常用管理命令

```bash
# 查看运行状态
docker compose ps

# 查看实时日志
docker compose logs -f

# 只看后端日志
docker compose logs -f backend

# 停止所有服务
docker compose down

# 停止并删除数据（慎用！会清空 output 目录中的数据）
docker compose down -v

# 重新构建并启动（代码更新后）
docker compose up -d --build

# 只重建后端
docker compose up -d --build backend
```

---

## 第二步：迁移到 VPS

当你在本机验证成功后，可以将整个部署迁移到 VPS（云服务器），实现 24 小时在线访问。
若你的vps不能直接访问外网，可参考 [阿里云vps迁移](docs/vps_migration_guide.md)。

### 2.1 VPS 环境准备

在你的 VPS 上安装 Docker：

```bash
# Ubuntu/Debian 系统（最常见）
# 更新系统
sudo apt update && sudo apt upgrade -y

# 安装 Docker
curl -fsSL https://get.docker.com | sh

# 让当前用户可以使用 docker（免 sudo）
sudo usermod -aG docker $USER

# 重新登录 SSH 使权限生效
exit

# 验证安装
docker --version
docker compose version
```

> **CentOS/RHEL 系统**同样可以使用上面的 `get.docker.com` 脚本安装。

### 2.2 迁移方案选择

| 方案 | 优点 | 缺点 | 适合场景 |
|------|------|------|---------|
| **A: Docker Hub** | VPS 只需拉取镜像，部署快 | 需要注册 Docker Hub 账号 | 推荐给所有用户 |
| **B: VPS 上构建** | 不需要额外账号 | VPS 配置低时构建很慢 | VPS 配置 ≥ 2核4G |

### 2.3 方案 A：推送到 Docker Hub（推荐）

**思路**：本机构建好镜像 → 推送到 Docker Hub → VPS 从 Docker Hub 拉取运行。

**第一步：注册 Docker Hub**

1. 访问 https://hub.docker.com/ 注册免费账号
2. 记住你的用户名（下面用 `YOUR_USERNAME` 代替）

**第二步：本机构建并推送镜像**

```bash
# 登录 Docker Hub
docker login

# 构建后端镜像并打标签
docker build -f Dockerfile.backend -t YOUR_USERNAME/zsxq-backend:latest .
docker push YOUR_USERNAME/zsxq-backend:latest

# 构建前端镜像并打标签
# 注意：VPS 部署时前端需要知道后端的公网地址
# 把 YOUR_VPS_IP 换成你的 VPS 公网 IP
docker build -f Dockerfile.frontend \
  --build-arg NEXT_PUBLIC_API_BASE_URL=http://YOUR_VPS_IP:8208 \
  -t YOUR_USERNAME/zsxq-frontend:latest .
docker push YOUR_USERNAME/zsxq-frontend:latest
```

**第三步：在 VPS 上创建 docker-compose.prod.yml**

SSH 登录 VPS，创建项目目录和配置文件：

```bash
mkdir -p ~/zsxq && cd ~/zsxq
```

创建 `docker-compose.prod.yml`：

```yaml
services:
  backend:
    image: YOUR_USERNAME/zsxq-backend:latest
    ports:
      - "8208:8208"
    volumes:
      - ./output:/app/output
    environment:
      - OUTPUT_DIR=/app/output
    restart: unless-stopped

  frontend:
    image: YOUR_USERNAME/zsxq-frontend:latest
    ports:
      - "80:3000"       # 直接用 80 端口，访问时不用加端口号
    environment:
      - NEXT_PUBLIC_API_BASE_URL=http://YOUR_VPS_IP:8208
    depends_on:
      - backend
    restart: unless-stopped
```

**第四步：在 VPS 上启动**

```bash
docker compose -f docker-compose.prod.yml up -d
```

访问 `http://YOUR_VPS_IP` 即可看到前端界面。

### 2.4 方案 B：直接在 VPS 上构建

**第一步：上传代码到 VPS**

```bash
# 方法 1：用 git clone（推荐）
ssh your-vps
git clone https://github.com/2977094657/ZsxqCrawler.git ~/zsxq
cd ~/zsxq

# 方法 2：用 scp 上传本机代码
# 在本机执行（把 your-vps 换成你的 VPS IP 或域名）
scp -r ./ your-vps:~/zsxq
```

**第二步：修改 docker-compose.yml 中的 API 地址**

```bash
# 在 VPS 上编辑 docker-compose.yml
# 将 NEXT_PUBLIC_API_BASE_URL 改为 VPS 的公网地址
```

**第三步：构建并启动**

```bash
cd ~/zsxq
docker compose up -d --build
```

> **注意**：构建过程需要下载依赖和编译前端，在低配 VPS 上可能需要 10-20 分钟，请耐心等待。

### 2.5 迁移已有数据

如果你在本机已经爬取了一些数据，想迁移到 VPS：

```bash
# 在本机执行：打包 output 目录
tar czf zsxq-data.tar.gz output/

# 上传到 VPS
scp zsxq-data.tar.gz your-vps:~/zsxq/

# 在 VPS 上解压
ssh your-vps
cd ~/zsxq
tar xzf zsxq-data.tar.gz
```

数据迁移完成后，重启容器即可识别：

```bash
docker compose restart backend
```

### 2.6 配置域名和 HTTPS（可选）

如果你有域名，可以用 Nginx 反向代理 + Let's Encrypt 免费证书实现 HTTPS。

**安装 Nginx 和 Certbot**：

```bash
sudo apt install -y nginx certbot python3-certbot-nginx
```

**创建 Nginx 配置**：

```bash
sudo nano /etc/nginx/sites-available/zsxq
```

写入以下内容（把 `your-domain.com` 换成你的域名）：

```nginx
server {
    listen 80;
    server_name your-domain.com;

    # 前端
    location / {
        proxy_pass http://127.0.0.1:80;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    # 后端 API
    location /api/ {
        proxy_pass http://127.0.0.1:8208;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    # 后端文档
    location /docs {
        proxy_pass http://127.0.0.1:8208;
    }
}
```

启用配置并申请证书：

```bash
sudo ln -s /etc/nginx/sites-available/zsxq /etc/nginx/sites-enabled/
sudo nginx -t              # 检查配置语法
sudo systemctl reload nginx
sudo certbot --nginx -d your-domain.com   # 申请 HTTPS 证书（自动续期）
```

完成后通过 `https://your-domain.com` 访问。

---

## 注意事项

### 数据安全

| 事项 | 说明 |
|------|------|
| 数据持久化 | `output` 目录通过 Volume 挂载到宿主机，`docker compose down` 不会删除数据 |
| 定期备份 | 建议定期备份 `output/` 目录：`tar czf backup-$(date +%Y%m%d).tar.gz output/` |
| Cookie 安全 | Cookie 通过 Web 界面输入存储在 SQLite 中，不会出现在 Docker 镜像或环境变量中 |

### 端口说明

| 端口 | 服务 | 说明 |
|------|------|------|
| 8208 | 后端 API | FastAPI 服务端口 |
| 3060/3000 | 前端界面 | 3060 是本机映射端口，容器内部是 3000 |
| 80 | Nginx（可选） | VPS 生产环境可以直接用 80 端口 |

### SQLite 限制

- SQLite 适合单实例部署（本项目的设计场景）
- 不要用 Docker 扩展多个 backend 实例，会导致数据损坏
- 如果未来数据量极大（百万级话题），可考虑迁移到 PostgreSQL

### 时区

容器已设置 `TZ=Asia/Shanghai`，日志和数据中的时间都是北京时间。

---

## 常见问题 FAQ

<details>
<summary><b>Q: 本机构建报错 <code>Cannot connect to the Docker daemon</code></b></summary>

Docker 没有启动。打开 Docker Desktop 应用，等待它启动完成后重试。Windows 用户可以在开始菜单搜索 "Docker Desktop"。

</details>

<details>
<summary><b>Q: 前端启动后页面空白或 <code>Failed to fetch</code></b></summary>

前端无法连接后端。检查 `docker-compose.yml` 中的 `NEXT_PUBLIC_API_BASE_URL` 是否正确：
- 本机：`http://localhost:8208`
- VPS：`http://你的VPS公网IP:8208`

修改后需要重新构建前端：`docker compose up -d --build frontend`

</details>

<details>
<summary><b>Q: VPS 上如何更新代码？</b></summary>

方案 A（Docker Hub）：本机重新构建推送，VPS 上 `docker compose pull && docker compose up -d`

方案 B（VPS 构建）：在 VPS 上 `git pull` 然后 `docker compose up -d --build`

</details>

<details>
<summary><b>Q: VPS 磁盘空间不够怎么办？</b></summary>

```bash
# 查看 Docker 占用空间
docker system df

# 清理未使用的镜像和缓存
docker system prune -a

# 清理下载的文件缓存（不影响数据库中的记录）
rm -rf output/databases/*/images/
```

</details>

<details>
<summary><b>Q: 如何查看容器占用的内存和 CPU？</b></summary>

```bash
docker stats
```

</details>

<details>
<summary><b>Q: VPS 的防火墙怎么配置？</b></summary>

需要开放以下端口：

```bash
# Ubuntu UFW 防火墙
sudo ufw allow 80/tcp      # 前端（或 Nginx）
sudo ufw allow 8208/tcp    # 后端 API
sudo ufw reload

# 阿里云/腾讯云：还需要在控制台的"安全组"中放行对应端口
```

</details>

---

## 总结

| 阶段 | 命令 | 耗时 |
|------|------|------|
| 本机部署 | `docker compose up -d` | 首次 3-5 分钟（构建镜像） |
| 迁移数据 | `scp` + `tar` | 取决于数据量 |
| VPS 部署 | `docker compose up -d` | 拉取镜像约 1-2 分钟 |

**推荐流程**：先在本机用 `docker compose up -d` 跑通 → 确认功能正常 → 推送镜像到 Docker Hub → 在 VPS 上拉取运行 → 按需迁移数据。
