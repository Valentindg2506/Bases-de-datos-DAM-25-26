En el ejercicio a continuacion vamos a crear una tabla **Cliente**, que incluya los atributos:
	- DNI
	- Nombre
	- Apellidos
	- Email
Primero hay que crear una base de datos:
```
CREATE DATABASE EJ;
```
Luego hay que seleccionar esa base de datos que acabamos de crear:
```
USE EJ;
```
Despues vamos a crear la tabla Cliente:
```
CREATE TABLE Cliente(
	dni VARCHAR(9),
	nombre VARCHAR(50),
	apellidos VARCHAR(255),
	email VARCHAR(100)
);
```
Y en la base de datos se visualiza de la siguiente manera:
```
+-----------+--------------+------+-----+---------+-------+
| Field     | Type         | Null | Key | Default | Extra |
+-----------+--------------+------+-----+---------+-------+
| dni       | varchar(9)   | YES  |     | NULL    |       |
| nombre    | varchar(50)  | YES  |     | NULL    |       |
| apellidos | varchar(255) | YES  |     | NULL    |       |
| email     | varchar(100) | YES  |     | NULL    |       |
+-----------+--------------+------+-----+---------+-------+
```
A continuacion se puede ver el registro de sql:
```
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
```
**NOTAS:**
- Al usar los comandos en sql no hay que olvidar el punto y coma `;` ya que de no ponerlo la terminal no ejecuta

