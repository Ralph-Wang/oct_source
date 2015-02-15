---
layout: post
title: "装饰器与多进程以及Pickle"
date: 2015-02-15 21:39:08 +0800
comments: true
keywords: [pickle, 多进程, 装饰器, 序列化]
description: 装饰器与多进程的化学反应
tags: [pickle, Python, 多进程, 装饰器, 序列化]
categories: Python
---


<!--more-->
* any list
{:toc}



## 缘起

因为需要并发请求同时计时, 写上如下代码:

```python
def timer(func):
    def _wrap(*args):
        start = time.time()
        ret = func(*args)
        return ret, time.time() - start
    return _wrap

@timer
def get(url):
    return requests.get(url)

rets = []
for i in xrange(10):
    rets.append(pool.apply_async(get, (url,)))
for ret in rets:
    ret.get()
```

好的, 来执行脚本...

得到了如下错误, WTF:

```
PicklingError: Can't pickle <type 'function'>: attribute lookup __builtin__.function failed
```

=,= 和 Pickle 有毛关系, 百思不得...


## 解答

这时候先上搜索引擎.

在 SO 上得到了这样一对问答: [戳这里](http://stackoverflow.com/questions/9336646/python-decorator-with-multiprocessing-fails)

简单总结一下:

* 进程间通信时, 对象(数据)的传输是需要序列化的.
* Python 中对象序列化最常见的方法是 Pickle
* 不是所有的 Python 对象都可以用 Pickle 序列化
* 函数装饰器反回的函数对象就不在可 Pickle 对象之列
* 换成类装饰器就万事大吉


好了, 先来结出类装饰器的版本:

```python
class timer(object):
    def __init__(self, func):
        self.func = func

    def __call__(self, *args):
        start = time.time()
        ret = self.func(*args)
        return ret, time.time() - start

@timer
def get(url):
    return requests.get(url)
```


## 分析

现在, 来分析一下为什么类装饰器就可以序列化, 而函数装饰器就不可以

先来看, 那些对象是可以序列化的. 参考[官方文档](https://docs.python.org/2/library/pickle.html#what-can-be-pickled-and-unpickle)

把这个问题相关的简单翻译一下:

* 只含有可 Pickle 元素的`元组`/`列表`/`集合`/`字典`
* 在模块顶层定义的`函数`
* `__dict__` 属性或 `__getstarte__()` 函数的返回可以 Pickle 的`实例`


#### 函数装饰器

```python
def timer(func):
    def _wrap(*args):
        # 省略
        return ret
    return _wrap
```

我们知道, 装饰器实际上是表达式 `get = timer(get)` 的语法糖.

那么, 被装饰器包裹后的 `get` 实际上就是 `timer` 的返回值 => `_wrap` 函数.

而这函数定义的位置是在 `timer` 内部. 并不满足 Pickle 的条件(模块顶层定义).

所以会导致文章开始的那个错误.


#### 类装饰器

```python
class timer(object):
    def __init__(self, func):
        self.func = func

    def __call__(self, *args):
        # 省略
```

在这里, 被装饰器包裹后的 `get` 就变成了 `timer` 类的实例.

既然是实例, 再加上我们没有定义 __getstate__ 方法, 就直接来看 __dict__ 属性

明显的, 这个实例的 __dict__ 是字典 `{'func': <function get at 0x*****>}`

字典所包含的元素为原始的 `get` 函数, 这个函数是定义在模块顶层的.

既然如此, 那么类装饰器的结果自然也就是可 Pickle 了:

`原 get 可 Pickle` => `__dict__ 可 Pickle` => `实例可 Pickle`


--------
