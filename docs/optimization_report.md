# 性能优化报告

> 生成日期：2026-04-08
> 分析范围：ZsxqCrawlerLearing 项目全部 Python 源码（13 个 .py 文件）

---

## 目录

- [问题总览](#问题总览)
- [Critical 级别](#critical-级别)
  - [C-1: get_groups 中 N+1 数据库连接问题](#c-1-get_groups-中-n1-数据库连接问题)
  - [C-2: import_topic_data 无事务批处理](#c-2-import_topic_data-无事务批处理)
  - [C-3: SQLite 连接无线程安全保护](#c-3-sqlite-连接无线程安全保护)
- [High 级别](#high-级别)
  - [H-1: 缺少数据库索引](#h-1-缺少数据库索引)
  - [H-2: get_topic_detail 执行 7+ 次独立查询](#h-2-get_topic_detail-执行-7-次独立查询)
  - [H-3: 内存泄漏 - 全局字典永不清理](#h-3-内存泄漏---全局字典永不清理)
  - [H-4: get_crawler_for_group 每次创建新实例](#h-4-get_crawler_for_group-每次创建新实例)
- [Medium 级别](#medium-级别)
  - [M-1: image_cache_manager 重复文件系统检查](#m-1-image_cache_manager-重复文件系统检查)
  - [M-2: get_timestamp_range_info 3 次查询可合并](#m-2-get_timestamp_range_info-3-次查询可合并)
  - [M-3: 三处重复代码（clean_cookie / headers / UA）](#m-3-三处重复代码clean_cookie--headers--ua)
  - [M-4: _interruptible_sleep 轮询改用 Event](#m-4-_interruptible_sleep-轮询改用-event)
- [Low 级别](#low-级别)
  - [L-1: datetime 在方法内部重复导入](#l-1-datetime-在方法内部重复导入)
- [修改优先级建议](#修改优先级建议)

---

## 问题总览

| #  | 严重性   | 问题简述                               | 文件                          |
|----|---------|----------------------------------------|-------------------------------|
| C-1| Critical| N+1: 每个本地群组打开独立 DB 连接       | `main.py:2378-2435`           |
| C-2| Critical| 导入无事务批处理，数千次 fsync          | `zsxq_database.py:258-323`    |
| C-3| Critical| SQLite 无线程安全保护                   | `zsxq_database.py:13` 等      |
| H-1| High    | 缺少数据库索引                         | `zsxq_database.py` 全文件      |
| H-2| High    | 单话题详情 7+ 次查询                   | `zsxq_database.py:1002-1193`  |
| H-3| High    | 全局字典内存泄漏                       | `main.py:74-80`               |
| H-4| High    | 每次请求创建新 crawler，连接泄漏        | `main.py:282-298`             |
| M-1| Medium  | 图片缓存冗余文件检查                    | `image_cache_manager.py`      |
| M-2| Medium  | 3 次查询可合并为 1 次                   | `zsxq_database.py:480-526`    |
| M-3| Medium  | 三处重复代码                            | 多个文件                       |
| M-4| Medium  | sleep 轮询改用 Event                    | `zsxq_interactive_crawler.py:125` |
| L-1| Low     | datetime 重复导入                       | `zsxq_database.py` 多处        |

---

## Critical 级别

### C-1: get_groups 中 N+1 数据库连接问题

**位置**: `main.py:2378-2435`

**问题说明**:
当群组仅存在于本地（无账号 API 信息）时，`/api/groups` 接口会对每个本地群组分别：
1. 打开一个新的 `ZSXQDatabase` 连接
2. 执行 2-3 次查询（群组信息、时间范围、话题统计）
3. 关闭连接

如果用户有 50 个本地群组，一次页面加载就会打开/关闭 50 个 SQLite 连接。

**修复方案**: 缓存已打开的数据库实例，避免重复创建和销毁。

```python
# 在 main.py 中添加缓存机制
_db_cache: Dict[str, ZSXQDatabase] = {}
_db_cache_lock = threading.Lock()

def _get_topics_db_cached(group_id: str) -> Optional[ZSXQDatabase]:
    """获取缓存的数据库连接，避免重复打开"""
    with _db_cache_lock:
        if group_id not in _db_cache:
            path_manager = get_db_path_manager()
            db_path = path_manager.get_topics_db_path(group_id)
            if os.path.exists(db_path):
                _db_cache[group_id] = ZSXQDatabase(db_path)
            else:
                return None
        return _db_cache.get(group_id)
```

然后在 `get_groups` 中替换 `ZSXQDatabase(topics_db)` 为 `_get_topics_db_cached(str(gid_int))`，并去掉 `db.close()`（由缓存统一管理生命周期）。

---

### C-2: import_topic_data 无事务批处理

**位置**: `zsxq_database.py:258-323`

**问题说明**:
`import_topic_data` 对单个话题执行约 10+ 条 SQL（group、user、topic、talk、images、likes、comments、tags 等），但没有显式事务包裹。SQLite 在 autocommit 模式下，每条 INSERT/UPDATE 都是一个独立事务，每次事务提交都需要磁盘 fsync。

批量爬取数百个话题时，这会导致数千次磁盘同步，严重拖慢爬取速度。

**修复方案**:

1. 在 `ZSXQDatabase` 中添加事务控制方法：

```python
class ZSXQDatabase:
    def begin_transaction(self):
        """开始事务"""
        self.cursor.execute("BEGIN TRANSACTION")

    def commit_transaction(self):
        """提交事务"""
        self.conn.commit()

    def rollback_transaction(self):
        """回滚事务"""
        self.conn.rollback()
```

2. 修改 `import_topic_data`，在方法结尾统一 commit：

```python
def import_topic_data(self, topic_data: Dict[str, Any]) -> bool:
    try:
        topic_id = topic_data.get('topic_id')
        if not topic_id:
            return False

        # ... 所有子操作不变（_upsert_group, _import_all_users 等）...

        return True
    except Exception as e:
        print(f"❌ 导入话题数据失败: {e}")
        return False
    # 注意：不在此处 commit，由调用方控制
```

3. 在爬虫循环中批量提交：

```python
# zsxq_interactive_crawler.py 中
BATCH_COMMIT_SIZE = 20

for i, topic in enumerate(topics):
    if self.is_stopped():
        break
    self.db.import_topic_data(topic)
    if (i + 1) % BATCH_COMMIT_SIZE == 0:
        self.db.conn.commit()
        self.log(f"💾 已提交 {i + 1} 条话题到数据库")

self.db.conn.commit()  # 提交剩余的
```

---

### C-3: SQLite 连接无线程安全保护

**位置**: `zsxq_database.py:13`, `zsxq_file_database.py:11`, `zsxq_columns_database.py`（类构造函数）

**问题说明**:
所有数据库类都使用 `sqlite3.connect(db_path, check_same_thread=False)` 允许跨线程使用，但没有加锁保护。FastAPI 的异步处理程序通过 `asyncio.to_thread` 在线程池中执行同步代码，多个请求可能同时操作同一个数据库对象。

只有 `accounts_sql_manager.py` 正确地使用了 `threading.RLock()`。

并发写入时可能导致：
- `ProgrammingError: SQLite objects created in a thread can only be used in that same thread`
- 数据损坏

**修复方案**:

```python
import threading

class ZSXQDatabase:
    def __init__(self, db_path: str = "zsxq_interactive.db"):
        self.db_path = db_path
        self._lock = threading.RLock()  # 可重入锁
        self.conn = sqlite3.connect(db_path, check_same_thread=False)
        self.conn.execute("PRAGMA journal_mode=WAL;")  # WAL 模式提升并发读
        self.cursor = self.conn.cursor()
        self._init_database()

    def import_topic_data(self, topic_data: Dict[str, Any]) -> bool:
        with self._lock:
            # ... 原有逻辑 ...

    def get_topic_detail(self, topic_id: int):
        with self._lock:
            # ... 原有逻辑 ...

    # 所有公开方法都加 with self._lock
```

同样需要修改 `ZSXQFileDatabase` 和 `ZSXQColumnsDatabase`。

---

## High 级别

### H-1: 缺少数据库索引

**位置**: `zsxq_database.py:17-256`（所有 CREATE TABLE 语句之后）

**问题说明**:
几乎所有高频查询涉及的列都缺少索引。没有索引时，每次查询都是全表扫描。以下是最常用的查询模式及其缺少的索引：

| 查询场景                 | 涉及表       | 缺少索引的列              |
|-------------------------|-------------|--------------------------|
| 话题列表按时间排序        | `topics`    | `create_time`            |
| 按群组过滤话题           | `topics`    | `group_id`               |
| 话题详情查评论           | `comments`  | `topic_id`               |
| 话题详情查内容           | `talks`     | `topic_id`               |
| 话题详情查图片           | `images`    | `topic_id`               |
| 话题详情查文件           | `topic_files`| `topic_id`              |
| 话题详情查点赞           | `likes`     | `topic_id`               |
| 标签按群组过滤           | `tags`      | `group_id`               |

**修复方案**: 在 `_init_database()` 末尾添加：

```python
def _init_database(self):
    # ... 所有 CREATE TABLE 语句 ...

    # 创建索引（IF NOT EXISTS 保证幂等）
    indexes = [
        "CREATE INDEX IF NOT EXISTS idx_topics_create_time ON topics(create_time)",
        "CREATE INDEX IF NOT EXISTS idx_topics_group_id ON topics(group_id)",
        "CREATE INDEX IF NOT EXISTS idx_comments_topic_id ON comments(topic_id)",
        "CREATE INDEX IF NOT EXISTS idx_talks_topic_id ON talks(topic_id)",
        "CREATE INDEX IF NOT EXISTS idx_images_topic_id ON images(topic_id)",
        "CREATE INDEX IF NOT EXISTS idx_topic_files_topic_id ON topic_files(topic_id)",
        "CREATE INDEX IF NOT EXISTS idx_likes_topic_id ON likes(topic_id)",
        "CREATE INDEX IF NOT EXISTS idx_talks_owner ON talks(owner_user_id)",
        "CREATE INDEX IF NOT EXISTS idx_tags_group_id ON tags(group_id)",
        "CREATE INDEX IF NOT EXISTS idx_topic_tags_topic ON topic_tags(topic_id)",
        "CREATE INDEX IF NOT EXISTS idx_topic_tags_tag ON topic_tags(tag_id)",
    ]
    for idx_sql in indexes:
        self.cursor.execute(idx_sql)

    self.conn.commit()
```

> **注意**: 如果数据库已有大量数据，添加索引可能需要几分钟时间。建议在首次运行时自动执行。

---

### H-2: get_topic_detail 执行 7+ 次独立查询

**位置**: `zsxq_database.py:1002-1193`

**问题说明**:
获取单个话题详情需要 7 次独立 SQL 查询：
1. 话题基本信息 + 群组信息
2. Talk 内容 + 作者
3. 话题图片
4. 话题文件
5. 文章信息
6. 最新点赞
7. 评论

每次查询都需要获取/释放数据库锁，在高并发场景下会显著增加延迟。

**修复方案**:

部分查询可以用子查询或 CTE 合并。但由于 SQLite 对并发读的 WAL 模式支持良好，更实际的优化是：

1. 对于列表页（非详情页），只查询基本信息，不做 7 次查询
2. 对于详情页，可以保留多次查询但确保有索引（H-1）
3. 如果确实需要进一步优化，可以合并 talk + topic + group 为一条查询：

```python
def get_topic_detail(self, topic_id: int):
    # 合并：话题 + talk + 用户 + 群组（一条查询）
    self.cursor.execute('''
        SELECT
            t.topic_id, t.type, t.title, t.create_time,
            t.digested, t.sticky, t.likes_count, t.comments_count,
            t.reading_count, t.annotation,
            tk.text as talk_text,
            u.user_id, u.name, u.avatar_url,
            g.group_id, g.name as group_name
        FROM topics t
        LEFT JOIN talks tk ON t.topic_id = tk.topic_id
        LEFT JOIN users u ON tk.owner_user_id = u.user_id
        LEFT JOIN groups g ON t.group_id = g.group_id
        WHERE t.topic_id = ?
    ''', (topic_id,))

    # 图片、文件、点赞、评论仍需单独查询（数据量可变）
    # 但已从 7 次减少到 4-5 次
```

---

### H-3: 内存泄漏 - 全局字典永不清理

**位置**: `main.py:74-80`

**问题说明**:
以下全局字典在任务完成后不会清理：
- `current_tasks` — 任务状态
- `task_logs` — 任务日志（每条日志都包含完整时间戳和消息文本）
- `task_stop_flags` — 停止标志
- `sse_connections` — SSE 连接
- `file_downloader_instances` — 文件下载器实例

如果用户频繁创建爬取/下载任务，这些字典会持续增长。特别是 `task_logs`，每个话题的每条日志都会永久保留。

**修复方案**:

添加定期清理函数：

```python
def cleanup_old_tasks(max_age_hours: int = 24):
    """清理过期任务数据"""
    now = datetime.now()
    expired_ids = []
    for task_id, task in current_tasks.items():
        if task["status"] in ("completed", "failed", "cancelled"):
            age = (now - task["updated_at"]).total_seconds()
            if age > max_age_hours * 3600:
                expired_ids.append(task_id)

    for task_id in expired_ids:
        current_tasks.pop(task_id, None)
        task_logs.pop(task_id, None)
        task_stop_flags.pop(task_id, None)
        sse_connections.pop(task_id, None)
        file_downloader_instances.pop(task_id, None)
```

可以通过定时任务或在创建新任务时顺带清理。

---

### H-4: get_crawler_for_group 每次创建新实例

**位置**: `main.py:282-298`

**问题说明**:
每次 API 请求都创建新的 `ZSXQInteractiveCrawler` 实例，其中会打开新的 `ZSXQDatabase` 连接。旧实例和连接从未关闭。浏览话题列表、查看详情等操作会在短时间内打开大量连接。

**修复方案**:

```python
_crawler_cache: Dict[str, ZSXQInteractiveCrawler] = {}
_crawler_cache_lock = threading.Lock()

def get_crawler_for_group(group_id: str, log_callback=None) -> ZSXQInteractiveCrawler:
    """为指定群组获取爬虫实例（带缓存）"""
    with _crawler_cache_lock:
        if group_id in _crawler_cache:
            crawler = _crawler_cache[group_id]
            if log_callback:
                crawler.log_callback = log_callback
            return crawler

    # 创建新实例（在锁外，避免持锁时间过长）
    config = load_config()
    if not config:
        raise HTTPException(status_code=500, detail="配置文件加载失败")

    cookie = get_cookie_for_group(group_id)
    if not cookie or cookie == "your_cookie_here":
        raise HTTPException(status_code=400, detail="未找到可用Cookie")

    path_manager = get_db_path_manager()
    db_path = path_manager.get_topics_db_path(group_id)

    crawler = ZSXQInteractiveCrawler(cookie, group_id, db_path, log_callback)

    with _crawler_cache_lock:
        _crawler_cache[group_id] = crawler

    return crawler
```

---

## Medium 级别

### M-1: image_cache_manager 重复文件系统检查

**位置**: `image_cache_manager.py:109-153, 155-198`

**问题说明**:
`is_cached()` 检查 5 个扩展名（5 次 `Path.exists()`），`get_cached_path()` 先调用 `is_cached()`（5 次），再遍历 5 个扩展名。`download_and_cache()` 又先调用 `is_cached()` 再调用 `get_cached_path()`。

如果图片已缓存，一次 `download_and_cache()` 调用会执行最多 15 次文件系统检查。

**修复方案**:

```python
def _find_cached_file(self, url: str) -> Optional[Path]:
    """一次性查找缓存文件，替代 is_cached + get_cached_path 的组合"""
    if not url:
        return None
    cache_key = self._get_cache_key(url)
    for ext in ['.jpg', '.png', '.gif', '.webp', '.bmp']:
        cache_file = self.cache_dir / f"{cache_key}{ext}"
        if cache_file.exists():
            return cache_file
    return None

def is_cached(self, url: str) -> bool:
    return self._find_cached_file(url) is not None

def get_cached_path(self, url: str) -> Optional[Path]:
    return self._find_cached_file(url)

def download_and_cache(self, url: str, timeout: int = 30):
    cached = self._find_cached_file(url)
    if cached:
        return True, cached, None
    # ... 下载逻辑 ...
```

---

### M-2: get_timestamp_range_info 3 次查询可合并

**位置**: `zsxq_database.py:480-526`

**问题说明**:
最新时间、最老时间、话题总数分别用 3 条 SQL 查询，可以合并为 1 条。

**修复方案**:

```python
def get_timestamp_range_info(self) -> Dict[str, Any]:
    try:
        self.cursor.execute('''
            SELECT
                MAX(CASE WHEN create_time IS NOT NULL AND create_time != ''
                         THEN create_time END),
                MIN(CASE WHEN create_time IS NOT NULL AND create_time != ''
                         THEN create_time END),
                COUNT(*)
            FROM topics
        ''')
        row = self.cursor.fetchone()
        newest, oldest, total = row[0], row[1], row[2]
        has_data = newest is not None and oldest is not None
        return {
            'newest_time': newest,
            'oldest_time': oldest,
            'newest_timestamp': newest,
            'oldest_timestamp': oldest,
            'total_topics': total,
            'has_data': has_data
        }
    except Exception as e:
        print(f"获取时间戳范围信息失败: {e}")
        return {
            'newest_time': None, 'oldest_time': None,
            'newest_timestamp': None, 'oldest_timestamp': None,
            'total_topics': 0, 'has_data': False
        }
```

---

### M-3: 三处重复代码（clean_cookie / headers / UA）

**位置**:
- `zsxq_interactive_crawler.py:132-178` 和 `zsxq_file_downloader.py:143-188` — `clean_cookie` 方法完全相同
- `main.py:383-416`、`zsxq_interactive_crawler.py:207-255`、`zsxq_file_downloader.py:190-200` — User-Agent 列表和 headers 构建逻辑重复

**问题说明**:
三处维护着相同的 User-Agent 列表和 Cookie 清理逻辑。如果需要更新 UA 或修改清理规则，需要同时修改三个地方。

**修复方案**: 提取到共享模块 `utils.py`：

```python
# utils.py
"""共享工具函数"""
import random
import time
from typing import Dict

# 统一的 User-Agent 池
USER_AGENTS = [
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:132.0) Gecko/20100101 Firefox/132.0",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36 Edg/131.0.0.0",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36",
    "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36",
]

def clean_cookie(cookie: str) -> str:
    """清理 Cookie 字符串"""
    # ... 原有逻辑 ...

def build_stealth_headers(cookie: str) -> Dict[str, str]:
    """构建反检测请求头"""
    return {
        "Accept": "application/json, text/plain, */*",
        "Cookie": cookie,
        "User-Agent": random.choice(USER_AGENTS),
        "X-Timestamp": str(int(time.time())),
        # ... 其他头部 ...
    }
```

---

### M-4: _interruptible_sleep 轮询改用 Event

**位置**: `zsxq_interactive_crawler.py:125-131`

**问题说明**:
当前实现每 0.1 秒轮询一次停止标志。长休眠 300 秒时产生 3000 次 `time.time()` + `time.sleep(0.1)` 调用。

**修复方案**:

```python
import threading

class ZSXQInteractiveCrawler:
    def __init__(self, ...):
        # ...
        self._stop_event = threading.Event()

    def set_stop_flag(self):
        self.stop_flag = True
        self._stop_event.set()  # 立即唤醒所有等待中的 sleep

    def _interruptible_sleep(self, duration: float):
        """可中断的睡眠，使用 Event 替代轮询"""
        self._stop_event.wait(timeout=duration)
        # wait 返回 True 表示被 set()（收到停止信号）
        # wait 返回 False 表示超时（正常醒来）
```

同样适用于 `ZSXQFileDownloader`。

---

## Low 级别

### L-1: datetime 在方法内部重复导入

**位置**: `zsxq_database.py` 中至少 8 处

```python
# 当前写法（在方法内部重复）
def _upsert_group(self, ...):
    from datetime import datetime, timezone, timedelta
    beijing_tz = timezone(timedelta(hours=8))
    current_time = datetime.now(beijing_tz).strftime(...) + '+0800'
```

**修复方案**:

```python
# 文件顶部
from datetime import datetime, timezone, timedelta

# 模块级常量
_BEIJING_TZ = timezone(timedelta(hours=8))

def _now_beijing() -> str:
    """获取当前北京时间字符串"""
    return datetime.now(_BEIJING_TZ).strftime('%Y-%m-%dT%H:%M:%S.%f')[:-3] + '+0800'

# 使用
def _upsert_group(self, ...):
    current_time = _now_beijing()
```

---

## 修改优先级建议

推荐按以下顺序逐步实施优化：

### 第一阶段（立即可做，风险低）
1. **H-1**: 添加数据库索引 — 纯粹加索引，不改动现有逻辑，立竿见影
2. **L-1**: 提取 datetime 导入 — 纯重构，无行为变化
3. **M-3**: 提取共享代码到 utils.py — 减少重复

### 第二阶段（需要测试验证）
4. **C-2**: 添加事务批处理 — 需要验证爬虫循环的 commit 时机
5. **C-3**: 添加线程锁 — 需要压力测试验证无死锁
6. **H-4**: 缓存 crawler 实例 — 需要验证 Cookie 更新场景

### 第三阶段（较大改动）
7. **C-1**: 重构 get_groups 的 N+1 问题
8. **H-2**: 合并 get_topic_detail 的查询
9. **H-3**: 添加任务清理机制
10. **M-1, M-2, M-4**: 其他中等优先级优化

---

> **备注**: 每项修改建议在独立分支上进行，配合功能测试验证无回归后再合并。
