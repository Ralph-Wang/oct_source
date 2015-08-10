---
layout: post
title: "bash 传参的一个细节"
date: 2015-08-10 18:04:59 +0800
comments: true
keywords: [bash, function, 参数]
description: "如题"
tags: [Linux, bash, function, 参数]
categories: Linux
---


<!--more-->
* any list
{:toc}

## 你四不四傻

写了个小函数如下:

* 接收两个参数
* 如果第一个参数为空字符串, 直接 echo 第二个
* 否则, 用逗号(,)连接两个字符串

```bash
append_str() {
    if [ -n "$1" ];then
        echo $2
    else
        echo $1,$2
    fi
}
```

然后, 在调用时却总是不能进行到前一个分支..

调用如下:

```bash
for i in $(some list);do
    $a=$(append_str $a $i)
done
```

得到总是类似如下结果

```
a,,b,c,d
```

## 捉虫

添加 `set -x` 查看命令具体执行

```
append_str a
append_str a, b
append_str a,,b c
append_str a,,b,c d
```

等等

```
append_str a
```

第一个参数应该是个空字符串啊, 被吃啦!!

等等, bash 中变量好像是直接展开, 而非传值的.

嗯, 这样就说通了. 因为第一次调用 $a 还是空, 展开后等同于没有传值给函数

于是, 改个调用

```
for i in $(some list);do
    $a=$(append_str "$a" "$b")
done
```

工作正常! Good Job.

## 小结

* bash 里参数如果用变量并不是直接传值, 而是先要展开
* 使用时, 给变量包一层双引号是个好习惯


--------
