-- Entramos en mysql --

sudo mysql -u root -p

-- Creamos la base de datos --

CREATE DATABASE biblioteca25;
Query OK, 1 row affected (0,02 sec)

-- Elegimos la base de datos --

USE biblioteca25;
Database changed

SELECT DATABASE();
+--------------+
| DATABASE()   |
+--------------+
| biblioteca25 |
+--------------+
1 row in set (0,00 sec)

-- Creamos una tabla llamada autores --

CREATE TABLE autores(
	nombre VARCHAR(50),
	pais VARCHAR(255)
);
Query OK, 0 rows affected (0,04 sec)

-- Le agregamos el identificador --

ALTER TABLE autores
ADD COLUMN id INT AUTO_INCREMENT PRIMARY KEY FIRST;
Query OK, 0 rows affected (0,07 sec)
Records: 0  Duplicates: 0  Warnings: 0

-- Mostramos la tabla --

SHOW TABLES;
+------------------------+
| Tables_in_biblioteca25 |
+------------------------+
| autores                |
+------------------------+
1 row in set (0,00 sec)

-- Describimos la tabla --

DESCRIBE autores;
+--------+--------------+------+-----+---------+----------------+
| Field  | Type         | Null | Key | Default | Extra          |
+--------+--------------+------+-----+---------+----------------+
| id     | int          | NO   | PRI | NULL    | auto_increment |
| nombre | varchar(50)  | YES  |     | NULL    |                |
| pais   | varchar(255) | YES  |     | NULL    |                |
+--------+--------------+------+-----+---------+----------------+
3 rows in set (0,00 sec)

-- Creamos otra tabla llamada libros --

CREATE TABLE libros(
	id INT AUTO_INCREMENT PRIMARY KEY,
	titulo VARCHAR(200) NOT NULL,
	isbn VARCHAR(20) NOT NULL UNIQUE,
	precio DECIMAL(8,2) NOT NULL CHECK (precio>=0),	
	autor_id INT NOT NULL
);
Query OK, 0 rows affected (0,05 sec)

-- Conectamos ambas tablas --

ALTER TABLE libros
ADD CONSTRAINT fk_libros_autores
FOREIGN KEY (autor_id) REFERENCES autores(id)
ON DELETE CASCADE
ON UPDATE CASCADE;
Query OK, 0 rows affected (0,10 sec)
Records: 0  Duplicates: 0  Warnings: 0

-- Describimos la tabla --

DESCRIBE libros;
+----------+--------------+------+-----+---------+----------------+
| Field    | Type         | Null | Key | Default | Extra          |
+----------+--------------+------+-----+---------+----------------+
| id       | int          | NO   | PRI | NULL    | auto_increment |
| titulo   | varchar(200) | NO   |     | NULL    |                |
| isbn     | varchar(20)  | NO   | UNI | NULL    |                |
| precio   | decimal(8,2) | NO   |     | NULL    |                |
| autor_id | int          | NO   | MUL | NULL    |                |
+----------+--------------+------+-----+---------+----------------+

-- Crear un indice sobre el titulo --

CREATE INDEX idx_titulo ON libros(titulo);
Query OK, 0 rows affected (0,04 sec)
Records: 0  Duplicates: 0  Warnings: 0

-- Mostramos el index --

SHOW INDEX FROM libros;
+--------+------------+-------------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
| Table  | Non_unique | Key_name          | Seq_in_index | Column_name | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment | Visible | Expression |
+--------+------------+-------------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
| libros |          0 | PRIMARY           |            1 | id          | A         |           0 |     NULL |   NULL |      | BTREE      |         |               | YES     | NULL       |
| libros |          0 | isbn              |            1 | isbn        | A         |           0 |     NULL |   NULL |      | BTREE      |         |               | YES     | NULL       |
| libros |          1 | fk_libros_autores |            1 | autor_id    | A         |           0 |     NULL |   NULL |      | BTREE      |         |               | YES     | NULL       |
| libros |          1 | idx_titulo        |            1 | titulo      | A         |           0 |     NULL |   NULL |      | BTREE      |         |               | YES     | NULL       |
+--------+------------+-------------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+

-- Probamos el check --

4 rows in set (0,01 sec)

INSERT INTO libros VALUES(
	NULL,
	'Alicia en el pais de las maravillas',
	'9788401352000',
	'-50',
	'1'
);
-- Da error = Funciona --
ERROR 3819 (HY000): Check constraint 'libros_chk_1' is violated.

-- Creamos otra tabla llamada socios --

CREATE TABLE socios(
	id INT AUTO_INCREMENT PRIMARY KEY,
	nombre VARCHAR(100) NOT NULL,
	email VARCHAR(120) NOT NULL UNIQUE,
	fecha_alta DATE NOT NULL DEFAULT (CURRENT_DATE)
);
Query OK, 0 rows affected (0,06 sec)

