---
layout: post
title: "df 与 du 结果不匹配问题"
date: 2014-08-04 22:03:28 +0800
comments: true
keywords: [Linux, 文件描述符, 磁盘空间, du, df]
description: Linux 磁盘空间莫名被占用, df 与 du / 结果不匹配
tags: [du, df, Linux, 磁盘, 文件描述符]
categories: Linux
---

du 与 df 与 文件描述符不得不说的故事

<!--more-->
* any list
{:toc}


## 案发现场

开发同学接到了 cacti 的预警. 一台生产机器硬盘吃紧, 使用量达到了 90% 以上

这里不方便给截图, 请看官们自行脑补...

## 侦探们

### df
首先, 我们派出第一位侦探 `df`, 以确认被占用的硬盘.

`df` 给出的调查报告如下

```
ralph -> df -h
Filesystem      Size  Used Avail Use% Mounted on
/dev/xvda1       20G   19G  972K 100% /
tmpfs           245M     0  245M   0% /dev/shm
/dev/xvdb1       40G  6.9G   31G  19% /data
```

根据 `df` 先生的报告, 我们确认被占用的磁盘为 /dev/xvda1, 其挂载目录为 `/`

### du

接下来, 该 `du` 先生出场了, 他会帮我们找到那该死的大文件在哪目录下面的.

我们先看他的第一次报告.

```
ralph -> du --max-depth=1 -h /
164K    /dev
5.9M    /bin
0       /sys
4.0K    /mnt
18M     /lib64
39M     /boot
292M    /var
603M    /root
5.5G    /usr
4.0K    /selinux
6.7G    /data
9.4M    /sbin
0       /proc
6.6M    /etc
75M     /tmp
239M    /lib
4.0K    /opt
4.0K    /media
699M    /home
20K     /lost+found
4.0K    /srv
15G     /
```

嗯, 从 `/` 中减掉 `/data` 目录下的 6.7G. 还有 8.3G.

O_O'''

`du` !!!! 你玩儿我呢吧... `df` 已经明确除了 `/data`, `/` 目录下应该还有 19G 文件. 是不是不想干了!!!

### lsof

这时, `lsof` 主动站出来说话了: 逗逼攻城狮, *说不定是有进程在向已删除的文件写数据啊!*

```
ralph -> lsof |grep delete
grep      12574  ralph  txt       REG  202,1    106232  720903 /bin/grep (deleted)
grep      12574  ralph    1u      CHR  136,2       0t0       5 /dev/pts/2 (deleted)
grep      12574  ralph    2u      CHR  136,2       0t0       5 /dev/pts/2 (deleted)
python    28230  ralph    3w      REG  202,1 734003200  401905 /home/ralph/tmp/write.log (deleted)
```

嗯~ 原来如此...杀掉这个 `28239` 这个 Python 进程后, 磁盘占用恢复正常

## 真相只有一个

* 首先, 在 Linux 系统下, 当一个程序以 `写模式` 打开一个文件后, 会在进程中保留一个`文件描述符`, 以便进程对磁盘进行写操作. `文件描述符` 在 `/proc` 文件系统下, 表现为一个`软链接`, 只占用 64 个字节的空间.

* 其次, 而在 Linux 的文件系统中, 我们看到的所谓文件只是一个叫`硬链接`的东西, 而且可以有多个`硬链接`指向同一个文件(调..啊不,和 `ln` 妹纸沟通过就知道). 当指向某一文件块的所有`硬链接`被删除后, Linux 才会回收对相应磁盘空间的占用

而此次事件的原因, 正好是`文件描述符`和`硬链接`指向同一块磁盘空间造成的.

故事应该是这样发生的:

1. Python 进程打开了 `write.log` 的文件描述符, 进行写操作. 但却忘记关闭其描述符   
2. Linux 上部署的定时清理程序开始工作, 清理掉了 `write.log` 文件最后一个硬链接
3. 因为 Python 进程的文件描述符没有关闭, Linux 内核"不敢"回收这块已经没有硬链接的磁盘空间.
4. 磁盘空间仍被占用, 但对应目录下却没有`文件`.


## 现场还原

呃, 实际上, 公司的开发语言使用的是 java. 而且, 解决问题时并没有及时截图什么的. 所以, 上面那些数据就是用`Python` 还原现场时的数据了.

这里再附上 Python 脚本.

```python
#!/usr/bin/env python

fobj = open('write.log', 'w')

whil True:
    fobj.write('*' * 1024 * 1024)
```

如果不想写太多数据出来, 可以用下面这个版本

```
#!/usr/bin/env python

fobj = open('write.log', 'w')

fobj.write('*' * 1024 * 1024)

while True:
    pass
```

死循环的目的都是为了模拟文件描述符占用

