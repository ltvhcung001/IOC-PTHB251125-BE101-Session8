CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    price NUMERIC,
    discount_percent INT
);

INSERT INTO products (name, price, discount_percent) VALUES 
('iPhone 15', 30000000, 10),
('Samsung S24', 20000000, 60);

-- 1. Viết Procedure calculate_discount(p_id INT, OUT p_final_price NUMERIC) để:
-- Lấy price và discount_percent của sản phẩm
-- Tính giá sau giảm:
--  p_final_price = price - (price * discount_percent / 100)
-- Nếu phần trăm giảm giá > 50, thì giới hạn chỉ còn 50%
CREATE OR REPLACE PROCEDURE calculate_discount(p_id INT, OUT p_final_price NUMERIC)
LANGUAGE plpgsql
AS $$
DECLARE
    v_price NUMERIC;
    v_discount INT;
    v_real_discount INT;
BEGIN
    SELECT price, discount_percent INTO v_price, v_discount
    FROM products
    WHERE id = p_id;

    IF v_discount > 50 THEN
        v_real_discount := 50; -- Giới hạn max là 50%
    ELSE
        v_real_discount := v_discount;
    END IF;

    p_final_price := v_price - (v_price * v_real_discount / 100.0);

    -- 2. Cập nhật lại cột price trong bảng products thành giá sau giảm
    UPDATE products 
    SET price = p_final_price 
    WHERE id = p_id;
END;
$$;

CALL calculate_discount(2, p_final_price);
SELECT p_final_price;
