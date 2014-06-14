---
layout: post
title: "Learning the Bash Shell 笔记-Debug"
date: 2014-06-11 10:40:33 +0800
comments: true
keywords: [debug, bash, shell]
description: 怎么去 debug 一个 bash 脚本
tags: [Linux, bash, debug]
categories: Linux
---

任何开发测试工作都离不开的话题 -- Debug. 

bash 脚本自然也不能免俗
<!--more-->

## 显示每一步执行的命令

默认情况下, bash 脚本执行时不会像 Windows 的 bat 一样显示每一次执行的命令.
虽然说这功能在执行时比较难看, 但在 Debug
时可以帮助我们查看脚本是执行到哪一行出现的问题

如果想让 bash 脚本运行时显示每行命令, 则需要在脚本开始添加如下命令:
```bash
set -o [noexec|verbose|xtrace]
```

参数说明:

* `noexec`	不执行脚本, 只检查语法错误

* `verbose`	显示每一行命令 (开启这个功能后 bash 就和 bat 很像了)

* `xtrace`	比 verbose 更详细的显示, 具体显示信息由 `PS4` 变量配置

## 几个 fake signal

### EXIT

在脚本退出时会触发该信号

```bash exit.sh
#!/bin/sh

trap 'echo exiting the script' EXIT

echo 'starting the script'
```

执行结果:

```bash
$./exit.sh
starting the script
exiting the script
```

### DEBUG

每一行命令执行前都会触发这个信号, 开启 `set -o functrace` 后函数内部也会触发

```bash debug.sh
#!/bin/sh

trap 'echo execute $LINENO' DEBUG

for ((_i=0;_i<2;_i++))
do
echo $_i
done
```

执行结果:

```bash
$./debug.sh
execute 5
execute 5
execute 7
0
execute 5
execute 5
execute 7
1
execute 5
execute 5
```

### ERR
当有命令执行后的返回值不是 0 时触发该信号
```bash err.sh
#!/bin/sh

trap 'echo Error with status $?' ERR

function bad
{
	return 111
}

bad
```
执行结果
```bash
$./err.sh
Error with status 111
```

### RETURN
当用 `source` 执行脚本返回后触发该信号

若执行 `set -o functrace`, 则函数返回后也能触发该信号
```bash x.sh
echo "Hello World"
```
```bash return.sh
#!/bin/sh
trap 'echo debug occured' DEBUG
trap 'echo return occured' RETURN

source ./x.sh
```
执行结果
```bash
debug occured
Hello World
return occured
```

## 一个简易的 Debugger

一个 Debugger 需要的功能点:

* 断点

* 逐步执行

* 变量监视

* 显示当前执行位置和断点位置

* 不需要改动源码即可进行 Debug

## 实现原理:
利用 `DEBUG` 信号中断执行. 进而进入 debug 命令行

## 核心数组:
* `_lines` 用来存储所有 Debug 脚本的代码

* `_linebp` 用来存储断点行号

文件结构:

> bashdb  # 主脚本, 即驱动器

> bashdb.pre # 添加到原脚本头的部分

> bashdb.fns # 定义的函数们


```bash bashdb
#!/bin/sh

_dbname=${0##*/}
echo 'Bash Debugger Version 1.0'

if (( $# < 1 ))
then
	echo "$_dbname Usage: $_dbname filename." >&2
	exit 1
fi

_guineapig=$1

if [ -r $_guineapig ]
then
	echo "$_dbname: file '$1' is not readable." >&2
	exit 1
fi

shift

_tmpdir=/tmp
_libdir=.
_debugfile=$_tmpdir/bashdb.$$ # tmp file for script debugged

cat $_libdir/bashdb.pre $_guineapig > $_debugfile
exec bash $_debugfile $_guineapig $_tmpdir $_libdir "$@"
```
> 关于 `exec` 命令
> > 执行其参数, 用其并替代当前进程. 脚本中在 `exec` 后的命令都不会执行
> > 在 cli 中执行 exec 后... 当前 shell 会直接退出

```bash bashdb.pre
#!/bin/sh

_debugfile=$0
_guineapig=$1

_tmpdir=$2
_libdir=$3

shift 3

# 将所有函数加载进来
source $_libdir/bashdb.fns

_linebp=
let _trace=0
let _i=0

{
	while read
	do
		_line[$_i]=$REPLY
		let _i=$_i+1
	done
} < $_guineapig

# 退出时清除临时文件
trap _cleanup EXIT

let _steps=1

# 减掉 bashdb.pre 的行数
trap '_steptrap $(($LINENO - 32))' DEBUG
```

```bash bashdb.fns
#!/bin/sh

# Debugger 的主要函数 _steptrap
# 每一行代码执行前, 这个函数都会被调用

function _steptrap
{
	_curlline=$1
	(( $trace )) && _msg "Line $_curlline: ${_lines[$_curlline]}"

	if (( $_steps >= 0 ))
	then
		let _steps=$_steps-1
	fi

	# check if there is a breakpoint
	if _at_linenumbp
	then
		_msg "Reached breakpoint at $_curlline"
		_cmdloop
	fi

	# check if there is a break condition
	if [ -n "$_brcond" ] && eval $_brcond 
	then
		_msg "Break condition $_brcond true at line $_curlline"
		_cmdloop
	
	# check if there are no more steps
	if (( $_steps == 0 ))
	then
		_msg "Stopped at line $_curlline"
		_cmdloop
	fi
}

# 命令处理函数 _cmdloop

function _cmdloop
{
	local cmd args

	while read -e -p "bash> " cmd args
	do
		case $cmd in
			\?|h ) # 显示命令菜单
				_menu ;;
			bc ) # 设置中断条件
				_setbc $args ;;
			bp ) # 设置断点
				_setbp $args ;;
			cb ) # 清除一个或全部断点
				_clearbp $args ;;
			ds ) # 显示脚本和断点
				_displayscript ;;
			g ) # 运行脚本直到断点
				return ;;
			q ) # 退出
				exit ;;
			s ) # 执行 N 行, 默认 1 行
				let _steps=${args:-1}
			x ) # 开关显示所在行
				_xtrace ;;
			!* ) # 执行 shell 命令
				eval ${cmd#!} $args;;
			* )
				_msg "Invalid command: '$cmd'" ;;
		esac
	done
}

# 设置断点命令对应函数 _setbp

functrace _setbp
{
	# 没有参数就显示断点信息
	if [ -z "$1" ]
	then
		_listbp
	elif [ $(echo $1 | grep '^[0-9]*') ]
	then
		if [ -n "${list[$1]" ]
		then # 将新断点与旧断点重新排序放入 _linebp
			_linebp=($(echo $( (for i in ${_linebp[@]} $1;do
			echo $i; done) | sort -n) ))
		else # 空行不能设置断点
			_msg "Breakpoints can only be set on non-blank lines"
		fi
	else
		_msg "Please specify a numeric line number"
	fi
}

## 其它函数这里省略
```