-- Agregamos un check para el email --

ALTER TABLE socios
	ADD CONSTRAINT chk_email_format
	CHECK (email REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$');
Query OK, 0 rows affected (0,11 sec)
Records: 0  Duplicates: 0  Warnings: 0

-- Describimos la tabla --

DESCRIBE socios;
+------------+--------------+------+-----+-----------+-------------------+
| Field      | Type         | Null | Key | Default   | Extra             |
+------------+--------------+------+-----+-----------+-------------------+
| id         | int          | NO   | PRI | NULL      | auto_increment    |
| nombre     | varchar(100) | NO   |     | NULL      |                   |
| email      | varchar(120) | NO   | UNI | NULL      |                   |
| fecha_alta | date         | NO   |     | curdate() | DEFAULT_GENERATED |
+------------+--------------+------+-----+-----------+-------------------+
4 rows in set (0,00 sec)

-- Creamos otra tabla llamada prestamos --

CREATE TABLE prestamos(
	id INT AUTO_INCREMENT PRIMARY KEY,
	socio_id INT NOT NULL,
	libro_id INT NOT NULL,
	fecha_prestamo DATE NOT NULL DEFAULT (CURRENT_DATE),
	fecha_devolucion DATE NULL
);
Query OK, 0 rows affected (0,04 sec)


-- Agregamos un check --

ALTER TABLE prestamos
	ADD CONSTRAINT chk_fecha_devolucion 
	CHECK (fecha_devolucion IS NULL OR fecha_devolucion >= fecha_prestamo);
Query OK, 0 rows affected (0,11 sec)
Records: 0  Duplicates: 0  Warnings: 0

-- Agregamos un indice --

CREATE INDEX idx_socio_libro ON prestamos (socio_id, libro_id);
Query OK, 0 rows affected (0,03 sec)
Records: 0  Duplicates: 0  Warnings: 0

-- Describimos la tabla --

DESCRIBE prestamos;
+------------------+------+------+-----+-----------+-------------------+
| Field            | Type | Null | Key | Default   | Extra             |
+------------------+------+------+-----+-----------+-------------------+
| id               | int  | NO   | PRI | NULL      | auto_increment    |
| socio_id         | int  | NO   | MUL | NULL      |                   |
| libro_id         | int  | NO   |     | NULL      |                   |
| fecha_prestamo   | date | NO   |     | curdate() | DEFAULT_GENERATED |
| fecha_devolucion | date | YES  |     | NULL      |                   |
+------------------+------+------+-----+-----------+-------------------+
5 rows in set (0,00 sec)

-- Conectamos las tablas --

ALTER TABLE prestamos
ADD CONSTRAINT fk_socio_socios
FOREIGN KEY (socio_id) REFERENCES socios(id)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE prestamos
ADD CONSTRAINT fk_libro_libros
FOREIGN KEY (libro_id) REFERENCES libros(id)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- Mostramos el index de la tabla --

SHOW INDEX FROM prestamos;
+-----------+------------+-----------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
| Table     | Non_unique | Key_name        | Seq_in_index | Column_name | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment | Visible | Expression |
+-----------+------------+-----------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
| prestamos |          0 | PRIMARY         |            1 | id          | A         |           0 |     NULL |   NULL |      | BTREE      |         |               | YES     | NULL       |
| prestamos |          1 | idx_socio_libro |            1 | socio_id    | A         |           0 |     NULL |   NULL |      | BTREE      |         |               | YES     | NULL       |
| prestamos |          1 | idx_socio_libro |            2 | libro_id    | A         |           0 |     NULL |   NULL |      | BTREE      |         |               | YES     | NULL       |
| prestamos |          1 | fk_libro_libros |            1 | libro_id    | A         |           0 |     NULL |   NULL |      | BTREE      |         |               | YES     | NULL       |
+-----------+------------+-----------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
4 rows in set (0,02 sec)	

-- Verificamos los checks --

INSERT INTO prestamos VALUES(
	NULL,
	1,
	2,
	'2025-10-31',
	NULL
);
INSERT INTO prestamos VALUES(
	NULL,
	1,
	2,
	'2025-10-31',
	'2025-11-25'
);

-- Insertamos datos --

			--Autores--
INSERT INTO autores VALUES(
	NULL,
	'Isabel Allende',
	'Chile'
);
Query OK, 1 row affected (0,01 sec)

INSERT INTO autores VALUES(
	NULL,
	'Gabriel García Márquez',
	'Colombia'
);
Query OK, 1 row affected (0,01 sec)

INSERT INTO autores VALUES(
	NULL,
	'Haruki Murakami',
	'Japón'
);
Query OK, 1 row affected (0,01 sec)

-- Mostramos los datos de la tabla --

SELECT * FROM autores;
+----+--------------------------+----------+
| id | nombre                   | pais     |
+----+--------------------------+----------+
|  1 | Isabel Allende           | Chile    |
|  2 | Gabriel García Márquez   | Colombia |
|  3 | Haruki Murakami          | Japón    |
+----+--------------------------+----------+
3 rows in set (0,00 sec)

		-- libros --

INSERT INTO libros VALUES(
	NULL,
	'La casa de los espíritus',
	'9788401352836',
	150.00,
	1
);
INSERT INTO libros VALUES(
	NULL,
	'Cien años de soledad',
	'9780307474728',
	100.00,
	2
);
INSERT INTO libros VALUES(
	NULL,
	'Kafka en la orilla',
	'9788499082478',
	175.00,
	3
);

-- Mostramos los datos de la tabla --

SELECT * FROM libros;
+----+---------------------------+---------------+--------+----------+
| id | titulo                    | isbn          | precio | autor_id |
+----+---------------------------+---------------+--------+----------+
|  1 | La casa de los espíritus  | 9788401352836 | 150.00 |        1 |
|  2 | Cien años de soledad      | 9780307474728 | 100.00 |        2 |
|  3 | Kafka en la orilla        | 9788499082478 | 175.00 |        3 |
+----+---------------------------+---------------+--------+----------+
3 rows in set (0,00 sec)

		-- Socios --
		
INSERT INTO socios VALUES(
	NULL,
	'Ana Ruiz',
	'ana.ruiz@example.com',
	'2025-10-31'
);
INSERT INTO socios VALUES(
	NULL,
	'Luis Pérez',
	'luis.perez@example.com',
	'2025-10-31'
);

-- Mostramos los datos de la tabla --

SELECT * FROM socios;
+----+-------------+------------------------+------------+
| id | nombre      | email                  | fecha_alta |
+----+-------------+------------------------+------------+
|  1 | Ana Ruiz    | ana.ruiz@example.com   | 2025-10-31 |
|  2 | Luis Pérez  | luis.perez@example.com | 2025-10-31 |
+----+-------------+------------------------+------------+
2 rows in set (0,00 sec)

-- Prestamos --

INSERT INTO prestamos VALUES(
	NULL,
	1,
	2,
	'2025-10-31',
	NULL
);
INSERT INTO prestamos VALUES(
	NULL,
	1,
	2,
	'2025-10-31',
	'2025-11-25'
);

SELECT * FROM prestamos;
+----+----------+----------+----------------+------------------+
| id | socio_id | libro_id | fecha_prestamo | fecha_devolucion |
+----+----------+----------+----------------+------------------+
|  1 |        1 |        2 | 2025-10-31     | NULL             |
|  2 |        1 |        2 | 2025-10-31     | 2025-11-25       |
+----+----------+----------+----------------+------------------+
2 rows in set (0,00 sec)

------------- VERIFICACION -------------------
SHOW TABLES;
+------------------------+
| Tables_in_biblioteca25 |
+------------------------+
| autores                |
| libros                 |
| prestamos              |
| socios                 |
+------------------------+
4 rows in set (0,00 sec)

DESCRIBE autores;
mysql> DESCRIBE autores;
+--------+--------------+------+-----+---------+----------------+
| Field  | Type         | Null | Key | Default | Extra          |
+--------+--------------+------+-----+---------+----------------+
| id     | int          | NO   | PRI | NULL    | auto_increment |
| nombre | varchar(50)  | YES  |     | NULL    |                |
| pais   | varchar(255) | YES  |     | NULL    |                |
+--------+--------------+------+-----+---------+----------------+
3 rows in set (0,00 sec)

DESCRIBE libros;
+----------+--------------+------+-----+---------+----------------+
| Field    | Type         | Null | Key | Default | Extra          |
+----------+--------------+------+-----+---------+----------------+
| id       | int          | NO   | PRI | NULL    | auto_increment |
| titulo   | varchar(200) | NO   | MUL | NULL    |                |
| isbn     | varchar(20)  | NO   | UNI | NULL    |                |
| precio   | decimal(8,2) | NO   |     | NULL    |                |
| autor_id | int          | NO   | MUL | NULL    |                |
+----------+--------------+------+-----+---------+----------------+
5 rows in set (0,00 sec)

DESCRIBE socios;
+------------+--------------+------+-----+-----------+-------------------+
| Field      | Type         | Null | Key | Default   | Extra             |
+------------+--------------+------+-----+-----------+-------------------+
| id         | int          | NO   | PRI | NULL      | auto_increment    |
| nombre     | varchar(100) | NO   |     | NULL      |                   |
| email      | varchar(120) | NO   | UNI | NULL      |                   |
| fecha_alta | date         | NO   |     | curdate() | DEFAULT_GENERATED |
+------------+--------------+------+-----+-----------+-------------------+
4 rows in set (0,00 sec)
