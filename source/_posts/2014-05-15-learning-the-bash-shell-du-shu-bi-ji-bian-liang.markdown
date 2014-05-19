---
layout: post
title: "Learning The Bash Shell 笔记-变量"
date: 2014-05-15 09:35:19 +0800
comments: true
keywords: shell, bash, $, String
description: Linux bash shell 中变量的一些细节知识
tags: [Linux, shell, bash, 变量]
categories: Linux
---


<!--more-->

## $\* 和 $@
这两个变量都可以得到脚本运行得到的所有参数.

默认情况下, 这两个变量没有区别

```bash sample.sh
#!/bin/bash

echo $*

echo $@
```

运行上面的脚本, 传入多个参数. 得到的两行输出结果是一样的.

```bash
$./sample.sh 1 2 3
1 2 3
1 2 3
```

但是, 当给变量 IFS(internal field sperator) 赋上值并用双引号将 `$*` 和 `$@`
括起来, 情况就不一样了.

```bash sample2.sh
#!/bin/bash

IFS=,

echo "$*"

echo "$@"
```

这时候, 在 `$*` 中不再是以空格分割所有参数, 而是由 IFS 的值 (当前脚本中为逗号)来分割

而 `$@` 则保持原样

```bash
$./sample2.sh 1 2 3
1,2,3
1 2 3
```

当用双引号括起来以后, `"$*"` 等价于 `"$1$IFS$2$IFS$3...$IFS$N"`

而 `"$@"` 等价于 `"$1" "$2" "$3"... "$N"`

## String Operator

对于 shell 变量, 还有一些操作符可以让脚本变得更活

* `${var:-word}`: 如果 var 变量不存在或为 null, 则返回 word. var 变量仍然不存在或为 null

* `${var:=word}`: 如果 var 变量不存在或为 null, 则将 word 赋值给 var, 并返回 var 的新值(word)

* `${var:?msg}`: 如果 var 变量不存在或为 null, 则停止脚本, 并输出信息 **var: msg**

* `${var:+word}`: 如果 var 变量存在并不为 null, 则返回 word. 否则, 返回 null

* `${var:offset:length}` 截取变量 var 从 offset 开始长度为 length 的字符串.  offset 从 0 开始. length 为 null 截取剩余全部.

```bash sample3.sh
#!/bin/bash

echo ${var:-"minus"}

echo ${var}

echo ${var:="equals"}

echo ${var}

echo ${var:+"plus"}

echo ${var:2:2} #output ua

echo ${theVar:?"should not be empty"}
```

输出:
```
minus

equals
equals
plus
ua
sample3.sh: line 15: theVar: should not be empty
```

## 一个练习
你收集了一专辑, 并已经统计出了不同歌手的专辑数量, 现在需要找出收集数量前 10 的歌手. 文件格式如下:
```text file
5 Depeche Mode
2 Split Enz
3 Simple Minds
1 Vivaldi, Antonio
```

ok, 实现代码很简单 `sort -nr file | head -n 10`

不过, 书中的解答不得不说更好
```bash
#!/bin/bash

filename=${1:?"filename missing"}
howmany=${2:-10}

sort -nr $filename | head -n $howmany
```

这样脚本化之后, 增加了可读性, 而且也不限于统计前 10.
