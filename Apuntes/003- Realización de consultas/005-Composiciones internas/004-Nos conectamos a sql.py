import mysql.connector

conexion = mysql.connector.connect(
  host="localhost",
  user="tienda",
  password="Tiendaclase123$",
  database="tienda"
)                                      
  
cursor = conexion.cursor() 
cursor.execute("SELECT * FROM clientes;")  

filas = cursor.fetchall()

print(filas)
