USE localsparepartsdb;

-- ==============================
--  BASIC USEFUL QUERIES
-- ==============================

-- Total sales by each worker
SELECT w.first_name, w.last_name, SUM(cp.paid_amount) AS total_sales
FROM ClientPayments cp
JOIN Orders o ON cp.order_id = o.order_id
JOIN Workers w ON o.worker_id = w.worker_id
GROUP BY w.worker_id;

-- Pending payments by clients
SELECT c.client_name, cp.total_amount, cp.paid_amount, cp.remaining_amount, cp.status
FROM ClientPayments cp
JOIN Orders o ON cp.order_id = o.order_id
JOIN Clients c ON o.client_id = c.client_id
WHERE cp.status <> 'Paid';

-- Stock summary (Products + Quantity)
SELECT p.product_name, p.quantity FROM Products p;

-- Supplier outstanding payments
SELECT s.supplier_name, sp.total_amount, sp.paid_amount, sp.status
FROM SupplierPayments sp
JOIN SupplyOrders so ON sp.supply_order_id = so.supply_order_id
JOIN Suppliers s ON so.supplier_id = s.supplier_id
WHERE sp.status <> 'Paid';

-- Worker salary payments
SELECT w.first_name, w.last_name, wp.amount, wp.status
FROM WorkerPayments wp
JOIN Workers w ON wp.worker_id = w.worker_id;

-- ==============================
--  TRIGGERS
-- ==============================

-- 1. Auto-update product stock when an order detail is inserted
DELIMITER //
CREATE TRIGGER trg_reduce_stock_after_order
AFTER INSERT ON OrderDetails
FOR EACH ROW
BEGIN
    UPDATE Products
    SET quantity = quantity - NEW.amount
    WHERE product_id = NEW.product_id;
END;
//
DELIMITER ;

-- 2. Auto-update remaining amount in ClientPayments
DELIMITER //
CREATE TRIGGER trg_calc_remaining_after_payment
BEFORE INSERT ON ClientPayments
FOR EACH ROW
BEGIN
    SET NEW.remaining_amount = NEW.total_amount - NEW.paid_amount;
END;
//
DELIMITER ;

-- 3. Auto-update supplier payment status
DELIMITER //
CREATE TRIGGER trg_update_supplier_status
BEFORE INSERT ON SupplierPayments
FOR EACH ROW
BEGIN
    IF NEW.paid_amount = NEW.total_amount THEN
        SET NEW.status = 'Paid';
    ELSEIF NEW.paid_amount = 0 THEN
        SET NEW.status = 'Unpaid';
    ELSE
        SET NEW.status = 'Partially Paid';
    END IF;
END;
//
DELIMITER ;

-- ==============================
--  FUNCTIONS
-- ==============================

-- 1. Function to calculate total order amount
DELIMITER //
CREATE FUNCTION fn_order_total(p_order_id INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);
    SELECT SUM(od.amount * p.price_per_piece)
    INTO total
    FROM OrderDetails od
    JOIN Products p ON od.product_id = p.product_id
    WHERE od.order_id = p_order_id;
    RETURN IFNULL(total,0);
END;
//
DELIMITER ;

-- 2. Function to check client payment status
DELIMITER //
CREATE FUNCTION fn_client_payment_status(p_order_id INT)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE stat VARCHAR(20);
    SELECT status INTO stat
    FROM ClientPayments
    WHERE order_id = p_order_id
    LIMIT 1;
    RETURN stat;
END;
//
DELIMITER ;

-- ==============================
--  STORED PROCEDURES
-- ==============================

-- 1. Procedure to get client balance summary
DELIMITER //
CREATE PROCEDURE sp_client_balance(IN p_client_id INT)
BEGIN
    SELECT c.client_name, cp.total_amount, cp.paid_amount, cp.remaining_amount, cp.status
    FROM ClientPayments cp
    JOIN Orders o ON cp.order_id = o.order_id
    JOIN Clients c ON o.client_id = c.client_id
    WHERE c.client_id = p_client_id;
END;
//
DELIMITER ;

-- 2. Procedure to record worker salary payment
DELIMITER //
CREATE PROCEDURE sp_pay_worker(IN p_worker_id INT, IN p_amount DECIMAL(10,2), IN p_method VARCHAR(50))
BEGIN
    INSERT INTO WorkerPayments(worker_id, amount, payment_date, payment_method, status)
    VALUES (p_worker_id, p_amount, CURDATE(), p_method, 'Paid');
END;
//
DELIMITER ;

-- 3. Procedure to view supplier outstanding report
DELIMITER //
CREATE PROCEDURE sp_supplier_outstanding()
BEGIN
    SELECT s.supplier_name, SUM(sp.total_amount) AS total, SUM(sp.paid_amount) AS paid,
           (SUM(sp.total_amount) - SUM(sp.paid_amount)) AS outstanding
    FROM SupplierPayments sp
    JOIN SupplyOrders so ON sp.supply_order_id = so.supply_order_id
    JOIN Suppliers s ON so.supplier_id = s.supplier_id
    GROUP BY s.supplier_id;
END;
//
DELIMITER ;
