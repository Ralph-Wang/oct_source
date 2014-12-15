2014.12`@Sina`

# Python <br /> 从数据类型说起

...

## 需要明确的一点

### Python 只有一种数据类型: 对象

* 数字是对象

* 字符串是对象

* 函数是对象

* 甚至类本身也是对象

...

## 数据类型的分类

### 按用途分

* 值类型: 整型, 长整型, 浮点型, 字符串

* 容器类型: `元组`, 列表, 字典, 集合

### 按可变性分

* 不可变类型: 整型, 长整型, 浮点型, 字符串, `元组`

* 可变类型: 列表, 字典, 集合

...

## 数字

* 整型 `int`


```
size = 1024
```

* 长整型 `long`

```
size = 1024L
```

* 浮点型 `float`

```
size = 1024.0
```

...

## 数字的四则运算

* 除了基本的四则运算外, 还有额外的`地板除` (//)

```
add   = 1 + 2
minus = 1 - 2
multi = 1 * 2
div   = 5 / 2     # 2
divf  = 5.0 / 2   # 2.5
fdiv  = 5 // 2    # 2
fdiv2 = 5.0 // 2  # 2.0
```

...

## 字符串

* 单引号和双引号是等价的

```
a_string = 'this is a string'
another  = "another string"
```

* 三个引号允许字符串换行

```
break_lines = '''
string
in multi
lines
'''
```

...

## 字符串的操作

* 运算符

```
add   = 'a' + 'b'  # 'ab'
multi = '-' * 5    # '-----'
```

* 切片

```
s = 'this is a string'
s[0]      # 't'
s[:4]     # this
s[5:]     # 'is a string'
s[0:4:2]  # 'ti'
```

* 常用方法

```
'  longdong '.strip()        # 'longdong'
'test'.find('e')             # 1
'Hey {0}'.format('World')  # 'Hey World'
'a,b,c'.split(',')           # ['a', 'b', 'c']
```

...

## 元组

* 唯一不可变的容器类型

```
t = (1, 'string')
```

* 在逗号(,)没有特殊含义时, 可以省略括号

```
t = 1, 'string'
```

* 元组只有一个元素时, 需要额外写一个逗号(,)

```
t = (1,)
```

...

## 元组的操作

* 运算符

```
add = (1,) + (2,) # (1, 2)
multi = (1,) * 3  # (1, 1, 1)
```

* 切片

```
t = (0, 1, 2, 3, 4, 5, 6)
t[2]   # 2
t[3:5] # (3, 4)
t[::2] # (0, 2, 4, 6)
```

* 方法

```
t.count(3) # 1
t.index(4) # 4
```

...

## 列表

* 可以理解为动态的数组

* 同一个列表里面可以存放不同类型的元素

```
lst = [1, 'string', []]
```

* 强大的列表表达式

```
[i for i in xrange(3) if i%2==0] # [0, 2]
```

...

## 列表的操作

* 运算符

```
add = [1,] + [2,]  # [1, 2]
multi = [1] * 3    # [1, 1, 1]
```

* 切片

```
t = [0, 1, 2, 3, 4, 5, 6]
t[2]   # 2
t[3:5] # [3, 4]
t[::2] # [0, 2, 4, 6]
```

* 常用方法

```
t = [0, 1, 2, 3]
t.pop()     # 3; t -> [0, 1, 2]
t.append(0) # None; t -> [0, 1, 2, 0]
t.reverse() # None; t -> [0, 2, 1, 0]
t.count(0)  # 2
t.index(0)  # 0
t.sort()    # None; t -> [0, 0, 1, 2]
```

...

## 字典

* 键必须是可hash的, 值可以是任意类型

```
dct = {'key': 'value', 1: 2}
```

* 类似列表, 也有字典表达式

```
dct = {i: i * 7 for i in xrange(9)}
```

...

## 字典的操作

* 基本操作

```
dct = {}
dct['name'] = 'Ralph'  # {'name': 'Ralph'}
dct['name']            # 'Ralph'
dct['no_such_key']     # KeyError
```

* 常用方法

```
dct = {'name': 'Ralph'}
dct.keys()       # ['name']
dct.values()     # ['Ralph']
dct.items()      # [('name', 'Ralph')]
dct.pop('name')  # 'Ralph'; dct -> {}
dct.get('name')  # 'Ralph'
dct.get('no')    # None
```

...

## 集合

* 集合唯一没有字面量的内建类型

* 集合中的元素必须是可hash的

```
s = set([1, 2, 'string', (1, 2)])
```

...

## 集合的操作

* 运算符

```
set([1]) - set([2]) # set([1])
```

* 常用方法

```
a = set([1])
b = set([2])
a.add(2)        # None; a -> set([1, 2])
a.union(b)      # set([1,2])
a.difference(b) # set([1])
```

...

## 容器类型的遍历

### 所有容器类型都是可遍历的

```
for item in <tuple, list, dict, set>:
    statements
```

###  遍历容器时需要注意的事

* 遍历字典时, `item` 的取值是 key

```
for item in {'a': 1, 'b': 2}:
    print item # a b
```

* 不要在遍历可变容器(list, dict, set)时, 对容器进行增删操作

```
l = range(10)
for i in l:
    print l.pop() # 9, 8, 7, 6, 5
    # 0,1,2,3,4 被吃掉了
```

....

# print '`Thank You`'
