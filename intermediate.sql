--  createuser -s -U myuser -p 5050 fakhridho
CREATE USER koda PASSWORD 'dako' VALID UNTIL '2026-05-07 00:00';
ALTER USER koda VALID UNTIL '2026-05-07 00:00:00+07';

CREATE DATABASE koda OWNER koda;
CREATE DATABASE test OWNER test;

-- DQL
-- SELECT table_name.column_name1 , table_name.column_name2, ...
-- FROM table_name 
SELECT id, username, age, email, created_at
FROM users;
SELECT DISTINCT age AS "umur", created_at
FROM users;
-- SELECT * FROM users;
UPDATE users SET username='aufa' WHERE id = 6;

SELECT u.id, u.username, u.age AS "umur", u.email, u.created_at
FROM users u
WHERE u.age >= 30
ORDER BY umur DESC, username ASC
LIMIT 1 OFFSET 2;

SELECT u.id, u.username, u.age AS "umur", u.email, u.created_at
FROM users u
WHERE extract(day FROM created_at) = 6
AND extract(month from created_at) = 5;
-- WHERE created_at BETWEEN '2026-05-05 00:00:00' AND '2026-05-05 23:59:59';

SELECT username
FROM users 
WHERE upper(username) LIKE upper('%AN%');

-- Market Koda 5
SELECT p.id, p.product_name, c.category_name, s.supplier_name
FROM products p
JOIN categories c ON p.category_id = c.id
JOIN suppliers s ON p.supplier_id = s.id
ORDER BY p.id ASC;

-- Aggregation (mydb)
SELECT count(age), age FROM users
GROUP BY age
HAVING count(age) > 3;

SELECT count(*), age FROM users
WHERE age > 25
GROUP BY age;

INSERT INTO users (username, age, email)
VALUES ('angga', 25, 'angga@mail.com'),
('akmal', 25, 'akmal@mail.com'),
('aqil', 25, 'aqil@mail.com');

INSERT INTO users (username, age, email)
VALUES ('dwiki', 27, 'dwiki@mail.com');

SELECT MIN(age) FROM users;
SELECT MAX(age) FROM users;

-- admin
CREATE TABLE students (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP
);
CREATE TABLE subjects (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP
);
CREATE TABLE scores (
    id SERIAL PRIMARY KEY,
    student_id INT NOT NULL,
    subject_id INT NOT NULL,
    scores INT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(id),
    FOREIGN KEY (subject_id) REFERENCES subjects(id)
);

ALTER TABLE scores
RENAME COLUMN scores TO score;

SELECT st.name, AVG(sc.score) AS "rerata nilai" 
FROM scores sc
JOIN students st ON st.id = sc.student_id
GROUP BY st.name
ORDER BY st.name ASC;

SELECT su.name AS mapel, AVG(sc.score) AS rerata 
FROM scores sc
JOIN subjects su ON su.id = sc.subject_id
WHERE su.id = 3
GROUP BY su.name;
-- HAVING AVG(sc.score) > 75.0;

SELECT st.name AS murid, sc.score, su.name as mapel
FROM scores sc
JOIN students st ON sc.student_id = st.id
JOIN subjects su ON sc.subject_id = su.id
WHERE su.name = 'Bhs. Indonesia';

table scores;

-- Mencari rerata siswa yg berada diatas rerata kumulatif

SELECT AVG(score) AS rerata
FROM scores;

SELECT st.name, AVG(sc.score) AS "rerata nilai" 
FROM scores sc
JOIN students st ON st.id = sc.student_id
GROUP BY st.name
HAVING AVG(sc.score) > (
    SELECT AVG(score) AS rerata
    FROM scores
)
ORDER BY st.name ASC;

SELECT d.id, count(m.id) AS total
FROM movies m
JOIN directors d ON m.director_id = d.id
GROUP BY d.id;

SELECT d.first_name, d.last_name, sq.total
FROM (
    SELECT director_id, count(id) AS total
    FROM movies 
    GROUP BY director_id
) sq
JOIN directors d ON sq.director_id = d.id;

SELECT first_name, last_name
FROM directors
WHERE id IN (
    SELECT d.id
    FROM movies m
    JOIN directors d ON m.director_id = d.id
    GROUP BY d.id
    HAVING count(m.id) > 5
);

