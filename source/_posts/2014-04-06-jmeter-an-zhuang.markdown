---
layout: post
title: "Jmeter 安装"
date: 2014-04-06 22:17:08 +0800
comments: true
keywords: 测试, 工具, Jmeter, 安装
description: 测试工具 Jmeter 安装
tags: [Jmeter, 安装, 工具]
categories: Jmeter
---

跨平台工具赛高
<!--more-->

## 安装 jdk
去 oracle 官网[下载](http://www.oracle.com/technetwork/java/javase/downloads/index.html)相应版本的 jdk

如果没有特别要求, 下载最新版就可以.

完成安装后配置上相应的环境变量

```bash
JAVA_HOME=/where/you/install/jdk
CLASSPATH=$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
```

可以用下面代码测试安装成功与否

```java Test.java
import java.util.Date;

public class Test {
	public static void main(String[] args) {
		System.out.println(new Date());
	}
}
```

## 安装 Jmeter
去 Apache 官网[下载](http://jmeter.apache.org/download_jmeter.cgi) Jmeter

解压得到目录 `apache-jmeter-*.*` (\*.\* 为版本号)

将 `apache-jmeter-*.*` 复制到任意你喜欢的目录

下面这段其实完全不需要 ( 2014-05-07 更新 )

> 配置 Jmeter 环境变量

```bash
JMETER_HOME=/where/you/put/apache-jmeter-*.*
CLASSPATH=$CLASSPATH:$JMETER_HOME/lib/logkit-2.0.jar:$JMETER_HOME/lib/jorphan.jar:$JMETER_HOME/lib/ext/ApacheJMeter_core.jar
```

> 其实就是在 `CLASSPATH` 中添加三个 jar 包: *(07-31更新: 可以不用配置)*
> $JMETER\_HOME/lib/logkit-2.0.jar   
> $JMETER\_HOME/lib/jorphan.jar   
> $JMETER\_HOME/lib/ext/ApacheJMeter\_core.jar



## 启动 Jmeter
运行 $JMETER\_HOME/bin 目录下的 jmeter (Windows 环境运行 jmeter.bat)
