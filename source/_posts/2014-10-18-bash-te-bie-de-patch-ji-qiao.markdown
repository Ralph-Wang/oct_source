---
layout: post
title: "BASH 特别的 Patch 技巧"
date: 2014-10-18 21:43:24 +0800
comments: true
keywords: [bash, patch, diff, 补丁, Linux]
description: bash 不出漏洞还真不会去学的东西
tags: [bash, patch, diff, 补丁, Linux]
categories: Linux
---


<!--more-->
* any list
{:toc}

## 问题 ##

9 月底爆出的 bash 漏洞, Mac 自然也受到影响.

但当时并没有找到苹果官方的解决方案,    
而 bash 官方释出的补丁方式完全看不懂怎么用...    
再加上就快升级 10.10 了.


想着也许会在升级时把补丁打上呢.    
(呃, 其实是懒得研究官方补丁怎么用)    
也就放着没管了

但昨天升级完后, 却发现并没有打上补丁.

只好硬着头皮上了.


## 解决方案[^1] ##

因为官方的补丁都是打在源码上的,    
所以我们需要去 [http://ftp.gnu.org/gnu/bash/](http://ftp.gnu.org/gnu/bash/) 下载 bash 的源码

没什么特别的需求的话, 就直接选最新的 4.3 版本好了. 懒人点 [这里](http://ftp.gnu.org/gnu/bash/bash-4.3.tar.gz)

下载完成后直接解压即可

```bash
$ tar zxvf bash-4.3.tar.gz
```

现在不着急编译安装, 因为我们还需要在源码上打补丁.

我们需要到 [bash-4.3-patches](http://ftp.gnu.org/gnu/bash/bash-4.3-patches/) 目录下把 01~30 补丁全部下载下来.

因为不想一个一个点, 所以玩了点小花样:

```bash
$ seq -f %02g 30| xargs -Ix curl -O <path-of-patches>/bash43-0x
```

好了, 把下载好的这些个补丁放到 bash 的源码目录下. 用 patch "一个一个"把补丁打上吧.

```bash
$ for i in `seq -f %02g 30`; do patch -p0 < bash43-0$i;done
```

> 这里因为变量在重定向符后面, 所以不能用 xargs 进行

好了, 接下来就是编译安装 -> 替换原有 bash, 就好了


## 相关工具 ##

patch: [这里](http://blog.chinaunix.net/uid-9525959-id-2001542.html)有一篇文章讲得蛮详细的, 就不重新造轮子了.


两个 bug 的测试代码:


```bash
env x='() { :;}; echo Your bash is Fucked'  bash -c "echo just test"
```

没漏洞的 bash 是不会被 Fuck 的

```bash
env X='() { (a)=>\' bash -c "echo date"; cat echo} 
```

没漏洞的 bash 看到的是 date 字样.


--------

[^1]: 因为是用官方源码打补丁, 所以 *NIX 系统通用
