/*
1 - Crear la base de datos Gestion_Proyectos_ACRONIMO
*/
create database Gestion_Proyectos_HHA;
use Gestion_Proyectos_HHA;

/*
2- Crear las tablas correspondientes sin crear PK ó FK
   los nombres de las tablas deben terminar con _ACRONIMO
*/

create table Clientes_HHA (idCliente integer, NombreEmpresa varchar(100), Nit integer, Contacto varchar(100),
                           Telefono integer);
create table Recursos_HHA (idRecurso integer, NombreRecurso varchar(100), TipoRecurso integer);
create table Empleados_HHA (idEmpleado integer, Nombre varchar(100), Apellidos varchar(100), Cargo varchar(100));
create table Proyectos_HHA (idProyecto integer, Cliente_idCliente integer, NombreProyecto varchar(100),
                            Descripción varchar(100), FechaInicio date, Estado bool);
create table Tareas_HHA (idTarea integer, Empleados_idEmplado integer, Recursos_idRecurso integer, Proyectos_idProyecto integer,
                         Descripción varchar(100), FechaInicio date, FechaFin date);

/*
3- Mostrar la descripción de las tablas
*/
describe Clientes_HHA;
describe Recursos_HHA;
describe Empleados_HHA;
describe Proyectos_HHA;
describe Tareas_HHA;

/*
4- agregar el campo correo y fecha de nacimiento a la tabla Empleados
*/
alter table Empleados_HHA add column Correo varchar(100);
alter table Empleados_HHA add column FechaNacimiento date after Apellidos;

/*
5- Agregar las PK a cada tabla, que sean requeridos y auto incrementables
*/
alter table Clientes_HHA add constraint pk_clientes primary key (idCliente);
alter table Clientes_HHA modify idCliente integer not null auto_increment;

alter table Recursos_HHA add constraint pk_recursos primary key (idRecurso);
alter table Recursos_HHA modify idRecurso integer not null auto_increment;

alter table Empleados_HHA add constraint pk_empleados primary key (idEmpleado);
alter table Empleados_HHA modify idEmpleado integer not null auto_increment;

alter table Proyectos_HHA add constraint pk_proyectos primary key (idProyecto);
alter table Proyectos_HHA modify idProyecto integer not null auto_increment;

alter table Tareas_HHA add constraint pk_tareas primary key (idTarea);
alter table Tareas_HHA modify idTarea integer not null auto_increment;

/*
6- La relación entre Tareas y Empleados debe ser de muchos a muchos, de tal forma que un empleado pueda participar en
muchas tareas y una tarea pueda ser hecha pr muchos empleados. Por consiguiente en Tareas eliminar la relación uno a muchos
con empleados, y crear la relación muchos a muchos
*/

alter table Tareas_HHA drop column Empleados_idEmplado;
create table Rel_TareasEmpledos_HHA (Tareas_idTarea int not null, Empleados_idEmpleado int not null,
                                     constraint fk_tareas foreign key (Tareas_idTarea) references Tareas_HHA (idTarea)
                                     on update cascade on delete no action,
                                     constraint fk_empleados foreign key (Empleados_idEmpleado) references Empleados_HHA (idEmpleado)
                                     on update cascade on delete no action );
describe Rel_TareasEmpledos_HHA;

/*
7- Agregar las llaves foráneas que permita establecer las relaciones correspondientes entre cada tabla según indica la imagen anterior
*/

alter table Proyectos_HHA add constraint fk_clientes foreign key (Cliente_idCliente) references Clientes_HHA (idCliente) on update cascade on delete no action;
alter table Tareas_HHA add constraint fk_recursos foreign key (Recursos_idRecurso) references Recursos_HHA (idRecurso) on update cascade on delete no action;
alter table Tareas_HHA add constraint fk_proyectos foreign key (Proyectos_idProyecto) references Proyectos_HHA (idProyecto) on update cascade on delete no action;

/*
8- Mostrar la descripción de las tablas.
*/

describe Proyectos_HHA;
describe Tareas_HHA;

/*
9- Todos los campos "Nombre..." deben de ser requeridos.
*/

alter table Empleados_HHA modify Nombre varchar(100) not null;
alter table Proyectos_HHA modify NombreProyecto varchar(100) not null;
alter table Clientes_HHA modify NombreEmpresa varchar(100) not null;
alter table Recursos_HHA modify NombreRecurso varchar(100) not null;

