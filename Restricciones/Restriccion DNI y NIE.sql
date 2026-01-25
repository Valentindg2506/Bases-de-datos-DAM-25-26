ALTER TABLE clientes
  ADD CONSTRAINT chk_dni_nie_valido
  CHECK (
    -- Formatos válidos
    (
      dni REGEXP '^[0-9]{8}[A-Z]$' OR
      dni REGEXP '^[XYZ][0-9]{7}[A-Z]$'
    )
    AND
    -- Cálculo de la letra por módulo 23: TRWAGMYFPDXBNJZSQVHLCKE
    SUBSTRING('TRWAGMYFPDXBNJZSQVHLCKE',
      (
        CASE
          WHEN dni REGEXP '^[0-9]{8}[A-Z]$'
            THEN (CAST(SUBSTRING(dni,1,8) AS UNSIGNED) MOD 23) + 1
          ELSE
            (
              -- NIE: mapear X/Y/Z→0/1/2 y concatenar con los 7 dígitos
              (CAST(CONCAT(
                CASE SUBSTRING(dni,1,1)
                  WHEN 'X' THEN '0'
                  WHEN 'Y' THEN '1'
                  WHEN 'Z' THEN '2'
                END,
                SUBSTRING(dni,2,7)
              ) AS UNSIGNED) MOD 23) + 1
            )
        END
      ),
      1
    ) = SUBSTRING(dni, -1)
  );
