Iniciamos sesion en MySQL
```
	sudo mysql -u root -p
```

Creo la base de datos
```
	CREATE DATABASE blog2;
```

Mostramos las bases de datos
```
	SHOW DATABASES;
```

La seleccionamos
```
	USE blog2;
```

Creamos la tabla

```
## OPCION 1 ##
	CREATE TABLE autores(
		identificador INT(10),
		nombre VARCHAR(100),
		apellidos VARCHAR(100),
		email VARCHAR(100)
	);
## OPCION 2 ##
		CREATE TABLE autores(
		identificador INT AUTO_INCREMENT,
		nombre VARCHAR(100),
		apellidos VARCHAR(100),
		email VARCHAR(100),
		PRIMARY KEY (identificador)
```

Mostramos las tablas
``
	SHOW TABLES;
```

eliminar la columna identificador
``
	ALTER TABLE autores DROP identificador;
```

Creo una columna y le pongo clave primaria
```
	ALTER TABLE autores
	ADD COLUMN identificador INT AUTO_INCREMENT PRIMARY KEY FIRST;
```

Vemos que hicimos:
```
	DESCRIBE autores;
```

Insertamos un autor de prueba:
```
	INSERT INTO autores VALUES(
		NULL,
		"Pepe",
		"Gomez",
		"pepe@gmail.com"
	);
```

Me aseguro:
```
 SELECT * FROM autores;
```

Creo la tabla entradas:
```
	CREATE TABLE entradas(
		identificador INT AUTO_INCREMENT,
		titulo VARCHAR(100),
		fecha VARCHAR(100),
		imagen VARCHAR(100),
		id_autor VARCHAR(100),
		contenido TEXT,
		PRIMARY KEY (identificador)
	);
```

Comprobamos que se creo correctamente:
```
	SHOW TABLES;
```

Describimos:
```
	DESCRIBE entradas;
```

Creamos una foreign key:
```
	ALTER TABLE entradas 
	ADD CONSTRAINT autores_a_entradas 
	FOREIGN KEY (id_autor) REFERENCES autores(identificador)
	ON DELETE CASCADE 
	ON UPDATE CASCADE;
```

Cambiamos el tipo de datos
``
	ALTER TABLE entradas 
	MODIFY COLUMN id_autor INT;
```

Insertamos una entrada de prueba:
```
	INSERT INTO entradas VALUES(
		NULL,
		"Titulo",
		"2025-03-11",
		"Imagen.jpg",
		1,
		"Este es el contenido de la primera entrada"
	);
```

Mostramos el contenido
``
	SELECT * FROM entradas;
```

Peticion cruzada
```
CREATE VIEW vista_entradas AS
SELECT
entradas.titulo,entradas.fecha,entradas.imagen,entradas.contenido
autores.nombre,autores.apellidos
FROM entradas
LEFT JOIN autores
ON entradas.id_autor = autores.Identificador;
```

