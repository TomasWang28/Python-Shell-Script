def addWord(theIndex, word, pagenumber):
    theIndex.setdefault(word, []).append(pagenumber)  # 存在就在基础上加入列表，不存在就新建个字典key

d = {"hello": [3]}
# d = {}
addWord(d, "hello", 3)
addWord(d, "hello", 56)
addWord(d, "nihao", 24)
print (d)
#{'nihao': [24], 'hello': [3, 3, 56]}



1、现在有两个列表，list1 = ['key1','key2','key3']和list2 = ['1','2','3']，把他们转为这样的字典：{'key1':'1','key2':'2','key3':'3'}

>>>list1 = ['key1','key2','key3']

>>>list2 = ['1','2','3']

>>>dict(zip(list1,list2))

{'key1':'1','key2':'2','key3':'3'}

2、将嵌套列表转为字典，有两种方法，

>>>new_list= [['key1','value1'],['key2','value2'],['key3','value3']]

>>>dict(list)

{'key3': 'value3', 'key2': 'value2', 'key1': 'value1'}

或者这样：

>>>new_list= [['key1','value1'],['key2','value2'],['key3','value3']]

>>>new_dict = {}

>>> for i in new_list:

...   new_dict[i[0]] = i[1]                #字典赋值，左边为key，右边为value

...

>>> new_dict

{'key3': 'value3', 'key2': 'value2', 'key1': 'value1'}
