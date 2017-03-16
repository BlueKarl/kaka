通用配置接口
========

kaka v1.0.0

rewrited by [OpenResty](https://github.com/openresty/lua-nginx-module)

Usage
=====

```
http://bconf.api.mgtv.com/v1/conf
```
method: GET

* Request:
```
http://bconf.api.mgtv.com/v1/conf?module=p2p,httpdns&sysver=6.0.1&appver=v5.1.2&app=1&guid=3242ejijlkl&model=xiaomi3s
```

Return:
```
{
    httpdns: {
        on: 0,
        conf: {
        request_addr: [
            "192.168.0.6",
            "192.168.0.10",
            "192.168.0.4",
            "192.168.0.3",
            "192.168.0.2",
            "192.168.0.7",
            "192.168.0.8",
            "192.168.0.9",
            "192.168.0.5"
            ],
        wait_time: 1000
        }
    }
    "p2p" : {
        "on" : 0
    },
    "其它模块" : {
        // 其它模块的配置信息
    }
}
```
* Request：
```
http://127.0.0.1:9527/v1/module/
```
Return:
```
{
    base_module: [
        "p2p",
        "httpdns"
    ]
}
```

* Request: 
```
http://127.0.0.1:9527/v1/level/
```
Return:
```
{
    p2p: {
        level: 4
    },
    httpdns: {
        level: 4
    }
}
```
## Level级别判定
* level=1: Master switch == 1  then  on = 1 else on = 0
* level=2: Master switch && appver in list-appver == 1 then on = 1 else on = 0
* level=3: Master switch && appver in list-appver && app in list-app == 1 then on = 1 else on = 0
* level=4: Master switch && appver in list-appver && app in list-app && model in list-model == 1 then on = 1 else on = 0

