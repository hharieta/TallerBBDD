USE adventureworks;
/*
Crear un procedimiento almacenado que se llame Cliente_x_ciudad que reciba como parámetro el nombre de una ciudad
Debe de validar que el nombre de la ciudad existe en la tabla de direcciones, en caso que no, debe de mandar un
mensaje que indique que la ciudad no se encontro.En caso que la ciudad exista, debe de realizar un conteo de
cuantos clientes coinciden su dirección con dicha ciudad. Al final, debe de imprimir el nombre de la ciudad y
el numero de clientes que corresponden a dicha ciudad. Invocar al procedimiento y probar con una ciudad
inexistente y con una existente.
 */

DROP PROCEDURE IF EXISTS Cliente_x_ciudad;

DELIMITER //

CREATE PROCEDURE Cliente_x_ciudad(in nombre_ciudad varchar(50))
BEGIN

    IF (SELECT COUNT(City) FROM address WHERE City LIKE nombre_ciudad) > 0
    THEN
        SELECT City, COUNT(City)  AS 'clientes' FROM address WHERE City LIKE nombre_ciudad GROUP BY City;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'lA CIUDAD NO EXISTE';
    END IF;

END //

DELIMITER ;

CALL Cliente_x_ciudad('London');

select City from address;

SELECT City, COUNT(City) AS 'clientes' FROM address WHERE City LIKE '%London%' GROUP BY City;


/*Crear un procedimiento almacenado llamado clientes que reciba como parámetro dos valores, un numero y un boleano
El procedimiento debe de imprimir el listado de clientes pero debe de usar el primer parámetro para indicar el numero de clientes a imprimir
El segundo parámetro debe de indicar el orden en el que se debe de enlistar los clientes, si es falso, el orden es ascendente, si es verdadero, el orden es descendente.
Se debe de validar que el primer numero sea mayor a 0 y menor a 100. En caso contrario, imprimir un mensaje que indique que el numero ingresado no es valido.
Invocar al procedimiento utilizando valores demo, como números negativos, números superiores a 100, números validos como 5, 10, 20, y cambiar los estados de falso a verdadero.
*/

/*2*/
DESCRIBE customer;


DROP PROCEDURE IF EXISTS Clientes;

DELIMITER //

CREATE PROCEDURE Clientes(in cantidad_clientes INTEGER, orden BOOLEAN)
BEGIN
    IF cantidad_clientes > 0 AND cantidad_clientes <= 1000
    THEN
        IF orden
        THEN
            SELECT CustomerID, FirstName, LastName, EmailAddress FROM customer ORDER BY CustomerID DESC LIMIT cantidad_clientes;
        ELSE
            SELECT CustomerID, FirstName, LastName, EmailAddress FROM customer ORDER BY CustomerID LIMIT cantidad_clientes;
        END IF;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '@Eror! 1 >= cantidad_clientes <= 1000';
    END IF;

END //

DELIMITER ;

/*1: true, 0: false*/
CALL Clientes(5, 0);


/*
Realizar un cambio al procedimiento almacenado anterior, se debe de agregar un tercer parámetro, que sea un nombre
Este cambio debe de permitir filtrar a los clientes por el nombre proporcionado.
Validar que el nombre sea mayor de 3 caracteres y menor a 20, y que no contenga espacios.
Invocar al procedimiento proporcionando un nombre invalido y nombre valido.
*/

DROP PROCEDURE IF EXISTS Clientes2;

DELIMITER //

CREATE PROCEDURE Clientes2(in cantidad_clientes INTEGER, orden BOOLEAN, nombre VARCHAR(50))
BEGIN
    SET @nombre_ = REPLACE(nombre, ' ', '');
    IF cantidad_clientes > 0 AND cantidad_clientes <= 1000
    THEN
        IF LENGTH(@nombre_) > 3 AND  LENGTH(@nombre_) < 20
            THEN
            IF orden
                THEN
                    SELECT CustomerID, FirstName, LastName, EmailAddress FROM customer WHERE FirstName LIKE @nombre_ ORDER BY CustomerID DESC LIMIT cantidad_clientes;
                ELSE
                    SELECT CustomerID, FirstName, LastName, EmailAddress FROM customer WHERE FirstName LIKE @nombre_ ORDER BY CustomerID LIMIT cantidad_clientes;
                END IF;
            ELSE
                SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '@Eror! longitud: 3 > nombre < 20';
        END IF;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '@Eror! 1 >= cantidad_clientes <= 1000';
    END IF;

END //

DELIMITER ;

/*1: true, 0: false*/
CALL Clientes2(5, 0, 'Orlando');


/*Crear un trigger llamado borrar_direcciones
Este trigger debe de ser invocado ANTES de borrar a un cliente, y lo que debe de realizar es borrar las direcciones con las que esta relacionado el cliente.
Realizar una consulta donde se muestra a un cliente que tenga una dirección
Ejecutar una consulta de borrado del cliente
Realizar una consulta en direcciones donde se muestre que ya no existe la dirección antes vinculada al cliente.*/

# describe customer;
# describe customeraddress;
# describe address;
#
# describe product;
# describe productcategory;
# describe productmodel;
#
# SELECT productcategory.Name, productmodel.Name FROM product INNER JOIN productcategory ON product.ProductCategoryID = productcategory.ProductCategoryID
# INNER JOIN productmodel ON product.ProductModelID = productmodel.ProductModelID;
#
# SELECT * FROM address LIMIT 10;
# SELECT * FROM customer LIMIT 10;
# SELECT * FROM customeraddress LIMIT 10;
#
# SELECT customer.FirstName, customer.LastName, customer.CompanyName, address.City, address.StateProvince, address.CountryRegion FROM customeraddress INNER JOIN customer ON customeraddress.CustomerID = customer.CustomerID
# INNER JOIN address ON customeraddress.CustomerID = address.AddressID;
#
# SELECT customer.FirstName, customer.LastName, customer.CompanyName, address.City, address.StateProvince
# FROM customer INNER JOIN customeraddress ON customeraddress.CustomerID = customer.CustomerID INNER JOIN address ON customeraddress.CustomerID=address.AddressID;



