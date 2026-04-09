#!/bin/bash
# VPS 诊断脚本
# 用法：bash diagnose.sh

cd ~/zsxq

echo "========== 1. 检查容器状态 =========="
docker compose -f docker-compose.prod.yml ps

echo ""
echo "========== 2. 检查后端健康 =========="
curl -s http://localhost:8208/api/health

echo ""
echo ""
echo "========== 3. 检查数据库话题数 =========="
docker compose -f docker-compose.prod.yml exec backend python -c "
import sqlite3, os, glob
db_dir = '/app/output/databases'
if os.path.exists(db_dir):
    for d in os.listdir(db_dir):
        db_path = os.path.join(db_dir, d, 'zsxq_topics_{}.db'.format(d))
        if os.path.exists(db_path):
            conn = sqlite3.connect(db_path)
            count = conn.execute('SELECT COUNT(*) FROM topics').fetchone()[0]
            print('  群组 {}: {} 条话题'.format(d, count))
else:
    print('  数据库目录不存在')
"

echo ""
echo "========== 4. 测试 ZSXQ API 连通性 =========="
echo "（使用前端保存的 Cookie 测试，不需要手动输入）"
docker compose -f docker-compose.prod.yml exec backend python -c "
import sqlite3, os
config_db = '/app/output/zsxq_config.db'
cookie = ''
if os.path.exists(config_db):
    conn = sqlite3.connect(config_db)
    try:
        row = conn.execute('SELECT cookie FROM accounts ORDER BY created_at ASC LIMIT 1').fetchone()
        if row:
            cookie = row[0]
    except:
        pass
if not cookie:
    print('  未找到已保存的 Cookie，请先在前端页面添加账号')
else:
    import requests
    tail = cookie[-8:] if len(cookie) >= 8 else cookie
    print('  使用 Cookie 尾号: ***{}'.format(tail))
    resp = requests.get('https://api.zsxq.com/v3/users/self', headers={'Cookie': cookie}, timeout=30)
    print('  状态码: {}'.format(resp.status_code))
    data = resp.json()
    if data.get('succeeded'):
        user = data.get('resp_data', {}).get('user', {})
        print('  Cookie 有效！登录用户: {}'.format(user.get('name', '未知')))
    else:
        print('  Cookie 已失效或被拒绝')
        print('  返回内容: {}...'.format(str(data)[:200]))
"

echo ""
echo "========== 5. 检查近期日志 =========="
docker compose -f docker-compose.prod.yml logs --tail=10 backend 2>&1 | grep -v "INFO:" | head -20

echo ""
echo "========== 诊断完成 =========="
