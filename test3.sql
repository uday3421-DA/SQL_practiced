CREATE DATABASE IF NOT EXISTS xyz_company2;
USE xyz_company2;

CREATE TABLE departments (
  dept_id INT PRIMARY KEY,
  dept_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE employees (
  emp_id INT PRIMARY KEY,
  emp_name VARCHAR(100) NOT NULL,
  dept_id INT,
  email VARCHAR(100) UNIQUE,
  salary DECIMAL(10,2) DEFAULT 0,
  hire_date DATE,
  CONSTRAINT fk_emp_dept FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

INSERT INTO departments (dept_id, dept_name) VALUES
(1,'HR'),(2,'IT'),(3,'Sales');

INSERT INTO employees (emp_id, emp_name, dept_id, email, salary, hire_date) VALUES
(101,'Amit Sharma',2,'amit@xyz.com',50000,'2022-01-15'),
(102,'Priya Rao',2,'priya@xyz.com',60000,'2021-07-01'),
(103,'Ravi Kumar',1,'ravi@xyz.com',35000,'2020-11-10'),
(104,'Sana Khan',3,'sana@xyz.com',45000,'2023-03-20'),
(105,'Karan Mehta',3,NULL,30000,'2024-02-25');
select * from employees;

-- A. DML QUERIES


INSERT INTO employees (emp_id, emp_name, dept_id, email, salary, hire_date)
VALUES (106,'Negjvrfyha Patil',2,'neha@xfjnyz.com',42000,'2025-01-10');

INSERT INTO employees (emp_id, emp_name, dept_id, email, salary, hire_date) VALUES
(107,'Deepak Joshi',1,'deepak@xyz.com',28000,'2024-05-05'),
(108,'Meera Iyer',2,'meera@xyz.com',48000,'2023-12-01');

UPDATE employees SET salary = salary * 1.10 WHERE emp_id = 102;
UPDATE employees SET salary = salary + 2000 WHERE dept_id = 3;
DELETE FROM employees WHERE emp_id = 105;
SELECT * FROM employees;
SELECT e.emp_id, e.emp_name, d.dept_name FROM employees e JOIN departments d ON e.dept_id = d.dept_id WHERE d.dept_name = 'IT';
SELECT emp_id, emp_name FROM employees WHERE email IS NULL;
UPDATE employees SET dept_id = 2 WHERE emp_id = 104;
DELETE FROM employees WHERE dept_id = 1;


-- B. DDL QUERIES

CREATE TABLE audit_log (log_id INT PRIMARY KEY AUTO_INCREMENT, emp_id INT, action VARCHAR(100), action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
ALTER TABLE employees ADD COLUMN phone VARCHAR(20);
ALTER TABLE employees MODIFY COLUMN phone VARCHAR(20) NOT NULL;
CREATE INDEX idx_emp_email ON employees(email);
DROP INDEX idx_emp_email ON employees;
CREATE VIEW vw_employee_basic AS SELECT emp_id, emp_name, dept_id, salary FROM employees;
DROP VIEW IF EXISTS vw_employee_basic;
TRUNCATE TABLE audit_log;
RENAME TABLE audit_log TO audit_history;
DROP TABLE IF EXISTS audit_history;


-- C. OPERATORS QUERIES


SELECT emp_id, emp_name, salary FROM employees WHERE salary >= 45000;
SELECT emp_id, emp_name FROM employees WHERE emp_name <> 'Amit Sharma';
SELECT emp_id, emp_name, hire_date FROM employees WHERE hire_date BETWEEN '2021-01-01' AND '2024-12-31';
SELECT emp_id, emp_name FROM employees WHERE dept_id IN (1,3);
SELECT emp_id, emp_name FROM employees WHERE emp_name LIKE 'P%';
SELECT emp_id, emp_name FROM employees WHERE email LIKE '%@xyz.com';
SELECT emp_id, emp_name FROM employees WHERE dept_id = 2 AND salary > 45000;
SELECT emp_id, emp_name FROM employees WHERE dept_id = 1 OR salary < 35000;
SELECT emp_id, emp_name FROM employees WHERE NOT (dept_id = 2);
SELECT d.dept_id, d.dept_name FROM departments d WHERE EXISTS (SELECT 1 FROM employees e WHERE e.dept_id = d.dept_id);


-- D. CONSTRAINT QUERIES


CREATE TABLE assets (asset_id INT PRIMARY KEY, emp_id INT, serial_no VARCHAR(50) UNIQUE, buy_date DATE, price DECIMAL(10,2) CHECK (price >= 0), CONSTRAINT fk_asset_emp FOREIGN KEY (emp_id) REFERENCES employees(emp_id));
ALTER TABLE assets MODIFY COLUMN serial_no VARCHAR(50) NOT NULL;
ALTER TABLE employees MODIFY salary DECIMAL(10,2) DEFAULT 10000;
ALTER TABLE employees DROP FOREIGN KEY fk_emp_dept;
ALTER TABLE employees ADD CONSTRAINT fk_emp_dept FOREIGN KEY (dept_id) REFERENCES departments(dept_id);
ALTER TABLE employees ADD CONSTRAINT uc_dept_emp UNIQUE (dept_id, emp_name);
-- INSERT INTO departments VALUES (1,'Finance'); -- duplicate PK (error example)
-- INSERT INTO employees (emp_id, emp_name, dept_id, email, salary) VALUES (109, NULL, 1, 'x@xyz.com', 25000); -- null in NOT NULL (error example)
SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE, TABLE_NAME FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA = 'xyz_company' AND TABLE_NAME = 'employees';
DROP TABLE IF EXISTS assets;


-- E. AGGREGATE FUNCTION QUERIES


SELECT COUNT(*) AS total_employees FROM employees;
SELECT COUNT(DISTINCT dept_id) AS dept_count FROM employees;
SELECT SUM(salary) AS total_salary FROM employees;
SELECT AVG(salary) AS avg_salary FROM employees;
SELECT MIN(salary) AS min_sal, MAX(salary) AS max_sal FROM employees;
SELECT d.dept_name, AVG(e.salary) AS avg_salary FROM employees e JOIN departments d ON e.dept_id = d.dept_id GROUP BY d.dept_name;
SELECT dept_id, COUNT(*) AS emp_count FROM employees GROUP BY dept_id;
SELECT dept_id, AVG(salary) AS avg_sal FROM employees GROUP BY dept_id HAVING AVG(salary) > 45000;
SELECT e.emp_id, e.emp_name, e.dept_id, e.salary FROM employees e JOIN (SELECT dept_id, MAX(salary) AS max_sal FROM employees GROUP BY dept_id) m ON e.dept_id = m.dept_id AND e.salary = m.max_sal;
SELECT YEAR(hire_date) AS year_hired, COUNT(*) AS hired_count FROM employees GROUP BY YEAR(hire_date);


