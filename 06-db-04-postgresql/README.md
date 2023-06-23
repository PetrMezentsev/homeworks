# Домашнее задание к занятию 4. «PostgreSQL»

## Задача 1

Используя Docker, поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

```bash
user@LE3:~/06-db-04-postgresql$ cat docker-compose.yml
version: '3.9'

services:
  db:
    image: postgres:13
    environment:
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres
    volumes:
      - ./pg_data:/var/lib/postgresql/data
      - ./pg_backup:/data/backup/postgres
    ports:
      - "5432:5432"
    restart: always
```

```bash
user@LE3:~/06-db-04-postgresql$ sudo docker ps
CONTAINER ID   IMAGE         COMMAND                  CREATED         STATUS         PORTS                                       NAMES
4ad8fdafbbe3   postgres:13   "docker-entrypoint.s…"   2 minutes ago   Up 2 minutes   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   06-db-04-postgresql-db-1
```

Подключитесь к БД PostgreSQL, используя `psql`.

```bash
user@LE3:~/06-db-04-postgresql$ sudo docker exec -it 06-db-04-postgresql-db-1 bash
root@4ad8fdafbbe3:/# psql -U postgres
psql (13.11 (Debian 13.11-1.pgdg120+1))
Type "help" for help.

postgres=#
```

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:

- вывода списка БД,

```bash
postgres=# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
-----------+----------+----------+------------+------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
(3 rows)
```

- подключения к БД,

```bash
postgres=# \c
You are now connected to database "postgres" as user "postgres".
```

- вывода списка таблиц,

```bash
postgres=# \dt
Did not find any relations.
postgres=# \dt+
Did not find any relations.
```

- вывода описания содержимого таблиц,

```bash
postgres=# \d pg_database
               Table "pg_catalog.pg_database"
    Column     |   Type    | Collation | Nullable | Default
---------------+-----------+-----------+----------+---------
 oid           | oid       |           | not null |
 datname       | name      |           | not null |
 datdba        | oid       |           | not null |
 encoding      | integer   |           | not null |
 datcollate    | name      |           | not null |
 datctype      | name      |           | not null |
 datistemplate | boolean   |           | not null |
 datallowconn  | boolean   |           | not null |
 datconnlimit  | integer   |           | not null |
 datlastsysoid | oid       |           | not null |
 datfrozenxid  | xid       |           | not null |
 datminmxid    | xid       |           | not null |
 dattablespace | oid       |           | not null |
 datacl        | aclitem[] |           |          |
Indexes:
    "pg_database_datname_index" UNIQUE, btree (datname), tablespace "pg_global"
    "pg_database_oid_index" UNIQUE, btree (oid), tablespace "pg_global"
Tablespace: "pg_global"
```

- выхода из psql.

```bash
postgres=# \q
root@4ad8fdafbbe3:/#
```

## Задача 2

Используя `psql`, создайте БД `test_database`.

```bash
postgres=# CREATE DATABASE test_database;
CREATE DATABASE
```

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/virt-11/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.

```bash
root@4ad8fdafbbe3:/data/backup/postgres# psql -U postgres test_database < /data/backup/postgres/test_dump.sql
SET
SET
SET
SET
SET
 set_config
------------

(1 row)

SET
SET
SET
SET
SET
SET
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
ALTER TABLE
COPY 8
 setval
--------
      8
(1 row)

ALTER TABLE
```

Перейдите в управляющую консоль `psql` внутри контейнера.

```bash
root@4ad8fdafbbe3:/data/backup/postgres# psql -U postgres
psql (13.11 (Debian 13.11-1.pgdg120+1))
Type "help" for help.

postgres=#
```

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

```bash
postgres=# \c test_database
You are now connected to database "test_database" as user "postgres".
test_database=# \d+
                                   List of relations
 Schema |     Name      |   Type   |  Owner   | Persistence |    Size    | Description
--------+---------------+----------+----------+-------------+------------+-------------
 public | orders        | table    | postgres | permanent   | 8192 bytes |
 public | orders_id_seq | sequence | postgres | permanent   | 8192 bytes |
(2 rows)

test_database=# ANALYZE VERBOSE orders;
INFO:  analyzing "public.orders"
INFO:  "orders": scanned 1 of 1 pages, containing 8 live rows and 0 dead rows; 8 rows in sample, 8 estimated total rows
ANALYZE
test_database=#
```

Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.

**Приведите в ответе** команду, которую вы использовали для вычисления, и полученный результат.

```sql
test_database=# SELECT tablename, attname, avg_width
FROM pg_stats
WHERE tablename = 'orders'
ORDER BY avg_width DESC
LIMIT 1;
 tablename | attname | avg_width
-----------+---------+-----------
 orders    | title   |        16
(1 row)
```

## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам как успешному выпускнику курсов DevOps в Нетологии предложили
провести разбиение таблицы на 2: шардировать на orders_1 - price>499 и orders_2 - price<=499.

Предложите SQL-транзакцию для проведения этой операции.

```sql
test_database=# BEGIN;
BEGIN
test_database=*# CREATE TABLE orders_temp (LIKE orders INCLUDING DEFAULTS) PARTITION BY RANGE (price);
CREATE TABLE
test_database=*# CREATE TABLE orders_1 PARTITION OF orders_temp FOR VALUES FROM (500) TO (MAXVALUE);
CREATE TABLE
test_database=*# CREATE TABLE orders_2 PARTITION OF orders_temp FOR VALUES FROM (MINVALUE) TO (500);
CREATE TABLE
test_database=*# INSERT INTO orders_temp SELECT * FROM orders;
INSERT 0 8
test_database=*# ALTER TABLE orders RENAME TO orders_old;
ALTER TABLE
test_database=*# ALTER TABLE orders_temp RENAME TO orders;
ALTER TABLE
test_database=*# COMMIT;
COMMIT
```

Можно ли было изначально исключить ручное разбиение при проектировании таблицы orders?

##### Ответ:

Если бы на этапе проектирования мы сразу создали партиционированную таблицу, то избежали бы последующего манипулирования с разбиением. Нюанс в том, что существующую непартиционированную таблицу нельзя сделать партиционированной, и наоборот. Это свойство определяется на этапе создания таблиц.

#

## Задача 4

Используя утилиту `pg_dump`, создайте бекап БД `test_database`.

```bash
root@4ad8fdafbbe3:/data/backup/postgres# pg_dump -U postgres test_database > /data/backup/postgres/test_database23062023.sql
root@4ad8fdafbbe3:/data/backup/postgres# ls
test_database23062023.sql  test_dump.sql
```

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?

```bash
#Можно заменить значения в файле бэкапа с помощью sed

root@4ad8fdafbbe3:/data/backup/postgres# sed -i.bak 's/title character varying(80) NOT NULL/title character varying(80) NOT NULL UNIQUE/g' /data/backup/postgres/test_database23062023.sql
```

---
