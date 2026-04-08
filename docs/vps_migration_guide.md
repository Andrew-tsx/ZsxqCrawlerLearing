# VPS 迁移操作手册

> 目标：将本机已验证的 Docker 部署迁移到阿里云 ECS（Ubuntu 24.04, 2C2G）
> 前置条件：本机 Docker 部署已成功运行

---

## 整体流程概览

```
方式 A（推荐）：本机导出镜像 tar 包 ── scp 上传 ──→ VPS 导入镜像 → VPS 启动
方式 B（备选）：本机推送镜像到 Docker Hub ──────→ VPS 从 Docker Hub 拉取 → VPS 启动
                                                                  ↕
                              本机 output/  ──── scp 传输 ────→  VPS output/
```

> **方式 A 的优势**：不需要 Docker Hub 账号，不占用公网带宽推送，适合一次性迁移。
> **方式 B 的优势**：适合需要频繁更新的场景，VPS 上一条命令就能拉取最新镜像。

---

## 方式 A：tar 包导入导出（推荐）

### 第一步：本机导出镜像

#### 1.1 重新构建前端（必须）

前端镜像里写死了后端 API 地址。本机的镜像是 `localhost:8208`，在 VPS 上用不了，必须用 VPS 的公网 IP 重新构建：

```powershell
# 把 YOUR_VPS_IP 替换成你的 VPS 公网 IP
docker build -f Dockerfile.frontend --build-arg NEXT_PUBLIC_API_BASE_URL=http://YOUR_VPS_IP:8208 -t zsxq-frontend-vps:latest .
```

> **为什么前端要重新构建？**
> Next.js 的 `NEXT_PUBLIC_*` 环境变量在构建时就被写入了 JavaScript 代码。
> 本机的镜像里写的是 `http://localhost:8208`，到了 VPS 上前端会请求 VPS 自己的 localhost，
> 而不是后端容器。所以必须用 VPS 的真实地址重新构建一次。
> 后端不需要重新构建，因为它不关心外部地址。

#### 1.2 导出镜像为 tar 文件

```powershell
# 导出后端镜像（约 200MB）
docker save -o zsxq-backend.tar zsxqcrawlerlearing-backend:latest

# 导出前端镜像（约 1GB）
docker save -o zsxq-frontend.tar zsxq-frontend-vps:latest
```

导出完成后，当前目录下会有两个 tar 文件。

### 第二步：上传到 VPS

```powershell
# 上传后端镜像
scp zsxq-backend.tar your-user@YOUR_VPS_IP:~/

# 上传前端镜像
scp zsxq-frontend.tar your-user@YOUR_VPS_IP:~/
```

> 两个文件加起来约 1.2GB，上传时间取决于你的上行带宽。
> 如果速度慢，可以先上传后端（小文件），确认流程跑通后再上传前端。

### 第三步：VPS 安装 Docker

#### 3.1 SSH 连接 VPS

```powershell
ssh your-user@YOUR_VPS_IP
```

#### 3.2 安装 Docker

```bash
# 官方一键安装脚本
curl -fsSL https://get.docker.com | sh

# 让当前用户可以使用 docker（免 sudo）
sudo usermod -aG docker $USER

# 退出并重新登录，让权限生效
exit
```

#### 3.3 重新连接并验证

```powershell
ssh your-user@YOUR_VPS_IP
```

```bash
docker --version
docker compose version
```

两个都有版本号输出就说明安装成功。

### 第四步：VPS 导入镜像

```bash
# 导入后端
docker load -i ~/zsxq-backend.tar

# 导入前端
docker load -i ~/zsxq-frontend.tar

# 验证镜像是否存在
docker images
```

应该能看到两个镜像：`zsxqcrawlerlearing-backend` 和 `zsxq-frontend-vps`。

导入完成后可以删除 tar 包释放空间：

```bash
rm ~/zsxq-backend.tar ~/zsxq-frontend.tar
```

### 第五步：VPS 创建配置文件并启动

#### 5.1 创建项目目录

```bash
mkdir -p ~/zsxq && cd ~/zsxq
```

#### 5.2 创建 docker-compose 配置

```bash
nano docker-compose.prod.yml
```

粘贴以下内容（替换 `YOUR_VPS_IP`）：

```yaml
services:
  backend:
    image: zsxqcrawlerlearing-backend:latest
    ports:
      - "8208:8208"
    volumes:
      - ./output:/app/output
    environment:
      - OUTPUT_DIR=/app/output
    restart: unless-stopped

  frontend:
    image: zsxq-frontend-vps:latest
    ports:
      - "80:3000"
    environment:
      - NEXT_PUBLIC_API_BASE_URL=http://YOUR_VPS_IP:8208
    depends_on:
      - backend
    restart: unless-stopped
```

按 `Ctrl+O` → `Enter` 保存，`Ctrl+X` 退出。

#### 5.3 防火墙放行端口

**阿里云 ECS 需要两处放行**：

1. **安全组**（阿里云控制台，必须做）：
   - 登录阿里云控制台 → ECS → 实例 → 安全组 → 添加规则
   - 放行 `80/tcp`（前端）
   - 放行 `8208/tcp`（后端 API）

2. **系统防火墙**（如果 VPS 上启用了 ufw）：

```bash
sudo ufw allow 80/tcp
sudo ufw allow 8208/tcp
sudo ufw reload
```

#### 5.4 启动服务

```bash
cd ~/zsxq
docker compose -f docker-compose.prod.yml up -d
```

