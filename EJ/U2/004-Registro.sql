Primero entramos en MySql:
sudo mysql -u root -p

Seleccionamos la base de datos:
USE EmpresaDAM;

Mostramos las tablas:
SHOW TABLES;
+----------------------+
| Tables_in_EmpresaDAM |
+----------------------+
| clientes             |
+----------------------+

Describimos la tabla:
DESCRIBE clientes;
+-----------+--------------+------+-----+---------+-------+
| Field     | Type         | Null | Key | Default | Extra |
+-----------+--------------+------+-----+---------+-------+
| dni       | varchar(9)   | YES  |     | NULL    |       |
| nombre    | varchar(50)  | YES  |     | NULL    |       |
| apellidos | varchar(255) | YES  |     | NULL    |       |
| email     | varchar(100) | YES  |     | NULL    |       |
+-----------+--------------+------+-----+---------+-------+

Le añadimos un identificador:
ALTER TABLE clientes ADD COLUMN identificador INT AUTO_INCREMENT PRIMARY KEY FIRST;

Volvemos a describir la tabla parta verificar que se añadio correctamente:
DESCRIBE clientes;
+---------------+--------------+------+-----+---------+----------------+
| Field         | Type         | Null | Key | Default | Extra          |
+---------------+--------------+------+-----+---------+----------------+
| identificador | int          | NO   | PRI | NULL    | auto_increment |
| dni           | varchar(9)   | YES  |     | NULL    |                |
| nombre        | varchar(50)  | YES  |     | NULL    |                |
| apellidos     | varchar(255) | YES  |     | NULL    |                |
| email         | varchar(100) | YES  |     | NULL    |                |
+---------------+--------------+------+-----+---------+----------------+

