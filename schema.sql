CREATE DATABASE IF NOT EXISTS localsparepartsdb;
USE localsparepartsdb;

CREATE TABLE Workers (
    worker_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    position VARCHAR(50),
    dob DATE,
    salary DECIMAL(10,2),
    shift VARCHAR(50),
    expertise VARCHAR(100),
    contact_info VARCHAR(100),
    residency VARCHAR(100)
);

CREATE TABLE Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100),
    quantity INT,
    price_per_piece DECIMAL(10,2),
    quality VARCHAR(50)
);

CREATE TABLE Clients (
    client_id INT PRIMARY KEY AUTO_INCREMENT,
    client_name VARCHAR(100),
    age INT,
    contact_info VARCHAR(100)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    client_id INT,
    worker_id INT,
    order_date DATE,
    FOREIGN KEY (client_id) REFERENCES Clients(client_id),
    FOREIGN KEY (worker_id) REFERENCES Workers(worker_id)
);

CREATE TABLE OrderDetails (
    order_detail_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    amount INT,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE TABLE ClientPayments (
    cpayment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    total_amount DECIMAL(10,2),
    paid_amount DECIMAL(10,2),
    remaining_amount DECIMAL(10,2),
    payment_date DATE,
    payment_method VARCHAR(50),
    status ENUM('Paid','Unpaid','Partially Paid'),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

CREATE TABLE Suppliers (
    supplier_id INT PRIMARY KEY AUTO_INCREMENT,
    supplier_name VARCHAR(100),
    contact_info VARCHAR(100)
);

CREATE TABLE SupplyOrders (
    supply_order_id INT PRIMARY KEY AUTO_INCREMENT,
    supplier_id INT,
    product_id INT,
    quantity INT,
    price_per_unit DECIMAL(10,2),
    quality VARCHAR(50),
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE TABLE SupplierPayments (
    spayment_id INT PRIMARY KEY AUTO_INCREMENT,
    supply_order_id INT,
    total_amount DECIMAL(10,2),
    paid_amount DECIMAL(10,2),
    payment_date DATE,
    payment_method VARCHAR(50),
    status ENUM('Paid','Unpaid','Partially Paid'),
    FOREIGN KEY (supply_order_id) REFERENCES SupplyOrders(supply_order_id)
);

CREATE TABLE WorkerPayments (
    wpayment_id INT PRIMARY KEY AUTO_INCREMENT,
    worker_id INT,
    amount DECIMAL(10,2),
    payment_date DATE,
    payment_method VARCHAR(50),
    status ENUM('Paid','Unpaid','Partially Paid'),
    FOREIGN KEY (worker_id) REFERENCES Workers(worker_id)
);
