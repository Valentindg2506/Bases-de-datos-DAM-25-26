# Importamos libreria #
import sqlite3

# Nos conectamos a la base de datos #
conexion = sqlite3.connect("empresa.db")

# Creamos un cursor #
cursor = conexion.cursor()


# Ejecutamos una sentencia #
cursor.execute('''
	INSERT INTO clientes VALUES(
		NULL,'Jorge','Garcia Lopez','jorge@jocarsa.com'
	);
''')

# Lanzamos la peticion #
conexion.commit()
