---
layout: post
title: "迂回的监控数据库连接数"
date: 2014-05-09 09:45:51 +0800
comments: true
keywords: [shell, 数据库, 连接数, Linux]
description: 用 shell 脚本迂回实现数据库连接数监控
tags: [Linux, 网络连接数, shell]
categories: Linux
---

不能通过数据库工具监控到连接数时可用的迂回监控方法
<!--more-->
## 原理
数据库连接底层使用的也是 TCP 协议.

所以当连接到数据库时, 在本地也有打开一个 TCP 端口. 可以通过 nestat 查看

并且每有一个连接, 就会产有一个端口.

所以, 我们只需要数一下 netstat 中打印出来连接到数据库的端口即可

## 代码

{% gist 2c5f64d45de600237f1c %}

## 命令分析

核心就一行, 摘出来看看:

```bash
netstat -an |awk '{gsub("::ffff:",""); print $5}'|grep "$port" |sort | uniq -c
|sed "s/^/$current_date/g"
```

各个命令在干什么: 

`netstat` 不多说, 打印出所有打开着的端口

`awk` 在这里做一步初步处理, gsub("::ffff:", ""), 是为了去除 ipv6 格式的 ip 地址.

`grep` 就是为了过滤出想监控的端口号

`sort` 让所有打印出来的远程连接排序, 为下一步 uniq 作铺垫

`uniq` 去重, `-c` 计算重复的项. 这样就得到连接的总数了

`sed` 既然是监控, 在行首添加上时间.

执行结果的样例:


![net_watch](/blogimgs/net_watch.png)
