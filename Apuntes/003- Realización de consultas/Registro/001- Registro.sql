-- sudo mysql -u root -p

CREATE DATABASE clientes;
USE clientes;

CREATE TABLE clientes(
	Nombre VARCHAR(255),
	Apellidos VARCHAR(255),
	Edad INT
);

INSERT INTO clientes VALUES ("Jose","Gomez",45)
INSERT INTO clientes VALUES ("Juan","Pedro",30)
INSERT INTO clientes VALUES ("Ana","Martínez",32);
INSERT INTO clientes VALUES ("Luis","Fernández",28);
INSERT INTO clientes VALUES ("María","López",41);
INSERT INTO clientes VALUES ("Carlos","Ruiz",37);
INSERT INTO clientes VALUES ("Lucía","Sánchez",29);
INSERT INTO clientes VALUES ("Pedro","Domínguez",50);
INSERT INTO clientes VALUES ("Sofía","Navarro",26);
INSERT INTO clientes VALUES ("Miguel","Torres",44);
INSERT INTO clientes VALUES ("Paula","Vargas",31);
INSERT INTO clientes VALUES ("Diego","Castro",39);
INSERT INTO clientes VALUES ("Elena","Molina",33);
INSERT INTO clientes VALUES ("Javier","Ortega",48);
INSERT INTO clientes VALUES ("Clara","Romero",27);
INSERT INTO clientes VALUES ("Hugo","Cabrera",36);
INSERT INTO clientes VALUES ("Isabel","Ramos",42);
INSERT INTO clientes VALUES ("Rafael","Iglesias",34);
INSERT INTO clientes VALUES ("Carmen","Santos",30);
INSERT INTO clientes VALUES ("Adrián","Reyes",25);
INSERT INTO clientes VALUES ("Valeria","Peña",38);
INSERT INTO clientes VALUES ("Fernando","Cortés",46);
INSERT INTO clientes VALUES ("Nuria","Beltrán",35);
INSERT INTO clientes VALUES ("Sergio","Acosta",40);
INSERT INTO clientes VALUES ("Patricia","Vega",28);
INSERT INTO clientes VALUES ("Óscar","Herrera",49);
INSERT INTO clientes VALUES ("Marta","Gil",30);
INSERT INTO clientes VALUES ("Iván","Jiménez",33);
INSERT INTO clientes VALUES ("Raquel","Solís",27);
INSERT INTO clientes VALUES ("Tomás","Mercado",52);
INSERT INTO clientes VALUES ("Andrea","Fuentes",24);
INSERT INTO clientes VALUES ("Gabriel","Paredes",43);
INSERT INTO clientes VALUES ("Bruno","Ledesma",29);
INSERT INTO clientes VALUES ("Angela","Montoya",34);
INSERT INTO clientes VALUES ("Emilio","Salinas",47);
INSERT INTO clientes VALUES ("Rocio","Benítez",31);
INSERT INTO clientes VALUES ("Matías","Campos",26);
INSERT INTO clientes VALUES ("Julieta","Esquivel",39);
INSERT INTO clientes VALUES ("Nicolás","Ponce",45);
INSERT INTO clientes VALUES ("Lorena","Silva",28);
INSERT INTO clientes VALUES ("Esteban","Gallego",41);
INSERT INTO clientes VALUES ("Victoria","Aguilar",33);
INSERT INTO clientes VALUES ("Sebastián","Bravo",36);
INSERT INTO clientes VALUES ("Daniela","Montes",27);
INSERT INTO clientes VALUES ("Álvaro","Barrenechea",50);
INSERT INTO clientes VALUES ("Camila","Arrieta",25);
INSERT INTO clientes VALUES ("Ramiro","Saavedra",44);
INSERT INTO clientes VALUES ("Noelia","Perdomo",32);
INSERT INTO clientes VALUES ("Joaquín","Ferrero",38);
INSERT INTO clientes VALUES ("Mariela","Izquierdo",30);
INSERT INTO clientes VALUES ("Ezequiel","Carreño",29);
INSERT INTO clientes VALUES ("Selena","Palacios",24);

