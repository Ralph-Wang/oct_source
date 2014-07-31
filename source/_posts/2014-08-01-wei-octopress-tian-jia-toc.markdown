---
layout: post
title: "为 octopress 添加 TOC"
date: 2014-08-01 00:52:13 +0800
comments: true
keywords: [markdown, octopress, toc]
description: 为 octopress 里文章添加 TOC 支持
tags: [octopress, markdown, toc]
categories: octopress
---


添加一个 TOC 方便阅读

<!--more-->

* any list
{:toc}

## 尝试

开始时尝试了使用默认引擎 `rdiscount` 的扩展 `generate_toc`, 但效果并不好.
生成的目录不能进行点击跳转

切换为 `kramdown` 引擎后, TOC 解析正常.

## kramdown 配置

要切换 `kramdown`, 只需要修改 `_config.yml` 文件中的 `markdown` 属性

如下:

```yaml _config.yml
markdown: kramdown
  toc_levels: 2..3
```

其中, `toc_levels` 是用来指定那些标题会进入目录.

因为写作习惯, 我这里就只配置为 h2, h3 进入目录.

## 在文章中使用

完成配置后, 在文章中需要的地方添加以下两行

```
* any list
{:toc}
```

`kramdown` 引擎会帮我们把上面两行按配置解析成 toc, 也就是目录了.

> 如果没有第一行的列表标识的话, kramdown 是不会进行正确的 toc 解析的

## 让 TOC 飘起来

为了让 TOC 更在阅读的时候更方便, 我们需要修改一下样式

kramdown 解析出来的 TOC 的 id 为 `markdown-toc`. 所以我们修改样式如下

```css
#markdown:before {
    content: "目录";
    font-weight: bold;
}
ul#markdown-toc {
    list-style: none;
    position: fixed;
    padding: 0px;
    left: 10px;
    bottom: 200px;
    border-radius: 0.3em;
    box-shadow: rgba(0,0,0,0.15) 0 1px 4px;
    box-sizing: border-box;
    border: #fff 0.5em solid;
    background-color: white;
}
```

这样一个在文章左边悬停的 TOC 就做了好

## 问题什么的[^1]

* kramdown 与 rdiscount 在对 markdown 的部分细节处理上有所不同. 以前的文章也要做调整

* TOC 的锚, 在跳转时因为 navbar-fixed-top 的问题, 调整 h1~h6 的样式为 {margin-top:-70px;padding-top:70px}.

* 小标题能太长.. 要不会盖到文章正文

-----------

[^1]: 呃, 为一个 TOC 做到这样. 我也算蛮拼的...
