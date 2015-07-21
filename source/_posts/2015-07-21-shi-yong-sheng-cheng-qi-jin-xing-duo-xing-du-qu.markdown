---
layout: post
title: "使用生成器进行惰性读取"
date: 2015-07-21 10:47:10 +0800
comments: true
keywords: [Python, file]
description: 用惰性读取节省内存
tags: [Python, read, file]
categories: Python
---


<!--more-->
* any list
{:toc}

## 需求

完成一个函数, 从文件中读取数据并按行解析

## 错误的实现

```python
def items(file_name):
    l = []
    for line in open(file_name):
        l.append(parse(line))
    return l
```

这样实现会将文件全部读入内存后才能返回所有解析好的数据列表,
在处理大文件时会变得非常慢,非常慢,非常慢


## 正确的实现

```
def items(file_name):
    for line in open(file_name):
        yield parse(line)
```

使用生成器的方式, 可以保留 open 提供的惰性读取特性, 使得内存占用很小


## tips

当需要同时读取两个文件时, 不要使用 `for i, j in zip(a, b)` 去处理, 因为 zip
需要把 a, b 全部读入, 这样破坏了惰性读取的特性.

正确的做法:

```
f1 = items(file_name1)
f2 = items(file_name2)
while True:
    try:
        i = f1.next()
        j = f2.next()
    except StopIteration:
        break
```

主动调用生成器的 next 方法可以在使用多个生成器时保留其惰性.




--------
