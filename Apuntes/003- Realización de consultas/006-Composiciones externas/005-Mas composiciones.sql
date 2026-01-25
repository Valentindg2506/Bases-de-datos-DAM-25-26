SELECT
*
FROM Matriculas
LEFT JOIN Asignaturas
ON Matriculas.id_asignatura = Asignaturas.Identificador
LEFT JOIN Alumnos
ON Matriculas.id_alumno = Alumnos.Identificador;
