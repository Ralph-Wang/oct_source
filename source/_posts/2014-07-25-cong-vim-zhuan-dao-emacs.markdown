---
layout: post
title: "从 vim 转到 emacs"
date: 2014-07-25 21:24:43 +0800
comments: true
keywords: 
description: 
tags: 
categories: 
---



正式从 vim 切换到 emacs

<!--more-->

# 理由
emacs 优势: 不区分模式, 移动和输入可以并行
emacs 劣势: 快捷键均为组合键, 输入相对 vim 麻烦

嘛, 上面那个劣势完全可以通过练习适应, 更何况 emacs 有传说中的 org-mode. 使用起来会更给力.

所以, 这个编辑器的切换是势在必行的

# 入门练习
emacs 提供了很好的帮助+练习文档 `M-x help-with-tutorial`

为了尽快能使用 emacs, 个人认为有必要优先学习以下快捷键:

* 翻页: C-v, M-V
* 移动: C-f, C-n, C-b, C-f
* 编辑: 直接狠狠的敲键盘, C-u (n) , M-(n)
* 保存及退出: C-x C-s, C-x C-c
* 删除: C-d, Delete/BackSpace, M-d, M-Delete, C-k, M-k
* 粘贴(yank): C-y, M-y
* Undo/Redo: C-x u, C-_ , `C-g` C-_. ( `C-g` 可以用任意非编辑命令代替
* Buffer: C-x C-b, C-x b [buffer]
* 窗口: C-x 1
* goto: M-x goto-line
* 简单补全: M-/

有了这些快捷键可以保证基本的文本编辑了, 至于高级的功能如语法高亮/自动缩进等一系列功能就需要另外学习了.

# 用 emacs 写 markdown

emacs 原生没有 markdown-mode. 需要下载安装
[markdown-mode.el](http://jblevins.org/projects/markdown-mode/)

安装方法参考官方文档

## markdown-mode 下的比较有用的快捷键


`C-c C-a L` 交互式的添加[链接][1], 这种方式会在 MiniBuffer 中以交互式完成链接书写 [相同链接][1]


`C-c C-a f`: 给句字添加一个注脚[^1],  Mou 倒是能解析. 不知道 octopress 能解析不?


### 添加图片 `C-c C-i`

`C-c C-i i` 插入 `![]()`, 按键位置比直接输入括号好一些

`C-c C-i I` 插入引用图片, ![][], 可惜不是交互式的



[1]: http://ralph-wang.github.io/ "This Blog"
[^1]: 这里是一个注脚
