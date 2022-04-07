Select nombre_corporativo, sum(stock) as "Stock Total" 
from producto, proveedor
where fk_idproveedor = idproveedor  
group by fk_idproveedor 
order by "Stock Total"  ASC;

SELECT idproveedor FROM proveedor WHERE idproveedor = 
(SELECT fk_idproveedor FROM producto WHERE stock = 68);

SELECT tablacaca.columna FROM (SELECT fk_idproveedor, sum(stock) AS columna from producto
GROUP BY fk_idproveedor)tablacaca
ORDER BY columna
LIMIT 1;

SELECT fk_idproveedor, sum(stock) FROM producto
GROUP BY fk_idproveedor;

Select fk_idproveedor, sum(stock) as "Stock Total"  from producto  
group by fk_idproveedor 
having count(*)=
(SELECT count(fk_idproveedor) from producto
group by fk_idproveedor
order by fk_idproveedor desc
limit 1 ) ;

SELECT idproveedor FROM proveedor WHERE idproveedor = 
(SELECT fk_idproveedor FROM producto WHERE stock = 14)
HAVING count(sotck)= (SELECT tablacaca.columna FROM (SELECT fk_idproveedor, sum(stock) AS columna from producto
GROUP BY fk_idproveedor)tablacaca
ORDER BY columna
LIMIT 1);

(SELECT count(stock) from producto
group by stock
order by stock
limit 1);

#ORDER BY stock ASC LIMIT 1;

