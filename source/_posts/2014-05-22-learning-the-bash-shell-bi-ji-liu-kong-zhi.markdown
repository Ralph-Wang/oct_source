---
layout: post
title: "Learning the Bash Shell 笔记-流控制"
date: 2014-05-22 21:19:21 +0800
comments: true
keywords: Linux, shell, bash, if, case, select
description: 
tags: [Linux, shell, bash, 流控制]
categories: Linux
---

但凡是代码就逃不开的流控制话题
<!--more-->

## 条件

bash 中的条件值以数字 0 表示真, 非0 则为假, 并不存在布尔类型

其中有三种条件形式可以得到条件值

### 命令的退出状态
一般来说, Linux 的命令若执行成功, 则退出状态为 0, 不成功则返回 1-255

> *diff 命令除外, diff 返回 0 表示两个文件没有差别, 1 表示有差别, 2+
> 表示发生错误*

### 脚本或函数的返回值

在脚本或函数中, 用 return 表示结束并返回

当然, 在 bash 中只能返回数字类型, 返回字符串的话脚本会出错

另外, return 写返回值的话, 默认返回 0

> 脚本或函数中若没有用 return 返回值时, 则以最后一条命令的退出状态作为返回值

### 测试 test

bash 中测试有两种写法

* test condition
* [ condition ] *[ ] 两个方括号和中间条件之间必须要有一个空格*

两种写法是等价的, 详细的写法可参考 `man test`

## if..elif..else
```bash
if condition
then
	statements
[elif condition
then
	statements]
[else
	statements]
fi
```

## case
```bash
case epxr in
	pattern1 )
		statements
		;;
	pattern2 )
		statements
		;;
	...
esac
```
*pattern1/2* 支持 bash 的通配符, 也支持 | 来表示多模式匹配

`;;` 类似于其它语言中的 break

因为匹配是从上到下的, 所以可以用 `*)` 来表示 default

## select
```bash
select case [in caselist]
do
	statements about $case
	[break]
done
```
用 caselist 里的所有项生成一个简单的选择菜单

statements 中 $case 就是选择的项

完成一次 statements 后, 若没有遇到 break 则会继续下一次 select

## for
```bash
for ((expr1;expr2;expr3))
	statements
end
```
这个比较类似 Java 里的 for

```bash
for i in list
begin
	statements
end
```
这个感觉更像 python 里的 for

## while & until
```bash
while condition
do
	statements
done
```

```bash
until condition
do
	statements
done
```
while condition 等价于 until ! condition

两者没有其它区别

## 附:
又一个友好地显示 PATH 的方法
```bash showpath.sh
path=$PATH

while [ $path ];
do
	echo ${path%%:*}
	echo ${path#*:}
done
```
