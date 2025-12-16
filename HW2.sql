CREATE TABLE inventory (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    quantity INT
);

INSERT INTO inventory (product_name, quantity) VALUES 
('Laptop Gaming', 10),
('Chuột không dây', 5);

-- 1. Viết một Procedure có tên check_stock(p_id INT, p_qty INT) để:
-- Kiểm tra xem sản phẩm có đủ hàng không
-- Nếu quantity < p_qty, in ra thông báo lỗi bằng RAISE EXCEPTION ‘Không đủ hàng trong kho’

CREATE OR REPLACE PROCEDURE check_stock(p_id INT, p_qty INT)
LANGUAGE plpgsql
AS $$
DECLARE
    v_current_stock INT;
BEGIN
    SELECT quantity INTO v_current_stock
    FROM inventory
    WHERE product_id = p_id;

    IF v_current_stock < p_qty THEN
        RAISE EXCEPTION 'Không đủ hàng trong kho (Hiện có: %, Yêu cầu: %)', v_current_stock, p_qty;
    ELSE
        RAISE NOTICE 'Sản phẩm đủ hàng để xuất!';
    END IF;
END;
$$;

-- 2. Gọi Procedure với các trường hợp:
-- Một sản phẩm có đủ hàng
-- Một sản phẩm không đủ hàng
CALL check_stock(1, 2);
CALL check_stock(2, 8);
