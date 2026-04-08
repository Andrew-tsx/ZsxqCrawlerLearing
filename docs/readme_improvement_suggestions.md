# README 改进建议

> 针对小白用户的 README 优化方案
> 基于现有 README.md 内容分析

---

## 一、现有问题

### 1. 术语没有解释，小白看不懂

| 原文术语           | 问题                         | 建议补充的解释                         |
|--------------------|------------------------------|----------------------------------------|
| Cookie             | 非技术人员不知道是什么        | "Cookie 是浏览器保存的登录凭证，相当于你的登录通行证" |
| F12 / 开发者工具    | 可能不知道在哪个浏览器可用    | "Chrome 或 Edge 浏览器按 F12"           |
| Network 标签       | 不知道找哪个请求              | "在 Network 标签中找一个包含 `zsxq.com` 的请求" |
| API 请求           | 不知道什么算 API 请求         | 给出具体示例截图说明                    |
| 群组 ID / group_id | 不知道从哪里获取              | 说明"现在会自动获取，不需要手动填写"      |
| `uv sync`          | 不知道 uv 是什么              | "uv 是一个 Python 包管理工具，类似 npm 之于 Node.js" |

### 2. 缺少前置条件说明

README 直接开始克隆项目，但没有说明：
- 需要什么操作系统
- 需要安装哪些软件（Python 3.8+、Node.js、npm）
- 各软件版本要求

### 3. "获取认证信息"部分可以更直观

目前只有文字描述，对于小白来说：
- 不知道 Cookie 长什么样
- 不知道具体要复制的值在哪里
- 建议增加截图或箭头标注

### 4. 缺少常见问题 / FAQ

- Cookie 过期了怎么办？
- 爬取失败/报错怎么办？
- 前端启动报错 `npm` not found 怎么办？
- 数据存在哪里？能不能迁移？

### 5. 重复内容

"提示：已赞助但未收录" 这句话在 README 中出现了两次（第 149 行和第 151 行），需要删除一处。

---

## 二、建议的 README 结构重写

以下是针对小白用户优化后的 README 结构（保留原有内容，补充解释）：

```markdown
<div align="center">
  <img src="images/_Image.png" alt="知识星球数据采集器" width="200">
  <h1>知识星球数据采集器</h1>
  <p>一键采集知识星球的话题、文章、文件，支持 Web 可视化浏览</p>

  [![Python](https://img.shields.io/badge/Python-3.8+-blue.svg)](https://www.python.org/downloads/)
  [![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
</div>

---

## 这是什么工具？

一句话：**帮你把知识星球里的所有内容（帖子、文章、文件、评论）保存到本地**，然后用网页界面浏览和管理。

适用场景：
- 担心知识星球内容丢失，想本地备份
- 想离线阅读星球内容
- 想批量下载星球里的文件

## 开始之前（前置条件）

在安装之前，请确保你的电脑上已经安装了以下软件：

| 软件        | 版本要求       | 下载地址                                        | 检查命令         |
|------------|---------------|-------------------------------------------------|-----------------|
| Python     | 3.8 或更高      | https://www.python.org/downloads/               | `python --version` |
| Node.js    | 18 或更高（用于前端）| https://nodejs.org/                            | `node --version` |
| Git        | 任意版本         | https://git-scm.com/                           | `git --version` |

> **小贴士**：打开"命令提示符"或"终端"，输入检查命令，如果显示版本号就说明已安装。

## 安装步骤

### 第一步：下载项目代码

```bash
git clone https://github.com/2977094657/ZsxqCrawler.git
cd ZsxqCrawler
```

> 如果没有 Git，也可以点击 GitHub 页面上的绿色 "Code" 按钮 → "Download ZIP" 下载解压。

### 第二步：安装 Python 依赖

**方式 A：使用 uv（推荐，更快）**

```bash
# 先安装 uv（Python 包管理器，类似 npm）
pip install uv

