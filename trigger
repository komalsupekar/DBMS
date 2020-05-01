dmin@localhost ~]$ su 
Password: 
[root@localhost admin]# systemctl start mysqld 
^[[A^[[A[root@localhost admin]# mysql 
Welcome to the MariaDB monitor.  Commands end with ; or \g. 
Your MariaDB connection id is 2 
Server version: 5.5.33a-MariaDB MariaDB Server 

Copyright (c) 2000, 2013, Oracle, Monty Program Ab and others. 

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement. 

MariaDB [(none)]> use test; 
Database changed 
MariaDB [test]> show tables; 
Empty set (0.00 sec) 


use mocktest; 
Reading table information for completion of table and column names 
You can turn off this feature to get a quicker startup with -A 

Database changed 
MariaDB [mocktest]> show tables; 
+--------------------+ 
| Tables_in_mocktest | 
+--------------------+ 
| item               | 
| sales              | 
+--------------------+ 
2 rows in set (0.00 sec) 





MariaDB [mocktest]> select * from item; 
+--------+-------+----------+-------+ 
| ItemId | Name  | Quantity | Price | 
+--------+-------+----------+-------+ 
|      1 | Train |       60 |    10 | 
|      2 | Plane |       60 |    20 | 
|      3 | Dog   |       40 |    20 | 
|      4 | Cat   |       50 |    30 | 
+--------+-------+----------+-------+ 
4 rows in set (0.00 sec) 

MariaDB [mocktest]> create table sales(ItemId int , SalesId int , QuantSold int, Price int ,TotPrice int);Query OK, 0 rows affected (0.06 sec) 


create trigger salescal 
    -> before insert 
    -> on sales 
    -> for each row 
    -> begin 
    -> set new.TotPrice = new.QuantSold*new.Price; 
    -> update item 
    -> set Quantity = Quantity - new.QuantSold 
    -> where ItemId = new.ItemId; 
    -> end; 
    -> // 
Query OK, 0 rows affected (0.07 sec) 

insert into sales(ItemId,SalesId,QuantSold,Price) values(1,101,10,10);select * from sales;// 
Query OK, 1 row affected (0.04 sec) 

+--------+---------+-----------+-------+----------+ 
| ItemId | SalesId | QuantSold | Price | TotPrice | 
+--------+---------+-----------+-------+----------+ 
|      1 |     101 |        10 |    10 |      100 | 
|      1 |     101 |        10 |    10 |      100 | 
+--------+---------+-----------+-------+----------+ 
2 rows in set (0.04 sec) 



MariaDB [mocktest]> select * from item;// 
+--------+-------+----------+-------+ 
| ItemId | Name  | Quantity | Price | 
+--------+-------+----------+-------+ 
|      1 | Train |       50 |    10 | 
|      2 | Plane |       55 |    20 | 
|      3 | Dog   |       40 |    20 | 
|      4 | Cat   |       50 |    30 | 
+--------+-------+----------+-------+ 
4 rows in set (0.01 sec) 




select * from sales;// 
+--------+---------+-----------+-------+----------+ 
| ItemId | SalesId | QuantSold | Price | TotPrice | 
+--------+---------+-----------+-------+----------+ 
|      1 |     101 |        10 |    10 |      100 | 
|      1 |     101 |        10 |    10 |      100 | 
|      2 |     101 |         5 |    20 |      100 | 
+--------+---------+-----------+-------+----------+ 
3 rows in set (0.00 sec) 

MariaDB [mocktest]> insert into sales(ItemId,SalesId,QuantSold,Price) values(3,104,7,20);select * from sales;// 
Query OK, 1 row affected (0.03 sec) 

+--------+---------+-----------+-------+----------+ 
| ItemId | SalesId | QuantSold | Price | TotPrice | 
+--------+---------+-----------+-------+----------+ 
|      1 |     101 |        10 |    10 |      100 | 
|      1 |     101 |        10 |    10 |      100 | 
|      2 |     101 |         5 |    20 |      100 | 
|      3 |     104 |         7 |    20 |      140 | 
+--------+---------+-----------+-------+----------+ 
4 rows in set (0.03 sec) 


MariaDB [mocktest]> select * from item;// 
+--------+-------+----------+-------+ 
| ItemId | Name  | Quantity | Price | 
+--------+-------+----------+-------+ 
|      1 | Train |       50 |    10 | 
|      2 | Plane |       55 |    20 | 
|      3 | Dog   |       33 |    20 | 
|      4 | Cat   |       50 |    30 | 
+--------+-------+----------+-------+ 
4 rows in set (0.00 sec) 
