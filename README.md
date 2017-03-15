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

request:
```
http://bconf.api.mgtv.com/v1/conf?module=p2p,httpdns&sysver=6.0.1&appver=v5.1.2&app=1&guid=3242ejijlkl&model=xiaomi3s
```

return:
```
{
    "p2p" : {
        "on" : 0
    },
    "httpdns" : {
        "on" : 0
    },
    "其它模块" : {
        // 其它模块的配置信息
    }
}
```
