CREATE TABLE "clientes" (
	"Identificador"	INTEGER,
	"Nombre"	TEXT,
	"Apellidos"	TEXT,
	"Email"	TEXT,
	PRIMARY KEY("Identificador" AUTOINCREMENT)
);
---------------------------------------------------
 CREATE TABLE "productos" (
	"Identificador"	INTEGER,
	"Nombre"	TEXT,
	"Descripción"	TEXT,
	"Precio"	TEXT,
	PRIMARY KEY("Identificador" AUTOINCREMENT)
);
---------------------------------------------------
INSERT INTO clientes VALUES(
	NULL,
	"Valentin",
	"De Gennaro",
	"valentindegennaro@gmail.com"
);
---------------------------------------------------
SELECT * FROM clientes

