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
		 ('5', '150000', '2', 'Audiovisual', 'Blanco', '8', 'Televisor'),
		 ('6', '80000', '4', 'Computación', 'Blanco', '32', 'Mouse'),
		 ('7', '150000', '1', 'Audio', 'Azul', '2', 'Parlantes'),
		 ('8', '25000', '4', 'Computación', 'Azul', '68', 'Teclado'),
		 ('9', '89000', '5', 'Computación', 'Rojo', '14', 'Impresora'),
		 ('10', '55000', '2', 'Audiovisual', 'Negro', '18', 'Soundbar');
  

CREATE TABLE db1.historial_de_compra (
	idcompra INT NOT NULL,
	fechacompra DATE NOT NULL,
	saldo INT NULL,
	valor INT NOT NULL,
	fk_idcliente INT NOT NULL,
	fk_idproducto INT NOT NULL,
	PRIMARY KEY (idcompra),
	INDEX idproducto_idx (fk_idproducto ASC) VISIBLE,
	INDEX idcliente_idx (fk_idcliente ASC) VISIBLE,
	CONSTRAINT idproducto
	FOREIGN KEY (fk_idproducto)
	REFERENCES db1.producto (idProducto),
	#ON DELETE CASCADE
	#ON UPDATE CASCADE,
	CONSTRAINT idcliente
	FOREIGN KEY (fk_idcliente)
	REFERENCES db1.cliente (idCliente)
	#ON DELETE CASCADE
	#ON UPDATE CASCADE
    );



# CONSULTAS SQL - - - - -

#1) La categoría de productos que más se repite
SELECT categoria, count(categoria) as "Productos por categoría" from producto
group by categoria
having count(*)= 2;
(SELECT count(categoria) from producto
group by categoria
order by categoria asc
limit 1);

-- SELECT categoria, count(*) AS total FROM producto
-- GROUP BY categoria
-- ORDER BY total DESC LIMIT 1;

-- #ORDER BY total DESC LIMIT 1;
-- #SELECT * FROM clientes WHERE (TotalPagado = (SELECT MAX(TotalPagado) FROM clientes)); 
 



-- ok
#2) Los productos con mayor stock
SELECT nombre_producto as "Producto con mayor Stock", stock
FROM producto
WHERE(stock = (SELECT max(stock) FROM producto));            

-- SELECT categoria, count(categoria) as "Productos por categoría" from producto
-- group by categoria
-- HAVING count(*)=
-- (SELECT count(categoria) from producto
-- group by categoria
-- order by categoria desc
-- limit 1);
    
 

#3) Color de producto que es más común en nuestra tienda

SELECT color, count(color) AS "Color mas común" FROM producto
GROUP BY color
HAVING count(*)=
(SELECT tabla_temp.col_aux FROM  
(SELECT COUNT(color) AS col_aux , color
FROM producto
GROUP BY color
ORDER BY count(color) DESC LIMIT 1)tabla_temp);

-- SELECT * FROM clientes WHERE (TotalPagado = (SELECT MAX(TotalPagado) FROM clientes));
-- #ORDER BY "Color mas común" DESC LIMIT 1;



#4) Los proveedores con menor stock de productos
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















# CAMBIO - - - - -
# la categoría de productos más popular por ‘Electrónica y computación’


SELECT * FROM producto LEFT JOIN proveedor ON producto.fk_idproveedor = proveedor.idproveedor;














#Entregable:
	#diagrama entidad relación sólo con la información que tenemos. 
    # construir un script a partir del diagrama que cree tablas de acuerdo a las entidades e ingrese datos. 
    #En caso de tener nuevas ideas respecto a futura información requerida y nuevas entidades, 
		#solo nos piden que la indiquemos en un archivo .docx. 
	# Deben subir el trabajo a un repositorio en Git-Hub.
    # documento Word o PDF en el que se indique:
		#Los nombres de los integrantes del equipo
		# Ruta del repositorio en GitHub
		# Consideraciones adicionales
        
        
        
        
        
        
        
        
        
        
