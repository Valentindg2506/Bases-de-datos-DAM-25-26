Primero entramos a MySql:
sudo mysql -u root -p

Creamos la base de datos:
CREATE DATABASE EJ;

Seleccionamos la base de datos:
USE EJ;

Creamos la tabla jugadores:
CREATE TABLE Jugadores(
	dni VARCHAR(9),
	nombre VARCHAR(100),
	posicion VARCHAR(100),
	equipo VARCHAR(100)
);

Describimos la tabla para verificar que este creada correctamente:
DESCRIBE Jugadores;
+----------+--------------+------+-----+---------+-------+
| Field    | Type         | Null | Key | Default | Extra |
+----------+--------------+------+-----+---------+-------+
| dni      | varchar(9)   | YES  |     | NULL    |       |
| nombre   | varchar(100) | YES  |     | NULL    |       |
| posicion | varchar(100) | YES  |     | NULL    |       |
| equipo   | varchar(100) | YES  |     | NULL    |       |
+----------+--------------+------+-----+---------+-------+

Insertamos datos en la tabla:
INSERT INTO Jugadores VALUES(
	"12345678Z",
	"Juan Perez",
	"Pilar",
	"GEBA"
);

Mostramos los datos de la tabla:
SELECT * FROM Jugadores;
+-----------+------------+----------+--------+
| dni       | nombre     | posicion | equipo |
+-----------+------------+----------+--------+
| 12345678Z | Juan Perez | Pilar    | GEBA   |
+-----------+------------+----------+--------+

