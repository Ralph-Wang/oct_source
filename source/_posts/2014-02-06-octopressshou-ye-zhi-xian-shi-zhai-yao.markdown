---
layout: post
title: "octopress首页只显示摘要"
date: 2014-02-06 00:30:36 +0800
comments: true
categories: octopress
---

上一篇博客比较长，发现首页居然照样显示了全文

于时查找了下如何只显示摘要
<!--more-->
实现方式很简单:

* 在博客文档中添加`<!--more-->`即可

* 添加之后，首页文章后会添加一个`read on`链接，指向文章页面

* 并且只有`<!--more-->`前的内容人显示到首页

像这样
```
上一篇博客比较长，发现首页居然照样显示了全文

于时查找了下如何只显示摘要
<!--more-->
实现方式很简单:

* 在博客文档中添加`<!--more-->`即可

* 添加之后，首页文章后会添加一个`read on`链接，指向文章页面

* 并且只有`<!--more-->`前的内容人显示到首页
```


####　懒人做法


修改`Rakefile`，使写新文章时自动添加一个`<!--more-->`
```ruby Rakefile
    post.puts "date: #{Time.now.strftime('%Y-%m-%d %H:%M:%S %z')}"
    post.puts "comments: true"
    post.puts "categories: "
    post.puts "---"
    post.puts ""
    post.puts ""
    post.puts "<!--more-->"
```


