<div align="center">
  <img src="images/_Image.png" alt="知识星球数据采集器" width="200">
  <h1>知识星球数据采集器</h1>
  <p>一键采集知识星球的话题、文章、文件，支持 Web 可视化浏览和管理</p>

  [![Python](https://img.shields.io/badge/Python-3.8+-blue.svg)](https://www.python.org/downloads/) [![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE) [![Platform](https://img.shields.io/badge/Platform-Windows | Linux | macOS-lightgrey.svg)]()

  <img src="images/info.png" alt="群组详情页面" height="400">
</div>

## 这是什么工具？

**帮你把知识星球里的所有内容（帖子、文章、文件、评论）保存到本地**，然后用网页界面浏览和管理。

适用场景：
- 担心知识星球内容丢失，想本地备份
- 想离线阅读星球内容
- 想批量下载星球里的文件

## 开始之前（前置条件）

在安装之前，请确保你的电脑上已经安装了以下软件。

> **小贴士**：打开"命令提示符"（Windows）或"终端"（Mac/Linux），输入检查命令，如果显示版本号就说明已安装。

| 软件 | 版本要求 | 下载地址 | 检查命令 |
|------|---------|---------|---------|
| Python | 3.8 或更高 | [python.org/downloads](https://www.python.org/downloads/) | `python --version` |
| Node.js | 18 或更高（用于前端） | [nodejs.org](https://nodejs.org/) | `node --version` |
| npm | 随 Node.js 一起安装 | 同上 | `npm --version` |
| Git | 任意版本 | [git-scm.com](https://git-scm.com/) | `git --version` |

> **Windows 用户注意**：安装 Python 时请勾选 "Add Python to PATH"（将 Python 添加到环境变量），否则命令行中无法使用 `python` 命令。

## 安装步骤

### 第一步：下载项目代码

```bash
git clone https://github.com/2977094657/ZsxqCrawler.git
cd ZsxqCrawler
```

> 如果没有 Git，也可以点击 GitHub 页面上的绿色 **"Code"** 按钮 → **"Download ZIP"** 下载并解压。

### 第二步：安装 Python 依赖

**方式 A：使用 uv（推荐，速度更快）**

```bash
# 先安装 uv（一个 Python 包管理器，类似 npm 之于 Node.js）
pip install uv

# 安装项目所需的所有 Python 库
uv sync
```

**方式 B：使用传统 pip**

```bash
pip install requests tomli fastapi uvicorn pydantic loguru
```

> 如果 `pip` 命令不可用，试试 `pip3` 或 `python -m pip install`。

### 第三步：安装前端依赖

```bash
cd frontend
npm install
cd ..
```

## 获取知识星球 Cookie（重要）

Cookie 相当于你的**"登录通行证"**，工具需要它来访问你的知识星球数据。下面教你如何获取。

### 详细步骤：

1. 用 **Chrome 或 Edge** 浏览器打开 [wx.zsxq.com](https://wx.zszq.com) 并登录你的知识星球账号
2. 按键盘上的 **F12** 键（打开"开发者工具"面板）
3. 点击顶部标签栏中的 **Network**（网络）
4. **刷新页面**（按 F5），此时 Network 标签下会出现很多请求
5. 在请求列表中，**点击任意一个请求**（优先选择包含 `zsxq.com` 的）
6. 在右侧面板中找到 **Request Headers**（请求标头）部分
7. 找到 `Cookie:` 那一行，复制它后面的**整段内容**

> **Cookie 长什么样？** 是一长串类似这样的文字：
> ```
> zsxq_access_token=xxxxx; abtest_env=xxxxx; _ga=xxxxx; ...
> ```

> **注意**：Cookie 是你的登录凭证，**不要分享给他人**！如同不要把密码告诉别人一样。

## 运行

### 方式一：Web 界面（推荐）

需要开两个终端窗口（一个跑后端，一个跑前端）。

**第一个终端 — 启动后端：**

```bash
# 在项目根目录下运行
uv run main.py

# 或者用传统方式：
# python main.py
```

看到类似 `Uvicorn running on http://0.0.0.0:8208` 的输出，就说明后端启动成功了。

**第二个终端 — 启动前端：**

```bash
cd frontend
npm run dev
```

看到类似 `Ready in 2s` 的输出，就说明前端启动成功了。

**开始使用：**

1. 打开浏览器访问 http://localhost:3060
2. 进入 **"账号管理"** 页面，粘贴刚才复制的 Cookie，点击保存
3. 系统会自动列出你加入的所有星球，选择你想采集的星球
4. 点击 **"开始采集"**，等待爬取完成即可

> 如果前后端不在同一台电脑上，需要在前端项目目录下创建 `frontend/.env.local` 文件，写入：
> ```
> NEXT_PUBLIC_API_BASE_URL=http://你的后端IP地址:8208
> ```

### 方式二：命令行工具

```bash
# 运行交互式命令行工具（不需要前端界面）
uv run zsxq_interactive_crawler.py
```

<div align="center">
  <img src="images/QQ20250703-170055.png" alt="命令行界面" height="400">
  <p><em>命令行界面 - 交互式操作控制台</em></p>
</div>

## 界面展示

### Web 界面

<div align="center">
  <img src="images/home.png" alt="首页界面" height="400">
  <p><em>首页 - 群组选择和概览</em></p>
</div>

<div align="center">
  <img src="images/config.png" alt="配置页面" height="400">
  <p><em>配置页面 - 爬取间隔设置</em></p>
</div>

<div align="center">
  <img src="images/log.png" alt="日志页面" height="400">
  <p><em>日志页面 - 实时任务执行日志</em></p>
</div>

<div align="center">
  <img src="images/column.png" alt="专栏文章页面" height="400">
  <p><em>专栏文章页面 - 专栏目录浏览、文章内容展示与视频下载</em></p>
</div>

## 数据存储与下载路径

所有数据默认保存在项目的 `output/databases/` 目录下，不同星球按 ID 分文件夹存放：

```
output/databases/
  └── {星球ID}/
      ├── zsxq_topics_{ID}.db    ← 话题、文章、评论（SQLite 数据库文件）
      ├── zsxq_files_{ID}.db     ← 文件列表和下载状态信息
      ├── zsxq_columns_{ID}.db   ← 专栏文章数据
      ├── downloads/             ← 下载的附件文件
      └── images/                ← 图片缓存（可安全删除，访问时自动重新生成）
```

> **提示**：`.db` 文件是 SQLite 数据库，可以用免费工具 [DB Browser for SQLite](https://sqlitebrowser.org/) 打开查看内容。

> **数据可以迁移吗？** 可以！直接把整个 `output/databases/` 文件夹复制到新机器的项目根目录下即可。

## Docker 部署（进阶）

如果你熟悉 Docker，可以使用 Docker Compose 一键部署。详见 [Docker 部署文档](docs/docker_deployment_analysis.md)。

```bash
# 一键启动（需要安装 Docker 和 Docker Compose）
docker-compose up -d
```

## 常见问题

<details>
<summary><b>Cookie 过期了怎么办？</b></summary>

知识星球的 Cookie 会定期过期（通常几天到几周）。过期后爬取会失败。解决方法：重新按照上面的"获取 Cookie"步骤获取新的 Cookie，在 Web 界面的"账号管理"中更新即可。

</details>

<details>
<summary><b>爬取时报错怎么办？</b></summary>

最常见的原因是 Cookie 过期，请先尝试更新 Cookie。如果问题持续，请到 [GitHub Issues](https://github.com/2977094657/ZsxqCrawler/issues) 提交问题，附上报错信息。

</details>

<details>
<summary><b>前端启动报错 <code>npm: command not found</code> 怎么办？</b></summary>

说明没有安装 Node.js。请前往 [nodejs.org](https://nodejs.org/) 下载安装，安装后重启终端再试。

</details>

<details>
<summary><b>能同时采集多个星球吗？</b></summary>

可以。添加 Cookie 后，系统会自动列出你加入的所有星球。你可以逐个选择采集，数据会按星球 ID 分开存储。

</details>

<details>
<summary><b>数据存太多会不会占空间？</b></summary>

主要占空间的是下载的附件文件。数据库文件（`.db`）本身很小，几万条话题通常只有几十 MB。如果磁盘空间紧张，可以删除 `images/` 缓存目录（下次访问时会自动重新下载）。

</details>

## 赞助与支持

如果本项目对你有帮助，请前往支持原作者。
<https://github.com/2977094657/ZsxqCrawler>

## 贡献指南

欢迎提交 Issue 和 Pull Request！

## 许可证

本项目采用 [MIT License](LICENSE) 开源协议。

## 免责声明

本工具仅供学习和研究使用，请遵守知识星球的服务条款和相关法律法规。使用本工具产生的任何后果由使用者自行承担。

---

<div align="center">
  <p>如果这个项目对你有帮助，请给个 Star 支持一下。</p>
</div>
