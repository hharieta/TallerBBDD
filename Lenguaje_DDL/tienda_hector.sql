/*
 Ejercicio DDL
 */

drop database if exists tienda_hector;
create database tienda_hector;
use tienda_hector;

create table Productos (nombre varchar(100), descripcion varchar(100), costo float);
create table Proveedores (nombre varchar(100), email varchar(100));

drop table Productos;
drop table Proveedores;

create table producto (idProducto integer not null auto_increment, nombre varchar(100), descripcion varchar(100), costo float,
                       constraint pk_producto primary key (idProducto));
create table proveedor (idProveedor integer not null auto_increment,nombre varchar(100), email varchar(100),
                       constraint pk_proveedor primary key (idProveedor));

alter table producto add column proveedor_idProveedor integer after idProducto;
alter table producto add constraint pk_proveedor foreign key (proveedor_idProveedor) references proveedor (idProveedor);

alter table producto modify nombre varchar(100) not null;
alter table proveedor modify nombre varchar(100) not null;

alter table proveedor add unique uidx_email (email);

alter table producto modify costo float check ( costo>0.0 );

alter table proveedor add column rfc varchar(100) not null;
alter table proveedor add index idx_rfc (rfc);

alter table producto add column fechaAlta datetime default NOW();

describe producto;
describe proveedor;