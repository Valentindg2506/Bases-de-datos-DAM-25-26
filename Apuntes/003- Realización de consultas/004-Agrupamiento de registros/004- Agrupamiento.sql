SELECT COUNT(color)
FROM PRODUCTOS; --- RESUMEN

SELECT COUNT(color),color
FROM productos
GROUP BY color;
