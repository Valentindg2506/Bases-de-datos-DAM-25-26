sudo mysql -u root -p

--- CREO UNA BASE DE DATOS ---
CREATE DATABASE ejemploclaves;

--- USO LA BASE DE DATOS ---
USE ejemploclaves;

--- CREO TABLAS PERSONAS ---
CREATE TABLE personas (
	Nombre VARCHAR(50),
	Apellidos VARCHAR (255)
);

--- AÑADO UN IDENTIFICADOR ---
ALTER TABLE personas
ADD COLUMN identificador INT AUTO_INCREMENT PRIMARY KEY FIRST;

SHOW TABLES;
