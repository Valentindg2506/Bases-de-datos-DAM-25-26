SELECT COUNT(color)
FROM PRODUCTOS; --- RESUMEN

SELECT
COUNT(color) AS Numero,
color
FROM productos
GROUP BY color
ORDER BY COUNT(color) ASC;

+--------+--------------+
| Numero | color        |
+--------+--------------+
|      1 | Morado       |
|      1 | Transparente |
|      2 | Beige        |
|      2 | Negro        |
|      3 | Rojo         |
|      3 | Naranja      |
|      3 | Dorado       |
|      3 | Azul         |
|      4 | Verde        |
|      4 | Marrón       |
|      5 | Amarillo     |
|      7 | Rosa         |
|     12 | Blanco       |
+--------+--------------+

