--- PASO 1 CAMBIAR EL TIPO DE COLUMNA ---
ALTER TABLE emails
MODIFY COLUMN persona INT;

--PASO 2 CREAR LA FOREIGN KEY ---
ALTER TABLE emails
ADD CONSTRAINT fk_emails_personas
FOREIGN KEY (persona) REFERENCES personas(identificador)
ON DELETE CASCADE
ON UPDATE CASCADE;

+---------------------------------------------NOTAS---------------------------------------------------------+
| ALTER TABLE emails                                             ALTERAR LA TABLA DE EMAILS			        |
| ADD CONSTRAINT fk_emails_personas						         CREAMOS UNA RESTRICCION CON ESTE NOMBRE    |
| FOREIGN KEY (persona)										     CREAMOS UNA CLAVE HACIA PERSONAS           |
| REFERENCES personas(identificador)						     QUE REFERENCIA EL IDENTIFICADOR            |
| ON DELETE CASCADE												 CUANDO ELIMINES, CASCADA                   |
| ON UPDATE CASCADE;										     CUANDO ACTUALICES, CASCADA                 |
+-----------------------------------------------------------------------------------------------------------+

SHOW TABLES;


