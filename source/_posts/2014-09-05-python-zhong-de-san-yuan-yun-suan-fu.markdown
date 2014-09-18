---
layout: post
title: "python 中的三元运算符"
date: 2014-09-05 11:08:30 +0800
comments: true
keywords: [python, 运算符, operator, if, else]
description: Python 中模拟三元运算符(:?)的方法
tags: [Python, 运算符, 基准]
categories: Python
---


<!--more-->
* any list
{:toc}

## 方法介绍 ##

Python 原生是不支持三元运算符: `(expresion):val1?val2`    
但 Python 提供了一些语法糖在模拟三元运算符的操作

就以下面这样一个用例来看看 Python 中可以怎么处理三元运算


```c
(val > 0)?1:(val < 0)?-1:0
```

运算含义: val 值为正则返回 1, 为负则返回 -1, 为 0 则返回 0

### IF 块[^1]###

这个是最笨拙的方法. 用 `if...else...` 块实现

写出来后代码如下:

```python
def if_block(val):
    if val > 0:
        return 1
    elif val < 0:
        return -1
    else:
        return 0
```

因为是直接用 `if...else...` 描述出三元描述符的运算过程.    
所以这种实现方法是最容易理解的.

### 逻辑运算 ###

`IF 块` 的方法虽然很容易理解, 但是相对的代码行数略微多了点.

那能不能一行就搞定呢.    
当然是可以的.

用`逻辑运算`来处理它

```python
def and_or(val):
    return (val > 0) and 1 or (val < 0) and -1 or 0
```

这种方法阅读起来并不是那么的直观, 但是三种方法中最接近原始表达.    
其中`逻辑符号`和`运算符`对应关系如下表

|逻辑符号|运算符号|
|:---:|:-:|
|`and` | `?` |
|`or` | `:` |

#### 不过...

这种方法有一个缺点, `and` 后的值对应的布尔值必须为真.
像下面这个条件, 返回值总会是 -1

```
(val == 0) and 0 or -1
```

嘛, 毕竟它只是`逻辑运算`

### 内联 IF ###

虽然用`逻辑运算`去 hack 是最接近三元运算最原始的表达的. 但毕竟有一个缺陷.

于是, 就是最后一种内联IF的写法. 很类似列表表达式


```python
def if_inline(val):
    return 1 if val > 0 else -1 if val < 0 else 0
```

就可读性来说, 这种写法是比较差的, 但没有逻辑运算那样的缺陷.
同时, 也不像 block 版那样写三遍 return

## 基准测试 ##

既然有三种不同的写法, 那三种写法的执行效率是否是样呢.

于是写了如下测试脚本:

```python ternary.py
#!/usr/bin/env python
import random

def if_block(val):
    'use if block for ternary operation'
    if val > 0:
        return 1
    elif val < 0:
        return -1
    else:
        return 0


def if_inline(val):
    'use if inline for ternary operation'
    return 1 if val > 0 else -1 if val < 0 else 0


def and_or(val):
    'use and/or for ternary operation'
    return val > 0 and 1 or val < 0 and -1 or 0


def test():
    import timeit
    import dis
    print 'if_block:'
    dis.dis(if_block)
    print timeit.timeit('if_block(random.randrange(-10,11))',
                        'from __main__ import if_block, random')
    print '-' * 20

    print 'if_inline:'
    dis.dis(if_inline)
    print timeit.timeit('if_inline(random.randrange(-10,11))',
                        'from __main__ import if_inline, random')
    print '-' * 20

    print 'and_or:'
    dis.dis(and_or)
    print timeit.timeit('and_or(random.randrange(-10,11))',
                        'from __main__ import and_or, random')
    print '-' * 20


test()
```


脚本执行结果如下:    
可以很清楚的看到, 三种写法编译后的指令数是一样的.    
执行时间相差也不大, 多次执行时会有一定浮动
(果然应该把 timeit 次数设置大一点么)

> `if_block` 最后多出来 2 条指令是因为 Python 中函数最后默认返回 None. 实际调用时, 不可能会执行到这两条指令

```text
if_block:
  8           0 LOAD_FAST                0 (val)
              3 LOAD_CONST               1 (0)
              6 COMPARE_OP               4 (>)
              9 POP_JUMP_IF_FALSE       16

  9          12 LOAD_CONST               2 (1)
             15 RETURN_VALUE

 10     >>   16 LOAD_FAST                0 (val)
             19 LOAD_CONST               1 (0)
             22 COMPARE_OP               0 (<)
             25 POP_JUMP_IF_FALSE       32

 11          28 LOAD_CONST               3 (-1)
             31 RETURN_VALUE

 13     >>   32 LOAD_CONST               1 (0)
             35 RETURN_VALUE
             36 LOAD_CONST               4 (None)
             39 RETURN_VALUE
1.25232696533
--------------------
if_inline:
 18           0 LOAD_FAST                0 (val)
              3 LOAD_CONST               1 (0)
              6 COMPARE_OP               4 (>)
              9 POP_JUMP_IF_FALSE       16
             12 LOAD_CONST               2 (1)
             15 RETURN_VALUE
        >>   16 LOAD_FAST                0 (val)
             19 LOAD_CONST               1 (0)
             22 COMPARE_OP               0 (<)
             25 POP_JUMP_IF_FALSE       32
             28 LOAD_CONST               3 (-1)
             31 RETURN_VALUE
        >>   32 LOAD_CONST               1 (0)
             35 RETURN_VALUE
1.26190900803
--------------------
and_or:
 23           0 LOAD_FAST                0 (val)
              3 LOAD_CONST               1 (0)
              6 COMPARE_OP               4 (>)
              9 POP_JUMP_IF_FALSE       18
             12 LOAD_CONST               2 (1)
             15 JUMP_IF_TRUE_OR_POP     39
        >>   18 LOAD_FAST                0 (val)
             21 LOAD_CONST               1 (0)
             24 COMPARE_OP               0 (<)
             27 POP_JUMP_IF_FALSE       36
             30 LOAD_CONST               3 (-1)
             33 JUMP_IF_TRUE_OR_POP     39
        >>   36 LOAD_CONST               1 (0)
        >>   39 RETURN_VALUE
1.27082109451
--------------------
```

[^1]: 这三个名称都不是官方名称...
