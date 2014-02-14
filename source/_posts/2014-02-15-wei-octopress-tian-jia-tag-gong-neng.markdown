---
layout: post
title: "为 Octopress 添加 Tag 功能"
date: 2014-02-15 00:09:14 +0800
comments: true
tags: [octopress, 边栏, 扩展]
categories: octopress
---

对于博客文章来讲, 除了类别外, 另一个重要的标识属性便是**标签**.
<!--more-->

诚如 `alswlx` 在 [给 octopress 加上标签功能](http://blog.log4d.com/2012/05/tag-cloud/)
描述的那样:
```
分类 和 标签 分别代表了 有序/无序 两种不同的知识归纳方法.
一篇文章只会属于一个分类, 但可以同时拥有多个标签.
```

而原生的 octopress 却不支持标签功能, 所以, 有必要为它添加上这个功能


我选择的解决方案来自: 

[为octopress添加tag
Cloud](http://codemacro.com/2012/07/18/add-tag-to-octopress/)

里面涉及到的两个插件都是 robbyedwards 写的, github 仓库附在下面:

[tag_pages](https://github.com/robbyedwards/octopress-tag-pages)

[tag_cloud](https://github.com/robbyedwards/octopress-tag-cloud)

clone 这两个项目, 得到两个相同的目录结构:

```
.
|--plugins
|--source
|--CHANGELOG.md
|--README.md
```

如果你用的是 octopress 原生的主题, 那么直接复制这两个文件夹到 octopress
目录下即可.

如果是自定义主题的话需要做一些修改一下, `source` 目录下的各个 `html`
文件来适应你的主题. 既然都玩上自定义主题了,
这里我就是赘述各个文件的修改方法了.

如果你和我一样使用的是 [octostrap3](https://github.com/kAworu/octostrap3), 可以参考一下我的配置
[octo-source](https://github.com/Ralph-Wang/octo-source)

配置好之后, 在文章中添加标签了.

使用方法就是在文章的头部配置部分添加 tags 属性即可.

如下:

```
-----
tags: [octopress, 扩展, asides]
categories: octopress
----
```
