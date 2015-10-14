---
layout: post
title: "几个排序算法(二)"
date: 2015-10-14 17:21:15 +0800
comments: true
keywords: [排序, Python, 算法]
description: 几个排序算法的个人理解及 Python 实现
tags: [排序, Python, 算法]
categories: Python
---


<!--more-->
* any list
{:toc}

## 归并排序

## 原理

`归并排序`的根基在于递归.

#### 初始状态

两个数排序只需要将较小的那个放到前面就可以了.

那么, 对于两个列表而言, 当列表内只有一个数时. 可以很容易的合并成一个有序的列表

#### 基本推导

两个有序的列表, 合并时总是从两个列表头取较小的值,
可以将两个有序列表合并成一个有序列表.

对于一个无序的列表, 可以将它不断分割, 直到得到初始状态中的`列表中只有一个数`
再逐次向止运算, 即可得到最终的排序结果


```python
def merge_sort(lst):
    if len(lst) == 1:
        return lst

    m = len(lst) / 2
    left = merge_sort(lst[:m])
    right = merge_sort(lst[m:])

    merged = []
    i = 0
    j = 0
    p = len(left)
    q = len(right)
    while i < p and j < q:
        if left[i] < right[j]:
            merged.append(left[i])
            i += 1
        else:
            merged.append(right[j])
            j += 1

    while i < p:
        merged.append(left[i])
        i += 1
    while j < q:
        merged.append(right[j])
        j += 1
    return merged
```

## 快速排序

### 原理

`快速排序` 每一步都在找某一个特定元素的最终位置.[^1]

具体方法就是, 选定一个特定的数. 将比它大的放到其右边. 比它小的放到其左边.

然后再分别对左边和右边做同样的事.


```python
def quick_sort(lst):
    """  sort

    :type lst: list
    :returns: list

    """
    if lst == []:
        return []
    pivot = lst.pop()
    left = []
    right = []
    while lst:
        x = lst.pop()
        if x < pivot:
            left.append(x)
        else:
            right.append(x)
    return quick_sort(left) + [pivot] + quick_sort(right)

```

--------
[^1]: 这是它被用来找第 N 大的数的原因