#### 5.5 验证

| 检查项 | 命令或地址 |
|--------|-----------|
| 容器状态 | `docker compose -f docker-compose.prod.yml ps` |
| 后端健康检查 | 浏览器访问 `http://YOUR_VPS_IP:8208/api/health` |
| 前端页面 | 浏览器访问 `http://YOUR_VPS_IP` |
| 查看日志 | `docker compose -f docker-compose.prod.yml logs -f` |

如果三个都正常，VPS 部署就成功了。

### 第六步：迁移已有数据

如果你在本机已经爬取了数据，想同步到 VPS：

#### 6.1 本机打包数据

在本机 PowerShell 执行：

```powershell
cd D:\4-codes\4-Zsxq\ZsxqCrawlerLearing
tar czf zsxq-data.tar.gz output/
```

#### 6.2 上传到 VPS

```powershell
scp zsxq-data.tar.gz your-user@YOUR_VPS_IP:~/zsxq/
```

#### 6.3 VPS 上解压

SSH 登录 VPS 后：

```bash
cd ~/zsxq
tar xzf zsxq-data.tar.gz
docker compose -f docker-compose.prod.yml restart backend
```

刷新前端页面，应该能看到迁移过来的数据。

---

## 方式 B：Docker Hub 中转（备选）

如果后续需要频繁更新镜像，可以使用 Docker Hub 作为中转。

### B.1 登录 Docker Hub

```powershell
docker login
```

### B.2 推送后端

```powershell
docker tag zsxqcrawlerlearing-backend:latest YOUR_USERNAME/zsxq-backend:latest
docker push YOUR_USERNAME/zsxq-backend:latest
```

### B.3 构建并推送前端

```powershell
docker build -f Dockerfile.frontend --build-arg NEXT_PUBLIC_API_BASE_URL=http://YOUR_VPS_IP:8208 -t YOUR_USERNAME/zsxq-frontend:latest .
docker push YOUR_USERNAME/zsxq-frontend:latest
```

### B.4 VPS 上拉取

`docker-compose.prod.yml` 中的 `image` 改为 Docker Hub 上的名称：

```yaml
image: YOUR_USERNAME/zsxq-backend:latest
image: YOUR_USERNAME/zsxq-frontend:latest
```

然后：

```bash
docker compose -f docker-compose.prod.yml pull
docker compose -f docker-compose.prod.yml up -d
```

---

## 第七步：绑定域名和 HTTPS（可选）

> 前面的步骤都跑通后再做这一步。

### 7.1 域名解析

在你的域名服务商（如阿里云万网）添加 DNS 解析记录：

| 记录类型 | 主机记录 | 记录值 |
|---------|---------|--------|
| A | @ | YOUR_VPS_IP |
| A | www | YOUR_VPS_IP |

等待 DNS 生效（通常几分钟，最长 48 小时）。

### 7.2 安装 Nginx 和 Certbot

```bash
sudo apt update
sudo apt install -y nginx certbot python3-certbot-nginx
```

### 7.3 创建 Nginx 配置

```bash
sudo nano /etc/nginx/sites-available/zsxq
```

粘贴以下内容（替换 `your-domain.com`）：

```nginx
server {
    listen 80;
    server_name your-domain.com www.your-domain.com;

    # 前端
    location / {
        proxy_pass http://127.0.0.1:80;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }

    # 后端 API
    location /api/ {
        proxy_pass http://127.0.0.1:8208;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }

    # 后端文档
    location /docs {
        proxy_pass http://127.0.0.1:8208;
    }
}
```

### 7.4 启用配置

```bash
sudo ln -s /etc/nginx/sites-available/zsxq /etc/nginx/sites-enabled/
sudo nginx -t                # 检查配置语法
sudo systemctl reload nginx  # 重载配置
```

### 7.5 申请 HTTPS 证书

```bash
sudo certbot --nginx -d your-domain.com -d www.your-domain.com
```

按提示操作（输入邮箱、同意条款）。Certbot 会自动修改 Nginx 配置，启用 HTTPS，并设置自动续期。

完成后访问 `https://your-domain.com` 验证。

---

## VPS 日常管理命令速查

```bash
cd ~/zsxq   # 先进入项目目录，以下命令基于此目录

# 查看容器状态
docker compose -f docker-compose.prod.yml ps

# 查看日志
docker compose -f docker-compose.prod.yml logs -f

# 只看后端日志
docker compose -f docker-compose.prod.yml logs -f backend

# 重启服务
docker compose -f docker-compose.prod.yml restart

# 停止服务
docker compose -f docker-compose.prod.yml down

# 启动服务
docker compose -f docker-compose.prod.yml up -d
```

---

## 常见问题

### 前端打开但数据显示"Failed to fetch"

后端地址配置不对。需要重新构建前端镜像，把 `NEXT_PUBLIC_API_BASE_URL` 改成正确的地址（VPS 公网 IP 或域名）。

### VPS 磁盘空间不足

```bash
# 查看 Docker 占用
docker system df

# 清理无用镜像和缓存
docker system prune -a
```

### 数据库被锁

SQLite 不支持多进程同时写入。确保 backend 只运行一个实例。

---

## 恢复与回滚

如果 VPS 部署出问题，随时可以回退到本机运行：

```powershell
cd D:\4-codes\4-Zsxq\ZsxqCrawlerLearing
docker compose up -d
```

数据始终在本机 `output/` 目录中，不会因为 VPS 操作而丢失。
