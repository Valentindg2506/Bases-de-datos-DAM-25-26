En este proyecto realizamos un tracker de series y peliculas, es una aplicación web diseñada para llevar un control personal de las peliculas y series que consumes. Permite a los usuarios registrarse y organizar series y películas en listas personalizadas según su estado (viendo, vistas, pendientes).

---

Para relizar este proyecto usamos una base de datos con 2 tablas:
	- Una para usuarios, va a ser la que se encargue de guardar los datos de cada usuario, que se registre en la aplicación. Almacenando su nombre, usuario, correo y contraseña.
	- Otra para contenido, es donde se va a almacenar todas las peliculas y series que el usuario agregue, almacenando el titulo de la pelicula o serie, el tipo (pelicula o serie), el estado (por_ver, viendo, vista), la puntuación, el comentario, la fecha de visualización y el nivel de prioridad (alta, baja, media).

---

A continuación el paso a paso de la base de datos:

- Primero debemos crear la base de datos:
```
	CREATE DATABASE AdminViews;
```
- Luego crearemos la primera tabla `usuario`:
```
	CREATE TABLE usuario (
		id INT AUTO_INCREMENT PRIMARY KEY,  ## IDENTIFICADOR UNICO QUE SE AUTOINCREMENTA ##
		nombre VARCHAR(255),
		usuario VARCHAR(255),
		correo VARCHAR(255),
		contrasena VARCHAR(255) ## LA CONTRASEÑA SE GUARDA HASHEADA (proceso que lo hace el registro de la app) ##
	);
```
- Luego usando un `ALTER TABLE` vamos a agregar un campo de token a la tabla `usuario`, que nos va a permitir validar el usuario a la hora de querer cambiar la contraseña:
```
	ALTER TABLE usuario ADD token VARCHAR(255) NULL;
```
- Despues vamos a crear la tabla de `contenido`:
```
	CREATE TABLE contenido (
		id INT AUTO_INCREMENT PRIMARY KEY, ## IDENTIFICADOR UNICO QUE SE AUTOINCREMENTA ##
		usuario_id INT,  ## FK --> VINCULA EL CONTENIDO CON EL USUARIO ##
		titulo VARCHAR(255),
		tipo ENUM('pelicula', 'serie'), ## SOLO PERMITE ESOS DOS VALORES ##
		## ENUM --> Es una lista cerrada de opciones, se obliga a que el dato sea uno de los definidos ##
		estado ENUM('Por_ver', 'Viendo', 'Vistas') NOT NULL DEFAULT 'Por_ver',  ## SE INDICA QUE por_ver SEA EL ESTADO POR DEFECTO ##
		puntuacion VARCHAR(255),
		comentario VARCHAR(255),
		fecha_visualizacion VARCHAR(255),
		nivel_prioridad ENUM('Alta', 'Media', 'Baja') NOT NULL DEFAULT 'Media', ## SE INDICA QUE media SEA EL VALOR POR DEFECTO ##
		
		## EVITA QUE SE CREE CONTENIDO PARA UN USUARIO INEXISTENTE ##
		CONSTRAINT fk_contenido_1 FOREIGN KEY (usuario_id) REFERENCES usuario(id)
	);
```
- Luego usando un `ALTER TABLE` vamos a agregar otro campo a la tabla `contenido`:
```
	ALTER TABLE contenido 
	ADD COLUMN imagen_url VARCHAR(255) NULL; ## LE PERMITE A LA API GUARDAR LA IMAGEN DE CADA PELICULA Y / O SERIE ##
```
- Y por ultimo tenemos que crear el usuario, darle acceso a la base de datos, sacarle las restricciones y recargar privilegios:
```
	CREATE USER 
	'AdminViews'@'localhost' 
	IDENTIFIED  BY 'AdminViews123$';

	## LE DAMOS ACCESO AL USUARIO ##
	GRANT USAGE ON *.* TO 'AdminViews'@'localhost';

	## LE SACAMOS LAS RESTRICCIONES ##
	ALTER USER 'AdminViews'@'localhost' 
	REQUIRE NONE 
	WITH MAX_QUERIES_PER_HOUR 0 
	MAX_CONNECTIONS_PER_HOUR 0 
	MAX_UPDATES_PER_HOUR 0 
	MAX_USER_CONNECTIONS 0;

	## LE DAMOS ACCESO A LA BD ##
	GRANT ALL PRIVILEGES ON AdminViews.* 
	TO 'AdminViews'@'localhost';

	## RECARGAMOS PRIVILEGIOS ##
	FLUSH PRIVILEGES
```

