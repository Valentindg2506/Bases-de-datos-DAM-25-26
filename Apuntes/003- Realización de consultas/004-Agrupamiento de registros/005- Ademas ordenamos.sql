SELECT COUNT(color)
FROM PRODUCTOS; --- RESUMEN

SELECT COUNT(color),color
FROM productos
GROUP BY color
ORDER BY COUNT(color) ASC;
+--------------+--------------+
| COUNT(color) | color        |
+--------------+--------------+
|            1 | Morado       |
|            1 | Transparente |
|            2 | Beige        |
|            2 | Negro        |
|            3 | Rojo         |
|            3 | Naranja      |
|            3 | Dorado       |
|            3 | Azul         |
|            4 | Verde        |
|            4 | Marrón       |
|            5 | Amarillo     |
|            7 | Rosa         |
|           12 | Blanco       |
+--------------+--------------+
SELECT COUNT(color),color
FROM productos
GROUP BY color
ORDER BY color ASC;
+--------------+--------------+
| COUNT(color) | color        |
+--------------+--------------+
|            5 | Amarillo     |
|            3 | Azul         |
|            2 | Beige        |
|           12 | Blanco       |
|            3 | Dorado       |
|            4 | Marrón       |
|            1 | Morado       |
|            3 | Naranja      |
|            2 | Negro        |
|            3 | Rojo         |
|            7 | Rosa         |
|            1 | Transparente |
|            4 | Verde        |
+--------------+--------------+

