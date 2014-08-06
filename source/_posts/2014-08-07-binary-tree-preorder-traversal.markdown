---
layout: post
title: "Binary Tree Preorder Traversal"
date: 2014-08-07 00:50:19 +0800
comments: true
keywords: [Binary Tree, 二叉树, 前序遍历]
description: leetcode 第二题 Binary Tree Preorder Traversal
tags: [遍历, 二叉树, 前序遍历, DSF, leetcode]
categories: leetCode
---

算法倒是没犯错. 坑在 Python 的一个赋值语法上了

<!--more-->
* any list
{:toc}

## 题目

Given a binary tree, return the preorder traversal of its nodes' values.

For example:   
Given binary tree {1,#,2,3},

```
   1
    \
     2
    /
   3
```

return [1,2,3].

Note: Recursive solution is trivial, could you do it iteratively?

### 翻译

一颗二叉树. 返回按前序遍历排序的节点值列表

例子:
二叉树: {1, #, 2, 3}

```
   1
    \
     2
    /
   3
```

返回 [1, 2, 3]

注: 递归式相当简单.试试迭代式?

## 我的解法

### 迭代式(DSF)

最近正好在看图的遍历. 看了下二叉树前序遍历的定义. 自然就想到了用 DSF 算法.    
很快就把代码写好了. 但得到的不是 RunTime Error, 就是 Time Limited Exceeded...

但是, 用 Java 实现却是直接就通过了...(忽略因为不熟 Java 各种类型造成的多次编译错误)

!!!! 还能不能愉快的玩耍了...n

把代码拷到本地调试后发现, 执行过程中 `discovered` 和 `ans` 是同一个列表    
回头看我的初始化代码

```python
discovered = ans = []
```

明白了...

Python 里面这样的连等赋值是将同一对象坑给不同变量...    
因为以前这样赋值时多是`不变量`, 所以没什么问题.    
但列表是`容器`, 所以..就出现了问题

修改初始化

```python
discovered = []
ans = []
```

OK, 顺利通过~    
下面是完整代码:

```python
class TreeNode:
    def __init__(self, x):
        self.val = x
        self.left = None
        self.right = None

class Solution:
    # @param root, a tree node
    # @return a list of integers
    def preorderTraversal(self, root):
        if root is None: # empty tree
            return []
        discovered = [] # error type: discovered = ans = []
        ans = []
        discovered.append(root)
        while discovered != []:
            v = discovered.pop()
            ans.append(v.val)
            if v.right is not None:
                discovered.append(v.right)
            if v.left is not None:
                discovered.append(v.left)
        return ans
```

### 递归式

递归式也不是很难. 想清楚 Base Case 好了

* Base Case: 以空树作为 Base Case, 返回空列表 `[]`    
* Recursion: 如果有的话, 依次加上左子树和右子树的前序列表就可以了

```
class Solution:
    # @param root, a tree node
    # @return a list of integers
    def preorderTraversal(self, root):
        if root is None:
            return []
        ans = [root.val]
        if root.left is not None:
            ans += self.preorderTraversal(root.left)
        if root.right is not None:
            ans += self.preorderTraversal(root.right)
        return ans
```
