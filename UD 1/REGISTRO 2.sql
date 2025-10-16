sudo mysql -u root -p

SHOW DATABASES;

USE empresadam;

SHOW TABLES;

DESCRIBE clientes;

SELECT * FROM clientes;

INSERT INTO productos VALUES(
	NULL,
	'Avion',
	'Proyectil',
	'2000',
	'5'
);


## VERIFICA QUE LOS EMAIL ESTEN BIEN ##
ALTER TABLE clientes
	ADD CONSTRAINT chk_email_format
	CHECK (email REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$');
	
## AL ESTAR NO DEJA AGREGAR EMAILS QUE ESTEN MAL ##
ERROR 3819 (HY000): Check constraint 'chk_email_format' is violated.
## Y DA ESE ERROR ##


DELETE FROM clientes WHERE identificador = 4;


## COMPROBAR DNI Y NIE ##
ALTER TABLE clientes
  ADD CONSTRAINT chk_dni_nie_valido
  CHECK (
    -- Formatos válidos
    (
      dninie REGEXP '^[0-9]{8}[A-Z]$' OR
      dninie REGEXP '^[XYZ][0-9]{7}[A-Z]$'
    )
    AND
    -- Cálculo de la letra por módulo 23: TRWAGMYFPDXBNJZSQVHLCKE
    SUBSTRING('TRWAGMYFPDXBNJZSQVHLCKE',
      (
        CASE
          WHEN dninie REGEXP '^[0-9]{8}[A-Z]$'
            THEN (CAST(SUBSTRING(dninie,1,8) AS UNSIGNED) MOD 23) + 1
          ELSE
            (
              -- NIE: mapear X/Y/Z→0/1/2 y concatenar con los 7 dígitos
              (CAST(CONCAT(
                CASE SUBSTRING(dninie,1,1)
                  WHEN 'X' THEN '0'
                  WHEN 'Y' THEN '1'
                  WHEN 'Z' THEN '2'
                END,
                SUBSTRING(dninie,2,7)
              ) AS UNSIGNED) MOD 23) + 1
            )
        END
      ),
      1
    ) = SUBSTRING(dninie, -1)
  );
## COMPROBAR DNI Y NIE ##

DELETE FROM clientes;  ## BORRA TODA LA TABLA ##

SELECT * FROM clientes;

INSERT INTO clientes VALUES(
	NULL,
	'12345678a',
	'Valentin Antonio',
	'De Gennaro',
	'valentindegennaro@gmail.com'
);

## SE PUEDE MODIFICAR LA ESTRUCTURA DE LA TABLA ##

DESCRIBE clientes;
# AGREGAR UNA COLUMNA #
ALTER TABLE clientes
ADD COLUMN direccion VARCHAR(255);

# ELIMINAR UNA COLUMNA #
ALTER TABLE clientes
DROP COLUMN direccion;

# CAMBIAR EL NOMBRE DE LA COLUMNA #
ALTER TABLE clientes
RENAME COLUMN dni to dninie;

# ELIMINO UNA RESTRICCION #
ALTER TABLE clientes
DROP CONSTRAINT chk_dni_nie_valido;

## COPIA DE SEGURIDAD ##




