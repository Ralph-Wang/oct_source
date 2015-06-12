2014.12 @ `Sina`

# Python 技巧 <br> 单元测试


....

## 大纲

* 为什么要做单元测试

* Python 的单元测试框架

* 实现一个斐波那契函数的单元测试

* 修改斐波那契函数的算法, 执行单元测试


...
## 几种类型的代码

* 明显没有错误的代码

```
for key in black_list:
    doc.pop(key, None)
```



* 没有明显错误的代码

```
def parse_json(jstring):
    try:
        j = json.loads(jstring)
    except Exception:
        j = {}
    return j
```



* 明显有错误的代码

```
if obj:
    row[key] = obj
else:
    row[key] = None
```

...

## 为什么要做单元测试

### 度量代码质量
框架 A 有单元测试, 全数通过; 框架 B 连测试代码都没有. 你用哪个?

### 重构
底层算法优化, 结构改变. 不做单元测试, 怎么保证接口功能一致.

### 增强信心
这可是单元测试 100% 覆盖率的代码. 全部跑通了的哦!

...

## 大家都在用的单元测试框架

### unittest
从 2.1 开始就是 Python 的标准库了, 不需要额外安装

### nosetests
语法兼容 unittest, 可以和 coverage 工具生成覆盖率报告

### pytest
Python 目前集成度最高的测试框架, 但学习成本也相对较高

...
## 如何选择

* 上手容易

* 方便生成覆盖率报告

### nosetests 是目前的上上之选

...

## 如何安装

* Ubuntu 先安装 pip

```
apt-get install python-pip
```

* nosetests

```
pip install nose
```

...

## 开始写斐波那契程序

### 需求:

* 允许计算 [0, 40] 之间的斐波那契数
* 范围外的数字, 返回字符串 'out of range'
* 非 int 类型, 返回字符串 'not int'

```
fib(10)   # return 55
fib(41)   # return 'out of range'
fib('4')  # return 'not int'
```

### 文件规划:

```
$ tree
|-- fib.py
|-- test.py
```

...

## 代码未动, 测试先行

* nose 框架不需额外引入
* 直接将需求变为测试用例


* @`test.py`

```
import fib
f = fib.fib
def test_normal():
    assert f(0) == 0
    assert f(1) == 1
    assert f(10) == 55
```

...

## 测试有了, 开始写功能

* @`fib.py`

```
def fib(n):
    if n < 2:
        return n
    return fib(n-1) + fib(n-2)
```

* 执行测试

```
$ nosetests
Ran 1 test in 0.002s
OK
```

...

## 补完测试用例和功能

* @`test.py`

```
def test_range():
    assert f(-1) == 'out of range'
    assert f(41) == 'out of range'
def test_value():
    assert f('string') == 'not int'
```

* @`fib.py`

```
def fib(n):
    if not isinstance(n, int):
        return 'not int'
    if n < 0 or n > 40:
        return 'out of range'
    if n < 2:
        return n
    return fib(n-1) + fib(n-2)
```

...

## 再执行测试

```
$ nosetests
Ran 3 test in 0.002s
OK
```
...

## 换个算法

* `fib(n-1) + fib(n-2)` 重复计算了太多
* 换成自底向上的算法. 高大上一点叫 `动态规划`

* @`fib.py`

```
    ..省略..
    pre = 0
    cur = 1
    for i in xrange(n):
        pre, cur = cur, pre + cur
    return cur
```

* 执行测试

```
$ nosetests
F..
FAIL: test.test_normal  
 ..省略一些不重要的信息
    assert f(0) == 0
 ..省略一些不重要的信息
```

...

## 修复 bug

* @`fib.py`

```
pre = 1
cur = 0
```

* 再执行测试

```
$ nosetests
Ran 3 test in 0.002s
OK
```

...

# print '`Thank You`'
