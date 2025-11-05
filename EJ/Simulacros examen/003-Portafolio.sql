sudo mysql -u root -p

CREATE DATABASE portafolio;

SHOW DATABASES;

USE portafolio;

CREATE TABLE pieza(
	titulo VARCHAR(100),
	descripcion VARCHAR(255),
	imagen VARCHAR(100),
	url VARCHAR(100),
	id_categoria INT
);

ALTER TABLE pieza
ADD COLUMN identificador INT AUTO_INCREMENT PRIMARY KEY FIRST;

SHOW TABLES;
+----------------------+
| Tables_in_portafolio |
+----------------------+
| pieza                |
+----------------------+

DESCRIBE pieza;
+---------------+--------------+------+-----+---------+----------------+
| Field         | Type         | Null | Key | Default | Extra          |
+---------------+--------------+------+-----+---------+----------------+
| identificador | int          | NO   | PRI | NULL    | auto_increment |
| titulo        | varchar(100) | YES  |     | NULL    |                |
| descripcion   | varchar(255) | YES  |     | NULL    |                |
| imagen        | varchar(100) | YES  |     | NULL    |                |
| url           | varchar(100) | YES  |     | NULL    |                |
| id_categoria  | int          | YES  |     | NULL    |                |
+---------------+--------------+------+-----+---------+----------------+


CREATE TABLE categoria(
	titulo VARCHAR(100),
	descripcion VARCHAR(255)
);

ALTER TABLE categoria
ADD COLUMN identificador INT AUTO_INCREMENT PRIMARY KEY FIRST;

SHOW TABLES;
+----------------------+
| Tables_in_portafolio |
+----------------------+
| categoria            |
| pieza                |
+----------------------+

DESCRIBE categoria;
+---------------+--------------+------+-----+---------+----------------+
| Field         | Type         | Null | Key | Default | Extra          |
+---------------+--------------+------+-----+---------+----------------+
| identificador | int          | NO   | PRI | NULL    | auto_increment |
| titulo        | varchar(100) | YES  |     | NULL    |                |
| descripcion   | varchar(255) | YES  |     | NULL    |                |
+---------------+--------------+------+-----+---------+----------------+

ALTER TABLE pieza 
	ADD CONSTRAINT pieza_a_categoria 
	FOREIGN KEY (id_categoria) REFERENCES categoria(identificador)
	ON DELETE CASCADE 
	ON UPDATE CASCADE;

	
CREATE VIEW vista_portafolio AS 
SELECT 
pieza.titulo AS titulo_pieza,
pieza.descripcion AS descripcion_pieza,
pieza.imagen,
pieza.url,
categoria.titulo AS titulo_categoria,
categoria.descripcion AS descripcion_categoria
FROM pieza
LEFT JOIN categoria
ON pieza.id_categoria = categoria.identificador;

DESCRIBE vista_portafolio;
+-----------------------+--------------+------+-----+---------+-------+
| Field                 | Type         | Null | Key | Default | Extra |
+-----------------------+--------------+------+-----+---------+-------+
| titulo_pieza          | varchar(100) | YES  |     | NULL    |       |
| descripcion_pieza     | varchar(255) | YES  |     | NULL    |       |
| imagen                | varchar(100) | YES  |     | NULL    |       |
| url                   | varchar(100) | YES  |     | NULL    |       |
| titulo_categoria      | varchar(100) | YES  |     | NULL    |       |
| descripcion_categoria | varchar(255) | YES  |     | NULL    |       |
+-----------------------+--------------+------+-----+---------+-------+

-------------------- INSERTAMOS DATOS EN LA TABLA PIEZA ---------------------

INSERT INTO pieza VALUES (NULL, "Escultura", "Mármol", "escultura1.jpg", "https://arte1.com", 2);
INSERT INTO pieza VALUES (NULL, "Retrato", "Óleo", "retrato1.jpg", "https://arte2.com", 3);
INSERT INTO pieza VALUES (NULL, "Fotografía", "Blanco y negro", "foto1.jpg", "https://arte3.com", 4);
INSERT INTO pieza VALUES (NULL, "Paisaje", "Acrílico", "paisaje1.jpg", "https://arte4.com", 1);
INSERT INTO pieza VALUES (NULL, "Boceto", "Grafito", "boceto1.jpg", "https://arte5.com", 2);
INSERT INTO pieza VALUES (NULL, "Mural", "Colorido", "mural1.jpg", "https://arte6.com", 3);
INSERT INTO pieza VALUES (NULL, "Collage", "Mixto", "collage1.jpg", "https://arte7.com", 4);
INSERT INTO pieza VALUES (NULL, "Grabado", "Metal", "grabado1.jpg", "https://arte8.com", 1);
INSERT INTO pieza VALUES (NULL, "Escultura", "Bronce", "escultura2.jpg", "https://arte9.com", 2);
INSERT INTO pieza VALUES (NULL, "Lienzo", "Abstracto", "lienzo1.jpg", "https://arte10.com", 3);

-------------------- INSERTAMOS DATOS EN LA TABLA CATEGORIA ---------------------

