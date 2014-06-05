---
layout: post
title: "Learning the Bash Shell 笔记-杂项"
date: 2014-06-05 09:49:16 +0800
comments: true
keywords: 
description: 
tags: [bash, Linux, getopts, make]
categories: Linux
---

一些零散的内容
<!--more-->
## getopts
getopts 主要用来定义和解析脚本支持的命令行选项.

简单用法如下:
```bash
while getopts ":ab:c" opt
do
	case $opt in
		a )
			statements for -a
			;;
		b )
			$OPTARG is the argument value of -b
			statements for -b
			;;
		c )
			statements for -c
			;;
		\? )
			other
	esac
done

shift $(($OPTINT - 1))

main scripts
```
* getopts 第一个字符串中声明支持的选项名 (只能单字符);
  如果字符后面加有冒号(:)则表示该选项有对应的选项参数,
  参数值会保存到变量`OPTARG`中

* 执行过 getopt 后, 会在变量`OPTINT`中保存 (选项+选项参数) 的总个数. 用 shift $(($OPTINT - 1)) 来确保后续代码不受实际选项个数影响

* 在声明所支持的选项时, 如果以冒号(:)开头, 可以忽略传入不合法的选项


## shell 实现极简 make
没有变量支持什么, 只是解释命令和依赖
```
#!/bin/sh

#set -o verbose

makecmd()
{
    read target colon sources
    for src in $sources
    do
        if [ $src -nt $target ]
        then
            while read cmd
            do
                echo "$cmd"
                eval ${cmd#\t}
            done
            break
        fi
    done
}

makecmd < Makefile
```
* 只能处理一个命令, 不支持变量什么的

* 用 read 从标准输入中读取 target colon sources

* 循环判断 sources 中各依赖与 target 修改日期; `FILE1 -nt FIlE2`, `FILE1 -ot
  FILE2` 用来比较两个文件修改时间

* eval "string" 将 string 作为 bash 命令解析
