---
layout: post
title: "java线程状态"
date: 2014-02-08 11:07:52 +0800
comments: true
categories: java
---

监控 Java 线程时，首先要关注的就是线程的运行状态。

一般来说，Java 线程有 6 种状态： 

1.  NEW
2.  RUNNABLE
3.  WAITING & TIMED_WAITING
4.  SLEEP
6.  TERMINATED
5.  BLOCK

下面，用代码示例一下各个状态
<!--more-->

### 1. NEW & TERMINATED
这两个状态比较特殊，分别出现在线程**运行之前**和线程**运行之后**。

这里所说的**运行**指调用线程的`start()`方法。

代码：
{% gist 8839097 NT.java %}

虽然没有重写`run`方法，线程会很快结束。但如果在`start()`后直接调用`getState()`的话，仍然会返回**RUNNABLE**，所以耐心的等上一秒吧。


### 2. RUNNABLE
我们开线程的目的就是要让它跑起来，所以这个状态可以说是线程的主要状态。

它表示线程正如我们预期的一样正在运行。

代码：
{% gist 8839123 Runnable.java %}

运行时，程序会在标准输出里不断输出 **running**。

下面是用 **jvisualvm** 监控到的情况：

![running](/blogimgs/status-runnable.png)

图中的 **runnable** 线程就是我们在代码中启动的线程。

### 3. SLEEP
**休眠**状态下，线程不能被唤醒；必须等到休眠时间结束线程才能回到可执行状态。

让线程进入状态需要调用`Thread`类的`sleep`方法。调用时指定好需要休眠的时间，线程就可以美美的睡上一觉了。

代码：
{% gist 8875811 Sleep.java %}

**jvisualvm** 中的情况：

![sleep](/blogimgs/status-sleep.png)

注：如果用**线程 dump** 查看，会发现 sleep 线程标示的是 **TIMED_WATING**


### 4.WAITING & TIMED_WAITING
和休眠类似，等待状态下的线程也没有在运行。但是等待下的线程可以随时被唤醒。

**WAITING** 和 **TIMED_WAITING** 都是调用`wait`方法后的状态。区别在于 **WATING** 没有指定时间，除非被唤醒，否则会一直等下去。而 **TIMED_WAITING**　因为指定了时间，即使不被唤醒，也会在指定时间到达之后回到可执行状态。

代码：
{% gist 8839194 TimedWait.java %}

**jvisualvm** 中的情况：

![waiting](/blogimgs/status-wait.png)

**线程 dump** 中的情况：

![timed_wating](/blogimgs/status-timedwait.png)

### 5.BLOCK
在线程中，可以使用 `sychronized` 关键字锁住某些资源，以保证其它线程不能同时访问。如果这时其它线程需要这个资源，就会进入**阻塞**状态。

如果，两个线程同时需要对方锁住的资源，而这些资源又不能被释放，那就会形成死锁。

这里就用死锁来示例**阻塞**状态

代码：
{% gist 8839167 DeadBlock.java %}

**jvisualvm** 中的情况：

![deadBlock](/blogimgs/status-block.png)
