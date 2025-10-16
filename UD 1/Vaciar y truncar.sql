DELETE FROM clientes; ## BORRA PERO RECUERDA ##

INSERT INTO clientes VALUES(
	NULL,
	'12345678a',
	'Valentin Antonio',
	'De Gennaro',
	'valentindegennaro@gmail.com'
);

SELECT * FROM clientes;

TRUNCATE TABLE clientes; ## EMPEZAR DE 0 SE BORRA TODO Y NO SE ACUERDA DE NADA ##

DROP TABLE clientes; ## *CUIDADO* BORRA LA TABLA ## 
