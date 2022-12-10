USE adventureworks;

/*Crear un usuario con tu nombre, y darle todos los privilegios como administrador de base de datos*/

CREATE USER 'hector' IDENTIFIED BY 'tucan123';
GRANT ALL PRIVILEGES ON *.* TO 'hector';
FLUSH PRIVILEGES;
SELECT User FROM mysql.user;
SHOW GRANTS FOR hector;

/*Crear un usuario con tu apellido, y asignarle todos los privilegios
sobre la base de datos adventure works, pero que solo se pueda conectar
desde tu IP publica.*/

CREATE USER 'hernandez'@'%' IDENTIFIED BY 'tucan123';
GRANT ALL PRIVILEGES ON adventureworks.* TO 'hernandez'@'%';
FLUSH PRIVILEGES;

SHOW GRANTS FOR 'hernandez'@'%';
SELECT User FROM mysql.user;


/*Cambiar los privilegios del segundo usuario (apellido)
y que solo pueda hacer consultas (DQL).*/

REVOKE ALL PRIVILEGES ON adventureworks.* FROM 'hernandez'@'%';
GRANT SELECT ON adventureworks.* TO 'hernandez'@'%';
FLUSH PRIVILEGES;

SHOW GRANTS FOR 'hernandez'@'%';
SELECT User FROM mysql.user;

/*Crear un usuario que tenga tu nombre y apellido que solo se pueda se conectar
  desde la IP local, pero que este limitado a la tabla Costumer de la base de datos
  adventure works y solo pueda ejecutar instrucciones de tipo DML.*/
#show tables from adventureworks ;
CREATE USER 'hector_hernandez'@'localhost' IDENTIFIED BY 'tucan123';
GRANT INSERT, DELETE, UPDATE ON adventureworks.customer TO 'hector_hernandez'@'localhost';
FLUSH PRIVILEGES;

SELECT User from mysql.user;
SHOW GRANTS FOR 'hector_hernandez'@'localhost';

/*Realizar pruebas de conexiones con los diferentes usuarios*/

/*
 borrar todos los usuarios creados
 */

DROP USER  'hector_hernandez'@'localhost';
DROP USER 'hector';
DROP USER 'hernandez'@'%';
SELECT User from mysql.user;