SELECT su.name, sc.score 
FROM scores sc
JOIN subjects su ON sc.subject_id = su.id
WHERE sc.score > 75;

-- sales & product
CREATE TABLE product_info (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR,
    category VARCHAR
);
CREATE TABLE sales_data (
    sales_id SERIAL PRIMARY KEY,
    product_id INT,
    quantity INT,
    unit_price INT,
    FOREIGN KEY (product_id) REFERENCES product_info(product_id)
);

SELECT * FROM product_info;
SELECT * FROM sales_data;

SELECT 
    p.name, 
    p.category, 
    sales_metrics.total_revenue, 
    sales_metrics.num_sales 
FROM product_info p 
JOIN (
    SELECT 
        product_id, 
        SUM(quantity * unit_price) AS total_revenue, 
        COUNT(*) AS num_sales 
    FROM sales_data 
    GROUP BY product_id
) AS sales_metrics 
ON p.product_id = sales_metrics.product_id;

SELECT 
    pin.name,
    pin.category, 
    SUM(sd.quantity * sd.unit_price) AS total_revenue, 
    COUNT(*) AS num_sales 
FROM sales_data sd
JOIN product_info pin ON sd.product_id = pin.product_id
GROUP BY pin.name, pin.category;

SELECT pin.name, pin.category, sd.unit_price
FROM sales_data sd
JOIN product_info pin ON sd.product_id = pin.product_id
WHERE sd.unit_price = (
    SELECT MAX(unit_price) FROM sales_data
);

-- HR DATA
CREATE TABLE departments (
	id SERIAL PRIMARY KEY,
	department_name VARCHAR
);
CREATE TABLE employees (
	id SERIAL PRIMARY KEY,
	employee_name VARCHAR,
	department_id INT,
	salary INT,
	FOREIGN KEY (department_id) REFERENCES departments(id)
);

SELECT * FROM departments;
SELECT * FROM employees;
-- cari employee dengan gaji diatas gaji rata-rata departemennya
SELECT department_id, AVG(salary)
FROM employees
GROUP BY department_id;

SELECT e1.id, e1.employee_name, e1.salary, e1.department_id
FROM employees e1
WHERE salary < (
    SELECT AVG(e2.salary)
    FROM employees e2
    WHERE e1.department_id = e2.department_id
);

SELECT e.id, e.employee_name, e.salary, e.department_id
FROM employees e
JOIN ( 
    SELECT department_id, AVG(salary) as avg_salary
    FROM employees
    GROUP BY department_id
) recap ON e.salary > recap.avg_salary AND e.department_id = recap.department_id;

SELECT 
    id,
    employee_name, 
    salary,
    (SELECT AVG(salary) FROM employees) AS average_salary
FROM employees
ORDER BY id ASC;

SELECT 
    e1.employee_name, 
    e1.salary,
    e2.average_salary
FROM 
    employees e1,
    (SELECT AVG(salary) AS average_salary FROM employees) e2;

-- product example
SELECT product_name, price
FROM products p1
WHERE price > (
    SELECT AVG(price) FROM products p2
    WHERE p2.category = p1.category
);

-- transaction
SELECT t1.customer_id, t1.amount
FROM transactions t1
WHERE amount > (
    SELECT AVG(t2.amount)
    FROM transactions t2
    WHERE t2.customer_id = t1.customer_id
);

SELECT t1.customer_id, t1.amount
FROM transactions t1
JOIN (
    SELECT t2.customer_id, AVG(t2.amount) as avg_amount
    FROM transactions t2
    GROUP BY t2.customer_id
) recap ON t1.customer_id = recap.customer_id AND t1.amount > recap.avg_amount

-- CTE sales
CREATE TABLE sales (
    product_id INT,
    sales_amount INT
);

INSERT INTO sales (product_id, sales_amount)
VALUES (1,100), (2, 200), (1, 300);

SELECT * FROM sales;

WITH recap AS (
    SELECT product_id, SUM(sales_amount) AS total_amount
    FROM sales
    GROUP BY product_id
)
SELECT product_id, total_amount
FROM recap
WHERE total_amount = (SELECT MAX(total_amount) from recap);