En este ejercicio vamos a practicar y dominar los conceptos fundamentales de proyección, selección y ordenación de registros en bases de datos.

---

Para realizar este ejercicio primero vamos a aprender a seleccionar solo las columnas que nos interesan, técnica conocida como proyección. Por ejemplo, para obtener nombre y apellidos:
```
	SELECT nombre, apellidos FROM clientes;
```
Luego vamos a utilizar la selección para filtrar registros en función de condiciones, como por ejemplo filtrar clientes mayores de 18 años:
```
	SELECT * FROM clientes WHERE edad > 18;
```
Después vamos a aprender a ordenar los resultados de forma ascendente o descendente. Si queremos los clientes ordenados por edad de mayor a menor:
```
	SELECT nombre, apellidos, edad FROM clientes ORDER BY edad DESC;
```
Y por último vamos a combinar estos conceptos para resolver un problema más complejo, seleccionando nombre y apellidos de mayores de 18 años y ordenándolos por edad:
```
	SELECT nombre, apellidos FROM clientes WHERE edad > 18 ORDER BY edad ASC;
```

---

A continuación el código completo:
```
	'''
		Práctica de consultas SQL
		v0.1 Valentin Antonio De Gennaro
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
```

---

**NOTAS:**
- Es importante probar con diferentes tablas y condiciones para entender completamente el funcionamiento.
- El objetivo es seleccionar datos de manera eficiente y ordenarlos según necesidad.
