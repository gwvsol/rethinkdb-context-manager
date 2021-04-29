## RethinkDB контекстный менеджер

Контекстный менеджер реклизует некоторые основные методы API RethinkDB   
[RethinkDB-context-manager](https://github.com/gwvsol/RethinkDB-context-manager)   
[Python ReQL command reference](https://rethinkdb.com/api/python/)    

### Использование

```Python
pip install rethinkdbcm

from rethinkdbcm import WorkRethinkDB
db = WorkRethinkDB()
db.db_list()
```
---

```Python
python
Python 3.8.5 (default, Jan 27 2021, 15:41:15) 
[GCC 9.3.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> from rethinkdbcm import WorkRethinkDB
>>> db = WorkRethinkDB()
>>> db.db_list()
['geo-temp', 'rethinkdb', 'test']
>>> 
```
---