---
layout: post
title: "mock.patch 用装饰器来回避缩进地狱"
date: 2016-01-04 10:54:44 +0800
comments: true
keywords: [mock, patch]
description: 用装饰器来回避 with 带来的缩进地狱
tags: [python, mock, unittest, patch]
categories: Python
---


<!--more-->
* any list
{:toc}

## 关于 mock

在测试中间模块时, 由于其会对底层模块有依赖, 或者对系统函数有依赖.
为了保证测试的自闭性, 需要用测试方的模块来代替原有模块. 这类技术就叫做 mock[^1]

在 Python 中有一个叫`mock`的模块, 就是用来做这件事的. 在 3.3 以上的版本中, mock
集成到了 `unittest.mock` 模块, 而对于之前的版本需要自行安装.

至于 `mock` 的具体用法, 请参考[官方文档](https://docs.python.org/3.5/library/unittest.mock.html)


## patch 的 with 用法

这个是最早接触的时候学到的关于 patch 的用法. 我们直接上代码示例

```python
def test_cases(self):
    with patch("codecs.open", return_value=io.StringIO(self.mock_string)):
        cases = {}
        for query, cards in case.Cases("any"):
            cases[query] = cards
        it(cases).should.have.key(u"case1").which.should.contain(u'a', u'b', u'c')
        it(cases).should.have.key(u"case2").which.should.contain(u'1', u'2', u'3')
```

这里面, patch 的关键字参数用于定义生成的 MagicMock 对象的相关属性


很显然, 当我们需要 mock 的模块比较多时, 缩进会变成一个大灾难. 像这样:


```python
def test_sth(self):
    with patch("moduleA.methodA"):
        with patch("moduleB.methodB"):
            do your test
```

从上面的示例看到, 仅仅是做了两个 mock, 测试代码的缩进就已经非常影响代码的可读性了. 更不用说三个或都更多了.


## 用装饰器用法

为了回避这样的缩进问题, 可以使用 `patch` 的装饰器用法, 如下


```python
@patch("codecs.open")
def test_cases(self, mock_open):
    mock_open.return_value = io.StringIO(self.mock_string)

    cases = {}
    for query, cards in case.Cases("any"):
        cases[query] = cards
    it(cases).should.have.key(u"case1").which.should.contain(u'a', u'b', u'c')
    it(cases).should.have.key(u"case2").which.should.contain(u'1', u'2', u'3')
```

这样, 将 patch 过程放到装饰器去, 测试代码主体便可以节省下缩进,
进而可以提升代码的可读性.


多层的示例

```python
@patch("moduleA.methodA")
@patch("moduleB.methodB")
def test_sth(self, mocked_methodB, mocked_methodA):
    do your test
```

对于装饰器用法, 需要注意的是有两条:

1. patch 后的 mock 对象需要作为参数传给测试函数
2. 当有多层 patch 时, 测试函数的参数和 patch 的顺序是相反的.





--------
[^1]: 有的地方叫插桩
