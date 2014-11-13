---
layout: post
title: "Python 名称空间对性能的影响"
date: 2014-11-13 20:03:05 +0800
comments: true
keywords: [Python, 名称空间, 局部变量]
description: 重新认识 Python 的名称空间和变量寻址
tags: [Python, 名称空间, 局部变量]
categories: Python
---


<!--more-->
* any list
{:toc}

## 名称空间 ##

Python 中变量的作用域有一个特别的名字叫做`名称空间`

`名称空间`呢, 有以下这些特点:

* 每一个模块, 函数, 类, 实例, 都拥有一个独立的名称空间.    
* 每一个变量都会处在一个名称空间下.     
* 名称空间可以相互包含, 或者说有上下级关系
* 在下级名称空间中可以访问上级名称空间的变量


用代码来举例子:

```python namespace.py
in_module = 'in module'

def method():
    in_method = 'in method'
```

在上面这段代码中, 一共有 个名称空间, 分别是:

* 文件, 就是 `namespace.py` 里面, 有`in_module` 变量
* 函数, 就是 `method` 里面, 有`in_method` 变量


以上名称空间, 从上向下都是包含关系.



## 变量寻址 ##

一般来讲, 在一个名称空间中, 只能访问到属于这个名称空间的变量

所以对于上面的代码来讲:

|名称空间|可见变量|
|--------|--------|
|namespace.py|`in_module`|
|method|`in_method`|

同时, 下级名称空间是可以访问到上级名称空间中的变量的.    
于是上表就变成了

|名称空间|可见变量|
|--------|--------|
|namespace.py|`in_module`|
|method|`in_method`, `in_module`|


所以现在可以在 `method` 中访问所有 `in_*` 变量    
就像下面这样

```python
def method():
    in_method = 'in method'
    print in_method
    print in_module
```

所谓`变量寻址`, 指的就是

> Python 在当前名称空间下找不到变量定义时,
> 会继续搜索上一层名称空间, 直到顶层.

这件事了.

概念说了一大堆, 和性能优化好像都没啥关系. 下面就进入正题

## 循环优化 ##

在日常代码编写中, 我们有时会写类似这样的代码:

```python
import math

def foo(lst):
    for i in xrange(len(lst)):
        lst[i] = math.sin(lst[i])
```

上面代码中, `foo` 里并没有定义 `math`.
它是通过`变量寻址`在上一层找到了引入进来的`math`进行操作

并且, 在循环内部, 每访问一次 `math` 就会发生一次`变量寻址`.
这对性能有一定的损耗.

我们可以创建一个`foo`内部的变量直接指向我们要用的`math.sin`
然后再进入循环, 这样可以节省不少时间

```python
def woo(lst):
    sin = math.sin
    for i in xrange(len(lst)):
        lst[i] = sin(lst[i])
```

当然, 类似这样重复调用外部方法的函数, 我们可以直接用 `map` 来代替

```python
def moo(lst):
    return map(math.sin, lst)
```

下面是用 `timeit` 模块跑的基准测试结果:

```
foo: 20.8992490768
woo: 15.5716171265
moo: 12.033983945
```

--------
