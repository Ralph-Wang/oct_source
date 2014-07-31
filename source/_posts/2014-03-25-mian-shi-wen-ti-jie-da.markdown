---
layout: post
title: "面试技术问题解答"
date: 2014-03-25 19:49:37 +0800
comments: true
keywords: 面试, Java, Linux, MySQL, 算法
description: 面试时遇到的一些问题, 当时没有完全答上来的
tags: [面试, Java, Linux, MySQL, 算法]
categories: 面试
---

面试时没有完全回答上或有存疑的问题
<!--more-->
Linux
------
### 统计文本中某字符串出现次数
前提: 一行中要查找的字符串可能出现多次.

文本样例:

```text sample
ralph, ralph
Hello, ralph, HaHA
No such word
Hey
ralph again.
two times ralph ,ralph
```

统计文中 `ralph` 出现的次数

如果确定 ralph 在每行只出现一次的话, 可以通过 `cat sample | grep ralph | wc
-l`解决

但因为一行里可以关键词可以出现多次, 这种方式会漏掉一些. 所以并不是好的解决方案

遂搜索之.  得如下解法

### 方法 1: grep 的 -o 选项

```bash
cat sample | grep -o ralph | wc -l
```
解释:

给 `grep` 加上 `-o` 选项后, 它只会打印出匹配到的字符串, 并且每匹配一次就打印一行. 

### 方法 2: 神器 awk 之 RS

```bash
awk -v RS='ralph' 'END {print NR-1}' sample
```

解释:

awk 中 RS 变量为行分隔符, 用目标字符串分隔行, 则总行数 = 出现次数 + 1.

在 END 中访问 NR 则为最后一行的行号, awk 起始行为 1, 所以此时总行数 = NR

### 方法 3: 神器 awk 之 gsub

```bash
awk '{count+=gsub(/ralph/, "#")} END {print count}' sample
```
解释:
awk 中的 `gsub` 返回文本的替换次数, 对每行的替换次数求和即可.

另外, awk 中的 `sub` 函数在每行中只完成一次替换.

Java
------
### 反射
参考[反射案例](http://www.cnblogs.com/rollenholt/archive/2011/09/02/2163758.html)

MySQL
------
MySQL 相关的性能问题, 关于**执行计划**的倒是 OK.

但一直没时间整理下关于慢查询日志的知识点. 所以这几次都只能回答说知道这个概念, 具体的配置参数却不记得了.

在这里整理一下, 权当备忘

* 查看慢查询是否开启

```mysql
mysql> show variables like '%slow%';
| Variable_name       | Value
| log_slow_queries    | OFF
| slow_launch_time    | 2
| slow_query_log      | OFF
| slow_query_log_file | ***

mysql> show variables like 'long%';
| Variable_name   | Value    |
| long_query_time | 1.000000 |
```

* 在 my.cnf 中配置开启慢查询跟踪

```ini my.cnf
[mysqld]
log-slow-queries = **** # 日志存放目录, 一般放到 MySQL 数据库的地方
long-query-time = 2 # 超过这个时间(单位:秒) 的查询为慢查询
log-queries-not-using-indexes # 记录下没有使用索引的查询
```

产生慢查询日志后可以使用 mysqldumpslow 工具进行分析查看了.

接下来的事就交给 `explain` 吧.



算法
-----
### 问题 1 链表倒序
...面试时, 想到去 clone next.. 为毛当时就没想到多给个变量呢...

```java List.java
public class List<T> { // 后进先出列表
	private static class Node<T> {
		private T item;
		private Node<T> next;
		/** init a end Node */
		public Node() {
			item = null;
			next = null;
		}

		/** normal Node */
		public Node(T item, Node<T> next) {
			this.item = item;
			this.next = next;
		}

		private T getItem() {
			return item;
		}

		private Node<T> getNext() {
			return next;
		}

		private void setNext(Node<T> next) {
			this.next = next;
		}

		public boolean isEnd() {
			return (next == null && item == null);
		}
	}

	private Node<T> top;

	public List() {
		top = new Node<T>(); //init a end Node for list
	}

	/** push a item to the top */
	public void push(T item) {
		top = new Node<T>(item, top);
	}

	/** pop the top item */
	public T pop() {
		T result = null;
		if (top.isEnd()) {
			return result;
		}
		result = top.getItem();
		top = top.getNext();
		return result;
	}

	/** reverse the list */
	public void reverse() {
		Node<T> cur = top;
		Node<T> next = cur.getNext();
		Node<T> pre = null;
		if (cur.isEnd()) { // Empty list
			return;
		}

		top.setNext(new Node<T>()); // a new sentinel
		do {
			pre = cur;
			cur = next;
			next = cur.getNext();
			cur.setNext(pre);
		} while(!next.isEnd());
		// reset top
		top = cur;
	}

	public static void main(String[] args) {
		List<String> l = new List<String>();
		l.push("a");
		l.push("B");
		l.push("c");
		l.push("D");
		l.push("e");
		l.push("F");
		l.reverse();
		String res = null;
		while ((res = l.pop()) != null) {
			System.out.println(res);
		}
	}
}

```
算法还是弱项...

### 问题 2 文本替换
今天太晚了, 明天再继续

---*** 2014-04-06 更新 ***---

需求, 字符串或字符数组, 如 `AAABBBAAACCADDD`, 取出连续的字符, 第N次出现取出连续N个, 不足则跳过

如 AAABBBAAACCADDD -> ABAACAD


```java
import java.util.*;

public class Sub {
	public static void main(String[] args) {
		char[] t = {'A', 'A', 'A', 'B', 'B', 'B','A', 'A', 'A', 'C',
			'C', 'A', 'D', 'D', 'D'};
		System.out.println(sub(t));
	}/* output:
		ABAACAD
	  *///:~

	public static String sub(final char[] charArray) {
		String res = "";
		HashMap<Character, Integer> count =
			new HashMap<Character, Integer>();
		int seq = 0;
		int curCount = 0;
		char pre = '\0';
		for (int i = 0; i < charArray.length; i++) {
			if (charArray[i] == pre && curCount >= seq) {
				continue;
			}
			if (charArray[i] != pre) { // recount the new char
				curCount = 0;
				// get the sequence of the char
				if (count.get(charArray[i]) == null) {
					seq = 1;
				} else {
					seq = count.get(charArray[i]) + 1;
				}
				// cache the char sequence
				count.put(charArray[i], seq);
			}
			res = res + charArray[i];
			curCount++;
			pre = charArray[i];
		}
		return res;
	}
}

```
若使用 `String` 作为输入, 则用 charAt 方法获取字符
