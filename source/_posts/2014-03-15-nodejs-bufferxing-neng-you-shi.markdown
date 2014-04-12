---
layout: post
title: "nodejs Buffer性能优势"
date: 2014-03-15 21:24:23 +0800
comments: true
keywords: nodejs, Buffer, 性能, 测试
description: nodejs 中 使用 Buffer 的性能优势
tags: nodejs, 性能, Buffer
categories: nodejs
---

最近在读朴大神的 `深入浅出 Nodejs`, 其中不乏性能相关话题.

这里选一个出来做个测试
<!--more-->

## 准备
在 Buffer 一章中, 有这么一个测试.

在 Web 服务中, 使用 Buffer 进行数据传输, 效率要比直接使用字符串快.

光看结果还是不太信服, 于是来做个验证.

先上源码:
```javascript server1.js
var http = require('http');

var size = 10 * 1024; // 10K

var helloworld = '';
for (var i = 0; i < size; i++) {
	helloworld += 'a';
}

http.createServer(function (req, res) {
	res.writeHead(200);
	res.end(helloworld);
}).listen(8888);
```


```javascript server2.js
var http = require('http');

var size = 10 * 1024; // 10K

var helloworld = '';
for (var i = 0; i < size; i++) {
	helloworld += 'a';
}

helloworld = new Buffer(helloworld); // 改用 Buffer 进行传输

http.createServer(function (req, res) {
	res.writeHead(200);
	res.end(helloworld);
}).listen(8888);
```

server1 和 server2 的差别就只有那一句 `helloworld = new Buffer(helloworld)`.

现在分别启动 server1 和 server2

并用 ab 测试, 同时将结果分别保存到 res1.txt 和 res2.txt
```bash
ab -c 200 -t http://100 10.161.130.110:8888/ > res1.txt
ab -c 200 -t http://100 10.161.130.110:8888/ > res2.txt
```


## 测试结果
比较一下测试结果

![node-buffer-perf](/blogimgs/node-buffer-perf.png)

可以看到, 使用 Buffer 后 QPS 和传输率确实有一定提升.

## CPU 利用率

监控两次测试的 CPU 使用情况并统计: (统计时, 取 CPU 平稳的 6 次结果并计算用户态 CPU 平均值)

![node-buffer-cpu](/blogimgs/node-buffer-cpu.png)

两次测试中, CPU 利用率均达到了 100%, 但不使用 Buffer 时, 用户态的 CPU 更高一些.

高出来这一部分, 应该就是进行额外的 Buffer/String 转换消耗掉的.

\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-

2014-04-12 更新

awk 脚本中 `sum/6` 应该改为 `sum/NR` 这样更通用
