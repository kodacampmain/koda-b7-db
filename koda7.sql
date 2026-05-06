CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    age INT NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP
);

ALTER TABLE users
ADD COLUMN photo VARCHAR(255);
ALTER TABLE users
ADD COLUMN gender CHAR(1) CHECK gender IN ('L', 'P') NOT NULL;
ALTER TABLE users
ALTER COLUMN photo SET DEFAULT 'default-profile.png';

CREATE TABLE posts (
    id UUID DEFAULT gen_random_uuid(),
    title VARCHAR(100) NOT NULL,
    content TEXT,
    user_id int NOT NULL ,
    created_at TIMESTAMP DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP,
    PRIMARY KEY (id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE books (
    id int PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP
);

-- INSERT INTO table_name (column_name1, column_name2, ...)
-- VALUES (value_column1, value_column2, ...), (value_column1, value_column2, ...), ...

INSERT INTO users (username, age, email) VALUES
('bundo', 30, 'bundo@mail.com'), ('gado', 30, 'gado@mail.com');

INSERT INTO users (username, age, email) VALUES
('Hanif', 50, 'Hanif@mail.com');

table users;

-- UPDATE table_name SET field=record WHERE condition;
UPDATE users SET age=25 WHERE id IN (2,3);

-- DELETE FROM table_name WHERE condition;
DELETE FROM users WHERE username='koda';
DELETE FROM users WHERE email='naufal@mail.com';

SELECT currval('users_id_seq');

-- post
INSERT INTO posts (title, content, user_id) VALUES
('postgreSQL vs mySQL', 'lorem ipsum dolor si amet', 2);

table posts;

-- books
INSERT INTO books (title, author) VALUES
('Laskar Pelangi', 'Andrea Hirata');

table books;

SELECT currval('books_id_seq');