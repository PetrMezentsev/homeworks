# Домашнее задание к занятию 2. «SQL»

## Задача 1

Используя Docker, поднимите инстанс PostgreSQL (версию 12) c 2 volume, 
в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose-манифест.

##### Ответ:

```bash
papercut@MP:~/06-db-02-sql$ cat docker-compose.yaml
version: '3.9'

services:
  postgres:
    image: postgres:12
    restart: always
    environment:
      - POSTGRES_PASSWORD=harumamburu
      - POSTGRES_USER=filewalker
    volumes:
      - ./pgdata:/var/lib/postgresql/data
      - ./pgbackup:/data/backup/postgres
    ports:
      - 5433:5432
```

#

## Задача 2

В БД из задачи 1: 

- создайте пользователя test-admin-user и БД test_db;
- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже);
- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db;
- создайте пользователя test-simple-user;
- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE этих таблиц БД test_db.

Таблица orders:

- id (serial primary key);
- наименование (string);
- цена (integer).

Таблица clients:

- id (serial primary key);
- фамилия (string);
- страна проживания (string, index);
- заказ (foreign key orders).

Приведите:

- итоговый список БД после выполнения пунктов выше;

```bash
test_db=# \l
                                    List of databases
    Name    |   Owner    | Encoding |  Collate   |   Ctype    |     Access privileges
------------+------------+----------+------------+------------+---------------------------
 filewalker | filewalker | UTF8     | en_US.utf8 | en_US.utf8 |
 postgres   | filewalker | UTF8     | en_US.utf8 | en_US.utf8 |
 template0  | filewalker | UTF8     | en_US.utf8 | en_US.utf8 | =c/filewalker            +
            |            |          |            |            | filewalker=CTc/filewalker
 template1  | filewalker | UTF8     | en_US.utf8 | en_US.utf8 | =c/filewalker            +
            |            |          |            |            | filewalker=CTc/filewalker
 test_db    | filewalker | UTF8     | en_US.utf8 | en_US.utf8 |
(5 rows)
```

- описание таблиц (describe);

```bash
test_db=# \d orders
                            Table "public.orders"
 Column |  Type   | Collation | Nullable |              Default
--------+---------+-----------+----------+------------------------------------
 id     | integer |           | not null | nextval('orders_id_seq'::regclass)
 name   | text    |           |          |
 price  | integer |           |          |
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "clients" CONSTRAINT "clients_booking_fkey" FOREIGN KEY (booking) REFERENCES orders(id)

test_db=# \d clients
                                     Table "public.clients"
  Column  |          Type          | Collation | Nullable |               Default
----------+------------------------+-----------+----------+-------------------------------------
 id       | integer                |           | not null | nextval('clients_id_seq'::regclass)
 lastname | character varying(100) |           |          |
 country  | character varying(100) |           |          |
 booking  | integer                |           |          |
Indexes:
    "clients_pkey" PRIMARY KEY, btree (id)
    "clients_country_idx" btree (country)
Foreign-key constraints:
    "clients_booking_fkey" FOREIGN KEY (booking) REFERENCES orders(id)
```

- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db;

```sql
SELECT table_name, array_agg(privilege_type), grantee
FROM information_schema.table_privileges
WHERE table_name = 'orders' OR table_name = 'clients'
GROUP BY table_name, grantee;
```

- список пользователей с правами над таблицами test_db.

```bash
 table_name |                         array_agg                         |     grantee
------------+-----------------------------------------------------------+------------------
 clients    | {INSERT,TRIGGER,REFERENCES,TRUNCATE,DELETE,UPDATE,SELECT} | filewalker
 clients    | {INSERT,TRIGGER,REFERENCES,TRUNCATE,DELETE,UPDATE,SELECT} | test-admin-user
 clients    | {DELETE,INSERT,SELECT,UPDATE}                             | test-simple-user
 orders     | {INSERT,TRIGGER,REFERENCES,TRUNCATE,DELETE,UPDATE,SELECT} | filewalker
 orders     | {INSERT,TRIGGER,REFERENCES,TRUNCATE,DELETE,UPDATE,SELECT} | test-admin-user
 orders     | {DELETE,SELECT,UPDATE,INSERT}                             | test-simple-user
(6 rows)
```

## Задача 3

Используя SQL-синтаксис, наполните таблицы следующими тестовыми данными:

Таблица orders

|Наименование|цена|
|------------|----|
|Шоколад| 10 |
|Принтер| 3000 |
|Книга| 500 |
|Монитор| 7000|
|Гитара| 4000|

Таблица clients

|ФИО|Страна проживания|
|------------|----|
|Иванов Иван Иванович| USA |
|Петров Петр Петрович| Canada |
|Иоганн Себастьян Бах| Japan |
|Ронни Джеймс Дио| Russia|
|Ritchie Blackmore| Russia|

