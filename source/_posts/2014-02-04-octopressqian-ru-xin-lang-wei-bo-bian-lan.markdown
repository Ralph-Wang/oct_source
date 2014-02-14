---
layout: post
title: "octopress嵌入新浪微博边栏"
date: 2014-02-04 18:26:31 +0800
comments: true
tags: [octopress, 边栏, 扩展]
categories: octopress
---


更换[`boottrap-theme`](http://github.com/bkutil/bootstrap-theme)后，边栏只有**最近发表**和**文章分类**两项内容显得有点寒碜。于是想着添加个新浪微博的边栏试试

<!--more-->
#### 使用微博秀服务
微博提供的一个小工具。点[这里](http://weibo.com/tool/weiboshow)查看。

从这个工具可以得到一个`iframe`片段如下：
```html weiboshow
<iframe width="100%" height="550" class="share_self"  frameborder="0"
	scrolling="no"
	src="http://widget.weibo.com/weiboshow/index.php?language=&
	width=0&
	height=550&
	fansRow=2&
	ptype=1&
	speed=0&
	skin=1&
	isTitle=1&
	noborder=1&
	isWeibo=1&
	isFans=1&
	uid={{yourUID}}&
	verifier={{yourVerifier}}&
dpc=1"></iframe>
```
src中的链接，就是微博秀的页面。

改造一下，变成`octopress`的边栏片段：
```html weibo.html
{% if site.weibo_uid %}
<section class="well">
	<ul class="nav nav-list">
		<li class="nav-header">微博</li>
		<li><iframe width="100%" height="550" class="share_self"  frameborder="0"
						scrolling="no"
						src="http://widget.weibo.com/weiboshow/index.php?language=&
						width=0&
						height=550&
						fansRow=2&
						ptype=1&
						speed=0&
						skin=1&
						isTitle=1&
						noborder=1&
						isWeibo=1&
						isFans=1&
						uid={{site.weibo_uid}}&
						verifier={{site.weibo_verifier}}&
						dpc=1"></iframe>
		</li>
	</ul>
</section>
{% endif %}
```
将这个文件保存到`custom/asides`目录下，并在`_config.yml`中的`default_asides`列表中添加`custom/asides/weibo.html`。
```yml _config.yml
default_asides: [custom/asides/weibo.html, custom/asides/category_list.html, custom/asides/recent_posts.html]
...
# Weibo
weibo_uid: 1854716251
weibo_verifier: verifier
```

接下来
```bash
rake generate
rake preview
```
访问`localhost:4000`查看一下效果。

注： `default_asides`列表中各页面的顺序就是边栏显示的顺序

---------------
####更新：
我在使用微博秀的过程中并不稳定，有时显示，有时不显示。不显示的时候直接访问URL又是有效的。

于是换一种方式, 新的`weibo.html`
```html weibo.html
{% if site.weibo_uid %}
<section class="well">
  <ul id="weibo" class="nav nav-list">
    <li class="nav-header">微博</li>
    <li>
    <iframe 
      width="100%"
      height="500"
      frameborder="0"
      scrolling="no"
      src="http://service.weibo.com/widget/widget_blog.php?uid={{site.weibo_uid}}&height=500&skin=wd_02&showpic=1"
      ></iframe>
    </li>
  </ul>
</section>
{% endif %}
```
