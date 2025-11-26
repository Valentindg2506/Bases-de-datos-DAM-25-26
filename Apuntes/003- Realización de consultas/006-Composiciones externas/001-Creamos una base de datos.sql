sudo mysql -u root -p

SHOW DATABASES;

CREATE DATABASE composiciones;

USE composiciones;

CREATE TABLE Alumnos(
	Identificador INT PRIMARY KEY,
	Nombre VARCHAR (100),
	Apellidos VARCHAR (100)
);

CREATE TABLE Profesores(
	Identificador INT PRIMARY KEY,
	Nombre VARCHAR (100),
	Apellidos VARCHAR (100)
);

CREATE TABLE Asignaturas(
	Identificador INT PRIMARY KEY,
	Nombre VARCHAR (100),
	id_profesor INT
);

CREATE TABLE Matriculas(
	Identificador INT PRIMARY KEY,
	id_asignatura INT,
	id_alumno INT
);

SHOW TABLES;
+-------------------------+
| Tables_in_composiciones |
+-------------------------+
| Alumnos                 |
| Asignaturas             |
| Matriculas              |
| Profesores              |
+-------------------------+

