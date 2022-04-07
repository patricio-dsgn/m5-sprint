# Módulo 5 sprint - v4
# Código está comentar debidamente para que sea comprensible.


# SCRIPT SQL - - - - -
# 1) crea la estructura de la base de datos
# 2) realiza operaciones en la base de datos (p. ej. rellenarla con datos)
# 3) cambia o eliminar la estructura de la base de datos

# CREACION ESQUEMA Y SELECCIÓN - - - - -
CREATE SCHEMA db1;
USE db1;

# CREACION USUARIO - - - - -
# con privilegios para:
# - crear
# - eliminar y modificar tablas
# - insertar registros
CREATE USER 'admin_tlv'@'localhost' IDENTIFIED BY '1234';
GRANT ALL ON db1.* TO 'admin_tlv'@'localhost';


# CREACION TABLAS - - - - -

# clientes (solo 5 para):
# - nombre
# - apellido
# - dirección (solo pueden ingresar una)
CREATE TABLE db1.cliente (
	idCliente INT NOT NULL,
	nombre VARCHAR(45) NOT NULL,
	apellido VARCHAR(45) NOT NULL,
	dirección VARCHAR(45) NOT NULL,
	PRIMARY KEY (idCliente));

INSERT INTO db1.cliente (idCliente, nombre, apellido, dirección) 
VALUES  ('1', 'Juán', 'Pérez', 'Calle camarón 123'),
		('2', 'Pedro ', 'Casas', 'Calle Langosta 234'),
		('3', 'Julia', 'Meza', 'Calle Jaiba 345'),
		('4', 'Marcia', 'Blanco', 'Calle Almeja 456'),
		('5', 'Luís', 'Plaza', 'Calle Ostión 567'),
		('6', 'Pablo', 'Mármol', 'Calle Centolla 678'),
		('7', 'Bilma', 'López', 'Calle Locos 789');

# Proveedor (5 proveedores):
# - nombre del representante legal
# - su nombre corporativo
# - al menos dos teléfonos de contacto (y el nombre de quien recibe las llamadas),
# - la categoría de sus productos (solo nos pueden indicar una categoría)
# - correo electrónico para enviar la factura
CREATE TABLE db1.proveedor (
	idProveedor INT NOT NULL,
	categoria VARCHAR(15) NOT NULL,
	representante_legal VARCHAR(45) NOT NULL,
	nombre_corporativo VARCHAR(45) NOT NULL,
	telefono1 VARCHAR(12) NOT NULL,
	telefono1_contacto VARCHAR(45) NOT NULL,
	telefono2 VARCHAR(12) NOT NULL,
	telefono2_contacto VARCHAR(45) NOT NULL,
	telefono3 VARCHAR(12) NULL,
	telefono3_contacto VARCHAR(45) NULL,
	email_factura VARCHAR(45) NOT NULL,
	PRIMARY KEY (idProveedor));
  
INSERT INTO db1.proveedor (idProveedor, categoria, representante_legal, nombre_corporativo, telefono1, telefono1_contacto, telefono2, telefono2_contacto, telefono3, telefono3_contacto, email_factura)
VALUES  ('1', 'Audio', 'Mr. Poo','Caca Corp.', '956987423', 'Eric Cartman', '956987423', 'Kyle Broflovski', NULL, NULL, 'hola@caca.com'),
		('2', 'Audiovisual', 'Milla Jovovich', 'Umbrela Corp.', '954786325', 'Michelle Rodríguez', '954786325', 'Heike Makatsch', NULL, NULL, 'hola@umbrela.com'),
		('3', 'Cocina', 'Remy', 'Ratatouille SA.', '954129856', 'Mustafá', '954129856', 'Alfredo Linguini', '954129856', 'Larousse', 'hola@rata.com'),
		('4', 'Computación', 'Richard Hendricks', 'Tesla SA.', '952367458', 'Erlich Bachman', '952367458', 'Bertram Gilfoyle', '952367458', 'Dinesh Chugtai', 'hola@tesla.com'),
		('5', 'Computación', 'Theodore Miller Edison', 'Edison SA.', '954128569', 'Marion', '954128569', 'Thomas jr.', '954128569', 'William', 'hola@edi.com');


