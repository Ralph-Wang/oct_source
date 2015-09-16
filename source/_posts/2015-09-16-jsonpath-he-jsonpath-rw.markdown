---
layout: post
title: "jsonpath 和 jsonpath-rw"
date: 2015-09-16 18:53:48 +0800
comments: true
keywords: [Python, jsonpath, json]
description: Python 的两个 jsonpath 模块
tags: [Python, json, jsonpath]
categories: Python
---


<!--more-->
* any list
{:toc}


## jsonpath

关于什么是 `jsonpath`: [出门左转](http://goessner.net/articles/JsonPath/)


## python 的模块


python 中用于 jsonpath 解析的库有以下两个.

* [jsonpath-rw-ext](https://pypi.python.org/pypi/jsonpath-rw/1.4.0)
* [jsonpath](https://pypi.python.org/pypi/jsonpath/0.54)

从下载量来看, `jsonpath-rw-ext` 的使用人数更多.

但因为历史原因[^1], 我选择使用了 `jsonpath` 模块

### 比较

#### 依赖
__jsonpath__ 是一个完全独立的库, 并且只有一个文件, 不依赖外部库

__jsonpath-rw-ext__ 依赖 `jsonpath-rw`, `Babel`, `pytz`, `pbr`, `ply`, `six`, `decorator` 多个外部库

#### 语法
**jsonpath**

* 支持 http://goessner.net/articles/JsonPath/ 提到的所有语法
* 扩展点号语法, 支持直接使用数组索引, 类示 `$.key.idx`.

**jsonpath-rw-ext**

* 同样支持文档中的所有语法

* 没有扩展点号语法, 如果是数组要明确使用 `$.key[idx]`

* 扩展了类似 ``this`` 这样的反引号关键词

#### 安装
**jsonapth** 

* 虽然在 [pypi] 上有索引, 但是并没有提供下载包, 需要自己手动下载并放入项目

**jsonapth-rw**

* 可以直接用 `pip` 进行安装, 包括所有依赖
* 使用 `pip` 需要能连接到的 pypi 服务, 一般来说需要外网


#### 易用
**jsonpath** 只暴露了一个接口

```python
import jsonpath
jsonpath.jsonpath(path, dict)
```

**jsonpath-rw-ext** 需要使用如下代码进行解析

```python
from jsonpath_rw_ext import parse
jsonpath_expr = parse('foo[*].baz')
[match.value for match in jsonpath_expr.find({'foo': [{'baz': 1}, {'baz': 2}]})]
```

#### 维护

**jsonpath** 的作者已经不再维护这个项目

**jsonpath-rw-ext** 的作者仍在维护, 最新一次更新代码在上个月

## 小结

机器能上外网, 或者能搞个本地 pypi 镜像的情况, 还是建议用 `jsonpath-rw-ext`

不能上外网又不想为这么个模块就做个 pypi 镜像, 那就用 `jsonpath`


---------
[pypi]: http://pypi.python.org
[^1]:  测试机不能访问外网, 当时也不懂自己搞个 pypi 本地镜象
[^2]: 这真是个大坑