/*
 10- El nombre del Proyecto no se puede repetir.
 */

 alter table Proyectos_HHA add unique udx_nombreProyecto (NombreProyecto);
describe Proyectos_HHA;
/*
10- Eliminar el campo Nit de la tabla Cliente y agregarle el campo RFC.
 */
alter table Clientes_HHA rename column Nit to RFC;
alter table Clientes_HHA modify RFC varchar(100) not null;
describe Clientes_HHA;

/*
 12- El campo RFC de Cliente y el campo email de Empleados deben de manejarse como un índice único.
 */
alter table Clientes_HHA add unique udx_rfc (RFC);
describe Clientes_HHA;
alter table Empleados_HHA add unique udx_email (Correo);
/*
 13- En las Tareas, el campo descripción debe de ser requerido.
 */
alter table Tareas_HHA modify Descripción varchar(100) not null;
describe Tareas_HHA;

/*
 14- Cada que se cree un Proyecto, se le debe de cargar la fecha actual por default en el campo de fecha de inicio y su estado debe de ser falso
 */
alter table Proyectos_HHA modify FechaInicio datetime default NOW();
alter table Proyectos_HHA modify Estado bool default false;

describe Proyectos_HHA;

/*
 15- En las Tareas, la fecha fin no debe de ser anterior a la fecha de inicio.
 */
alter table Tareas_HHA modify FechaInicio date not null;
alter table Tareas_HHA modify FechaFin date not null;
alter table Tareas_HHA add constraint chck_fechaProyecto check ( FechaFin > Tareas_HHA.FechaInicio);
describe Tareas_HHA;

/*
 16- Todo Empleado debe de ser mayor de edad.
 */

delimiter $$
create procedure chck_mayor_edad(in FechaNacimiento date)
    begin
        if timestampdiff(year, FechaNacimiento, now()) < 18 then
            signal sqlstate '45000' set message_text = 'El empleado debe ser mator de edad';
        end if;
    end $$

create trigger trg_chck_mayor_edad
    before insert on Empleados_HHA
    for each row
    begin
        call chck_mayor_edad(new.FechaNacimiento);
    end $$

create trigger updatetrg_chck_mayor_edad
    before update on Empleados_HHA
    for each row
    begin
        call chck_mayor_edad(new.FechaNacimiento);
    end $$
delimiter ;

describe Empleados_HHA;
insert into Empleados_HHA (idEmpleado, Nombre, Apellidos, FechaNacimiento, Cargo, Correo)
values (null, 'Olgo', 'Zaratustra', '2015-01-01', 'Jefe', 'xxxxx@yyyy');

/*
 17- Solo pueden darse de alta Empleados que su cargo sea: "Jefe", "Supervisor", y "Operador"
 */
alter table Empleados_HHA add constraint chck_cargo check ( Cargo = 'Jefe' or Cargo = 'Supervisor' or Cargo = 'Operador' );

show create table Empleados_HHA;

/*
 18- El nombre del Cliente y de los Empleados deben de ser igual o mayor a 2 caracteres y máximo de 50.
 */
alter table Clientes_HHA add constraint chck_longnamecli check ( char_length(NombreEmpresa) >= 2 and char_length(NombreEmpresa) <= 50);
show create table Clientes_HHA;
insert into Clientes_HHA values (null, 'a', 'xxxxxxxx',  null, 0000000);

alter table Empleados_HHA add constraint chck_longnameemp check ( char_length(Nombre) >=2 and char_length(Nombre) <= 50);
describe Empleados_HHA;
insert into Empleados_HHA (Nombre) value ('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
/*
 19- En la descripción de la Tarea siempre deben de tener al menos los siguientes textos: "Problema:", "Objetivo:"
 y que la extensión sea al menos de 30 caracteres
 */
alter table Tareas_HHA drop constraint chck_descripcion;
alter table Tareas_HHA modify Descripción varchar(300) not null;
alter table Tareas_HHA add constraint chck_descripcion check  (Tareas_HHA.Descripción like 'Problema:%' AND Tareas_HHA.Descripción like 'Objetivo:%' AND length(Descripción) >= 30);

show create table Tareas_HHA;

/*
 20- Mostrar la estructura de creación de las tablas
 */

show create table Clientes_HHA;
show create table Empleados_HHA;
show create table Proyectos_HHA;
show create table Recursos_HHA;
show create table Tareas_HHA;
show create table Rel_TareasEmpledos_HHA;