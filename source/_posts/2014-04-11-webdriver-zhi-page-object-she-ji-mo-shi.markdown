---
layout: post
title: "WebDriver 之 Page Object 设计模式"
date: 2014-04-11 21:17:47 +0800
comments: true
keywords: selenium, webdriver, Page Object, 设计模式, 自动化测试
description: 使用 Page Object 进行 webdriver 自动化测试
tags: [webdriver, selenium, python, 自动化测试, 设计模式]
categories: Selenium
---

使用 Selenium Webdriver 最常用的设计模式 Page Object 规划页面
<!--more-->
例子页面:

[login_test.html](http://ralph-wang.github.io/sample/login_test.html)

用户名: test 密码: test

## 一般写法
```python
from selenium import webdriver

driver = webdriver.Chrome()

driver.get('http://ralph-wang.github.io/sample/login_test.html')

username = 'test'
pwd = 'test'

# 登录操作
driver.find_element_by_id('username').send_keys(username)
driver.find_element_by_id('pwd').send_keys(pwd)
driver.find_element_by_id('ok').click()

# 验证登录
alert = driver.switch_to_alert()
assert 'succ' in alert.text
```

这样的写法的代码复用和管理都会成为麻烦.

一方面测试值的参数化不方便, 另一方面没有抽象出业务操作来, 可读性能差.

如果需要自动化的页面只有一个时, 可以就这么写. 但业务多起来后代码的维护会非常痛苦

下面就用 Page Object 来重构这个测试

## Page Object 设计模式

先需要两个基类: `BrowserContainer`, `BasePage`

```python Base.py
class BrowserContainer(object):
	def __init__(se	lf, driver, baseURL):
		self.driver = driver
		self.baseURL = baseURL

class BasePage(BrowserContainer):
	def __init__(self, driver, baseURL, path):
		BrowserContainer.__init__(self, driver, baseURL)
		self.path = path ## 页面路径
	def open(self):
		self.driver.get(self.baseURL + self.path)

```
BrowserContainer 是一个抽象类, 用来存储 driver 和测试站点的 baseURL

BasePage 也是一个抽象类, 继承自 BrowserContainer, 后续所有测试页面都继承自它

```python Site.py
import page.Base

class Site(page.Base.BrowserContainer):
	def __init__(self, driver, baseURL):
		page.Base.BrowserContainer.__init__(self, driver, baseURL)
	def getLoginPage(self):
		return LoginPage(self.driver, self.baseURL, '/login_test.html')


class LoginPage(page.Base.BasePage):
	def __init__(self, driver, baseURL, path):
		page.Base.BasePage.__init__(self, driver, baseURL, path)

	def login(self, username, pwd):
		self.driver.find_element_by_id('username').send_keys(username)
		self.driver.find_element_by_id('pwd').send_keys(pwd)
		self.driver.find_element_by_id('ok').click()

```
`Site` 是一个工厂类, 用来取得各个测试页面的实例

`LoginPage` 就对应我们的测试页面 `/login_test.html`

这样, 我们可以把环境因素 baseURL 和 项目因素 path 分离, 这样更方便的实现多环境复用

```python case.py
import unittest
from selenium import webdriver

import page.Site

class TestLogin(unittest.TestCase):
	def setUp(self):
		self.driver = webdriver.Chrome()
		self.site = page.Site.Site(self.driver,\
				'http://ralph-github.io/sample')
		self.loginPage = self.site.getLoginPage()

		def testLogin(self):
			self.loginPage.open()
			self.loginPage.login('test', 'test')

			alert = self.driver.switch_to_alert()
			assert 'succ' in alert.text
			alert.accept()

	def tearDown(self):
		self.driver.quit()


if __name__ == '__main__':
	unittest.main()
```
最后我们再用 `unittest` 模块组织我们的测试用例.

这样我们增加了不少代码, 但用例部分的可读性提升了不少.

并且我们的业务和页面是绑定在一起了, 管理起来也很方便

如果再增加测试页面和测试用例, 我们只需要增加一个页面类并添加一个 Site 的工厂函数即可.

sample 所在的 git:

[page_object_sample](https://github.com/Ralph-Wang/page_object_sample)