# Productos (10 productos):
# - stock
# - precio
# - categoría
# - proveedor
# - color
# nota: Los productos pueden tener muchos proveedores. 
CREATE TABLE db1.producto (
	idProducto INT NOT NULL,
	nombre_producto VARCHAR(75) NOT NULL,
	precio INT NOT NULL,
	categoria VARCHAR(45) NOT NULL,
	color VARCHAR(45) NULL,
	stock INT NOT NULL,
	fk_idproveedor INT NOT NULL,
	PRIMARY KEY (idProducto),
	INDEX idProveedor_idx (fk_idproveedor ASC) VISIBLE,
	CONSTRAINT idProveedor
	FOREIGN KEY (fk_idproveedor)
	REFERENCES db1.proveedor (idProveedor));
	-- ON DELETE CASCADE
-- 	ON UPDATE CASCADE);
  
  INSERT INTO db1.producto (idProducto, precio, fk_idproveedor, categoria, color, stock, nombre_producto)
  VALUES ('1', '18000', '1', 'Audio', 'Negro', '6', 'Audifonos'),
		 ('2', '32000', '1', 'Audio', 'Negro', '1', 'Microfono'),
 		 ('3', '85000', '3', 'Cocina', 'Blanco', '7', 'Microondas'),
		 ('4', '18000', '3', 'Cocina', 'Rojo', '2', 'Hervidor'),
		 ('5', '150000', '2', 'Audiovisual', 'Blanco', '14', 'Televisor'),
		 ('6', '80000', '4', 'Computación', 'Blanco', '10', 'Mouse'),
		 ('7', '150000', '1', 'Audio', 'Azul', '2', 'Parlantes'),
		 ('8', '25000', '4', 'Computación', 'Azul', '10', 'Teclado'),
		 ('9', '89000', '5', 'Computación', 'Rojo', '14', 'Impresora'),
		 ('10', '55000', '2', 'Audiovisual', 'Negro', '20', 'Soundbar');
  



# CONSULTAS SQL - - - - -

#1) La categoría de productos que más se repite
SELECT categoria, count(categoria) as "Productos por categoría" from producto
group by categoria
having count(*)= 2;
(SELECT count(categoria) from producto
group by categoria
order by categoria asc
limit 1);




#2) Los productos con mayor stock
SELECT nombre_producto as "Producto con mayor Stock", stock
FROM producto
WHERE(stock = (SELECT max(stock) FROM producto));            
 
 

#3) Color de producto que es más común en nuestra tienda

SELECT color, count(color) AS "Color mas común" FROM producto
GROUP BY color
HAVING count(*)=
(SELECT tabla_temp.col_aux FROM  
(SELECT COUNT(color) AS col_aux , color
FROM producto
GROUP BY color
ORDER BY count(color) DESC LIMIT 1)tabla_temp);



#4) Los proveedores con menor stock de productos

# suma los stocks de cada proveedor
# encuentra el numero menor
# lo guarda en una variable
SET @num = (SELECT min(Stock_Total) FROM
(Select nombre_corporativo, sum(stock) as Stock_Total
from producto, proveedor
where fk_idproveedor = idproveedor  
group by fk_idproveedor 
order by sum(stock))tabla_temp2);

# suma los stocks de cada proveedor
# los compara con en numero menor ya buscado
SELECT * FROM
(Select nombre_corporativo, sum(stock) as "Stock_Total" 
from producto, proveedor
where fk_idproveedor = idproveedor  
group by fk_idproveedor 
order by sum(stock))tabla_temp2 WHERE Stock_Total = @num;






-- pendiente ----------------------
# CAMBIO - - - - -
# la categoría de productos más popular por 'Electrónica y computación'

Select categoria, sum(stock) as "Stock Total" 
from producto
group by categoria 
order by "Stock Total"  asc;




