---
layout: post
title: "Linux bash 的 C-s"
date: 2014-08-13 22:22:02 +0800
comments: true
keywords: [Linux, shell, readline, bash, ctrl]
description: linux 下的快捷键 C-s 和 C-r
tags: [Linux, shell, bash, readline]
categories: Linux
---

putty 莫名不响应问题...


<!--more-->
* any list
{:toc}

## 事故 ##

在 Windows 下, 一直使用 putty 作为连接远程 Linux 的工具.

偶尔会出现 putty 不响应的现象. 一直不知道是什么问题.    
一般直接关闭重启 putty. 也就没有太理会它

今天一次逗[哔]的尝试, 却找到了这个问题的源头:

> 该死的 C-s

## 缘起 emacs ##

`emacs` 中 `C-s` 和 `C-r` 对应的`向下`搜索和`向上`搜索    
而 `bash` 的编辑快捷键默认采用的便是 emacs 模式.    
便试了试 `C-s`. 结果出现了不响应的情况.[^1]

搜索到下[这篇文章](http://tianya23.blog.51cto.com/1081650/740207)


## C-s/C-q

bash 中 `C-s` 和 `C-q` 是代表了一对`流控制符`.    
其作用就是`停止`和`重启`从一个设备向另一个设备的输出流.    
以前是用来切断速率过低的传输过程的(具体有多低, 我也不知道)    

现在的网络比以往要快很多,    
所以这两个控制符也就没什么大用了    
只需要记住, 误敲 `C-s` 导致 bash 不响应时,    

> 敲下`C-q` 即可恢复    

----

[^1]: bash 中 `C-r` 仍是`向上`搜索. 不过,搜索目标是命令历史
