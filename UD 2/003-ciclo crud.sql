--create--
INSERT INTO clientes VALUES(
	NULL,
	"Valentin",
	"De Gennaro",
	"valentindegennaro@gmail.com"
);
--read--
SELECT * FROM clientes;
--update--
UPDATE clientes
SET email = 'valentindegennaro@icloud.com'
WHERE Identificador = 1;
--delete--
DELETE clientes
WHERE Identificador = 1;

