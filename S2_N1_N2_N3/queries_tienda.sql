DESCRIBE producto;
--- 1 ---
SELECT DISTINCT nombre FROM producto;
--- 2 ---
SELECT nombre, precio FROM producto;
--- 3 ---
DESCRIBE producto;
--- 4 ---
SELECT nombre, ROUND (precio,2) 'precio EUR', ROUND (precio*1.08,2) 'precio USD' FROM producto;
--- 5 ---
SELECT nombre, ROUND (precio,2) AS euros, ROUND (precio*1.08,2) AS dòlars FROM producto;
--- 6 ---
SELECT UPPER (nombre), ROUND (precio,2) AS euros, ROUND (precio*1.08,2) AS dòlars FROM producto;
--- 7 ---
SELECT LOWER (nombre), ROUND (precio,2) AS euros, ROUND (precio*1.08,2) AS dòlars FROM producto;
--- 8 ---
SELECT nombre, SUBSTRING(UPPER(nombre),1,2) AS abreviatura FROM fabricante;
-- select nombre, left(nombre,2) from producto;
--- 9 ---
SELECT nombre, ROUND(precio, 0) FROM producto;
--- 10 ---
SELECT nombre, TRUNCATE(precio, 0) FROM producto;
--- 11 ---
SELECT codigo_fabricante FROM producto;
--- 12 ---
SELECT DISTINCT codigo_fabricante FROM producto;
--- 13 ---
SELECT nombre FROM fabricante ORDER BY nombre;
--- 14 ---
SELECT nombre FROM fabricante ORDER BY nombre DESC;
--- 15 ---
SELECT nombre, precio FROM producto ORDER BY nombre, precio DESC;
--- 16 ---
SELECT * FROM fabricante LIMIT 5;
--- 17 ---
SELECT * FROM fabricante LIMIT 2 OFFSET 3;
-- select * from fabricante limit 3,2;
--- 18 ---
SELECT nombre, precio FROM producto ORDER BY precio LIMIT 1 ;
--- 19 ---
SELECT nombre, precio FROM producto ORDER BY precio DESC LIMIT 1 ;
--- 20 ---
SELECT nombre FROM producto WHERE codigo_fabricante=2;
--- 21 ---
SELECT P.nombre, P.precio, F.nombre FROM producto P LEFT JOIN fabricante F ON P.codigo_fabricante= F.codigo;
--- 22 ---
SELECT P.nombre, P.precio, F.nombre FROM producto P LEFT JOIN fabricante F ON P.codigo_fabricante= F.codigo ORDER BY F.nombre;
--- 23 ---
SELECT P.codigo, P.nombre, F.codigo, F.nombre FROM producto P LEFT JOIN fabricante F ON P.codigo_fabricante= F.codigo;
--- 24 ---
SELECT P.nombre, P.precio, F.nombre 
FROM producto P LEFT JOIN fabricante F 
ON P.codigo_fabricante = F.codigo
ORDER BY P.precio
LIMIT 1;
--- 25 ---
SELECT P.nombre, P.precio, F.nombre 
FROM producto P LEFT JOIN fabricante F 
ON P.codigo_fabricante = F.codigo
ORDER BY P.precio DESC
LIMIT 1;
--- 26 ---
SELECT P.nombre, F.nombre FROM producto P LEFT JOIN fabricante F
ON (P.codigo_fabricante = F.codigo)
WHERE F.nombre LIKE "%lenovo%";
--- 27 ---
SELECT P.nombre, F.nombre FROM producto P LEFT JOIN fabricante F
ON (P.codigo_fabricante = F.codigo)
WHERE F.nombre LIKE "%crucial%"
AND P.precio > 200;
--- 28 ---
SELECT P.nombre, F.nombre FROM producto P LEFT JOIN fabricante F
ON (P.codigo_fabricante = F.codigo)
WHERE F.nombre LIKE "%asus%" 
OR F.nombre LIKE "%hewlett_packard%"
OR F.nombre LIKE "%seagate%";
--- 29 ---
SELECT P.nombre, F.nombre FROM producto P LEFT JOIN fabricante F
ON (P.codigo_fabricante = F.codigo)
WHERE F.nombre IN ('asus', 'hewlett-packard', 'seagate');
--- 30 ---
SELECT P.nombre, P.precio FROM producto P LEFT JOIN fabricante F
ON (P.codigo_fabricante = F.codigo)
WHERE F.nombre LIKE "%e";
--- 31 ---
SELECT P.nombre, P.precio FROM producto P LEFT JOIN fabricante F
ON (P.codigo_fabricante = F.codigo)
WHERE F.nombre LIKE "%w%";
--- 32 ---
SELECT P.nombre, P.precio, F.nombre FROM producto P LEFT JOIN fabricante F
ON (P.codigo_fabricante = F.codigo)
WHERE P.precio >= 180
ORDER BY P.precio DESC, P.nombre;
--- 33 ---
SELECT DISTINCT F.codigo, F.nombre FROM  fabricante F LEFT JOIN producto P
ON (F.codigo = P.codigo_fabricante)
WHERE P.codigo IS NOT NULL;
--- 34 ---
SELECT F.nombre, P.nombre FROM fabricante F LEFT JOIN producto P
ON (F.codigo = P.codigo_fabricante);
--- 35 ---
SELECT F.nombre as 'Fabricante sin producto' FROM fabricante F LEFT JOIN producto P
ON (F.codigo = P.codigo_fabricante)
WHERE P.nombre IS NULL;
--- 36 ---
SELECT P.nombre FROM producto P
WHERE P.codigo_fabricante IN 
(SELECT F.codigo FROM fabricante F WHERE F.nombre LIKE "Lenovo");

