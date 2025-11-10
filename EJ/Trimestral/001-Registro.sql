-- ENTRAMOS A MYSQL --
sudo mysql -u root -p

-- CREAMOS LA BASE DE DATOS --
CREATE DATABASE portafolioexamen;

-- USAMOS LA BASE DE DATOS --
USE portafolioexamen;

-- CREAMOS LA 1ER TABLA --
CREATE TABLE piezasportafolio(
	titulo VARCHAR(100),
	descripcion VARCHAR(255),
	fecha VARCHAR(50),
	id_categoria INT
);

-- INSERTAMOS EL IDENTIFICADOR EN LA TABLA --
ALTER TABLE piezasportafolio
ADD COLUMN identificador INT AUTO_INCREMENT PRIMARY KEY FIRST;

-- DESCRIBIMOS LA TABLA --
DESCRIBE piezasportafolio;
+---------------+--------------+------+-----+---------+----------------+
| Field         | Type         | Null | Key | Default | Extra          |
+---------------+--------------+------+-----+---------+----------------+
| identificador | int          | NO   | PRI | NULL    | auto_increment |
| titulo        | varchar(100) | YES  |     | NULL    |                |
| descripcion   | varchar(255) | YES  |     | NULL    |                |
| fecha         | varchar(50)  | YES  |     | NULL    |                |
| id_categoria  | int          | YES  |     | NULL    |                |
+---------------+--------------+------+-----+---------+----------------+

-- CREAMOS LA 2DA TABLA --
CREATE TABLE categoriasportafolio(
	nombre VARCHAR(100)
);

-- INSERTAMOS EL IDENTIFICADOR EN LA TABLA --
ALTER TABLE categoriasportafolio
ADD COLUMN identificador INT AUTO_INCREMENT PRIMARY KEY FIRST;

-- DESCRIBIMOS LA TABLA --
DESCRIBE categoriasportafolio;
+---------------+--------------+------+-----+---------+----------------+
| Field         | Type         | Null | Key | Default | Extra          |
+---------------+--------------+------+-----+---------+----------------+
| identificador | int          | NO   | PRI | NULL    | auto_increment |
| nombre        | varchar(100) | YES  |     | NULL    |                |
+---------------+--------------+------+-----+---------+----------------+

-- CONECTAMOS LAS TABLAS --
ALTER TABLE piezasportafolio
ADD CONSTRAINT fk_piezas_categorias
FOREIGN KEY (id_categoria) REFERENCES categoriasportafolio(identificador)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- INSERTAMOS --
INSERT INTO categoriasportafolio VALUES(
	NULL,
	'PRUEBA'
);

INSERT INTO piezasportafolio VALUES(
	NULL,
	'PRUEBA',
	'PROBANDO',
	'2025-11-10',
	1
);

-- VERIFICAMOS QUE SE INSERTÓ CORRECTAMENTE --
SELECT * FROM categoriasportafolio;
+---------------+--------+
| identificador | nombre |
+---------------+--------+
|             1 | PRUEBA |
+---------------+--------+

SELECT * FROM piezasportafolio;
+---------------+--------+-------------+------------+--------------+
| identificador | titulo | descripcion | fecha      | id_categoria |
+---------------+--------+-------------+------------+--------------+
|             2 | PRUEBA | PROBANDO    | 2025-11-10 |            1 |
+---------------+--------+-------------+------------+--------------+

-- ACTUALIZAMOS LOS DATOS --
UPDATE categoriasportafolio
SET nombre = "TEST"
WHERE identificador = 1;

UPDATE piezasportafolio
SET titulo = "TEST"
WHERE identificador = 2;

-- VERIFICAMOS QUE SE ACTUALIZARON LOS DATOS --
SELECT * FROM categoriasportafolio;
+---------------+--------+
| identificador | nombre |
+---------------+--------+
|             1 | TEST   |
+---------------+--------+

SELECT * FROM piezasportafolio;
+---------------+--------+-------------+------------+--------------+
| identificador | titulo | descripcion | fecha      | id_categoria |
+---------------+--------+-------------+------------+--------------+
|             2 | TEST   | PROBANDO    | 2025-11-10 |            1 |
+---------------+--------+-------------+------------+--------------+

