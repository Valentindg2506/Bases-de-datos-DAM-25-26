-- sudo mysql -u root -p

USE clientes;

SELECT
nombre,
apellidos,
edad,
edad < 30 AS '¿Es menor de 30 años?'
FROM clientes;

