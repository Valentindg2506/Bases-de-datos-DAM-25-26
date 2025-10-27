sudo mysql -u root -p

CREATE DATABASE EJ;
Query OK, 1 row affected (0,02 sec)

SHOW DATABASE;
+--------------------+
| Database           |
+--------------------+
| EJ                 |
| ejemploclaves      |
| empresadam         |
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+

USE EJ;
Database changed

CREATE TABLE Cliente(
	dni VARCHAR(9),
	nombre VARCHAR(50),
	apellidos VARCHAR(255),
	email VARCHAR(100)
);
Query OK, 0 rows affected (0,19 sec)

DESCRIBE Cliente;
+-----------+--------------+------+-----+---------+-------+
| Field     | Type         | Null | Key | Default | Extra |
+-----------+--------------+------+-----+---------+-------+
| dni       | varchar(9)   | YES  |     | NULL    |       |
| nombre    | varchar(50)  | YES  |     | NULL    |       |
| apellidos | varchar(255) | YES  |     | NULL    |       |
| email     | varchar(100) | YES  |     | NULL    |       |
+-----------+--------------+------+-----+---------+-------+

