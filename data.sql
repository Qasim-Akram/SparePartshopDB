USE localsparepartsdb;

INSERT INTO Workers (first_name,last_name,position,dob,salary,shift,expertise,contact_info,residency) VALUES
('Ali','Khan','Manager','1985-03-12',50000,'Morning','Inventory','03001234567','Lahore'),
('Sara','Ahmed','Sales','1990-07-22',30000,'Evening','Customer Service','03007654321','Karachi');

INSERT INTO Products (product_name,quantity,price_per_piece,quality) VALUES
('Brake Pad',100,1200,'High'),
('Clutch Plate',50,3500,'Medium'),
('Oil Filter',200,800,'High');

INSERT INTO Clients (client_name,age,contact_info) VALUES
('Bilal Traders',40,'03121234567'),
('Usman Autos',35,'03459876543');

INSERT INTO Orders (client_id,worker_id,order_date) VALUES
(1,1,'2025-09-01'),
(2,2,'2025-09-02');

INSERT INTO OrderDetails (order_id,product_id,amount) VALUES
(1,1,10),
(1,3,5),
(2,2,3);

INSERT INTO ClientPayments (order_id,total_amount,paid_amount,remaining_amount,payment_date,payment_method,status) VALUES
(1,20000,15000,5000,'2025-09-03','Cash','Partially Paid'),
(2,10500,10500,0,'2025-09-04','Bank Transfer','Paid');

INSERT INTO Suppliers (supplier_name,contact_info) VALUES
('AutoSupply Co.','0421234567'),
('SpareParts Ltd.','0427654321');

INSERT INTO SupplyOrders (supplier_id,product_id,quantity,price_per_unit,quality) VALUES
(1,1,50,1000,'High'),
(2,2,30,3000,'Medium');

INSERT INTO SupplierPayments (supply_order_id,total_amount,paid_amount,payment_date,payment_method,status) VALUES
(1,50000,50000,'2025-09-01','Cash','Paid'),
(2,90000,45000,'2025-09-02','Bank Transfer','Partially Paid');

INSERT INTO WorkerPayments (worker_id,amount,payment_date,payment_method,status) VALUES
(1,50000,'2025-08-31','Cash','Paid'),
(2,15000,'2025-09-01','Cash','Partially Paid');