Используя SQL-синтаксис:
- вычислите количество записей для каждой таблицы.

Приведите в ответе:

    - запросы,
    - результаты их выполнения.

##### Ответ:

```bash
INSERT INTO orders (name, price)
VALUES
('Шоколад', '10'),
('Принтер', '3000'),
('Книга', '500'),
('Монитор', '7000'),
('Гитара', '4000')
;
INSERT 0 5

INSERT INTO clients (lastname, country)
VALUES
('Иванов Иван Иванович', 'USA'),
('Петров Петр Петрович', 'Canada'),
('Иоганн Себастьян Бах', 'Japan'),
('Ронни Джеймс Дио', 'Russia'),
('Ritchie Blackmore', 'Russia')
;
INSERT 0 5

SELECT 'orders' AS table,  COUNT(*) AS rows_count FROM orders
UNION ALL 
SELECT 'clients' AS table,  COUNT(*) AS rows_count FROM clients;

table  | rows_count
---------+------------
 orders  |          5
 clients |          5
(2 rows)
```

#

## Задача 4

Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys, свяжите записи из таблиц, согласно таблице:

|ФИО|Заказ|
|------------|----|
|Иванов Иван Иванович| Книга |
|Петров Петр Петрович| Монитор |
|Иоганн Себастьян Бах| Гитара |

Приведите SQL-запросы для выполнения этих операций.

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод этого запроса.
 
Подсказка: используйте директиву `UPDATE`.

##### Ответ:

```bash
UPDATE clients SET "booking"=3 WHERE id=1;
UPDATE clients SET "booking"=4 WHERE id=2;
UPDATE clients SET "booking"=5 WHERE id=3;

SELECT lastname, booking, orders.name
FROM clients
INNER JOIN orders ON booking=orders.id;
       lastname       | booking |  name
----------------------+---------+---------
 Иванов Иван Иванович |       3 | Книга
 Петров Петр Петрович |       4 | Монитор
 Иоганн Себастьян Бах |       5 | Гитара
(3 rows)

SELECT * FROM clients
WHERE booking IS NOT null;
 id |       lastname       | country | booking
----+----------------------+---------+---------
  1 | Иванов Иван Иванович | USA     |       3
  2 | Петров Петр Петрович | Canada  |       4
  3 | Иоганн Себастьян Бах | Japan   |       5
(3 rows)
```

#

## Задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 
(используя директиву EXPLAIN).

Приведите получившийся результат и объясните, что значат полученные значения.

##### Ответ:

```sql
test_db=# EXPLAIN SELECT * FROM clients
WHERE booking IS NOT null;
                       QUERY PLAN
--------------------------------------------------------
 Seq Scan on clients  (cost=0.00..1.05 rows=3 width=47)
   Filter: (booking IS NOT NULL)
(2 rows)
```

`Seq Scan` - планировщик выбрал план простого последовательного сканирования;  
`cost` - приблизительная стоимость запуска. Это время, которое проходит, прежде чем начнётся этап вывода данных, например для сортирующего узла это время сортировки;  
`1.05` - приблизительная общая стоимость. Она вычисляется в предположении, что узел плана выполняется до конца, то есть возвращает все доступные строки;  
`rows` - ожидаемое число строк, которое должен вывести этот узел плана. При этом так же предполагается, что узел выполняется до конца;  
`width` - ожидаемый средний размер строк, выводимых этим узлом плана (в байтах);  
`Filter` - используется фильтр `booking IS NOT NULL`.

#

## Задача 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. задачу 1).

```bash
root@fb197245ec79:/data/backup/postgres# pg_dump -U filewalker test_db > /data/backup/postgres/test_db.dump
```

Остановите контейнер с PostgreSQL, но не удаляйте volumes.

```bash
papercut@MP:~/06-db-02-sql$ sudo docker stop 06-db-02-sql_postgres_1

#Очистил содержимое по пути  /home/papercut/06-db-02-sql/pgdata на хостовой машине
```

Поднимите новый пустой контейнер с PostgreSQL.

```bash
papercut@MP:~/06-db-02-sql$ sudo docker-compose up -d
Starting 06-db-02-sql_postgres_1 ... done
papercut@MP:~/06-db-02-sql$ sudo docker exec -ti 06-db-02-sql_postgres_1 bash
root@fb197245ec79:/# psql -U filewalker
psql (12.15 (Debian 12.15-1.pgdg120+1))
Type "help" for help.

filewalker=# \l
                                    List of databases
    Name    |   Owner    | Encoding |  Collate   |   Ctype    |     Access privileges
------------+------------+----------+------------+------------+---------------------------
 filewalker | filewalker | UTF8     | en_US.utf8 | en_US.utf8 |
 postgres   | filewalker | UTF8     | en_US.utf8 | en_US.utf8 |
 template0  | filewalker | UTF8     | en_US.utf8 | en_US.utf8 | =c/filewalker            +
            |            |          |            |            | filewalker=CTc/filewalker
 template1  | filewalker | UTF8     | en_US.utf8 | en_US.utf8 | =c/filewalker            +
            |            |          |            |            | filewalker=CTc/filewalker
(4 rows)
```

