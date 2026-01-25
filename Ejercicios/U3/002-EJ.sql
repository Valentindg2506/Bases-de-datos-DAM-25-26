'''
	Práctica de operadores aritméticos SQL
	v0.1 Asistente
	Suma, resta, multiplicación y división de datos numéricos.
'''

-- SUMA: AUMENTAR EDAD EN 500 --
SELECT nombre, apellidos, edad+500 FROM clientes;

-- RESTA: REDUCIR EDAD EN 500 --
SELECT nombre, apellidos, edad-500 FROM clientes;

-- MULTIPLICACIÓN: MULTIPLICAR EDAD POR 500 --
SELECT nombre, apellidos, edad*500 FROM clientes;

-- DIVISIÓN: DIVIDIR EDAD ENTRE 500 --
SELECT nombre, apellidos, edad/500 FROM clientes;
