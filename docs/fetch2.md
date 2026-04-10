# fetch2

这个接口是针对某一个话题，点击【查看详情】按钮后出来的。据我观察里面只是返回评论。

## 常规

请求 URL
https://api.zsxq.com/v2/topics/55522284244482854/comments?sort=asc&count=30&with_sticky=true
请求方法
GET
状态代码
200 OK
Remote Address
106.75.29.131:443
引用站点策略
strict-origin-when-cross-origin

## Response headers

access-control-allow-credentials
true
access-control-allow-headers
X-Requested-With,Authorization,Content-Type,X-Request-Id,X-Version,X-Timestamp,X-Signature,X-Expire-In,X-Product,X-Aduid
access-control-allow-methods
GET,POST,OPTIONS,DELETE,PUT,PUTCH
access-control-allow-origin
https://wx.zsxq.com
access-control-expose-headers
X-Expire-In
content-encoding
gzip
content-type
application/json; charset=UTF-8
date
Fri, 10 Apr 2026 01:07:43 GMT
server
openresty
vary
Accept-Encoding,Origin

x-expire-in
2437494
x-frame-options
SAMEORIGIN

## Request headers

:authority
api.zsxq.com
:method
GET
:path
/v2/topics/55522284244482854/comments?sort=asc&count=30&with_sticky=true
:scheme
https
accept
application/json, text/plain, */*
accept-encoding
gzip, deflate, br, zstd
accept-language
zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6
cookie
zsxq_access_token=383F5918-31CD-44B0-B173-BD0C8E9727E5_85487ECE94F2CA08; sensorsdata2015jssdkcross=%7B%22distinct_id%22%3A%22421114288542428%22%2C%22first_id%22%3A%2219d6bd0ba0b28a-028f7c860143a28-4c657b58-2073600-19d6bd0ba0c37%22%2C%22props%22%3A%7B%7D%2C%22identities%22%3A%22eyIkaWRlbnRpdHlfY29va2llX2lkIjoiMTlkNmJkMGJhMGIyOGEtMDI4ZjdjODYwMTQzYTI4LTRjNjU3YjU4LTIwNzM2MDAtMTlkNmJkMGJhMGMzNyIsIiRpZGVudGl0eV9sb2dpbl9pZCI6IjQyMTExNDI4ODU0MjQyOCJ9%22%2C%22history_login_id%22%3A%7B%22name%22%3A%22%24identity_login_id%22%2C%22value%22%3A%22421114288542428%22%7D%7D; abtest_env=product
dnt
1
origin
https://wx.zsxq.com
priority
u=1, i
referer
https://wx.zsxq.com/
sec-ch-ua
"Chromium";v="146", "Not-A.Brand";v="24", "Microsoft Edge";v="146"
sec-ch-ua-mobile
?0
sec-ch-ua-platform
"Windows"
sec-fetch-dest
empty
sec-fetch-mode
cors
sec-fetch-site
same-site
sec-gpc
1
user-agent
Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0
x-aduid
587c45f2a-957f-2c43-a7ea-09178c30e53
x-request-id
2268d078d-07d4-9fdc-cff6-f65291087d0
x-signature
2d1134810d6eb070a6bd1880034b0a0a48764dc0
x-timestamp
1775783261
x-version
2.89.0

## fetch

```js
fetch("https://api.zsxq.com/v2/topics/55522284244482854/comments?sort=asc&count=30&with_sticky=true", {
  "headers": {
    "accept": "application/json, text/plain, */*",
    "accept-language": "zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6",
    "priority": "u=1, i",
    "sec-ch-ua": "\"Chromium\";v=\"146\", \"Not-A.Brand\";v=\"24\", \"Microsoft Edge\";v=\"146\"",
    "sec-ch-ua-mobile": "?0",
    "sec-ch-ua-platform": "\"Windows\"",
    "sec-fetch-dest": "empty",
    "sec-fetch-mode": "cors",
    "sec-fetch-site": "same-site",
    "sec-gpc": "1",
    "x-aduid": "587c45f2a-957f-2c43-a7ea-09178c30e53",
    "x-request-id": "2268d078d-07d4-9fdc-cff6-f65291087d0",
    "x-signature": "2d1134810d6eb070a6bd1880034b0a0a48764dc0",
    "x-timestamp": "1775783261",
    "x-version": "2.89.0",
    "cookie": "zsxq_access_token=383F5918-31CD-44B0-B173-BD0C8E9727E5_85487ECE94F2CA08; sensorsdata2015jssdkcross=%7B%22distinct_id%22%3A%22421114288542428%22%2C%22first_id%22%3A%2219d6bd0ba0b28a-028f7c860143a28-4c657b58-2073600-19d6bd0ba0c37%22%2C%22props%22%3A%7B%7D%2C%22identities%22%3A%22eyIkaWRlbnRpdHlfY29va2llX2lkIjoiMTlkNmJkMGJhMGIyOGEtMDI4ZjdjODYwMTQzYTI4LTRjNjU3YjU4LTIwNzM2MDAtMTlkNmJkMGJhMGMzNyIsIiRpZGVudGl0eV9sb2dpbl9pZCI6IjQyMTExNDI4ODU0MjQyOCJ9%22%2C%22history_login_id%22%3A%7B%22name%22%3A%22%24identity_login_id%22%2C%22value%22%3A%22421114288542428%22%7D%7D; abtest_env=product",
    "Referer": "https://wx.zsxq.com/"
  },
  "body": null,
  "method": "GET"
});
```

## 预览

```js
{
    "succeeded": true,
    "resp_data": {
        "comments": [
            {
                "comment_id": 8852414882512412,
                "create_time": "2026-04-10T08:00:12.353+0800",
                "owner": {
                    "user_id": 418451148421448,
                    "name": "帆帆帆帆",
                    "avatar_url": "https://images.zsxq.com/FjjcPzqzIuB9Ga4zz-hBlW95tXgn?imageMogr2/auto-orient/thumbnail/150x/format/jpg/blur/1x0/quality/75/ignore-error/1&e=1780243199&token=q6iZ0sQtf9U7s1qz0r4yMawNq3-u2w6lbnai6y2J:BYOA7quVJj2r21A1mGVp3xLrn_4=",
                    "location": "江苏"
                },
                "text": "商业很多时候都是围绕从众展开",
                "likes_count": 0,
                "group_owner_liked": false,
                "topic_owner_liked": false,
                "rewards_count": 0,
                "sticky": false
            },
            {
                "comment_id": 2852414882285541,
                "create_time": "2026-04-10T08:36:34.420+0800",
                "owner": {
                    "user_id": 421411814428118,
                    "name": "陈政法",
                    "avatar_url": "https://images.zsxq.com/FjIVmQVQVCOPFJB-2YcHFQvQ2Ol6?imageMogr2/auto-orient/thumbnail/150x/format/jpg/blur/1x0/quality/75/ignore-error/1&e=1780243199&token=q6iZ0sQtf9U7s1qz0r4yMawNq3-u2w6lbnai6y2J:Qm4CdqSzGJbqwmiVr3cN94gralI=",
                    "location": "广东"
                },
                "text": "同意👍年轻人又在寻找自我和集体认同了",
                "likes_count": 0,
                "group_owner_liked": false,
                "topic_owner_liked": false,
                "rewards_count": 0,
                "sticky": false,
                "replies_count": 1,
                "replied_comments": [
                    {
                        "comment_id": 8852414882245822,
                        "parent_comment_id": 2852414882285541,
                        "create_time": "2026-04-10T08:51:24.205+0800",
                        "owner": {
                            "user_id": 88855251114812,
                            "name": "永不沉没的太阳",
                            "avatar_url": "https://images.zsxq.com/FhVQYc_pgopXKQfc8gTx3pbAAGAD?imageMogr2/auto-orient/thumbnail/150x/format/jpg/blur/1x0/quality/75/ignore-error/1&e=1780243199&token=q6iZ0sQtf9U7s1qz0r4yMawNq3-u2w6lbnai6y2J:kYzioz0o-mu3Xf7mbOD0GbRyNr8=",
                            "location": "湖南"
                        },
                        "text": "是的，只是真自我在自己内心，不需要向外寻求，更不需要集体认同",
                        "likes_count": 0,
                        "group_owner_liked": false,
                        "topic_owner_liked": false,
                        "rewards_count": 0,
                        "sticky": false,
                        "repliee": {
                            "user_id": 421411814428118,
                            "name": "陈政法",
                            "avatar_url": "https://images.zsxq.com/FjIVmQVQVCOPFJB-2YcHFQvQ2Ol6?imageMogr2/auto-orient/thumbnail/150x/format/jpg/blur/1x0/quality/75/ignore-error/1&e=1780243199&token=q6iZ0sQtf9U7s1qz0r4yMawNq3-u2w6lbnai6y2J:Qm4CdqSzGJbqwmiVr3cN94gralI="
                        }
                    }
                ]
            },
            {
                "comment_id": 2852414882224521,
                "create_time": "2026-04-10T08:48:32.470+0800",
                "owner": {
                    "user_id": 48884184484518,
                    "name": "Goldberg",
                    "avatar_url": "https://images.zsxq.com/FqnR0xVtrY2iEzvb6hslAKJV5_tq?imageMogr2/auto-orient/thumbnail/150x/format/jpg/blur/1x0/quality/75/ignore-error/1&e=1780243199&token=q6iZ0sQtf9U7s1qz0r4yMawNq3-u2w6lbnai6y2J:U0Yg7DUsI7p3B5TbXQ2cKbFdLRY=",
                    "location": "英国"
                },
                "text": "而且那个不是mbti那种有逻辑的，只是一个博主做出来恶搞的……",
                "likes_count": 0,
                "group_owner_liked": false,
                "topic_owner_liked": false,
                "rewards_count": 0,
                "sticky": false,
                "replies_count": 1,
                "replied_comments": [
                    {
                        "comment_id": 8852414882221552,
                        "parent_comment_id": 2852414882224521,
                        "create_time": "2026-04-10T08:50:23.934+0800",
                        "owner": {
                            "user_id": 141485148812,
                            "name": "鳗鱼",
                            "avatar_url": "https://images.zsxq.com/FmTFUnCs53-dye6v1CYVtrkPVilw?imageMogr2/auto-orient/thumbnail/150x/format/jpg/blur/1x0/quality/75/ignore-error/1&e=1780243199&token=q6iZ0sQtf9U7s1qz0r4yMawNq3-u2w6lbnai6y2J:FibIK0fp-BWoE4pSe4H1BSxFqyQ=",
                            "description": "除了游历世界的深度见闻，你将在这个星球收获自己更自由与富裕的人生：启蒙，苏醒——有时并非需要你多么拼搏努力，可能仅仅需要你想通一些事情而已。",
                            "location": "哥伦比亚"
                        },
                        "text": "对，比起正经的MBTI，今天那个没有实际的实证意义。纯粹“担心跟不上潮流”",
                        "likes_count": 0,
                        "group_owner_liked": false,
                        "topic_owner_liked": false,
                        "rewards_count": 0,
                        "sticky": false,
                        "repliee": {
                            "user_id": 48884184484518,
                            "name": "Goldberg",
                            "avatar_url": "https://images.zsxq.com/FqnR0xVtrY2iEzvb6hslAKJV5_tq?imageMogr2/auto-orient/thumbnail/150x/format/jpg/blur/1x0/quality/75/ignore-error/1&e=1780243199&token=q6iZ0sQtf9U7s1qz0r4yMawNq3-u2w6lbnai6y2J:U0Yg7DUsI7p3B5TbXQ2cKbFdLRY="
                        }
                    }
                ]
            },
            {
                "comment_id": 8852414882248552,
                "create_time": "2026-04-10T08:52:56.060+0800",
                "owner": {
                    "user_id": 421851824844528,
                    "name": "富强诚信文明",
                    "avatar_url": "https://images.zsxq.com/FmVhdFJ7-f5UxhC6po0omcWprD8F?imageMogr2/auto-orient/thumbnail/150x/format/jpg/blur/1x0/quality/75/ignore-error/1&e=1780243199&token=q6iZ0sQtf9U7s1qz0r4yMawNq3-u2w6lbnai6y2J:eH2laEOnpKNXe8AaKLhq9NdwnCI=",
                    "location": "天津"
                },
                "text": "虽然但是，我是觉得这东西也花不了多少时间，重点是不要当回事，不要投入过度精力，也不要去深度思考，纯粹当成抽了一根烟解解闷，还是有一点点价值的",
                "likes_count": 0,
                "group_owner_liked": false,
                "topic_owner_liked": false,
                "rewards_count": 0,
                "sticky": false,
                "replies_count": 1,
                "replied_comments": [
                    {
                        "comment_id": 2852414882484241,
                        "parent_comment_id": 8852414882248552,
                        "create_time": "2026-04-10T08:58:43.993+0800",
                        "owner": {
                            "user_id": 141485148812,
                            "name": "鳗鱼",
                            "avatar_url": "https://images.zsxq.com/FmTFUnCs53-dye6v1CYVtrkPVilw?imageMogr2/auto-orient/thumbnail/150x/format/jpg/blur/1x0/quality/75/ignore-error/1&e=1780243199&token=q6iZ0sQtf9U7s1qz0r4yMawNq3-u2w6lbnai6y2J:FibIK0fp-BWoE4pSe4H1BSxFqyQ=",
                            "description": "除了游历世界的深度见闻，你将在这个星球收获自己更自由与富裕的人生：启蒙，苏醒——有时并非需要你多么拼搏努力，可能仅仅需要你想通一些事情而已。",
                            "location": "哥伦比亚"
                        },
                        "text": "这是一种思维方式，以小见大，以小及多，并不是专门指这件事情。你可能没有太明白我想说什么。人生的365天，很多人每天都耗在这种追潮流的随众的行为里面。\n你如果有我的朋友圈，你会发现我平时关注的内容、发的东西，基本不受别人影响，不受大趋势的影响。我有我自己的定力和关注的重点。",
                        "likes_count": 0,
                        "group_owner_liked": false,
                        "topic_owner_liked": false,
                        "rewards_count": 0,
                        "sticky": false,
                        "repliee": {
                            "user_id": 421851824844528,
                            "name": "富强诚信文明",
                            "avatar_url": "https://images.zsxq.com/FmVhdFJ7-f5UxhC6po0omcWprD8F?imageMogr2/auto-orient/thumbnail/150x/format/jpg/blur/1x0/quality/75/ignore-error/1&e=1780243199&token=q6iZ0sQtf9U7s1qz0r4yMawNq3-u2w6lbnai6y2J:eH2laEOnpKNXe8AaKLhq9NdwnCI="
                        }
                    }
                ]
            },
            {
                "comment_id": 2852414882421211,
                "create_time": "2026-04-10T09:06:12.538+0800",
                "owner": {
                    "user_id": 818284828158252,
                    "name": "爱喝鲜奶鲫鱼汤",
                    "avatar_url": "https://images.zsxq.com/FqOKbgC54WDzm6ygwndHKhkelJ0r?imageMogr2/auto-orient/thumbnail/150x/format/jpg/blur/1x0/quality/75/ignore-error/1&e=1780243199&token=q6iZ0sQtf9U7s1qz0r4yMawNq3-u2w6lbnai6y2J:18YivraGh5vw81Md2iVYapUPOyw=",
                    "location": "江苏"
                },
                "text": "感觉只是一种对mbti的解构和怯魅（）",
                "likes_count": 0,
                "group_owner_liked": false,
                "topic_owner_liked": false,
                "rewards_count": 0,
                "sticky": false
            }
        ],
        "index": ""
    }
}
```