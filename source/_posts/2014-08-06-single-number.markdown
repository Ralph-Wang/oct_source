---
layout: post
title: "Single Number"
date: 2014-08-06 16:44:56 +0800
comments: true
keywords: [leetcode, 算法, 解题]
description: leetcode 刷题第一道. Single Number
tags: [leetcode, 算法]
categories: leetcode
---

最近开始撸算法相关的东西. 于是在 LeetCode 上找一些题来练习

<!--more-->

* any list
{:toc}

## 题目

第一题还是选择简单点的好了. 选择了一个 AC 率最高的题目.

原题:

Given an array of integers, every element appears twice except for one. Find that single one.

Note: Your algorithm should have a linear runtime complexity. Could you implement it without using extra memory?

翻译:

一个整型数组, 其中所有元素都出现了**两次**, 只有一个例外. 找出这个例外

注意:
你的算法的时间复杂度必须是线性的. 能不能不使用额外的空间就实现它?

## 我的解法

使用 Cache 计数. 可以 AC, 但使用了额外空间.

```python
class Solution:
    # @param A, a list of integer
    # @return an integer
    def singleNumber(self, A):
        cached = {}
        for i in  A:
            cached[i] = cached.get(i, 0) + 1
        for i in cached:
            if cached[i] == 1:
                return i
```

这种方法算是比较通用的通用的解法吧. 重复的元素可以不限制于**两次**

也许, 正因为没有利用到**两次**这个条件, 所以才需要使用到额外空间?

如果先排序的话倒是可以通过比较前后两个元素是否相等来寻找唯一元素.

但是目前撸过的排序算法里面就没有线性复杂度的...所以放弃了..

## 大触的解法

之后浏览了下讨论区. 似乎使用 nlg(n) 复杂度的也 AC 了..

不过看到一个相当 trick 的解法 -- 使用`异或`计算[^1]

### 异或

简单说明下异或操作:

```python
x = 1             # 1 -> 0x01 -> 00000001
y = 2             # 2 -> 0x02 -> 00000010
z = x ^ y         # 3 -> 0x03 -> 00000011
```

把整型数按位进行计算. 同为0或1则得到0, 一个0一个1则得到1
因此得到上面的 `1 ^ 2 = 3` 的计算

关于异或, 比较特殊的计算

```python
a ^ a == 0
a ^ 0 == a
a ^ b == b ^ a
```

大触的解法里就用到了上面的公式

### 解

```python
class Solution:
    # @param A, a list of integer
    # @return an integer
    def singleNumber(self, A):
        ans = 0
        for i in iter(A):
            ans ^= i
        return ans

if __name__ == '__main__':
    A = [2, 2, 3, 5, 4, 3, 5]
    s = Solution()
    print s.singleNumber(A)
```

原理就是上面提到的特殊计算: (2^2) ^ (3^3) ^ (5^5) ^ 4 = 4

---------

[^1]: 给大触们跪了 Orz