SELECT P.nombre FROM producto P
WHERE P.codigo_fabricante =
(SELECT F.codigo FROM fabricante F WHERE F.nombre LIKE "Lenovo");
--- 37 ---
SELECT P.codigo, P.nombre, P.precio, P.codigo_fabricante 
FROM producto P LEFT JOIN fabricante F 
ON (P.codigo_fabricante = F.codigo) 
WHERE P.precio = (SELECT MAX(P.precio) FROM producto P LEFT JOIN fabricante F 
				ON P.codigo_fabricante = F.codigo 
                WHERE F.nombre = 'Lenovo');  
--- 38 ---
SELECT P.nombre, P.precio, F.nombre FROM producto P INNER JOIN fabricante F
ON (P.codigo_fabricante = F.codigo)
WHERE F.nombre LIKE "Lenovo"
ORDER BY P.precio DESC
LIMIT 1;

SELECT P.nombre FROM producto P JOIN fabricante F
ON (P.codigo_fabricante = F.codigo) 
WHERE p.precio = 
				(SELECT MAX(P.precio) FROM producto P JOIN fabricante F 
                ON P.codigo_fabricante = F.codigo
                WHERE f.nombre = 'Lenovo'); 
--- 39 ---
SELECT P.nombre, P.precio, F.nombre FROM producto P INNER JOIN fabricante F
ON (P.codigo_fabricante = F.codigo)
WHERE F.nombre LIKE "Hewlett-packard"
ORDER BY P.precio
LIMIT 1;

SELECT P.nombre, P.precio, F.nombre FROM producto P INNER JOIN fabricante F
ON (P.codigo_fabricante = F.codigo)
WHERE P.precio = 
				(SELECT MIN(P.precio) FROM producto P INNER JOIN fabricante F
                ON (P.codigo_fabricante = F.codigo)
                WHERE F.nombre LIKE "Hewlett-packard");
--- 40 ---
SELECT P.nombre, P.precio, F.nombre FROM producto P LEFT JOIN fabricante F
ON (P.codigo_fabricante = F.codigo)
WHERE P.precio >=
				(SELECT MAX(P.precio) FROM producto P LEFT JOIN fabricante F
                ON (P.codigo_fabricante = F.codigo)
                WHERE F.nombre LIKE "Lenovo");
--- 41 ---
SELECT P.nombre, P.precio, F.nombre FROM producto P INNER JOIN fabricante F
ON (P.codigo_fabricante = F.codigo)
WHERE F.nombre LIKE 'Asus'
AND P.precio > (
				SELECT AVG(P.precio) FROM producto P INNER JOIN fabricante F
				ON (P.codigo_fabricante = F.codigo)
				WHERE F.nombre LIKE 'Asus');