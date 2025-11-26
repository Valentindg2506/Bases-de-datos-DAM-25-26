SELECT
Asignaturas.Nombre AS 'Nombre de la asignatura',
Alumnos.Nombre AS 'Nombre del alumno',
Alumnos.Apellidos AS 'Apellidos del alumno'
FROM Matriculas
LEFT JOIN Asignaturas
ON Matriculas.id_asignatura = Asignaturas.Identificador
LEFT JOIN Alumnos
ON Matriculas.id_alumno = Alumnos.Identificador;
