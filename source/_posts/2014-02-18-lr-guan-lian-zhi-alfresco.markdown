---
layout: post
title: "LR 关联之 Alfresco"
date: 2014-02-18 00:39:11 +0800
comments: true
keywords: LoadRunner, 性能测试, 性能, 关联, 参数化, Headers, urlEncode, LR
description: LoadRunner 开发 Alfresco 创建用户脚本实例, 遇到的关联问题及解决思路
tags: [LoadRunner, 性能测试, 脚本开发, 关联]
categories: LoadRunner
---

遇到一个比较特别的关联的例子. 
<!--more-->
项目是 [Alfresco](http://www.alfresco.com).
需要开发的脚本业务: 管理员新增用户.


### 问题
录制后, 原本以为简单参数化一下就可以成功运行, 但却发现运行时最后一步提交请求时, 返回的状态码为 500.

![Error Message][1]

本以为是系统出了什么毛病, 于是去手工操作业务, 却发现一切正常.

再去翻看 LoadRunner 的 Test Result. 发现了好东西.

![Test Result][2]

如上图, 虽然是虽然请求返回的状态码是 500, 但返回页面仍是 Alfresco 的页面, 


### 分析

状态码 500, 返回页面为系统页面. 这说明 500 的状态码是系统主动返回的. 

一般来说, 这种情况都是系统需要验证了某些提交信息, 
而这些信息是由前面的某个请求返回的. 回放时这些信息发生了变化, 导致请求失败.

我们需要关联这些信息来保证请求的合法性.

----

首先我们需要找到哪些信息是系统要验证的, 如果有开发配合, 问一嘴就好了.

没有开发配合的话, 就得我们自己找了. 就像现在.

我们先来看请求发出的信息. 首先从请求体里面找

请求体是 `json` 格式的, 如下
```javascript
{   "userName":"www2",
	"password":"www2",
	"firstName":"www2",
	"lastName":"",
	"email":"www2@www.com",
	"disableAccount":false,
	"quota":127893619,
	"groups":[]
}
```
`userName` 是用户名, `password` 是用户密码, `firstName` 是名字, `lastName`
是姓氏, `email` 是邮箱, `disableAccount` 是禁用选项, `quota` 是分配容量, `groups` 是用户所在组

呃... 每个 key 都有对应的表单字段. 看来需要关联的验证信息并不在请求体中.

那就只有看看请求头了.

![LR Log][3]

这里发现了一个嫌疑犯: `Alfresco-CSRFToken`

看名字, 应该是用来防止 `CSRF` 攻击的. 应该是它没错.

我们再用 `Fiddler` 来看下新请求里, 这个值是否发生了变化.

![Fiddler][4]

果然发生了变化. 这下没错了, 它就是我们需要关联的对象.

然后, 我们要找到系统是什么时候把这个信息发送给我们的.

依次查看各个请求后发现, 在进入用户管理页面时, 返回的请求头里有如下信息

![To Correlations][5]

由于信息中的特殊符号被 `URL编码` 了, 导致在前后两个请求中看上去有些不一样.
通过解码我们可以确认, 这里就是关联参数的来源

```javascript
decodeURIComponent('NPizHL2EuHsHN6VMml0sAfezFhPQmT5fynjkx%2fkqP88%3d')

// output: NPizHL2EuHsHN6VMml0sAfezFhPQmT5fynjkx/kqP88=
```

### 解决方案

添加以下代码
```c
web_reg_save_param("token",
		"LB=CSRFToken=",
		"RB=;",
		"Search=Headers",
		LAST);
...
// user requests codes
...

web_add_header("Alfresco-CSRFToken", url_decode(lr_eval_string("{token}")));
...
// submit requests codes
...
```
TIPS:

* 由于不能直接在请求中添加请求头信息, 所以我们需要调用 `web_add_header`
函数来添加.

* 因为系统发送过来的 `token` 是 `URL编码` 的字符串, 而提交新增时发送回去的是解码过的. 所以我们在添加 header 时需要进行解码.  这就是 `url_decode` 函数的作用. 这个函数并不是 LR 自带的函数, 需要自行添加. 源代码及添加方法戳[这里](http://www.51testing.com/html/96/n-832896.html)

-----
关于 `URL编码` 问题, 后来又找到一个 LoadRunner 原生的解决方案如下:

[http://blog.csdn.net/womengdoushizhongguo/article/details/8517598](http://blog.csdn.net/womengdoushizhongguo/article/details/8517598)

于是, 新增的代码可以修改为
```c
web_reg_save_param("token",
		"LB=CSRFToken=",
		"RB=;",
		"Search=Headers",
		LAST);
...
// user requests codes
...
lr_convert_string_encoding(lr_eval_string("{token}"),LR_ENC_SYSTEM_LOCALE,
		LR_ENC_UTF8 , "token"); 
web_convert_param("token", "SourceEncoding=URL",
		"TargetEncoding=PLAIN",LAST );
lr_convert_string_encoding(lr_eval_string("{token}"),LR_ENC_UTF8
		, LR_ENC_SYSTEM_LOCALE, "token");

web_add_header("Alfresco-CSRFToken", lr_eval_string("{token}"));
...
// submit requests codes
```

[1]: /blogimgs/alfresco-errmsg.png "Err Msg"
[2]: /blogimgs/alfresco-500page.png "500 Page"
[3]: /blogimgs/alfresco-lr.png "Lr Log"
[4]: /blogimgs/alfresco-fiddler.png "Fiddler" 
[5]: /blogimgs/alfresco-tocor.png "To Correlations"
