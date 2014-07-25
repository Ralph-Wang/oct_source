# NoSQL 数据库 <br> MongoDB  <br> II

2014-07, @MyTesting


...
## 我是谁? Who am I?

### 网秦广告平台 QA, 花名 @\_漏斗

-------------------

GitHub: @[Ralph-Wang](https://github.com/Ralph-Wang)

Blog: <http://ralph-wang.github.io>

Weibo: @\_漏斗

> 嘁, 打个酱油

...

## 大纲 Syllibus

#### 1. 关系型数据库与 NoSQL (Part I)

* 什么是数据库
* 关系型数据库
* NoSQL 数据库

#### 2. MongoDB 基础 (Part I)

* 为什么独爱 MongoDB
* MongoDB 基本使用

### 3. 在 Python 中使用 MongoDB

* 在 Python 中使用 MongoDB
* 一个简单的项目(带单元测试)

.....

# [怎么应用到各类语言?!!!](http://api.mongodb.org)

...

# 怎么应用到 Python?!!!

...

## 预备知识 Knowledge Requirements

* Python Basic

```
name = 'Ralph-Wang'
age = 25
if 1 == 2:
    age = 20
sum = 0
for i in range(10):
    sum += i
```

* Python dict

```
dict_sample = {"key": "value",
               "num": 1024,
               "list": [1, 2, 3]}
```

...

## 像 RDBMS 一样? Just Like RDBMS?

### 拼接字符串?

```
import MySQLdb
conn = MySQLdb.connect(host='localhost', db='test')
cur = conn.cursor()
sql = 'select id, name from tbl where id = %s'
cur.execute(sql, 1)  # 查询数据
for data in cur.fetchall():
    print data
```

...

## [原生 API Native Api](http://api.mongodb.org/)

* find\_one 直接返回查询对象

# 怎么可能!?

```
import pymongo
conn = pymongo.MongoClient('mongodb://localhost:27017')  # 连接服务器
db = conn.test  # 选择数据库
tbl = db.tbl  # 选择集合
print tbl.find_one()
```
....
## 带上查询条件 With Query

* find 方法返回的是一个游标对象
* 使用 for 循环迭代出查询结果

```
import pymongo
conn = pymongo.MongoClient('mongodb://localhost:27017')
db = conn.test # 选择数据库
tbl = db.tbl # 选择集合
query = {'name' : 'ralph'}
cur = tbl.find(query)
for doc in cur:
    print doc
```
...
## 排序和限量 Sort & limit

* 只有使用 for 迭代结果时, 游标才去 MongoDB 执行查询

```
import pymongo
conn = pymongo.MongoClient('mongodb://localhost:27017')
db = conn.test # 选择数据库
tbl = db.tbl # 选择集合
cur = tbl.find()
cur.sort({'age' : pymongo.ASCENDING})
cur.limit(1)
for doc in cur:
    print doc
```
...

## 一个实例 A Simple Project

### [qboard](https://github.com/Ralph-Wang/qboard)

目录结构

```
.
├── main.py
├── MsgDAO.py
├── README.md
├── tests.py
└── views
    └── index.tpl
```

...

## Mongo操作类 MongoDAO

### MsgDAO:

```
class MsgDAO(object):
    '''MsgDAO: accesser to database msg in mongodb'''
    def __init__(self, db):
        '''Construct Method'''
    def _get_model(self):
        '''private method get document model'''
    def insert(self, detail):
        '''insert : insert method'''
    def get(self, detail='', is_answered=None, num=0):
        '''get : query method'''
    def count(self, is_answered=NOT_ANSWERED):
        '''count : count documents'''
    def up(self, _id):
        '''up : up a Question'''
    def answer(self, _id):
        '''answer: answer a Question'''
```

...
## 怎么做单元测试? How To Test it?

### 需要一个 Suite

```
class TestSuite(object):
    '''TestSuite: simple test suite class'''
    def __init__(self):
        self._count = 0
        self._failure = 0
    def run_test(self, computed, expected, msg=""):
        '''run_test: check computed value and expected avlue.'''
        self._count += 1
        if computed != expected:
            print msg, ',', 'Computed:', computed, 'Expected:', expected
            self._failure += 1
    def report(self):
        '''report: report test'''
        print 'run', self._count, 'cases', self._failure, 'failed'
```
.....

## 怎么做单元测试? How To Test it?

### 开始写测试用例:

```
suite = TestSuite()
msgDAO =  # get msgDAO
suite.run_test(msgDAO.insert('just_test')['detail'], 'just test', '#insert0')
suite.run_test(msgDAO.insert(''), None, '#insert0')
suite.run_test(msgDAO.insert(1), None, '#insert0')
// Ohter Cases
suite.report()
```
...

# .insert({`'Thanks'` : `'End'`})
