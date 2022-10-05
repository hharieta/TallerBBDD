# Author: Gatovsky
create database salespoint character set utf8mb4;
use salespoint;

-- TABLA PROVEEDORES --
create table suppliers (
    supplier_id int unsigned not null auto_increment,
    company_name varchar(100) not null,
    contact_name varchar(50) not null,
    contact_tittle varchar(50),
    address varchar(100) not null,
    city varchar(50) not null,
    region varchar(50) not null,
    postal_code int(10) not null,
    country varchar(50) not null,
    phone varchar(20) not null,
    fax text,
    home_page longtext,
    constraint pk_supplers primary key (supplier_id),
    key company_name_indx(company_name),
    key postal_code_indx(postal_code)
);

-- TABLA CATEGORIAS --
create table categories (
    category_id int unsigned not null auto_increment,
    category_name varchar(50) not null,
    description text,
    picture blob,
    constraint pk_categories primary key (category_id),
    unique key category_name_indx(category_name)
);

-- TABLA PRODUCTOS --
create table products (
  product_id int unsigned not null auto_increment,
  product_name varchar(50) not null,
  supplier_id int unsigned not null,
  category_id int unsigned not null,
  quantity_per_unit int not null,
  unit_price float not null,
  unit_stock int not null,
  unit_in_order int not null,
  reorder_level varchar(50) not null,
  discontinued bit not null comment '1: true | 0: false',
  constraint pk_products primary key (product_id),
  key supplier_indx(supplier_id),
  key category_indx(category_id),
  key product_name_idnx(product_name),
  constraint fk_products_suppliers foreign key (supplier_id) references suppliers(supplier_id) on update cascade on delete no action,
  constraint fk_products_categories foreign key (category_id) references categories(category_id) on update cascade on delete no action
);

-- TABLA EMPLEADOS --
create table employees (
    employee_id int unsigned not null auto_increment,
    lastname varchar(100) not null,
    firstname varchar(100) not null,
    tittle varchar(50),
    tittle_of_courtesy varchar(22),
    birth_date date not null comment 'YYYY-MM-DD',
    hire_date date not null comment 'YYYY-MM-DD',
    address varchar(100) not null,
    city varchar(50) not null,
    region varchar(50) not null,
    postal_code int(10) not null,
    country varchar(50) not null,
    home_phone varchar(20) not null,
    extension varchar(10) not null,
    photo blob,
    notes text,
    reports_to varchar(100),
    constraint pk_employees primary key (employee_id),
    key lastname_indx(lastname),
    key postal_code_indx(postal_code)
);

-- TABLA CLIENTES --
create table customers (
    customer_id int unsigned not null auto_increment,
    company_name varchar(100) not null,
    contact_name varchar(50) not null,
    contact_tittle varchar(50),
    address varchar(100) not null,
    city varchar(50) not null,
    region varchar(50) not null,
    postal_code int(10) not null,
    country varchar(50) not null,
    phone varchar(20) not null,
    fax text,
    constraint pk_customers primary key (customer_id),
    key company_name_indx(company_name),
    key city_indx(city),
    key region_indx(region),
    key postal_code_indx(postal_code)
);

-- TABLA ENVÍOS --
create table shippers (
    shipper_id int unsigned not null auto_increment,
    company_name varchar(100) not null,
    phone varchar(13) not null,
    constraint pk_shippers primary key (shipper_id)
);

-- TABLA ÓRDENES --
create table orders (
    order_id int unsigned not null auto_increment,
    customer_id int unsigned not null,
    employee_id int unsigned not null,
    order_date datetime not null comment 'YYYY-MM-DD HH:MM:SS',
    require_date date comment 'YYYY-MM-DD',
    shipped_date datetime not null comment 'YYYY-MM-DD HH:MM:SS',
    ship_via int unsigned not null,
    freight float not null,
    ship_name varchar(50),
    ship_address varchar(100) not null,
    ship_city varchar(50) not null,
    ship_region varchar(50) not null,
    ship_postal_code varchar(10) not null,
    ship_country varchar(50) not null,
    constraint pk_orders primary key (order_id),
    constraint fk_orders_customers foreign key (customer_id) references customers(customer_id),
    constraint fk_orders_employees foreign key (employee_id) references employees(employee_id),
    constraint fk_orders_shippers foreign key (ship_via) references shippers(shipper_id),
    key customer_indx(customer_id),
    key employee_indx(employee_id),
    key order_date_indx(order_date),
    key shipped_date_indx(shipped_date),
    key ship_via_indx(ship_via),
    key ship_postal_code_indx(ship_postal_code)
);

-- TABLA DETALLES DE COMPRA --
create table order_details (
    order_id int unsigned not null,
    product_id int unsigned not null,
    unit_price float not null,
    quantity int not null,
    discount float,
    #constraint pk_orders_products primary key (order_id, product_id),
    constraint fk_orderdetails_orders foreign key (order_id) references orders(order_id) on update cascade on delete no action,
    constraint fk_orderdetails_products foreign key (product_id) references products(product_id) on update cascade on delete no action
);
