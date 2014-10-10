---
layout: post
title: "count += 1 不是原子级的"
date: 2014-10-10 12:04:09 +0800
comments: true
keywords: [Python, 自增, 线程安全]
description: Python 中的 count += 1 操作不是原子级的, 不是线程安全的
tags: [Python, 自增, 线程安全]
categories: Python
---


<!--more-->
* any list
{:toc}

## 怀疑

一直以为 Python 中类似 `count += 1` 的操作是原子级的...

于是在看到如下代码时, 产生了怀疑

```python
done_num = 0
lock = threading.RLock()
# 省略...
class Trans(threading.Thread):
    def run(self):
        global count
        # ...
        lock.acquire()
        count += 1
        lock.release()
        # ...
```

看到这部分代码时, 第一反应是为毛这种统计要用全局变量做啊...    
且不说这种用全局变量的行为; 为毛做个计数 + 1 也要锁一下啊. 难道计数不是原子级的吗!!!

## 测试

本着, `如果不出代码出过问题, 不会在这么逗[哔][^1]的地方加锁` 的想法. 用以下代码进行了测试.

```python

count = 0

class GlobalCount(threading.Thread):
    def __init__(self):
        super(GlobalCount, self).__init__()

    def run(self):
        global count
        for dummy_i in xrange(10):
            count += 1

threads = []
threads_num = 100000

for dummy_i in xrange(threads_num):
    threads.append(GlobalCount())

for thread in threads:
    thread.start()

for thread in threads:
    thread.join()

print count
```

如果 count += 1 是线程安全的话, 上面这段脚本执行完成后输出应该是 `1000000`. 不会多, 也不会少

执行以上脚本三次的结果:

```bash
999990
999982
999940
```

哇嚓嘞, 还真是线程不安全的...

## 分析

好吧, 即然线程不安全了, 那为什么呢? 为什么做个加法会线程不安全呢?

来看下 `count += 1` 的编译码:

```
3 LOAD_CONST               1 (1)
6 INPLACE_ADD
7 STORE_GLOBAL             0 (count)
```

假设如下场景:    
1. 如果有那个一个线程完成 `3 LOAD_CONST` 后, 因为时间片消耗完了停了一小会儿. 我们假设这时 count 为 999    
2. 这时候, 其它线程正常进行, 并且 count 已经增加到 1003 或者更大.    
3. `1.`中的线程又得到的时间片, 完成后续步骤. 这时 count 被改回到 1000.    
4. 其它线程的计数被抹掉了...

## 扩展

类似的在其它语言中 `count++` 等操作也有不是线程安全的

相关阅读: [来自Google](https://www.google.com/?gws_rd=ssl#q=i%2B%2B+%E7%BA%BF%E7%A8%8B%E5%AE%89%E5%85%A8)

--------


[^1]: 事实证明, 逗[哔]的是博主
