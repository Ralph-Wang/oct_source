---
layout: post
title: "用 jstack 线程定位初体验"
date: 2014-03-01 22:42:48 +0800
comments: true
keywords: java, jstack, 线程, 堆栈, 分析, 问题定位, 瓶颈定位
description: 用 top + jstack 定位 java 进程问题, 定位到代码行号.
tags: [java, jstack, 堆栈, top]
categories: java
---

用 top + jstack 定位 java 线程问题
<!--more-->
### 1. 需要定位的程序
首先, 写一个用于计算并输出蜚波那契数列的 java 程序, 大致的输出信息如下.
![Fibonacci][6]
这里特意写成**死循环**, 让它不停地去消耗 CPU

### 2. 用 top 命令定位进程号
程序运行起来之后, 就该 `top` 命令出场了.

直接在命令行中输入
```bash
$top
```

看 `top` 命令的输出
![use top][1]
看到消耗 CPU 最高的就是一个 java 进程.

OK, 记下进程号 **100162**


> 补充:
> > `top` 添加 -c 参数可以查看到命令的参数信息
> > 
> > 这样可以看到 java 具体执行的类, 定位更准确

### 3. 用 top -H -p 命令定位到线程号
现在, 我们知道消耗 CPU 最高的进程是哪个了. 

但我们还不知道具体是哪个线程的问题, 所以不着急用 `jstack` 去获取 java 进程快照. 

再次使用 `top` 命令, 不过, 这次我们加上 `-H -p` 参数来查看线程运行情况.

```bash
$ top -H -p 100162
```
> 注: *也可以 `top -p <pid>` 后再敲 H 打开子线程信息*


这次, 得到如下图的结果:
![use top -H -p (pid)][2]

消耗 CPU 最高的不再是 100162 了. 可以清楚的看到是线程 **100172**

### 4. 用 jstack 定位到代码行
下面, 就可以用 `jstack` 来导出进程的堆栈信息了.

```bash
$jstack 100162
```
* 这里不能直接使用 `jstack 100172`的形式, jstack 似乎只能对**主线程**使用
* jstack 不能导出堆栈问题解决: [jstack 不能导出堆栈](http://www.haply.info/blog/archives/305)

然后, 在堆栈信息中找到 nid=0x27bc(100172 的 16 进制) 的线程.

就是下面的 **Thread-0** 线程了

![use jstack][4]

全是 `Fibonacci.calcFibo (testJstack.java:28)`

定位源码文件 `testJstack.java` 第 28 行, 最土最慢最二的蜚波那契数列算法...

![get the criminal][5]

问题定位结束

上完整源码

{% gist 9290490 testJstack.java %}

[1]: /blogimgs/thread-top.png "use top"
[2]: /blogimgs/thread-topHp.png "use top -H -p <pid>"
[4]: /blogimgs/thread-jstack.png "use jstack"
[5]: /blogimgs/thread-28.png "get the criminal"
[6]: /blogimgs/thread-fb.png "a Fibonacci Thread"
