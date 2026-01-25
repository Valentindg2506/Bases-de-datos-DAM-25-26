En este ejercicio vamos a practicar el uso de los operadores aritméticos en consultas SQL, lo cual es fundamental para realizar cálculos directos sobre los datos almacenados.

---

Para realizar este ejercicio primero vamos a utilizar el operador de suma `+` para proyectar la edad aumentada en 500 años:
```
	SELECT nombre, apellidos, edad+500 FROM clientes;
```
Luego vamos a utilizar el operador de resta `-` para reducir la edad en 500 años:
```
	SELECT nombre, apellidos, edad-500 FROM clientes;
```
Después vamos a aplicar el operador de multiplicación `*` para multiplicar la edad por 500:
```
	SELECT nombre, apellidos, edad*500 FROM clientes;
```
Y por último vamos a utilizar el operador de división `/` para dividir la edad entre 500:
```
	SELECT nombre, apellidos, edad/500 FROM clientes;
```

---


A continuación el código completo:
```
	'''
		Práctica de operadores aritméticos SQL
		v0.1 Valentin Antonio De Gennaro
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
```

---

**NOTAS:**
- Los operadores aritméticos permiten manipular los datos numéricos directamente en la proyección sin alterar los datos originales de la tabla.
- Es útil para realizar reportes, proyecciones futuras o ajustes temporales de datos.
