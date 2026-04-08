# VPS 迁移操作手册

> 目标：将本机已验证的 Docker 部署迁移到阿里云 ECS（Ubuntu 24.04, 2C2G）
> 前置条件：本机 Docker 部署已成功运行

---

## 整体流程概览

```
本机构建镜像 → 推送到 Docker Hub → VPS 从 Docker Hub 拉取 → VPS 启动服务
         ↕                              ↕
    本机 output/  ──── scp 传输 ────→  VPS output/
```

---

## 第一步：本机推送镜像到 Docker Hub

### 1.1 登录 Docker Hub

在本机 PowerShell 执行：

```powershell
docker login
```

输入你的 Docker Hub 用户名和密码。

### 1.2 推送后端镜像

后端镜像之前构建时已经存在本地，只需要打标签并推送：

```powershell
# 把 YOUR_USERNAME 替换成你的 Docker Hub 用户名
docker tag zsxqcrawlerlearing-backend:latest YOUR_USERNAME/zsxq-backend:latest
docker push YOUR_USERNAME/zsxq-backend:latest
```

### 1.3 重新构建并推送前端镜像

前端需要在构建时指定后端地址（让前端知道 API 在哪里）：

```powershell
# 把 YOUR_USERNAME 和 YOUR_VPS_IP 替换成实际值
docker build -f Dockerfile.frontend --build-arg NEXT_PUBLIC_API_BASE_URL=http://YOUR_VPS_IP:8208 -t YOUR_USERNAME/zsxq-frontend:latest .
docker push YOUR_USERNAME/zsxq-frontend:latest
```

> **注意**：`NEXT_PUBLIC_API_BASE_URL` 中的地址要填 VPS 的公网 IP。如果后续要绑定域名，这里直接填域名，比如 `http://your-domain.com:8208`。

### 1.4 验证推送成功

登录 https://hub.docker.com/ ，在你的个人页面应该能看到两个仓库：
- `zsxq-backend`
- `zsxq-frontend`

---

## 第二步：VPS 安装 Docker

### 2.1 SSH 连接 VPS

```powershell
ssh your-user@YOUR_VPS_IP
```

### 2.2 安装 Docker

```bash
# 官方一键安装脚本
curl -fsSL https://get.docker.com | sh

# 让当前用户可以使用 docker（免 sudo）
sudo usermod -aG docker $USER

# 退出并重新登录，让权限生效
exit
```

### 2.3 重新连接并验证

```powershell
ssh your-user@YOUR_VPS_IP
```

```bash
docker --version
docker compose version
```

两个都有版本号输出就说明安装成功。

---

## 第三步：VPS 创建配置文件

### 3.1 创建项目目录

```bash
mkdir -p ~/zsxq && cd ~/zsxq
```

### 3.2 创建 docker-compose 配置

```bash
nano docker-compose.prod.yml
```

粘贴以下内容（替换 3 处占位符）：

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
      - "80:3000"
    environment:
      - NEXT_PUBLIC_API_BASE_URL=http://YOUR_VPS_IP:8208
    depends_on:
      - backend
    restart: unless-stopped
```

按 `Ctrl+O` → `Enter` 保存，`Ctrl+X` 退出。

### 3.3 防火墙放行端口

**阿里云 ECS 需要两处放行**：

1. **安全组**（阿里云控制台）：
   - 登录阿里云控制台 → ECS → 实例 → 安全组 → 添加规则
   - 放行 `80/tcp`（前端）
   - 放行 `8208/tcp`（后端 API）

2. **系统防火墙**（如果 VPS 上启用了 ufw）：

```bash
sudo ufw allow 80/tcp
sudo ufw allow 8208/tcp
sudo ufw reload
```

---

## 第四步：VPS 启动服务

```bash
cd ~/zsxq
docker compose -f docker-compose.prod.yml up -d
```

等待镜像拉取完成（首次约 1-2 分钟）。

### 验证

| 检查项 | 命令或地址 |
|--------|-----------|
| 容器状态 | `docker compose -f docker-compose.prod.yml ps` |
| 后端健康检查 | 浏览器访问 `http://YOUR_VPS_IP:8208/api/health` |
| 前端页面 | 浏览器访问 `http://YOUR_VPS_IP` |
| 查看日志 | `docker compose -f docker-compose.prod.yml logs -f` |

如果三个都正常，VPS 部署就成功了。

---

## 第五步：迁移已有数据

如果你在本机已经爬取了数据，想同步到 VPS：

### 5.1 本机打包数据

在本机 PowerShell 执行：

```powershell
cd D:\4-codes\4-Zsxq\ZsxqCrawlerLearing
tar czf zsxq-data.tar.gz output/
```

### 5.2 上传到 VPS

```powershell
scp zsxq-data.tar.gz your-user@YOUR_VPS_IP:~/zsxq/
```

### 5.3 VPS 上解压

SSH 登录 VPS 后：

```bash
cd ~/zsxq
tar xzf zsxq-data.tar.gz
docker compose -f docker-compose.prod.yml restart backend
```

刷新前端页面，应该能看到迁移过来的数据。

---

## 第六步：绑定域名和 HTTPS（可选）

> 前五步完成后再做这一步。

### 6.1 域名解析

在你的域名服务商（如阿里云万网）添加 DNS 解析记录：

| 记录类型 | 主机记录 | 记录值 |
|---------|---------|--------|
| A | @ | YOUR_VPS_IP |
| A | www | YOUR_VPS_IP |

等待 DNS 生效（通常几分钟，最长 48 小时）。

### 6.2 安装 Nginx 和 Certbot

```bash
sudo apt update
sudo apt install -y nginx certbot python3-certbot-nginx
```

### 6.3 创建 Nginx 配置

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

### 6.4 启用配置

```bash
sudo ln -s /etc/nginx/sites-available/zsxq /etc/nginx/sites-enabled/
sudo nginx -t                # 检查配置语法
sudo systemctl reload nginx  # 重载配置
```

### 6.5 申请 HTTPS 证书

```bash
sudo certbot --nginx -d your-domain.com -d www.your-domain.com
```

按提示操作（输入邮箱、同意条款）。Certbot 会自动修改 Nginx 配置，启用 HTTPS，并设置自动续期。

完成后访问 `https://your-domain.com` 验证。

---

## VPS 日常管理命令速查

```bash
# 查看容器状态
docker compose -f docker-compose.prod.yml ps

# 查看日志
docker compose -f docker-compose.prod.yml logs -f

# 重启服务
docker compose -f docker-compose.prod.yml restart

# 停止服务
docker compose -f docker-compose.prod.yml down

# 启动服务
docker compose -f docker-compose.prod.yml up -d

# 更新镜像（本机重新 push 后）
docker compose -f docker-compose.prod.yml pull
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
# 本机启动
cd D:\4-codes\4-Zsxq\ZsxqCrawlerLearing
docker compose up -d
```

数据始终在本机 `output/` 目录中，不会因为 VPS 操作而丢失。
