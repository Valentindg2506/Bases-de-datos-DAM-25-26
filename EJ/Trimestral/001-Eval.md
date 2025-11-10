En este ejercicio vamos a crear una base de datos para un portafolio, el cual va a contener dos tablas para almacenar información, una para las piezas y otra para las categorias. Tambien creamos un usuario y le dimos acceso a esta base de datos, y creamos una vista cruzada para ver todos los datos en una sola tabla.

---

Para hacer este ejercicio primero debemos acceder a MySql:
```
	sudo mysql -u root -p
```
Luego debemos crear y acceder a esa base de datos:
```
	CREATE DATABASE portafolioexamen;
	USE portafolioexamen;
```
Seguido de eso comenzamos con la primer tabla:
```
	CREATE TABLE piezasportafolio(
		titulo VARCHAR(100),
		descripcion VARCHAR(255),
		fecha VARCHAR(50),
		id_categoria INT
	);
```
Y le insertamos un identificador como clave primaria:
```
	ALTER TABLE piezasportafolio
	ADD COLUMN identificador INT AUTO_INCREMENT PRIMARY KEY FIRST;
```
Luego creamos la segunda tabla:
```
CREATE TABLE categoriasportafolio(
	nombre VARCHAR(100)
);
```
Y tambien le insertamos un identificador como clave primaria:
```
	ALTER TABLE categoriasportafolio
	ADD COLUMN identificador INT AUTO_INCREMENT PRIMARY KEY FIRST;
```
Luego creamos la clave foranea:
```
	ALTER TABLE piezasportafolio
	ADD CONSTRAINT fk_piezas_categorias
	FOREIGN KEY (id_categoria) REFERENCES categoriasportafolio(identificador)
	ON DELETE CASCADE
	ON UPDATE CASCADE;
```
Describimos las tablas para verificar que se crearon correctamente:
```
DESCRIBE categoriasportafolio;
+---------------+--------------+------+-----+---------+----------------+
| Field         | Type         | Null | Key | Default | Extra          |
+---------------+--------------+------+-----+---------+----------------+
| identificador | int          | NO   | PRI | NULL    | auto_increment |
| nombre        | varchar(100) | YES  |     | NULL    |                |
+---------------+--------------+------+-----+---------+----------------+

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
```
Ahora les insertamos datos de prueba:
```
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
```
Y verificamos que esos datos se insertaron correctamente:
```
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
```
Una vez verificado que se añadieron vamos a actualizar los datos:
```
UPDATE categoriasportafolio
SET nombre = "TEST"
WHERE identificador = 1;

UPDATE piezasportafolio
SET titulo = "TEST"
WHERE identificador = 2;
```
Y volvemos a verificar, para confirmar que se actualizaron correctamente:
```
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
```
Y para completar el ciclo CRUD vamos a eliminar datos:
```
DELETE FROM categoriasportafolio
WHERE identificador = 1;

DELETE FROM piezasportafolio
WHERE identificador = 2;
```
Y volvemos a verificar:
```
SELECT * FROM categoriasportafolio;
Empty set (0,00 sec)

SELECT * FROM piezasportafolio;
Empty set (0,00 sec)
```
**El empty set significa que la tabla esta vacia**
Ahora creamos una vista cruzada entre ambas tablas:
```
CREATE VIEW vista_portafolio AS 
SELECT 
piezasportafolio.titulo,
piezasportafolio.descripcion,
piezasportafolio.fecha,
categoriasportafolio.nombre
FROM piezasportafolio
LEFT JOIN categoriasportafolio
ON piezasportafolio.id_categoria = categoriasportafolio.identificador;
```
Y verificamos que se creo correctamente:
```
SELECT * FROM vista_portafolio;
Empty set (0,00 sec)
```
**Y nos sale el empty set ya que previamente borramos los datos de ambas tablas por lo cual vamos a volver a insertar datos**
Volvemos a insertar datos:
```
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
```
**Y nos sale un error**
```
ERROR 1452 (23000): Cannot add or update a child row: a foreign key constraint fails (`portafolioexamen`.`piezasportafolio`, CONSTRAINT `fk_piezas_categorias` FOREIGN KEY (`id_categoria`) REFERENCES `categoriasportafolio` (`identificador`) ON DELETE CASCADE ON UPDATE CASCADE)
```
**Este error muestra que la clave foranea funciona correctamente, y sale porque al intentar insertar en `piezasportafolio` en `id_categoria` puse el numero 1 y como borre la información y puse nueva el `identificador ahora es el 2.**
Y insertamos correctamente:
```
INSERT INTO categoriasportafolio VALUES(
	NULL,
	'PRUEBA'
);
INSERT INTO piezasportafolio VALUES(
	NULL,
	'PRUEBA',
	'PROBANDO',
	'2025-11-10',
	2
);
```
Y mostramos la vista cruzada:
```
SELECT * FROM vista_portafolio;
+--------+-------------+------------+--------+
| titulo | descripcion | fecha      | nombre |
+--------+-------------+------------+--------+
| PRUEBA | PROBANDO    | 2025-11-10 | PRUEBA |
+--------+-------------+------------+--------+
```
Y por ultimo creamos un usuario, le damos acceso y privilegios en esta base de datos:
```
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
```

---

A continuación el registro completo:
```
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
```

---

**NOTAS:**
- Al usar Mysql hay que recordar poner siempre al final de cada comando el `;`.
- Luego de crear cada tabla o vista cruzada o fk o pk es recomendable verificar que funcione correctamente.
- Al crear el usuario hay que recordar darle acceso a la base de datos y darle privilegios.

---

**CONCLUSIÓN:**
Es util usar fk y pk para conectar las tablas entre si y poder prevenir errores, y la vista cruzada es al go util ya que te permite ver información de ambnas tablas en una sola.
