-- Active: 1742154973525@@127.0.0.1@5432@bookstore_db
CREATE TABLE books (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255) NOT NULL,
    price  DECIMAL(10,2) CHECK (price >= 0) NOT NULL,
    stock INT CHECK (stock >= 0) DEFAULT 0 NOT NULL,
    published_year INT NOT NULL
)

CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    joined_date DATE DEFAULT CURRENT_DATE NOT NULL
)

CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    book_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE
);

INSERT INTO books (title, author, price, stock, published_year) VALUES
('The Pragmatic Programmer', 'Andrew Hunt', 40.00, 10, 1999),
('Clean Code', 'Robert C. Martin', 35.00, 5, 2008),
('You Don''t Know JS', 'Kyle Simpson', 30.00, 8, 2014),
('Refactoring', 'Martin Fowler', 50.00, 3, 1999),
('Database Design Principles', 'Jane Smith', 20.00, 0, 2018);

SELECT * FROM books;

INSERT INTO customers (name, email, joined_date) VALUES
('Alice', 'alice@email.com', '2023-01-10'),
('Bob', 'bob@email.com', '2022-05-15'),
('Charlie', 'charlie@email.com', '2023-06-20');

SELECT * FROM customers;

INSERT INTO orders (customer_id, book_id, quantity, order_date) VALUES
(1, 2, 1, '2024-03-10'),
(2, 1, 1, '2024-02-20'),
(1, 3, 2, '2024-03-05');


SELECT * FROM orders;

-- 1️⃣ Find books that are out of stock.
SELECT * FROM books
    WHERE stock <= 0;

-- 2️⃣ Retrieve the most expensive book in the store.
SELECT * FROM books
    ORDER BY price DESC
    LIMIT 1;

-- 3️⃣ Find the total number of orders placed by each customer.
SELECT customers.name, count(*) AS total_orders FROM orders
JOIN customers ON orders.customer_id = customers.id
GROUP BY customers.NAME;


-- 4️⃣ Calculate the total revenue generated from book sales.
SELECT SUM(orders.quantity * books.price) as total_revenue from orders
    JOIN books on orders.book_id = books.id

-- 5️⃣ List all customers who have placed more than one order.
SELECT customers.name, COUNT(orders.id) AS total_orders FROM orders
    JOIN customers ON orders.customer_id = customers.id
    GROUP BY customers.name
    HAVING count(orders.id) > 1

-- 6️⃣ Find the average price of books in the store.
SELECT ROUND(AVG(price), 2) AS avg_book_price FROM books;

-- 7️⃣ Increase the price of all books published before 2000 by 10%.
UPDATE books
SET price = ROUND(price * 1.10, 2)
WHERE published_year < 2000;

SELECT * FROM books;

-- 8️⃣ Delete customers who haven't placed any orders.
DELETE FROM customers
WHERE id NOT IN (SELECT customer_id FROM orders);

SELECT * from customers;
