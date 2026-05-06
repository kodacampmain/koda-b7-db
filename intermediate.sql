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