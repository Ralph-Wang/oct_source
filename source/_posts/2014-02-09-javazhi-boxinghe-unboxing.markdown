---
layout: post
title: "Java之Boxing和Unboxing"
date: 2014-02-09 22:07:16 +0800
comments: true
tags: [java, boxing, 拆箱, 装箱, 数据类型]
categories: java
---

Java中有两大类数据类型： **基本类型**和**引用类型**。

另外地，**基本类型**们都有其对应的**封装类**。

比如： `int` -> `Integer`
<!--more-->

将**基本类型**转换成其对应的**封装类**的过程，就叫做装箱(Boxing)。

反之，就叫拆箱(Unboxing)。


## Auto Boxing && Unboxing

因为每次显示的装箱、拆箱过于麻烦，从`JDK 5`开始，Java　提供了自动装箱、拆箱(Auto Boxing & Unboxing)

让下面这样的代码成立。

```java
Integer i = 100; //Boxing
int j = new Integer(100); //Unboxing
```

但是在装箱过程中，有个小特点需要注意一下。

当装箱的`int`类型在 -128~127 之间时，装箱后的引用会指向同一对象。

而不在这范围内的值，每次装箱都会产生一个新对象。

类似的其它基本类型的范围：

* `boolean` : 装箱后总是指向同一对象
* `long` : -128L~127 之间，装箱后指向同一对象
* `float` : 总是产生新对象
* `double` : 总是产生新对象

下面是测试代码：
{% gist 8900088 %}
