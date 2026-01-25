<!doctype html>
<html lang="es">
	<head>
		<title>Valentin de Gennaro</title>
		<meta charset="utf-8">
		<style>
			body,html{
				margin:0px;
				padding:0px;
				width:100%;
				height:100%;
			}
			body{
				display:flex;
				justify-content:center;
				align-items:center;
				background:orangered;
			}
			form{
				display:flex;
				flex-direction:column;
				width:400px;
				height:400px;
				background:white;
				padding:20px;
				align-items:center;
				justify-content:center;
				gap:10px;
			}
			input{
				width:100%;
				padding:10px;
				box-sizing:border-box;
				border:1px solid lightgray;
			}
		</style>
	</head>
	<body>
		<main>
			<!-- 
				Es importante que el formulario tenga los mismos campos
				que la base de datos
				Es decir: se debe mantener el modelo de datos
			-->
			<form action="002-Procesa.php" method="POST">
				<h2>Rellena la información</h2>
				<input type="text" name="nombre" placeholder="nombre">
				<input type="text" name="puesto" placeholder="puesto">
				<input type="text" name="salario" placeholder="salario">
				<input type="text" name="fecha_contratacion" placeholder="fecha_contratacion">
				<input type="text" name="departamento" placeholder="departamento">
				<input type="submit">
			</form>
		</main>
	</body>
</html>
