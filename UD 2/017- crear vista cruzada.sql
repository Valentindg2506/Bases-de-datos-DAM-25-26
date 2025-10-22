CREATE VIEW personas_correo AS
SELECT
emails.direccion,
personas.nombre,
personas.apellidos
FROM emails
LEFT JOIN personas
ON emails.persona = personas.Identificador;


SELECT * FROM personas_correo;



