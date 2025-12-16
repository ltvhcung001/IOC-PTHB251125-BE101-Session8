-- Tạo bảng order_detail
CREATE TABLE order_detail (
    id SERIAL PRIMARY KEY,
    order_id INT,
    product_name VARCHAR(100),
    quantity INT,
    unit_price NUMERIC
);

INSERT INTO order_detail (order_id, product_name, quantity, unit_price) VALUES 
(1, 'Laptop', 1, 1000),
(1, 'Mouse', 2, 50),
(2, 'Keyboard', 1, 150);

-- 1+2. Viết một Stored Procedure có tên calculate_order_total(order_id_input INT, OUT total NUMERIC)
-- Tham số order_id_input: mã đơn hàng cần tính
-- Tham số total: tổng giá trị đơn hàng
-- Viết câu lệnh tính tổng tiền theo order_id

CREATE OR REPLACE PROCEDURE calculate_order_total(IN order_id_input INT, OUT)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT COALESCE(SUM(quantity * unit_price), 0)
    INTO total
    FROM order_detail
    WHERE order_id = order_id_input;
    
END;
$$;

-- 3. Gọi Procedure để kiểm tra hoạt động với một order_id cụ thể
CALL calculate_order_total(1, my_total);
