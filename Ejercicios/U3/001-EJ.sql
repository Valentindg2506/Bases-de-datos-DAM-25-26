'''
	Práctica de consultas SQL
	v0.1 Asistente
	Proyección, selección y ordenación de datos.
'''

-- PROYECCIÓN: SELECCIONAR SOLO COLUMNAS ESPECIFICAS --
SELECT nombre, apellidos FROM clientes;

-- SELECCIÓN: FILTRAR REGISTROS POR CONDICIÓN --
SELECT * FROM clientes WHERE edad > 18;

-- ORDENACIÓN: ORDENAR RESULTADOS DESCENDENTE --
SELECT nombre, apellidos, edad FROM clientes ORDER BY edad DESC;

-- APLICACIÓN PRÁCTICA: COMBINACIÓN DE CONCEPTOS --
SELECT nombre, apellidos FROM clientes WHERE edad > 18 ORDER BY edad ASC;
