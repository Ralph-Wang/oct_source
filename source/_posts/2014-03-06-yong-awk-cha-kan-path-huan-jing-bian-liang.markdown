---
layout: post
title: "用 awk 查看 PATH 环境变量"
date: 2014-03-06 14:18:22 +0800
comments: true
keywords: awk, linux, 环境变量, 管道, 换行
description: 用 awk 分割单行的 PATH 环境变量 为多行 , 方便查看
tags: [linux, awk, 环境变量, tips]
categories: linux
---


<!--more-->
查看 PATH 环境变量是件痛苦的事情.

用 `echo` 直接显示时, 输出只有一行, 查看起来很费神

如下图
```bash
$echo $PATH
```

![path normal](/blogimgs/path-normal.png)

看 `awk` 用法时, 记得可以用 `RS` 变量修改行标识, 于是试试

```bash
$echo $PATH | awk 'BEGIN {RS=":"} {print $0}'
```

![path with awk](/blogimgs/path-withawk.png)

确实清晰不少.