SELECT * FROM clientes;
+------------+-------------+------+
| Nombre     | Apellidos   | Edad |
+------------+-------------+------+
| Luis       | Fernández   |   28 |
| María      | López       |   41 |
| Carlos     | Ruiz        |   37 |
| Lucía      | Sánchez     |   29 |
| Pedro      | Domínguez   |   50 |
| Sofía      | Navarro     |   26 |
| Miguel     | Torres      |   44 |
| Paula      | Vargas      |   31 |
| Diego      | Castro      |   39 |
| Elena      | Molina      |   33 |
| Javier     | Ortega      |   48 |
| Clara      | Romero      |   27 |
| Hugo       | Cabrera     |   36 |
| Isabel     | Ramos       |   42 |
| Rafael     | Iglesias    |   34 |
| Carmen     | Santos      |   30 |
| Adrián     | Reyes       |   25 |
| Valeria    | Peña        |   38 |
| Fernando   | Cortés      |   46 |
| Nuria      | Beltrán     |   35 |
| Sergio     | Acosta      |   40 |
| Patricia   | Vega        |   28 |
| Óscar      | Herrera     |   49 |
| Marta      | Gil         |   30 |
| Iván       | Jiménez     |   33 |
| Raquel     | Solís       |   27 |
| Tomás      | Mercado     |   52 |
| Andrea     | Fuentes     |   24 |
| Gabriel    | Paredes     |   43 |
| Bruno      | Ledesma     |   29 |
| Angela     | Montoya     |   34 |
| Emilio     | Salinas     |   47 |
| Rocio      | Benítez     |   31 |
| Matías     | Campos      |   26 |
| Julieta    | Esquivel    |   39 |
| Nicolás    | Ponce       |   45 |
| Lorena     | Silva       |   28 |
| Esteban    | Gallego     |   41 |
| Victoria   | Aguilar     |   33 |
| Sebastián  | Bravo       |   36 |
| Daniela    | Montes      |   27 |
| Álvaro     | Barrenechea |   50 |
| Camila     | Arrieta     |   25 |
| Ramiro     | Saavedra    |   44 |
| Noelia     | Perdomo     |   32 |
| Joaquín    | Ferrero     |   38 |
| Mariela    | Izquierdo   |   30 |
| Ezequiel   | Carreño     |   29 |
| Selena     | Palacios    |   24 |
+------------+-------------+------+
-- LO MISMO QUE ANTES
SELECT
Nombre,
Apellidos,
Edad
FROM
clientes;

-- MENOS COLUMNAS
SELECT
Nombre,
Apellidos
FROM
clientes;

-- CAMBIAMOS LOS NOMBRES
SELECT
Nombre AS 'Nombre del cliente',
Apellidos AS 'Apellidos del cliente',
Edad AS 'Edad del cliente'
FROM
clientes;

-- ORDENAMOS 
-- POR APELLIDO
SELECT
Nombre AS 'Nombre del cliente',
Apellidos AS 'Apellidos del cliente',
Edad AS 'Edad del cliente'
FROM
clientes
ORDER BY
Apellidos;

SELECT
Nombre AS 'Nombre del cliente',
Apellidos AS 'Apellidos del cliente',
Edad AS 'Edad del cliente'
FROM
clientes
ORDER BY
Apellidos ASC;

SELECT
Nombre AS 'Nombre del cliente',
Apellidos AS 'Apellidos del cliente',
Edad AS 'Edad del cliente'
FROM
clientes
ORDER BY
Apellidos DESC;

-- POR EDAD
SELECT
Nombre AS 'Nombre del cliente',
Apellidos AS 'Apellidos del cliente',
Edad AS 'Edad del cliente'
FROM
clientes
ORDER BY
Edad DESC;

-- Y CON DOS COLUMNAS
SELECT
Nombre AS 'Nombre del cliente',
Apellidos AS 'Apellidos del cliente',
Edad AS 'Edad del cliente'
FROM
clientes
ORDER BY
Edad DESC,Apellidos ASC;
