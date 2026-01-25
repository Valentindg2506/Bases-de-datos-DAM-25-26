import mysql.connector 
from flask import Flask
import json

conexion = mysql.connector.connect(
  host="localhost",
  user="tienda",
  password="Tiendaclase123$",
  database="tienda"
)                                      
app = Flask(__name__)

@app.route("/clientes")
# http://127.0.0.1:5000/clientes
def clientes():
	cursor = conexion.cursor() 
	cursor.execute("SELECT * FROM clientes;")  

	filas = cursor.fetchall()
	return json.dumps(filas)

@app.route("/tablas")
# http://127.0.0.1:5000/tablas
def tablas():
	cursor = conexion.cursor() 
	cursor.execute("SHOW TABLES;")  

	filas = cursor.fetchall()
	tablas = []
	for fila in filas:
		tablas.append(fila[0])
	return json.dumps(tablas)


if __name__ == "__main__":
	app.run(debug=True) 
    