Восстановите БД test_db в новом контейнере.

```sql
root@fb197245ec79:/data/backup/postgres# psql -U filewalker
psql (12.15 (Debian 12.15-1.pgdg120+1))
Type "help" for help.

filewalker=# CREATE DATABASE test_db;
CREATE DATABASE
filewalker=# \l
                                    List of databases
    Name    |   Owner    | Encoding |  Collate   |   Ctype    |     Access privileges
------------+------------+----------+------------+------------+---------------------------
 filewalker | filewalker | UTF8     | en_US.utf8 | en_US.utf8 |
 postgres   | filewalker | UTF8     | en_US.utf8 | en_US.utf8 |
 template0  | filewalker | UTF8     | en_US.utf8 | en_US.utf8 | =c/filewalker            +
            |            |          |            |            | filewalker=CTc/filewalker
 template1  | filewalker | UTF8     | en_US.utf8 | en_US.utf8 | =c/filewalker            +
            |            |          |            |            | filewalker=CTc/filewalker
 test_db    | filewalker | UTF8     | en_US.utf8 | en_US.utf8 |
(5 rows)

filewalker=# \du
                                    List of roles
 Role name  |                         Attributes                         | Member of
------------+------------------------------------------------------------+-----------
 filewalker | Superuser, Create role, Create DB, Replication, Bypass RLS | {}

filewalker=# CREATE USER "test-admin-user" WITH LOGIN;
CREATE ROLE
filewalker=# CREATE USER "test-simple-user" WITH LOGIN;
CREATE ROLE
filewalker=# \du
                                       List of roles
    Role name     |                         Attributes                         | Member of
------------------+------------------------------------------------------------+-----------
 filewalker       | Superuser, Create role, Create DB, Replication, Bypass RLS | {}
 test-admin-user  |                                                            | {}
 test-simple-user |                                                            | {}

filewalker=# \q
root@fb197245ec79:/data/backup/postgres# psql -U filewalker test_db < test_db.dump
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
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
ALTER TABLE
ALTER TABLE
COPY 5
COPY 5
 setval
--------
      5
(1 row)

 setval
--------
      5
(1 row)

ALTER TABLE
ALTER TABLE
CREATE INDEX
ALTER TABLE
GRANT
GRANT
GRANT
GRANT

root@fb197245ec79:/data/backup/postgres# psql -U filewalker
psql (12.15 (Debian 12.15-1.pgdg120+1))
Type "help" for help.

filewalker=# \l
                                    List of databases
    Name    |   Owner    | Encoding |  Collate   |   Ctype    |     Access privileges
------------+------------+----------+------------+------------+---------------------------
 filewalker | filewalker | UTF8     | en_US.utf8 | en_US.utf8 |
 postgres   | filewalker | UTF8     | en_US.utf8 | en_US.utf8 |
 template0  | filewalker | UTF8     | en_US.utf8 | en_US.utf8 | =c/filewalker            +
            |            |          |            |            | filewalker=CTc/filewalker
 template1  | filewalker | UTF8     | en_US.utf8 | en_US.utf8 | =c/filewalker            +
            |            |          |            |            | filewalker=CTc/filewalker
 test_db    | filewalker | UTF8     | en_US.utf8 | en_US.utf8 |
(5 rows)

filewalker=# \c test_db
You are now connected to database "test_db" as user "filewalker".
test_db=# \d orders
                            Table "public.orders"
 Column |  Type   | Collation | Nullable |              Default
--------+---------+-----------+----------+------------------------------------
 id     | integer |           | not null | nextval('orders_id_seq'::regclass)
 name   | text    |           |          |
 price  | integer |           |          |
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "clients" CONSTRAINT "clients_booking_fkey" FOREIGN KEY (booking) REFERENCES orders(id)

test_db=# \d clients
                                     Table "public.clients"
  Column  |          Type          | Collation | Nullable |               Default
----------+------------------------+-----------+----------+-------------------------------------
 id       | integer                |           | not null | nextval('clients_id_seq'::regclass)
 lastname | character varying(100) |           |          |
 country  | character varying(100) |           |          |
 booking  | integer                |           |          |
Indexes:
    "clients_pkey" PRIMARY KEY, btree (id)
    "clients_country_idx" btree (country)
Foreign-key constraints:
    "clients_booking_fkey" FOREIGN KEY (booking) REFERENCES orders(id)
 
```

Приведите список операций, который вы применяли для бэкапа данных и восстановления. 

---
