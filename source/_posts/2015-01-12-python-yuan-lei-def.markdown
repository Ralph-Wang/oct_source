---
layout: post
title: "Python 元类 DEF"
date: 2015-01-12 20:13:16 +0800
comments: true
keywords: [Python, 元类, metaclass]
description: Python 中关于元类的一些东西
tags: [Python, 面向对象, 元类]
categories: Python
---


<!--more-->
* any list
{:toc}


## 元类基础

Python 中一切事物都是类型的实例. 

数值是数字类型的实例, 字符串是字符串类型的实例, 对象是类-类型的实例

同样的, 类(就是那个用 `class` 关键字创造出来的东西), 也是*某种*类型的实例

这种类型就叫`元类`.

如果说类是创建对象的模板, 那么`元类`就是创建类的模板

下面的代码就创建了一个名为 `meta` 的元类, 当然, 这个元类什么都没定义

```python
meta = type('meta', (object,), {})
```

当然, 元类的定义还有其它方法, 还请自行 [Google](https://mygso.herokuapp.com/search?q=Python+%E5%85%83%E7%B1%BB)

## 2.\* 和 3.\* 的坑

因为元类可能复用, 而要创建的类也会有一些自己的属性.

所以我们一般会这么写

```python
class Cls(object):
    __metaclass__ = meta
    def method_of_cls(self):
        pass
```

但是这么写有一个问题 -- `不兼容 3.*`

在 `3.*` 中, 元类语法不是上面这个样子

而是:

```
class Cls(metaclass=meta):
    def method_of_cls(self):
        pass
```

而且, 两种写法完全不兼容(不像 print)

### 兼容写法

语法上不兼容就没撤了?

如果真要兼容 `2.*` 和 `3.*`, 只能放弃 `class` 关键字, 直接使用 type 的返回值

```python
Cls = meta
```

有需要自定义的方法的情况, 将 type 的调用封装一下就可以了.

```python
def meta(name, parents, attrs):
    # do sth with name/parents/attrs
    return type(name, parents, attrs)

Cls = meta('Cls1', (object,), {})

def method_of_cls2(self):
    pass
Clas = meta('Cls2', (object,), {'method_of_cls2': method_of_cls2})
```

--------
