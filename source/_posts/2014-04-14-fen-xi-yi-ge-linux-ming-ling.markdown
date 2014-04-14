---
layout: post
title: "分析一个 Linux 命令"
date: 2014-04-14 22:44:14 +0800
comments: true
keywords: [Linux, 命令, 硬件, 拆解] 
description: 通过折解一些 Linux 命令组合来学习每个独立命令
tags: [Linux, 命令, 管道]
categories: Linux
---

通过拆解查看 CPU 信息的组合命令, 来学习每个独立命令
<!--more-->

 查看 CPU 信息
-----------
## 1. 查看 CPU 型号
原命令
```bash
#cat /proc/cpuinfo | grep name | cut -f2 -d: | uniq -c
```
cat 和 grep 就不多说了
### cut:
help 中的说明是 ** Print selected parts of lines from each FILE to standard
output ** .  输出所有选中的行

`-f2` 是选中第二列, 换成`--fields=2`也是可以的.

`-d:` 则表示用冒号作为列分割符, 等价于`--delimiter=:`

**其它选项:**

`-s` 不包含分割符的不输出

### uniq:
man 中的说明 ** report or omit repeated lines ** . 实际就是去除重复行

`-c` 表示在输出行前加上其在原文件中出现的次数

**其它选项:**

*和输出相关:*

`-d` 只输出发生了重复的行.

`-D` 只输出发生了重复的行. 但输出所有行. 即, 去除唯一行

`-u` 只输出唯一行

*和比较相关:*

`-fN` 前N列不比较. 以空格或TAB为列分割符

`-sN` 前N个字符不比较

`-wN` 最多比较N个字符

`-i` 无视大小写差别. A 与 a 视为一致

*其它:*

`-z` 以 0 作为行末