INSERT INTO categoria VALUES (NULL, "Escultura", "Obras tridimensionales talladas o moldeadas");
INSERT INTO categoria VALUES (NULL, "Fotografía", "Imágenes capturadas a través de cámaras");
INSERT INTO categoria VALUES (NULL, "Dibujo", "Representaciones gráficas hechas a mano");
INSERT INTO categoria VALUES (NULL, "Pintura", "Obras creadas con pigmentos y pinceles");
INSERT INTO categoria VALUES (NULL, "Grabado", "Diseños obtenidos mediante impresión sobre metal o madera");
INSERT INTO categoria VALUES (NULL, "Mural", "Pinturas o composiciones aplicadas directamente sobre muros");
INSERT INTO categoria VALUES (NULL, "Collage", "Composición artística a partir de materiales variados");
INSERT INTO categoria VALUES (NULL, "Arte digital", "Creaciones generadas o manipuladas mediante software");
INSERT INTO categoria VALUES (NULL, "Arte abstracto", "Obras que buscan expresar ideas sin representar figuras reales");
INSERT INTO categoria VALUES (NULL, "Arte contemporáneo", "Manifestaciones artísticas actuales e innovadoras");

SELECT * FROM categoria;
+---------------+---------------------+----------------------------------------------------------------+
| identificador | titulo              | descripcion                                                    |
+---------------+---------------------+----------------------------------------------------------------+
|             2 | Escultura           | Obras tridimensionales talladas o moldeadas                    |
|             3 | Fotografía          | Imágenes capturadas a través de cámaras                        |
|             4 | Dibujo              | Representaciones gráficas hechas a mano                        |
|             5 | Pintura             | Obras creadas con pigmentos y pinceles                         |
|             6 | Grabado             | Diseños obtenidos mediante impresión sobre metal o madera      |
|             7 | Mural               | Pinturas o composiciones aplicadas directamente sobre muros    |
|             8 | Collage             | Composición artística a partir de materiales variados          |
|             9 | Arte digital        | Creaciones generadas o manipuladas mediante software           |
|            10 | Arte abstracto      | Obras que buscan expresar ideas sin representar figuras reales |
|            11 | Arte contemporáneo  | Manifestaciones artísticas actuales e innovadoras              |
+---------------+---------------------+----------------------------------------------------------------+

SELECT * FROM pieza;
+---------------+-------------+----------------+----------------+--------------------+--------------+
| identificador | titulo      | descripcion    | imagen         | url                | id_categoria |
+---------------+-------------+----------------+----------------+--------------------+--------------+
|             9 | Escultura   | Mármol         | escultura1.jpg | https://arte1.com  |            2 |
|            10 | Retrato     | Óleo           | retrato1.jpg   | https://arte2.com  |            3 |
|            11 | Fotografía  | Blanco y negro | foto1.jpg      | https://arte3.com  |            4 |
|            13 | Boceto      | Grafito        | boceto1.jpg    | https://arte5.com  |            2 |
|            14 | Mural       | Colorido       | mural1.jpg     | https://arte6.com  |            3 |
|            15 | Collage     | Mixto          | collage1.jpg   | https://arte7.com  |            4 |
|            17 | Escultura   | Bronce         | escultura2.jpg | https://arte9.com  |            2 |
|            18 | Lienzo      | Abstracto      | lienzo1.jpg    | https://arte10.com |            3 |
+---------------+-------------+----------------+----------------+--------------------+--------------+

SELECT * FROM vista_portafolio;
+--------------+-------------------+----------------+--------------------+------------------+---------------------------------------------+
| titulo_pieza | descripcion_pieza | imagen         | url                | titulo_categoria | descripcion_categoria                       |
+--------------+-------------------+----------------+--------------------+------------------+---------------------------------------------+
| Escultura    | Mármol            | escultura1.jpg | https://arte1.com  | Escultura        | Obras tridimensionales talladas o moldeadas |
| Retrato      | Óleo              | retrato1.jpg   | https://arte2.com  | Fotografía       | Imágenes capturadas a través de cámaras     |
| Fotografía   | Blanco y negro    | foto1.jpg      | https://arte3.com  | Dibujo           | Representaciones gráficas hechas a mano     |
| Boceto       | Grafito           | boceto1.jpg    | https://arte5.com  | Escultura        | Obras tridimensionales talladas o moldeadas |
| Mural        | Colorido          | mural1.jpg     | https://arte6.com  | Fotografía       | Imágenes capturadas a través de cámaras     |
| Collage      | Mixto             | collage1.jpg   | https://arte7.com  | Dibujo           | Representaciones gráficas hechas a mano     |
| Escultura    | Bronce            | escultura2.jpg | https://arte9.com  | Escultura        | Obras tridimensionales talladas o moldeadas |
| Lienzo       | Abstracto         | lienzo1.jpg    | https://arte10.com | Fotografía       | Imágenes capturadas a través de cámaras     |
+--------------+-------------------+----------------+--------------------+------------------+---------------------------------------------+




