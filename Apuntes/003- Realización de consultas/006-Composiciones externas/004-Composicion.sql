SELECT
*
FROM Matriculas
LEFT JOIN Asignaturas
ON Matriculas.id_asignatura = Asignaturas.Identificador

