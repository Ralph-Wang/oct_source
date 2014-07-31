---
layout: post
title: "无节操地重新认识多态和IoC"
date: 2014-07-27 23:41:34 +0800
comments: true
keywords: [多态, IoC, 面向对象, 程序设计]
description: 一种独特的方式来认识多态和 IoC
tags: 程序设计, IoC, 多态
categories: 程序设计与算法
---

起源 <http://weibo.com/1854716251/BfnE2jSR9>

<!--more-->

* list here
{:toc}

刚转这篇微博的时候, 确实只意识到它用了多态特性.

在自己尝试写一个 Python 版的时候, 才意识到其实这里面更多的在表达 IoC 的设计思路

## IoC 简介

`IoC` 的全称是 `Inversion of Control` 译过来就是控制返转.

[酷壳][1]有一个比较好的例子, 我这里就不重复造轮子了.

## 无节操的例子

这里我们详细谈一下[起源][2]里的例子是怎么回事:

妹子与汉子约会, 会因为汉子的种类(高富帅或diaosi)采取不同行动.

一般的理解思路就是`妹子在做选择`, 也就是控制权在妹子手里.

这样如果用代码表示的话可能就是下面这样

```python
def meet(hanzi):
   hanzi.flower()
   if isinstance(hanzi, GFS):
       print '啪啪啪啪啪啪啪啪'
   elif isinstance(hanzi, DS):
       print '啪'
```

而 IoC 的理解思路却是这样的:

> *控制权其实在 `hanzi` 这边, 妹子对汉子的表达是相同的, 但因为 `hanzi` 的不同而产生了不同结果而已*

用代码来表达就是这样

```python
class Meizi(object):
    def meet(hanzi):
        hanzi.flower()
        hanzi.chu()
```

`Meizi` 这边的代码是不是就变得非常干净了, 那汉子在 chu 之后的结果就不在妹子这里控制了.

至于发生了什么, 我们来看一下 `Hanzi` 们的具体实现

```python
class Hanzi(object):
    'Abstract class Hanzi'
    def flower(self):
        print '妹子笑了...'

    def chu(self):
        raise NotImplementedError('Abstract Method chu not implemented yet')

class GFS(Hanzi):
    def chu(self):
        print '啪啪啪啪啪啪啪啪'

class DS(Hanzi):
    def chu(self):
        print '啪'
```

**看, 结果的不同是因为 `Hanzi` 自己的属性, 而不是妹子的选择.**

这就是 IoC 的本质了[^1].


[1]: http://coolshell.cn/articles/9949.html "酷壳"

[2]: http://weibo.com/1854716251/BfnE2jSR9 "PHP版"

[^1]: 其实是把妹的本质吧, 喂!!