---

**AdminPanel**
Una vez que ya conoces la base de datos veremos como la aplicacion le pide o agrega o elimina contenido de la base de datos:
- Vamos a empezar por el `AdminPanel` el cual debe pedir datos a la base de datos para poder mostrarle al administrador la información de la aplicación y que pueda actualizar o eliminar datos. A continuacion el codigo y su explicación:

	- Mostrar la cantidad de usuarios: En el panel de administrador se muestra la cantidad total de usuario que hay registrados en la aplicación y para eso se debe pedir información a la base de datos usando un `SELECT` para que seleccione la información y un `COUNT` para que los cuente, para eso vamos a usar `PHP`. A continuación el codigo:
	```
		$sqlUsers = "SELECT COUNT(*) as total FROM usuario";
	```
	- Mostrar la cantidad de peliculas y series: Es similar a mostrar la cantidad de usuario pero cambiando la tabla de la que se saca la información, pero como contenido es una sola tabla debemos indicarle el `tipo` que es el que se encarga de separar entre peliculas y series en la `base de datos`:
	```
		$sqlSeries = "SELECT COUNT(*) as total FROM contenido WHERE tipo = 'serie'";
		$sqlPelis = "SELECT COUNT(*) as total FROM contenido WHERE tipo = 'pelicula'";
	```
	- Mostrar la cantidad de viendo, vistas y por ver: Tambien se muetra la cantidad de series o peliculas que hay por_ver, viendo y vistas, tambien usando un `SELECT`:
	```
		$sqlChart = "SELECT estado, COUNT(*) as cantidad FROM contenido GROUP BY estado";
	```
	- Top 10 de peliculas mas vistas: El admin puede ver un top 10 de las peliculas mas vistas y para que la base de datos muestre esa información vamos a usar un `SELECT` para que seleccione la información, un `COUNT` para que cuente la cantidad, un `WHERE` para indicarle un campo de la tabla en especifico de donde tiene que sacar la información, un `GROUP BY` para indicarle que campo quiero que tome de esos datos, un `ORDER BY` para indicarle el orden en el que quiero que este la información, en este caso descendiente `DESC`, y un `LIMIT 10` para indicarle que solo quiero 10, le pongo un limite.
	```
		$sqlTopSeries = "SELECT titulo, COUNT(*) as total FROM contenido WHERE tipo = 'pelicula' AND estado = 'Vistas' GROUP BY titulo 
		ORDER BY total DESC LIMIT 10";
	```
	- Top 10 de series de series mas vistas: Es exactamente igual que en peliculas pero cambiando el `tipo` cambiamos de pelicula a serie:
	```
		$sqlTopSeries = "SELECT titulo, COUNT(*) as total FROM contenido WHERE tipo = 'pelicula' AND estado = 'Vistas' GROUP BY titulo 
		ORDER BY total DESC LIMIT 10";
	```
	- Luego tenemos una seccion en la que mostramos todas las peliculas: Para ello es un `SELECT` indicandole el `tipo` que en este caso es pelicula:
	```
		$sql = "SELECT * FROM contenido WHERE tipo = 'pelicula'";
	```
	- Luego tenemos otra sección en la que se muestran todas las series: Es similar al de peliculas pero cambiando el `tipo` de pelicula a serie:
	```
		$sql = "SELECT * FROM contenido WHERE tipo = 'serie'";
	```
	- Y por ultimo el admin tiene una opcion para ver en detalle los usuario que hay registrados en la aplicación y para eos es un `SELECT`:
	```
		$sql = "SELECT * FROM usuario";
	```
