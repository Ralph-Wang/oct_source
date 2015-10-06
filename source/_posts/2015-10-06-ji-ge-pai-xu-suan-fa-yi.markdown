---
layout: post
title: "几个排序算法(一)"
date: 2015-10-06 20:51:23 +0800
comments: true
keywords: [排序, Python, 算法]
description: 几个排序算法的个人理解及 Python 实现
tags: [排序, Python, 算法]
categories: Python
---


<!--more-->
* any list
{:toc}

## 插入排序

### 原理

1. 列表 A 是待排序列表, 列表 B 是空列表
2. 从列表 A 读数, 并插入列表 B. 插入时, 将元素放在顺序正确的位置
3. 当元素从列表 A 完全转移到列表 B 时, 排序完成

```python
def insert_sort(lst):
    ret = []
    for i in lst:
        for j in xrange(len(ret)):
            if ret[j] > i:
                ret.insert(j, i)
        else:
            ret.append(i)
    return ret
```

### 原地化

因为列表 A 和列表 B 中元素总和是一定的.
可以利用原始列表的已访问部分作为列表 B, 进而完成原地[^inplace]的排序.

```
def insert_sort(lst):
    for i in xrange(len(lst)):
        key = lst[i]
        # 下面整个循环都是在完成插入合适的位置
        # 因为是原地插入, 所以需要一边搜索一边交换
        for j in xrange(i-1, -1, -1):
            if key < lst[j]:
                lst[j+1] = lst[j]
                lst[j] = key
            else:
                break
```

## 选择排序

### 原理

1. 类似于插入排序, 不同的是, 不再是按顺序从列表 A 从选择元素, 而是选择最大/最小值再插入.
2. 插入到列表 B 时不再涉及位置问题, 最大值总是插入列表头, 最小值总是插入列表尾

```python
def select_sort(lst):
    ret = []
    n = len(lst)
    for _ in xrange(lst):
        x = min(lst)
        lst.remove(x)
        ret.append(x)
    return ret
```

### 原地化

把列表前半部分看作空列表, 同样可以把`选择排序`原地化

```python
def select_sort(lst):
    n = len(lst)
    for i in xrange(lst):
        min_idx = lst.index(min(lst[i:]))
        if min_idx != i: # 最小值在 i 位置时位置正确, 不交换
            lst[min_idx] = lst[i] ^ lst[min_idx]
            lst[i] = lst[i] ^ lst[min_idx]
            lst[min_idx] = lst[i] ^ lst[min_idx]
```

## 冒泡排序

### 原理

`冒泡排序`和前两个排序的不同在于它一开始就是原地的.

1. 它遍历所有索引, 每次都判断当前索引的值与后一索引顺序是否正确. 不正确则进行交换.
2. 进行等同数组长度次数的遍历后, 排序完成

```
def bubble_sort(lst):
    n = len(lst)
    for i in xrange(n):
        for j in xrange(n-1):
            if lst[j] > lst[j+1]:
                lst[j] = lst[j] ^ lst[j+1]
                lst[j+1] = lst[j] ^ lst[j+1]
                lst[j] = lst[j] ^ lst[j+1]
```

### 减少循环

因为冒泡排序的特定, 经过 N 次遍历后, 数组后面的 N 项顺序是正确的.
不需要进行再遍历.

```
def bubble_sort(lst):
    n = lst(lst)
    for i in xrange(n):
        for j in xrange(n-1):
            if lst[j] > lst[j+1]:
                lst[j] = lst[j] ^ lst[j+1]
                lst[j+1] = lst[j] ^ lst[j+1]
                lst[j] = lst[j] ^ lst[j+1]
```


--------

[^inplace]: 英文术语是*in-place*, 没太注意正式的中译名.
