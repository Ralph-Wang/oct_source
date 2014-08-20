---
layout: post
title: "blockdev 命令及相关概念"
date: 2014-08-20 23:36:02 +0800
comments: true
keywords: [Linux, 硬盘, blockdev, 命令, 参数]
description: 通过 blockdev 了解 Linux 下硬盘相关概念
tags: [Linux, blockdev, 磁盘, 参数]
categories: Linux
---


* any list
{:toc}

## 命令本身 ##

`blockdev` 是直接调用 `ioctl` 函数的一个命令.

其原生帮助如下:

```bash
$ blockdev

用法:
  blockdev -V
  blockdev --report [devices]
  blockdev [-v|-q] commands devices

可用命令:
    # 这里暂时省略.
```

* `-V` 自然是查看版本号了, 这里就不多说    
* `--report` 用来查看硬盘的相关配置参数, 不传硬盘的话, 会显示所有硬盘    
* 最后一种用法, 就是调用各种命令, 对硬盘进行设置. 或单个参数的查看.

## report 的内容 ##

```bash
$ blockdev --report
RO    RA    SSZ    BSZ    StartSec          Size    Device
rw   256    512   4096           0   21474836480    /dev/xvda
```

调用 blockdev 时需要注意使用 `root` 用户, 或者 `sudo`

现在来看一下这些字段都是些什么含义

| 字段| 全称 | 含义 |
| RO | readonly | 硬盘的读写状态. `rw` 表示可读可写, `ro` 则表示只读 |
| RA | readahead | `预读` 的大小. Linux 实际大小为 readahead * 2 (KB) |
| SSZ| sector size | Linux 中`扇区`(sector) 大小, 单位 `byte` |
| BSZ| block size | Linux 中`块`大小 , 单位 `byte`|
| StarcSec| start sector | 当前设备是从第几个 sector 开始的 |
| Size | ... | 设备的大小, 不支持 -h 参数变得可读 Orz |
| Device | ... | 硬盘对应的设备文件 |

想必你现在和我一样, 表格里面的东西看得晕晕乎乎的.

下面我们简单说明一下

#### 预读 ####

当 Linux 向磁盘发起 IO 时, 会进行所谓的`预读`操作.
即, 会比 CPU 操作需要的内容多从读取一小块内容.

> 当然, 如果发现下一次 IO 是随机的, 便会中断当前预读

而 `readahead` 项, 就是配置需要提前读取的内容大小

在 tuning[^1] 数据服务器, 需要关注这个参数    
不过, 一般情况下, 使用默认的 256 (即预读 512KB) 就足够了.

#### 扇区 ####

`扇区`是硬盘的物理属性. 也是操作系统读取数据的最小单位.

#### 块 ####

`块` 是操作系统在存储文件时的最小单位. 不论文件真实大小, 其占据的硬盘空间一定是块的整数倍.

一个只有一个字符的文件却占据 4K 空间, 就是这个原因

```bash
$ cat txt
1
$ du -h txt
4.0K    txt
```


--------

[^1]: 不知道怎么翻译好... 有调优的意思, 但又有试探性
