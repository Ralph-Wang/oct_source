---
layout: post
title: "用 Python 搞一个分布式系统玩?"
date: 2015-06-05 17:08:19 +0800
comments: true
keywords: 
description: 
tags: 
categories: 
---


<!--more-->
* any list
{:toc}


最近在撸廖雪峰老师的 Python 教程. 算是对自己做一遍查缺补漏吧.

看到分布式进程一节, 自己做了一些发散. 现在写下来, 算是补一补长达 4 个月的博文空白...

基础的代码和结构见[原教程](http://www.liaoxuefeng.com/wiki/0014316089557264a6b348958f449949df42a6d3a2e542c000/001431929340191970154d52b9d484b88a7b343708fcc60000)

## 抽离队列

为了让任务的分配和执行更自由的启动和停止.
我们必须把队列独立出来.

另外, 因为访问队列的客户端是共用的, 也抽离出来


```python base.py
#!/usr/bin/env python
# -*- coding: utf-8 -*-

from multiprocessing.managers import BaseManager

class _QueueManagerServer(BaseManager):
    pass


def QueueManagerServer(task_queue, result_queue):
    _QueueManagerServer.register('get_task_queue', callable=lambda: task_queue)
    _QueueManagerServer.register('get_result_queue', callable=lambda: result_queue)
    return _QueueManagerServer


class _QueueManagerClient(BaseManager):
    pass

def QueueManagerClient():
    _QueueManagerClient.register('get_task_queue')
    _QueueManagerClient.register('get_result_queue')
    return _QueueManagerClient
```

因为具体的队列是在 `q.py` 中创建的, 所以这里 `base.py` 只提供一个函数.

客户端虽然不需要在使用时绑定具体队列, 但为了接口调用的一致, 仍然封装到一个函数


```python q.py
#!/usr/bin/env python
# -*- coding: utf-8 -*-

from base import QueueManagerServer
from multiprocessing import Queue

task_queue = Queue()
result_queue = Queue()

Server = QueueManagerServer(task_queue, result_queue)

manager = Server(address=('0.0.0.0', 5000), authkey=b'secret')

manager.start()

manager.join()
```

这里最后一定要调用 join 来防止程序直接退出.

## 任务分配

这里我们让处理器"分布式"的向某个 webserver 发请求.

因为只是一个示例, 我们就直接向队列里输入要请求的 url.

```python dispatcher.py
#!/usr/bin/env python
# -*- coding: utf-8 -*-

from base import QueueManagerClient


client = QueueManagerClient()(address=('0.0.0.0', 5000), authkey=b'secret')

client.connect()

task = client.get_task_queue()

n = 1000000
for i in xrange(n):
    task.put('http://localhost:8888/?q={0}'.format(i))
```


## 任务处理

因为不太喜欢依赖 `try...except`, 所以在取数据前加上一队列空的检查

```python worker.py
#!/usr/bin/env python
# -*- coding: utf-8 -*-

from base import QueueManagerClient
import time, random
import requests

client = QueueManagerClient()(address=('0.0.0.0', 5000), authkey=b'secret')

print 'connect to queue...'
client.connect()


task = client.get_task_queue()
result = client.get_result_queue()

def get(url):
    start = time.time()
    try:
        requests.get(url)
    except:
        ok = 0
    else:
        ok = 1
    finally:
        rt = time.time() - start
        return {'ok': ok, 'rt': rt}

while True:
    if task.empty():
        print 'no task yet, wait 5s...'
        time.sleep(5)
        continue
    try:
        i = task.get(timeout=10)
        print 'get {0}...'.format(i)
        print 'request...'
        o = get(i)
        result.put({'i': i, 'o': o})
    except Exception, e:
        print 'Error: {0}'.format(e)
```


## 结果输出

这里我把结果输出也抽离出来了.

实际上应该根据应用来决定是放到 `dispatcher.py` 里, 还是抽离出来

```python output.py
#!/usr/bin/env python
# -*- coding: utf-8 -*-


from base import QueueManagerClient
import time


client = QueueManagerClient()(address=('0.0.0.0', 5000), authkey=b'secret')

client.connect()

result = client.get_result_queue()


while True:
    if result.empty():
        print 'no result yet, wait 5s'
        time.sleep(5)
        continue
    try:
        print result.get(timeout=2)
    except Exception as e:
        print 'Error: {0}'.format(e)
```


## 一些思考

实际上因为 QueueManager 的协议对开发者并不透明,
这样的**分布式**系统只能完全由 `Python` 来构建.

如果某部分需要更换语言会变得比较吃力.

相对的, 如果将队列更换成其它透明的队列服务(如, `memcacheq`), 
再定义好队列的数据格式. 便可以很容易的实现跨语言的**分布式**系统


P.S. 你们城里人真会玩...概念





--------
