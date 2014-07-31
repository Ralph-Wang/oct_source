---
layout: post
title: "用jvisualvm监控远程java进程"
date: 2014-02-06 21:48:26 +0800
comments: true
keywords: java, 性能, jvm, jvisualvm, 监控, 远程, jdk
description: jvisualvm 监控 java 线程, 监控远程 java 线程
tags: [java, 监控, jvm, jvisualvm]
categories: java
---

**jvisualvm**是从**jdk1.6**开始添加到JDK包中的图形化监控工具。

<!--more-->
开启后可以自动监控本机运行中的java进程。

另外，**jvisualvm**它还可以监控远程机器上java进程的运行状态。

不过，监控远程机器需要在被监控机器上做一些配置：

#### 1. 安装JDK
这一步不多说了

#### 2. 配置/etc/hosts
要让**jvisualvm**成功连接到被监控机器上，需要在/etc/hosts文件中将被监控机的主机名绑定到被监控机的IP地址。

通过`hostname`命令可以获得主机名

```text /etc/hosts
192.168.192.132 Ralph.Wang
```

`hostname -i`返回实际的IP地址即绑定成功。



注：**CentOS**中的/etc/hosts默认是没有绑定主机名的IP的，直接添加即可

#### 3. 运行jstatd
运行`jstatd`之前，我们需要配置一个安全策略文件,如下

{% gist 8844076 jstatd.all.policy %}

运行`jstatd`时需要用`-J-Djava.security.policy`参数指定策略文件

```bash
jstatd -J-Djava.security.policy=jstatd.all.policy
```


### 4.在jvisualvm中添加远程机
`文件`->`添加远程主机` 输入IP地址即可。

下面是示例图
![jvisualvm监控示例](/blogimgs/jvisualvm-remote.png)
