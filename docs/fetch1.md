# fetch1

我找到了一个接口的内容，里面的信息我不是很懂，我分类复制出来。
据我观察，我看到预览的内容里面有text，就是该话题的具体文本内容。

## 标头

### 常规

请求 URL
https://api.zsxq.com/v2/hashtags/828881214282/topics?count=1
请求方法
GET
状态代码
200 OK
Remote Address
117.50.8.120:443
引用站点策略
strict-origin-when-cross-origin

### Response headers

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
Fri, 10 Apr 2026 00:44:36 GMT
server
openresty
vary
Accept-Encoding,Origin
x-expire-in
2438881
x-frame-options
SAMEORIGIN

### Request headers

:authority
api.zsxq.com
:method
GET
:path
/v2/hashtags/828881214282/topics?count=1
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
0c7d5b83a-1738-752b-67fe-b057a0866af
x-signature
c6890acb5bf4589a15c6e052adf6ba194dd28c79
x-timestamp
1775781873
x-version
2.89.0

## fetch

```js
fetch("https://api.zsxq.com/v2/hashtags/828881214282/topics?count=1", {
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
    "x-request-id": "0c7d5b83a-1738-752b-67fe-b057a0866af",
    "x-signature": "c6890acb5bf4589a15c6e052adf6ba194dd28c79",
    "x-timestamp": "1775781873",
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
        "topics": [
            {
                "topic_id": 45544415585881460,
                "topic_uid": "45544415585881458",
                "group": {
                    "group_id": 552445551254,
                    "name": "日落之海",
                    "type": "pay",
                    "background_url": "https://images.zsxq.com/Ft4yIuyg44zUQwFJveRXdItuxs8L?e=1780243199&token=q6iZ0sQtf9U7s1qz0r4yMawNq3-u2w6lbnai6y2J:MMkTZ66NUtto0AkMIGcYf9flIug="
                },
                "type": "solution",
                "solution": {
                    "task_id": 118844121444152,
                    "task_uid": "118844121444152",
                    "owner": {
                        "user_id": 88855251114812,
                        "name": "永不沉没的太阳",
                        "avatar_url": "https://images.zsxq.com/FhVQYc_pgopXKQfc8gTx3pbAAGAD?imageMogr2/auto-orient/thumbnail/150x/format/jpg/blur/1x0/quality/75/ignore-error/1&e=1780243199&token=q6iZ0sQtf9U7s1qz0r4yMawNq3-u2w6lbnai6y2J:kYzioz0o-mu3Xf7mbOD0GbRyNr8=",
                        "location": "湖南"
                    },
                    "text": "一线城市是一场骗局 <e type=\"hashtag\" hid=\"825124888212\" title=\"%23%E6%84%9F%E6%83%B3%23\" /> <e type=\"hashtag\" hid=\"828881214282\" title=\"%23%E7%AC%AC%E4%BA%8C%E8%81%8C%E4%B8%9A%23\" /> \n\n今年2月开始，自己回所在省会城市，远程接项目不再坐班以后，越来越发现一线城市是一场骗局\n\n一线城市的高收入只是一种幻觉，只能依赖一线城市生活，意味着必须买一线的房子，那普通人所谓的“高收入”，是绝对远远覆盖不了房款的，还得搭上六个钱包，外加30年贷款。名副其实的“一线赚钱一线花，一分别想带回家”，或者说“仅把贷款带回家”\n\n一线的看似高收入，毕业前几年近一半奉献给房租，后面的年份奉献给房价房贷，上面都精准计算好了\n\n具体到生活品质层面，一线城市能买到的东西，具备的商业形态，二三线都有，然后一线不允许的商业形态，二三线也都不允许，其实没有本质区别，尤其对于30+的人群\n\n就算顶着压力不买房，在一线工作生活，总得租房吧，我自己的亲身体验，整个一家子的一个月日常开销，还不及深圳一个月房租，然后深圳的房租相比北京上海还算便宜的，相比同等体量的国外城市，更算是便宜的\n\n当然，并不反对刚毕业那几年，去一线增长见识\n\n真正的本事，是能在十八线赚一线的钱，或者在中国赚美国的钱\n真正的本事，是不依赖单一公司、平台、组织，依然能够赚到钱，这才算真正的独立自主\n\n这个时候，出国旅游可以说走就走，不用凑假期，不用挤节假日，5月份计划去菲律宾，到时多多分享\n\n图片是家附近公园盛开的樱花和垂柳",
                    "images": [
                        {
                            "image_id": 8855148418248482,
                            "type": "jpg",
                            "thumbnail": {
                                "url": "https://images.zsxq.com/FjbkulGDvAptxSj-K2pzyxWJXAO2?imageMogr2/auto-orient/thumbnail/380x/format/jpg/blur/1x0/quality/75&e=1780243199&s=jytttjyvvmjyjyv&token=q6iZ0sQtf9U7s1qz0r4yMawNq3-u2w6lbnai6y2J:DjO2iXNMb0TImKcKSJIxqGkUgjE=",
                                "width": 380,
                                "height": 285
                            },
                            "large": {
                                "url": "https://images.zsxq.com/FjbkulGDvAptxSj-K2pzyxWJXAO2?imageMogr2/auto-orient/thumbnail/800x/format/jpg/blur/1x0/quality/75&e=1780243199&s=jytttjyvvmjyjyv&token=q6iZ0sQtf9U7s1qz0r4yMawNq3-u2w6lbnai6y2J:D8X7a3uxls8HqSoqURrfXk_UxVE=",
                                "width": 800,
                                "height": 600
                            },
                            "original": {
                                "url": "https://images.zsxq.com/FjbkulGDvAptxSj-K2pzyxWJXAO2?imageMogr2/auto-orient/quality/100!/ignore-error/1&e=1780243199&s=jytttjyvvmjyjyv&token=q6iZ0sQtf9U7s1qz0r4yMawNq3-u2w6lbnai6y2J:AnbbiHfyJ0J0XYBwTq_o7xzHQMw=",
                                "width": 1142,
                                "height": 856,
                                "size": 534218
                            }
                        },
                        {
                            "image_id": 1522815185414152,
                            "type": "png",
                            "thumbnail": {
                                "url": "https://images.zsxq.com/FmQNOTBV-XSfx2_Wp2vx0vbJV5oR?imageMogr2/auto-orient/thumbnail/380x/format/jpg/blur/1x0/quality/75&e=1780243199&s=jytttjyvvmjyjyv&token=q6iZ0sQtf9U7s1qz0r4yMawNq3-u2w6lbnai6y2J:X8MyRASV9l2614WWYJygxH3PJVs=",
                                "width": 380,
                                "height": 285
                            },
                            "large": {
                                "url": "https://images.zsxq.com/FmQNOTBV-XSfx2_Wp2vx0vbJV5oR?imageMogr2/auto-orient/thumbnail/800x/format/jpg/blur/1x0/quality/75&e=1780243199&s=jytttjyvvmjyjyv&token=q6iZ0sQtf9U7s1qz0r4yMawNq3-u2w6lbnai6y2J:IrryBUjQj4a6MRNN4d9u3mPJC10=",
                                "width": 800,
                                "height": 600
                            },
                            "original": {
                                "url": "https://images.zsxq.com/FmQNOTBV-XSfx2_Wp2vx0vbJV5oR?imageMogr2/auto-orient/quality/100!/ignore-error/1&e=1780243199&s=jytttjyvvmjyjyv&token=q6iZ0sQtf9U7s1qz0r4yMawNq3-u2w6lbnai6y2J:N8MwH6vbSvQPz_mN0PLJqRL60NQ=",
                                "width": 1080,
                                "height": 810,
                                "size": 830824
                            }
                        },
                        {
                            "image_id": 1522815185414142,
                            "type": "png",
                            "thumbnail": {
                                "url": "https://images.zsxq.com/FlV2EqkrFPS-pOKlJZFxJh7b_KKY?imageMogr2/auto-orient/thumbnail/380x/format/jpg/blur/1x0/quality/75&e=1780243199&s=jytttjyvvmjyjyv&token=q6iZ0sQtf9U7s1qz0r4yMawNq3-u2w6lbnai6y2J:6-pJTne-asJ1OuUkOvHrsRTRtNk=",
                                "width": 380,
                                "height": 285
                            },
                            "large": {
                                "url": "https://images.zsxq.com/FlV2EqkrFPS-pOKlJZFxJh7b_KKY?imageMogr2/auto-orient/thumbnail/800x/format/jpg/blur/1x0/quality/75&e=1780243199&s=jytttjyvvmjyjyv&token=q6iZ0sQtf9U7s1qz0r4yMawNq3-u2w6lbnai6y2J:FadtrXweota3uSOEYOrGAEWAviw=",
                                "width": 800,
                                "height": 600
                            },
                            "original": {
                                "url": "https://images.zsxq.com/FlV2EqkrFPS-pOKlJZFxJh7b_KKY?imageMogr2/auto-orient/quality/100!/ignore-error/1&e=1780243199&s=jytttjyvvmjyjyv&token=q6iZ0sQtf9U7s1qz0r4yMawNq3-u2w6lbnai6y2J:RJ12ylbDuLdGk0h1oycKgsr05KM=",
                                "width": 1080,
                                "height": 810,
                                "size": 820666
                            }
                        },
                        {
                            "image_id": 4844128218525218,
                            "type": "png",
                            "thumbnail": {
                                "url": "https://images.zsxq.com/Fo6Mz0nX47wUEzROvdNd0tCwQZ9u?imageMogr2/auto-orient/thumbnail/380x/format/jpg/blur/1x0/quality/75&e=1780243199&s=jytttjyvvmjyjyv&token=q6iZ0sQtf9U7s1qz0r4yMawNq3-u2w6lbnai6y2J:qkrjyy0NZi1kklnJn6116vTXOjE=",
                                "width": 380,
                                "height": 285
                            },
                            "large": {
                                "url": "https://images.zsxq.com/Fo6Mz0nX47wUEzROvdNd0tCwQZ9u?imageMogr2/auto-orient/thumbnail/800x/format/jpg/blur/1x0/quality/75&e=1780243199&s=jytttjyvvmjyjyv&token=q6iZ0sQtf9U7s1qz0r4yMawNq3-u2w6lbnai6y2J:8be6gUXz1EzzsoEyBp8VqfHVIIQ=",
                                "width": 800,
                                "height": 600
                            },
                            "original": {
                                "url": "https://images.zsxq.com/Fo6Mz0nX47wUEzROvdNd0tCwQZ9u?imageMogr2/auto-orient/quality/100!/ignore-error/1&e=1780243199&s=jytttjyvvmjyjyv&token=q6iZ0sQtf9U7s1qz0r4yMawNq3-u2w6lbnai6y2J:oRZpGLCcT295jePqUoy3V0sDQ4o=",
                                "width": 1080,
                                "height": 810,
                                "size": 1180867
                            }
                        }
                    ]
                },
                "latest_likes": [
                    {
                        "create_time": "2026-04-10T08:10:39.907+0800",
                        "owner": {
                            "user_id": 414458885484258,
                            "name": "sz",
                            "avatar_url": "https://images.zsxq.com/FheH8p8ucokMTTsNsyGqH5Va3GlH?imageMogr2/auto-orient/thumbnail/150x/format/jpg/blur/1x0/quality/75/ignore-error/1&e=1780243199&token=q6iZ0sQtf9U7s1qz0r4yMawNq3-u2w6lbnai6y2J:rUq0VfL-RcceoiGNzUK6WEwsdvk=",
                            "number": 3058
                        }
                    },
                    {
                        "create_time": "2026-04-10T08:07:53.914+0800",
                        "owner": {
                            "user_id": 218588411844541,
                            "name": "Vvv",
                            "avatar_url": "https://images.zsxq.com/FlnlpiCSPKkRRDYFHd_WIsGx51Hm?imageMogr2/auto-orient/thumbnail/150x/format/jpg/blur/1x0/quality/75/ignore-error/1&e=1780243199&token=q6iZ0sQtf9U7s1qz0r4yMawNq3-u2w6lbnai6y2J:lvxqs1eoMSqPiHca4-rHnEZ3Njk=",
                            "number": 7926
                        }
                    },
                    {
                        "create_time": "2026-04-10T08:03:48.383+0800",
                        "owner": {
                            "user_id": 841825845851552,
                            "name": "福",
                            "avatar_url": "https://images.zsxq.com/Ft3QtXyGva6apM0p2Y0qFRUGDmb6?imageMogr2/auto-orient/thumbnail/150x/format/jpg/blur/1x0/quality/75/ignore-error/1&e=1780243199&token=q6iZ0sQtf9U7s1qz0r4yMawNq3-u2w6lbnai6y2J:EcwRtBzHcVy6O4yHfMTFmkjezZo=",
                            "number": 2549
                        }
                    },
                    {
                        "create_time": "2026-04-09T23:10:03.725+0800",
                        "owner": {
                            "user_id": 48825454815828,
                            "name": "Heng",
                            "avatar_url": "https://images.zsxq.com/FueP_ZD-8EZ_S76kIslYM8WKj7is?imageMogr2/auto-orient/thumbnail/150x/format/jpg/blur/1x0/quality/75/ignore-error/1&e=1780243199&token=q6iZ0sQtf9U7s1qz0r4yMawNq3-u2w6lbnai6y2J:RZuU6VAlb11nH6ZMkOx4D47eNKQ=",
                            "number": 8752
                        }
                    },
                    {
                        "create_time": "2026-04-09T23:00:50.608+0800",
                        "owner": {
                            "user_id": 585241485514824,
                            "name": "琦琦",
                            "avatar_url": "https://images.zsxq.com/FvWi0i3QNWhRsqrJDgg5yjRZl21-?imageMogr2/auto-orient/thumbnail/150x/format/jpg/blur/1x0/quality/75/ignore-error/1&e=1780243199&token=q6iZ0sQtf9U7s1qz0r4yMawNq3-u2w6lbnai6y2J:npiW4-IJXqUQgyU1KMuHc-oQTxk=",
                            "number": 10936
                        }
                    },
                    {
                        "create_time": "2026-04-09T21:07:08.956+0800",
                        "owner": {
                            "user_id": 241845525151111,
                            "name": "雨诸",
                            "alias": "雨诸",
                            "avatar_url": "https://images.zsxq.com/Ftty-mxCZWOaAZwxsOAYlIaW-mBf?imageMogr2/auto-orient/thumbnail/150x/format/jpg/blur/1x0/quality/75/ignore-error/1&e=1780243199&token=q6iZ0sQtf9U7s1qz0r4yMawNq3-u2w6lbnai6y2J:-OHMAsNMNRJlEimy6-5dTBsJjEk=",
                            "number": 2307
                        }
                    },
                    {
                        "create_time": "2026-04-09T19:44:45.421+0800",
                        "owner": {
                            "user_id": 111888288251522,
                            "name": "春水秋山",
                            "avatar_url": "https://images.zsxq.com/FpXkR2CvwcUFzVl-vZsO0k3EkPeq?imageMogr2/auto-orient/thumbnail/150x/format/jpg/blur/1x0/quality/75/ignore-error/1&e=1780243199&token=q6iZ0sQtf9U7s1qz0r4yMawNq3-u2w6lbnai6y2J:OabEY91T9vlXxp_dIt8Q09P0mBo=",
                            "number": 6973
                        }
                    },
                    {
                        "create_time": "2026-04-09T18:58:31.554+0800",
                        "owner": {
                            "user_id": 421488215841558,
                            "name": "Nora.🌊",
                            "avatar_url": "https://images.zsxq.com/FmCAtNV0j_ekV2dKW56qq5259WqM?imageMogr2/auto-orient/thumbnail/150x/format/jpg/blur/1x0/quality/75/ignore-error/1&e=1780243199&token=q6iZ0sQtf9U7s1qz0r4yMawNq3-u2w6lbnai6y2J:yooCNsjbDLJ_X6FWF8u6uimP5-s=",
                            "number": 2459
                        }
                    },
                    {
                        "create_time": "2026-04-09T17:33:47.787+0800",
                        "owner": {
                            "user_id": 28844521244441,
                            "name": "Quinn.Z",
                            "avatar_url": "https://images.zsxq.com/FpFO52smmc0_zAzB9H4gE_8XAaoj?imageMogr2/auto-orient/thumbnail/150x/format/jpg/blur/1x0/quality/75/ignore-error/1&e=1780243199&token=q6iZ0sQtf9U7s1qz0r4yMawNq3-u2w6lbnai6y2J:TH5DRJsUPNdFoV5JodyszajNdt8=",
                            "number": 2413
                        }
                    }
                ],
                "show_comments": [
                    {
                        "comment_id": 5125484225412114,
                        "create_time": "2026-04-08T10:52:20.268+0800",
                        "owner": {
                            "user_id": 421444844551448,
                            "name": "信信信信",
                            "avatar_url": "https://images.zsxq.com/FrRAAhC9GyIhemXwZPmBpQnV6j2z?imageMogr2/auto-orient/thumbnail/150x/format/jpg/blur/1x0/quality/75/ignore-error/1&e=1780243199&token=q6iZ0sQtf9U7s1qz0r4yMawNq3-u2w6lbnai6y2J:FKySbGwGeEe7QQRM09uXo2rJu_I=",
                            "location": "广东"
                        },
                        "text": "所以当身边人都劝我所谓上车买深圳的房子哪怕是个小公寓，我从来没买动摇过始终坚决不买。不买房，生活可以很惬意，可以随时去自己想去的地方，消费也不用束手束脚。挣一线的钱，计算不去其他国家，去其他城市何尝不是一种地理套利。",
                        "likes_count": 19,
                        "rewards_count": 0,
                        "sticky": false,
                        "replies_count": 1
                    },
                    {
                        "comment_id": 8852414552122882,
                        "parent_comment_id": 5125484225412114,
                        "create_time": "2026-04-08T11:08:02.763+0800",
                        "owner": {
                            "user_id": 88855251114812,
                            "name": "永不沉没的太阳",
                            "avatar_url": "https://images.zsxq.com/FhVQYc_pgopXKQfc8gTx3pbAAGAD?imageMogr2/auto-orient/thumbnail/150x/format/jpg/blur/1x0/quality/75/ignore-error/1&e=1780243199&token=q6iZ0sQtf9U7s1qz0r4yMawNq3-u2w6lbnai6y2J:kYzioz0o-mu3Xf7mbOD0GbRyNr8=",
                            "location": "湖南"
                        },
                        "text": "太占现金流了",
                        "likes_count": 3,
                        "rewards_count": 0,
                        "sticky": false,
                        "repliee": {
                            "user_id": 421444844551448,
                            "name": "信信信信",
                            "avatar_url": "https://images.zsxq.com/FrRAAhC9GyIhemXwZPmBpQnV6j2z?imageMogr2/auto-orient/thumbnail/150x/format/jpg/blur/1x0/quality/75/ignore-error/1&e=1780243199&token=q6iZ0sQtf9U7s1qz0r4yMawNq3-u2w6lbnai6y2J:FKySbGwGeEe7QQRM09uXo2rJu_I="
                        }
                    },
                    {
                        "comment_id": 8852414554545152,
                        "create_time": "2026-04-08T11:20:54.577+0800",
                        "owner": {
                            "user_id": 48851812221458,
                            "name": "姆明与幸运星",
                            "avatar_url": "https://images.zsxq.com/FkU1FTi6CZebh0WKTwBJoMGFH8BI?imageMogr2/auto-orient/thumbnail/150x/format/jpg/blur/1x0/quality/75/ignore-error/1&e=1780243199&token=q6iZ0sQtf9U7s1qz0r4yMawNq3-u2w6lbnai6y2J:4RwdGitpv60tPyO4QPKEfJ73Eog=",
                            "location": "湖南"
                        },
                        "text": "太阳是在长沙的球友？长沙最近可太缺太阳了[偷笑]这个樱花看起来像湖南省植物园呢",
                        "likes_count": 5,
                        "rewards_count": 0,
                        "sticky": false,
                        "replies_count": 9
                    },
                    {
                        "comment_id": 5125484224421144,
                        "create_time": "2026-04-08T11:56:46.739+0800",
                        "owner": {
                            "user_id": 215258414418441,
                            "name": "许D",
                            "avatar_url": "https://images.zsxq.com/FhjV7Flf3yv96yRAgADvJJLYdfu2?imageMogr2/auto-orient/thumbnail/150x/format/jpg/blur/1x0/quality/75/ignore-error/1&e=1780243199&token=q6iZ0sQtf9U7s1qz0r4yMawNq3-u2w6lbnai6y2J:PT67GW4XSccfu5rMtrZp5afQiGU=",
                            "location": "广东"
                        },
                        "text": "大家好，在这里给大家分享一下我的经验，我在深圳光明区上班，住了很便宜的政策性住房，800块公寓单间。深圳市目前有一项租房政策：叫保障性租赁型安居房，这个房子并不向社会供给，而是政府分配给当地政府机构，事业单位，和纳税大户企业。由单位自己再向内部分配，这些房子如果能租到性价比很高，不管是自己本身就是这些单位人员，还是能找到这些单位人员“转租”（原则不允许），都是优于市面其他租房的",
                        "likes_count": 7,
                        "rewards_count": 0,
                        "sticky": false,
                        "replies_count": 4
                    },
                    {
                        "comment_id": 1524181221145482,
                        "parent_comment_id": 8852414554545152,
                        "create_time": "2026-04-08T12:10:22.380+0800",
                        "owner": {
                            "user_id": 548814121581184,
                            "name": "MJ",
                            "alias": "MJ",
                            "avatar_url": "https://images.zsxq.com/Fil5wzQ0WhXlp1T3_yWsUNaSW_XJ?imageMogr2/auto-orient/thumbnail/150x/format/jpg/blur/1x0/quality/75/ignore-error/1&e=1780243199&token=q6iZ0sQtf9U7s1qz0r4yMawNq3-u2w6lbnai6y2J:UVg3ZAs85h-oa02-hRSq_czeJXk=",
                            "location": "湖南"
                        },
                        "text": "清明假期去省植物园拍的樱花[偷笑]",
                        "likes_count": 4,
                        "rewards_count": 0,
                        "sticky": false,
                        "images": [
                            {
                                "image_id": 2855148412221841,
                                "type": "jpg",
                                "thumbnail": {
                                    "url": "https://images.zsxq.com/Fmqp4t1UPDNu1vaDTXTBaeeqHAZ0?imageMogr2/auto-orient/thumbnail/380x/format/jpg/blur/1x0/quality/75&e=1780243199&s=jytttjyvvmjyjyv&token=q6iZ0sQtf9U7s1qz0r4yMawNq3-u2w6lbnai6y2J:TmhK1gSpYVIILFS_pXkvz_ogMp8=",
                                    "width": 380,
                                    "height": 285
                                },
                                "large": {
                                    "url": "https://images.zsxq.com/Fmqp4t1UPDNu1vaDTXTBaeeqHAZ0?imageMogr2/auto-orient/thumbnail/800x/format/jpg/blur/1x0/quality/75&e=1780243199&s=jytttjyvvmjyjyv&token=q6iZ0sQtf9U7s1qz0r4yMawNq3-u2w6lbnai6y2J:_hq5L8qoY806Pix6gTza58ec1PE=",
                                    "width": 800,
                                    "height": 599
                                },
                                "original": {
                                    "url": "https://images.zsxq.com/Fmqp4t1UPDNu1vaDTXTBaeeqHAZ0?imageMogr2/auto-orient/quality/100!/ignore-error/1&e=1780243199&s=jytttjyvvmjyjyv&token=q6iZ0sQtf9U7s1qz0r4yMawNq3-u2w6lbnai6y2J:pZLfcbT-SeJpJeuoYTy4bmTdRWg=",
                                    "width": 1434,
                                    "height": 1074,
                                    "size": 789722
                                }
                            }
                        ],
                        "repliee": {
                            "user_id": 48851812221458,
                            "name": "姆明与幸运星",
                            "avatar_url": "https://images.zsxq.com/FkU1FTi6CZebh0WKTwBJoMGFH8BI?imageMogr2/auto-orient/thumbnail/150x/format/jpg/blur/1x0/quality/75/ignore-error/1&e=1780243199&token=q6iZ0sQtf9U7s1qz0r4yMawNq3-u2w6lbnai6y2J:4RwdGitpv60tPyO4QPKEfJ73Eog="
                        }
                    },
                    {
                        "comment_id": 8852414554184452,
                        "parent_comment_id": 8852414554545152,
                        "create_time": "2026-04-08T12:22:24.707+0800",
                        "owner": {
                            "user_id": 88855251114812,
                            "name": "永不沉没的太阳",
                            "avatar_url": "https://images.zsxq.com/FhVQYc_pgopXKQfc8gTx3pbAAGAD?imageMogr2/auto-orient/thumbnail/150x/format/jpg/blur/1x0/quality/75/ignore-error/1&e=1780243199&token=q6iZ0sQtf9U7s1qz0r4yMawNq3-u2w6lbnai6y2J:kYzioz0o-mu3Xf7mbOD0GbRyNr8=",
                            "location": "湖南"
                        },
                        "text": "家旁边额玉湖公园",
                        "likes_count": 1,
                        "rewards_count": 0,
                        "sticky": false,
                        "repliee": {
                            "user_id": 48851812221458,
                            "name": "姆明与幸运星",
                            "avatar_url": "https://images.zsxq.com/FkU1FTi6CZebh0WKTwBJoMGFH8BI?imageMogr2/auto-orient/thumbnail/150x/format/jpg/blur/1x0/quality/75/ignore-error/1&e=1780243199&token=q6iZ0sQtf9U7s1qz0r4yMawNq3-u2w6lbnai6y2J:4RwdGitpv60tPyO4QPKEfJ73Eog="
                        }
                    },
                    {
                        "comment_id": 8852414554125842,
                        "parent_comment_id": 5125484224421144,
                        "create_time": "2026-04-08T12:23:51.689+0800",
                        "owner": {
                            "user_id": 88855251114812,
                            "name": "永不沉没的太阳",
                            "avatar_url": "https://images.zsxq.com/FhVQYc_pgopXKQfc8gTx3pbAAGAD?imageMogr2/auto-orient/thumbnail/150x/format/jpg/blur/1x0/quality/75/ignore-error/1&e=1780243199&token=q6iZ0sQtf9U7s1qz0r4yMawNq3-u2w6lbnai6y2J:kYzioz0o-mu3Xf7mbOD0GbRyNr8=",
                            "location": "湖南"
                        },
                        "text": "是的有这个，民企名额太少了，根本排不上",
                        "likes_count": 4,
                        "rewards_count": 0,
                        "sticky": false,
                        "repliee": {
                            "user_id": 215258414418441,
                            "name": "许D",
                            "avatar_url": "https://images.zsxq.com/FhjV7Flf3yv96yRAgADvJJLYdfu2?imageMogr2/auto-orient/thumbnail/150x/format/jpg/blur/1x0/quality/75/ignore-error/1&e=1780243199&token=q6iZ0sQtf9U7s1qz0r4yMawNq3-u2w6lbnai6y2J:PT67GW4XSccfu5rMtrZp5afQiGU="
                        }
                    },
                    {
                        "comment_id": 1524181228522252,
                        "parent_comment_id": 5125484224421144,
                        "create_time": "2026-04-08T12:55:04.818+0800",
                        "owner": {
                            "user_id": 15528841422122,
                            "name": "橙子皮～",
                            "avatar_url": "https://images.zsxq.com/FvqZyx60dr57EL-Hq53OQ5M5UGHE?imageMogr2/auto-orient/thumbnail/150x/format/jpg/blur/1x0/quality/75/ignore-error/1&e=1780243199&token=q6iZ0sQtf9U7s1qz0r4yMawNq3-u2w6lbnai6y2J:MWXehQFu6LKYWR6GAMBhVs2D4dA=",
                            "location": "广东"
                        },
                        "text": "保障租赁房确实很好，深圳其他区也可以申请。就是很难申请；\n不过如果没有保障租赁房，在光明正常租房也不贵。我也在光明区，太喜欢这了，公园多，除开教育和医疗拉垮，其他都挺好的。不过不鸡娃，教育重要性没那么高；没到那个年纪，医疗也还好。",
                        "likes_count": 4,
                        "rewards_count": 0,
                        "sticky": false,
                        "repliee": {
                            "user_id": 215258414418441,
                            "name": "许D",
                            "avatar_url": "https://images.zsxq.com/FhjV7Flf3yv96yRAgADvJJLYdfu2?imageMogr2/auto-orient/thumbnail/150x/format/jpg/blur/1x0/quality/75/ignore-error/1&e=1780243199&token=q6iZ0sQtf9U7s1qz0r4yMawNq3-u2w6lbnai6y2J:PT67GW4XSccfu5rMtrZp5afQiGU="
                        }
                    }
                ],
                "likes_count": 105,
                "tourist_likes_count": 0,
                "likes_detail": {
                    "emojis": [
                        {
                            "emoji_key": "[强]",
                            "likes_count": 105
                        }
                    ]
                },
                "rewards_count": 0,
                "comments_count": 28,
                "reading_count": 1,
                "readers_count": 1305,
                "digested": false,
                "sticky": false,
                "create_time": "2026-04-08T10:34:21.101+0800",
                "user_specific": {
                    "liked": true,
                    "liked_emojis": [
                        "[强]"
                    ],
                    "subscribed": false
                },
                "title": "一线城市是一场骗局 #感想 #..."
            }
        ]
    }
}
```