# 安装项目依赖
uv sync
```

**方式 B：使用传统 pip**

```bash
pip install requests tomli fastapi uvicorn pydantic loguru
```

### 第三步：安装前端依赖

```bash
cd frontend
npm install
cd ..
```

## 获取知识星球 Cookie（重要）

Cookie 相当于你的"登录通行证"，工具需要它来访问你的知识星球数据。

### 详细图文步骤：

1. 用 **Chrome 或 Edge** 浏览器打开 https://wx.zsxq.com 并登录
2. 按键盘上的 **F12** 键（打开"开发者工具"）
3. 点击顶部的 **Network**（网络）标签
4. 刷新页面（按 F5）
5. 在请求列表中，点击任意一个请求
6. 在右侧面板中找到 **Request Headers**（请求标头）
7. 找到 `Cookie:` 那一行，复制它后面的**整段内容**

> **Cookie 长什么样？** 它是一长串类似这样的文字：
> `zsxq_access_token=xxxxx; abtest_env=xxxxx; ...`
>
> **注意**：Cookie 是敏感信息，不要分享给他人！

## 运行

### 启动后端（第一步）

```bash
# 在项目根目录下运行
uv run main.py
# 或者用传统方式：python main.py
```

看到类似 `Uvicorn running on http://0.0.0.0:8208` 就说明启动成功了。

### 启动前端（第二步，新开一个终端窗口）

```bash
cd frontend
npm run dev
```

### 开始使用

1. 打开浏览器访问 http://localhost:3060
2. 进入"账号管理"页面，粘贴刚才复制的 Cookie
3. 选择你要采集的知识星球
4. 点击"开始采集"！

> 如果前后端不在同一台电脑，需要配置 `frontend/.env.local`：
> ```
> NEXT_PUBLIC_API_BASE_URL=http://你的后端IP:8208
> ```

## 数据存在哪里？

所有数据默认保存在项目的 `output/databases/` 目录下：

```
output/databases/
  └── {星球ID}/
      ├── zsxq_topics_{ID}.db    ← 话题、文章、评论（SQLite 数据库）
      ├── zsxqq_files_{ID}.db    ← 文件列表信息
      ├── downloads/             ← 下载的附件文件
      └── images/                ← 图片缓存（可安全删除）
```

> **提示**：数据库文件可以用 [DB Browser for SQLite](https://sqlitebrowser.org/) 等免费工具打开查看。

## 常见问题

### Q: Cookie 过期了怎么办？
A: 知识星球的 Cookie 会定期过期（通常几天到几周）。过期后重新按照"获取 Cookie"步骤获取新的 Cookie，在"账号管理"中更新即可。

### Q: 爬取时报错怎么办？
A: 最常见的原因是 Cookie 过期，请先尝试更新 Cookie。如果问题持续，请到 GitHub Issues 提交问题。

### Q: 能同时采集多个星球吗？
A: 可以。在"账号管理"中添加 Cookie 后，系统会自动列出你加入的所有星球，逐个选择采集即可。

### Q: 数据库文件可以迁移吗？
A: 可以。整个 `output/databases/` 目录可以直接复制到新机器上，放在项目根目录下即可。

---

（后续保留原有的"界面展示"、"赞助"、"贡献指南"、"许可证"、"免责声明"等内容）
```

---

## 三、总结

| 改动点             | 说明                                         |
|--------------------|----------------------------------------------|
| 添加"这是什么工具"  | 用大白话解释项目用途，让小白 3 秒钟理解       |
| 添加前置条件表      | 明确列出需要安装的软件和检查命令              |
| Cookie 获取步骤细化 | 增加每一步的详细说明和示例                    |
| 添加 FAQ           | 回答最常见的新手问题                          |
| 删除重复文字        | 第 149/151 行重复的提示                      |
| 安装方式二选一      | 同时提供 uv 和 pip 两种方式                  |