**Front**
- En el `front` tenemos una carpeta `controladores` en la que se guardan los archios que se encargan de procesar información:
	
	- Guardar contenido: Se encarga de recibir los datos y  meterlos en la base de datos usando un `INSERT`:
	```
		$sql = "INSERT INTO contenido (usuario_id, titulo, comentario, estado, tipo, nivel_prioridad, imagen_url) 
		VALUES (?, ?, ?, ?, ?, ?, ?)";
	```
	- Login_procesa: Se encarga como le nombre lo indica de procesar el login de la aplicación y para ello necesita validar que los datos que introduce el usuario coincidan con los que hay en la basde de datos y para eso usamos un `SELECT` para obtener esos datos:
	```
		$sql = "SELECT id, usuario, contrasena FROM usuario WHERE usuario = ?";
	```
	- Registro_procesa: Se encarga como el nombre lo indica de procesar el registro y para ello primero debemeos pedirle a la base de datos con un `SELECT` los datos de usuario para verificar que el usuario que se va a crear no exista ya en la base de datos y luego un `INSERT` para meter los datos del usuario ya creado en la base de datos:
	```
		$sql_check = "SELECT * FROM usuario WHERE usuario = '$usuario_seguro'";
		$sql = "INSERT INTO usuario (usuario, contrasena, nombre, correo) VALUES (?, ?, ?, ?)";
	```
- Tambien en el `front` tenemos una pantalla en la que se muestran las peliculas y otra en la que se muestran las series, es un `CRUD` en las que usamos `UPDATE` para actualizar la información de un contenido en el caso que el usuario quiera, un `DELETE` para poder borrar un contenido, `SELECT` para mostrar la información, `INSERT` para agregar las peliculas o series y tenemos la opción de ordenar las peliculas por orden alfabetico, por nivel de prioridad o por fecha de creación y para eso usamos `ORDER`. A continuación los codigos:
**Peliculas**
```
	"UPDATE contenido SET estado='Vistas', fecha_visualizacion=?, puntuacion=? WHERE id=?"
	"DELETE FROM contenido WHERE id=?"
	"INSERT INTO contenido (usuario_id, titulo, comentario, estado, tipo, nivel_prioridad, imagen_url) VALUES (?, ?, ?, ?, ?, ?, ?)";
	"SELECT * FROM contenido WHERE tipo = 'pelicula' AND usuario_id = ? $sql_order";
	"ORDER BY id DESC"
	"ORDER BY titulo ASC"
	"ORDER BY FIELD(nivel_prioridad, 'Alta', 'Media', 'Baja')"
```
**Series**
```
	"UPDATE contenido SET estado='Vistas', fecha_visualizacion=?, puntuacion=? WHERE id=?"
	"DELETE FROM contenido WHERE id=?"
	"INSERT INTO contenido (usuario_id, titulo, comentario, estado, tipo, nivel_prioridad, imagen_url) VALUES (?, ?, ?, ?, ?, ?, ?)";
	"SELECT * FROM contenido WHERE tipo = 'serie' AND usuario_id = ? $sql_order";
	"ORDER BY id DESC"
	"ORDER BY titulo ASC"
	"ORDER BY FIELD(nivel_prioridad, 'Alta', 'Media', 'Baja')"
```

---

**NOTAS:**
- El uso de `tipo` en la tabla de `contenido` nos permite crear una sola tabla para todo el contenido y no necesitar una para peliculas y otra para series.
- Usamos `ENUM` para definir las opciones permitidas, y no permitir una diferente.	
