# Author: Gatovsky
create database ine character set utf16;
use ine;

-- TABLA USUARIOS --
create table usuarios (
    id_usuario int unsigned not null auto_increment,
    nombre varchar(50) not null,
    alias varchar(50) not null,
    password char(102) not null,
    activo bit comment '1: verdadero | 0: falso',
    email varchar(50) not null,
    constraint pk_usuarios primary key (id_usuario),
    unique key indx_alias(alias)
);

-- TABLA CATEGORIAS --
create table categorias (
    id_categoria int unsigned not null auto_increment,
    nombre varchar(100) not null,
    descripcion text,
    constraint pk_categorias primary key (id_categoria),
    unique key indx_nombre(nombre)
);

-- TABLA NOTICIAS --
create table noticias (
    id_noticia int unsigned not null auto_increment,
    titulo varchar(100) not null,
    id_categoria int unsigned not null,
    id_usuario int unsigned not null,
    fecha date,
    ruta text,
    constraint pk_noticias primary key (id_noticia),
    key indx_categoria(id_categoria),
    constraint fk_noticias_usuarios foreign key (id_usuario) references usuarios(id_usuario) on update cascade on delete no action,
    constraint fk_noticias_categorias foreign key (id_categoria) references categorias(id_categoria) on update cascade on delete no action
);

-- TABLA VOTACIONES --
create table votaciones (
    id_votacion int unsigned not null auto_increment,
    id_noticia int unsigned not null,
    fecha_inicio date comment 'YYYY-MM-DD',
    fecha_fin date comment 'YYYY-MM-DD',
    pregunta varchar(100),
    respuesta1 varchar(100),
    respuesta2 varchar(100),
    respuesta3 varchar(100),
    votos_resp1 int,
    votos_resp2 int,
    votos_resp3 int,
    constraint pk_votaciones primary key (id_votacion),
    unique key indx_id_noticia(id_noticia),
    constraint fk_votaciones_noticias foreign key (id_noticia) references noticias(id_noticia) on update cascade on delete no action
);

-- TABLA COMENTARIOS --
create table comentarios (
    id_comentario int unsigned not null auto_increment,
    id_noticia int unsigned,
    id_usuario int unsigned not null,
    texto text,
    fecha date comment 'YYYY-MM-DD',
    constraint pk_comentarios primary key (id_comentario),
    key indx_noticia(id_noticia),
    constraint fk_comentarios_noticias foreign key (id_noticia) references noticias(id_noticia) on update cascade on delete no action,
    constraint fk_comentarios_usuarios foreign key (id_usuario) references usuarios(id_usuario) on update cascade on delete no action
);

-- TABLA PRIVILEGIOS --
create table privilegios (
    id_usuario int unsigned not null,
    privilegio int unsigned not null auto_increment,
    id_categoria int unsigned not null,
    constraint pk_privilegios primary key (privilegio),
    constraint fk_privilegios_usuario foreign key (id_usuario) references usuarios(id_usuario) on update cascade on delete no action,
    constraint fk_privilegios_categorias foreign key (id_categoria) references categorias(id_categoria) on update cascade on delete no action
    #constraint pkcom_idusuario_idcategoria primary key (id_usuario, id_categoria)
);