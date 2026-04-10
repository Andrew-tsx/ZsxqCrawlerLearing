# fetch3

评论的接口

## fetch

```js
fetch("https://api.zsxq.com/v2/topics/45544412415158558/comments", {
  "headers": {
    "accept": "application/json, text/plain, */*",
    "accept-language": "zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6",
    "content-type": "application/json",
    "priority": "u=1, i",
    "sec-ch-ua": "\"Chromium\";v=\"146\", \"Not-A.Brand\";v=\"24\", \"Microsoft Edge\";v=\"146\"",
    "sec-ch-ua-mobile": "?0",
    "sec-ch-ua-platform": "\"Windows\"",
    "sec-fetch-dest": "empty",
    "sec-fetch-mode": "cors",
    "sec-fetch-site": "same-site",
    "sec-gpc": "1",
    "x-aduid": "587c45f2a-957f-2c43-a7ea-09178c30e53",
    "x-request-id": "301baa95a-789c-d22c-daf0-762d314e9cf",
    "x-signature": "659086e20365b8eb9dee90deb26044018633cb14",
    "x-timestamp": "1775784571",
    "x-version": "2.89.0",
    "cookie": "zsxq_access_token=383F5918-31CD-44B0-B173-BD0C8E9727E5_85487ECE94F2CA08; sensorsdata2015jssdkcross=%7B%22distinct_id%22%3A%22421114288542428%22%2C%22first_id%22%3A%2219d6bd0ba0b28a-028f7c860143a28-4c657b58-2073600-19d6bd0ba0c37%22%2C%22props%22%3A%7B%7D%2C%22identities%22%3A%22eyIkaWRlbnRpdHlfY29va2llX2lkIjoiMTlkNmJkMGJhMGIyOGEtMDI4ZjdjODYwMTQzYTI4LTRjNjU3YjU4LTIwNzM2MDAtMTlkNmJkMGJhMGMzNyIsIiRpZGVudGl0eV9sb2dpbl9pZCI6IjQyMTExNDI4ODU0MjQyOCJ9%22%2C%22history_login_id%22%3A%7B%22name%22%3A%22%24identity_login_id%22%2C%22value%22%3A%22421114288542428%22%7D%7D; abtest_env=product",
    "Referer": "https://wx.zsxq.com/"
  },
  "body": "{\"req_data\":{\"text\":\"鳗鱼哥，请教一下，文中说的：“保持思维的定力和独立性。”如何保持或者获取这种思考能力？我感觉我的认知边界不够，针对很多事情难以做出判断，反而容易被别人的观点说服。不管是简中互联网还是外网，我感觉越看越迷茫，而且有很严重的割裂感，内部歌舞升平，外部忧患拉满。更直白的说，我甚至有时候分不清什么是抹黑的言论，什么是客观的评价[捂脸]\\n\",\"image_ids\":[],\"mentioned_user_ids\":[]}}",
  "method": "POST"
});
```

## 预览

```js
{
    "succeeded": true,
    "resp_data": {
        "comment": {
            "comment_id": 5125484115881124,
            "create_time": "2026-04-10T09:29:33.830+0800",
            "owner": {
                "user_id": 421114288542428,
                "name": "贪睡熊",
                "avatar_url": "https://images.zsxq.com/Fm-96NLbHEqEOIguF5hAYgGgj1KH?imageMogr2/auto-orient/thumbnail/150x/format/jpg/blur/1x0/quality/75/ignore-error/1&e=1780243199&token=q6iZ0sQtf9U7s1qz0r4yMawNq3-u2w6lbnai6y2J:Qz8vdrMR2Hl0WHtjj85JVowU6m8=",
                "location": "上海"
            },
            "text": "鳗鱼哥，请教一下，文中说的：“保持思维的定力和独立性。”如何保持或者获取这种思考能力？我感觉我的认知边界不够，针对很多事情难以做出判断，反而容易被别人的观点说服。不管是简中互联网还是外网，我感觉越看越迷茫，而且有很严重的割裂感，内部歌舞升平，外部忧患拉满。更直白的说，我甚至有时候分不清什么是抹黑的言论，什么是客观的评价[捂脸]",
            "likes_count": 0,
            "group_owner_liked": false,
            "topic_owner_liked": false,
            "rewards_count": 0,
            "sticky": false
        }
    }
}
```