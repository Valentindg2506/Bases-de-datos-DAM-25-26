## INSERTAR DATOS EN LA TABLA ##
-- Create
INSERT INTO clientes VALUES(
	"12345678A",
	"Valentin",
	"De Gennaro",
	"valentindegennaro@gmail.com"
);

SELECT * FROM clientes;

--Update
UPDATE clientes
SET dni = "11111111A"
WHERE nombre = "Valentin";

UPDATE clientes
SET apellidos = "DeGennaro"
WHERE nombre = "Valentin";

--Delete

DELETE FROM clientes
WHERE dni = "11111111A";

	
