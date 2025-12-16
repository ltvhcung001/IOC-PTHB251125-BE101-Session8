CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    emp_name VARCHAR(100),
    job_level INT,
    salary NUMERIC
);

INSERT INTO employees (emp_name, job_level, salary) VALUES 
('Nguyen Van A', 1, 10000000), 
('Tran Thi B', 2, 20000000),   
('Le Van C', 3, 30000000);    

-- 1. Tạo Procedure adjust_salary(p_emp_id INT, OUT p_new_salary NUMERIC) để:
-- Nhận emp_id của nhân viên
-- Cập nhật lương theo quy tắc trên
-- Trả về p_new_salary (lương mới) sau khi cập nhật
CREATE OR REPLACE PROCEDURE adjust_salary(p_emp_id INT, OUT p_new_salary NUMERIC)
LANGUAGE plpgsql
AS $$
DECLARE
    v_job_level INT;
    v_old_salary NUMERIC;
    v_multiplier NUMERIC;
BEGIN
    SELECT job_level, salary INTO v_job_level, v_old_salary
    FROM employees
    WHERE emp_id = p_emp_id;

    IF v_job_level = 1 THEN
        v_multiplier := 1.05;
    ELSIF v_job_level = 2 THEN
        v_multiplier := 1.10;
    ELSIF v_job_level = 3 THEN
        v_multiplier := 1.15;
    ELSE
        v_multiplier := 1.0; 
    END IF;
    
    p_new_salary := v_old_salary * v_multiplier;

    UPDATE employees 
    SET salary = p_new_salary 
    WHERE emp_id = p_emp_id;
END;
$$;

-- 2. Gọi Procedure
CALL adjust_salary(3, p_new_salary);
SELECT p_new_salary;