-- ELIMINAMOS DATOS --
DELETE FROM categoriasportafolio
WHERE identificador = 1;

DELETE FROM piezasportafolio
WHERE identificador = 2;

-- VERIFICAMOS QUE SE BORRO CORRECTAMENTE --
SELECT * FROM categoriasportafolio;
Empty set (0,00 sec)

SELECT * FROM piezasportafolio;
Empty set (0,00 sec)

-- CREAMOS UNA VISTA CRUZADA --
CREATE VIEW vista_portafolio AS 
SELECT 
piezasportafolio.titulo,
piezasportafolio.descripcion,
piezasportafolio.fecha,
categoriasportafolio.nombre
FROM piezasportafolio
LEFT JOIN categoriasportafolio
ON piezasportafolio.id_categoria = categoriasportafolio.identificador;

-- VERIFICAMOS QUE LA VISTA CRUZADA SE CREO CORRECTAMENTE --
SELECT * FROM vista_portafolio;
Empty set (0,00 sec) -- ME SALE ESO YA QUE PREVIAMENTE ELIMINAMOS LOS DATOS DE AMBAS TABLAS --

-- DESCRIBIMOS LA TABLA --
DESCRIBE vista_portafolio;
+-------------+--------------+------+-----+---------+-------+
| Field       | Type         | Null | Key | Default | Extra |
+-------------+--------------+------+-----+---------+-------+
| titulo      | varchar(100) | YES  |     | NULL    |       |
| descripcion | varchar(255) | YES  |     | NULL    |       |
| fecha       | varchar(50)  | YES  |     | NULL    |       |
| nombre      | varchar(100) | YES  |     | NULL    |       |
+-------------+--------------+------+-----+---------+-------+

-- AÑADIMOS OTRA VEZ LOS DATOS PARA COMPROBAR LA TABLA --
INSERT INTO categoriasportafolio VALUES(
	NULL,
	'PRUEBA'
);

INSERT INTO piezasportafolio VALUES(
	NULL,
	'PRUEBA',
	'PROBANDO',
	'2025-11-10',
	1
);

-- ME SALE ESTE ERROR Y VERIFICAMOS QUE LA FK FUNCIONA CORRECTAMENTE, EL ERROR ES CAUSADO POR EL id_categoria PUSE 1 PERO TENGO QUE PONER 2 --
ERROR 1452 (23000): Cannot add or update a child row: a foreign key constraint fails (`portafolioexamen`.`piezasportafolio`, CONSTRAINT `fk_piezas_categorias` FOREIGN KEY (`id_categoria`) REFERENCES `categoriasportafolio` (`identificador`) ON DELETE CASCADE ON UPDATE CASCADE)

-- CORREGIMOS EL INSERT --
INSERT INTO piezasportafolio VALUES(
	NULL,
	'PRUEBA',
	'PROBANDO',
	'2025-11-10',
	2
);

-- MOSTRAMOS LA TABLA DE LA VISTA CRUZADA --
SELECT * FROM vista_portafolio;
+--------+-------------+------------+--------+
| titulo | descripcion | fecha      | nombre |
+--------+-------------+------------+--------+
| PRUEBA | PROBANDO    | 2025-11-10 | PRUEBA |
+--------+-------------+------------+--------+

-- CREAMOS UN USUARIO --

CREATE USER 
'trimestral'@'localhost' 
IDENTIFIED  BY 'Portafolio123@';

-- PERMITE ACCESO A ESE USUARIO --
GRANT USAGE ON *.* TO 'trimestral'@'localhost';

-- QUITAMOS TODOS LOS LIMITES QUE TENGA --
ALTER USER 'trimestral'@'localhost'
REQUIRE NONE 
WITH MAX_QUERIES_PER_HOUR 0 
MAX_CONNECTIONS_PER_HOUR 0 
MAX_UPDATES_PER_HOUR 0 
MAX_USER_CONNECTIONS 0;

-- LE DAMOS ACCESO A LA BASE DE DATOS --
GRANT ALL PRIVILEGES ON `portafolioexamen`.* 
TO 'trimestral'@'localhost';

-- RECARGAMOS LOS PRIVILEGIOS --
FLUSH PRIVILEGES;
