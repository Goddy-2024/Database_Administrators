CREATE DATABASE BookStoreManagementSystem;
USE BookStoreManagementSystem;

-- Create country table (referenced by address)
CREATE TABLE country (
    country_id INT AUTO_INCREMENT PRIMARY KEY,
    country_name VARCHAR(100) NOT NULL
);

-- Create address_status table (referenced by customer_address)
CREATE TABLE address_status (
    address_status_id INT AUTO_INCREMENT PRIMARY KEY,
    status_name VARCHAR(50) NOT NULL
);

-- Create address table (referenced by customer_address, cust_order)
CREATE TABLE address (
    address_id INT AUTO_INCREMENT PRIMARY KEY,
    street VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100),
    postal_code VARCHAR(20) NOT NULL,
    country_id INT NOT NULL,
    FOREIGN KEY (country_id) REFERENCES country(country_id)
);

-- Create customer table (referenced by customer_address, cust_order)
CREATE TABLE customer (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(20)
);

-- Create customer_address table (junction between customer and address)
CREATE TABLE customer_address (
    customer_id INT NOT NULL,
    address_id INT NOT NULL,
    address_status_id INT NOT NULL,
    PRIMARY KEY (customer_id, address_id),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (address_id) REFERENCES address(address_id),
    FOREIGN KEY (address_status_id) REFERENCES address_status(address_status_id)
);

-- Create publisher table (referenced by book)
CREATE TABLE publisher (
    publisher_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    contact_email VARCHAR(255),
    contact_phone VARCHAR(20)
);

-- Create book_language table (referenced by book)
CREATE TABLE book_language (
    language_id INT AUTO_INCREMENT PRIMARY KEY,
    language_name VARCHAR(100) NOT NULL
);

-- Create author table (referenced by book_author)
CREATE TABLE author (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    bio TEXT
);

-- Create book table (referenced by book_author, order_line)
CREATE TABLE book (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    isbn VARCHAR(20) NOT NULL UNIQUE,
    publication_year INT,
    price DECIMAL(10, 2) NOT NULL,
    language_id INT NOT NULL,
    publisher_id INT NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 0,
    FOREIGN KEY (language_id) REFERENCES book_language(language_id),
    FOREIGN KEY (publisher_id) REFERENCES publisher(publisher_id)
);

-- Create book_author junction table (many-to-many between book and author)
CREATE TABLE book_author (
    book_id INT NOT NULL,
    author_id INT NOT NULL,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id),
    FOREIGN KEY (author_id) REFERENCES author(author_id)
);

-- Create shipping_method table (referenced by cust_order)
CREATE TABLE shipping_method (
    shipping_method_id INT AUTO_INCREMENT PRIMARY KEY,
    method_name VARCHAR(100) NOT NULL,
    shipping_cost DECIMAL(10, 2) NOT NULL
);

-- Create order_status table (referenced by cust_order, order_history)
CREATE TABLE order_status (
    order_status_id INT AUTO_INCREMENT PRIMARY KEY,
    status_name VARCHAR(50) NOT NULL
);

-- Create cust_order table (referenced by order_line, order_history)
CREATE TABLE cust_order (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    shipping_method_id INT NOT NULL,
    order_status_id INT NOT NULL,
    shipping_address_id INT NOT NULL,
    billing_address_id INT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (shipping_method_id) REFERENCES shipping_method(shipping_method_id),
    FOREIGN KEY (order_status_id) REFERENCES order_status(order_status_id),
    FOREIGN KEY (shipping_address_id) REFERENCES address(address_id),
    FOREIGN KEY (billing_address_id) REFERENCES address(address_id)
);

-- Create order_line table (junction between cust_order and book)
CREATE TABLE order_line (
    order_id INT NOT NULL,
    book_id INT NOT NULL,
    quantity INT NOT NULL,
    price_at_order_time DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (order_id, book_id),
    FOREIGN KEY (order_id) REFERENCES cust_order(order_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id)
);

-- Create order_history table (tracks order status changes)
CREATE TABLE order_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    status_id INT NOT NULL,
    status_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES cust_order(order_id),
    FOREIGN KEY (status_id) REFERENCES order_status(order_status_id)
);


use bookstoremanagementsystem;

-- -- -- Insert into country
 INSERT INTO country (country_name) VALUES 
('Kenya'), ('South Africa'), ('USA');

-- -- -- Insert into address_status
INSERT INTO address_status (status_name) VALUES 
('Current'), ('former');

-- -- -- Insert into address
INSERT INTO address (street, city, state, postal_code, country_id) VALUES
('123 Moi Avenue', 'Nairobi', 'Nairobi', '00100', 1),
 ('45 Long Street', 'Cape Town', 'Western Cape', '8001', 2),
('789 Broadway', 'New York', 'NY', '10003', 3);

-- -- -- Insert into customer
 INSERT INTO customer (first_name, last_name, email, phone) VALUES
 ('Godswill', 'Omondi', 'gaoajuoga@gmail.com', '+254 740 275 539'),
 ('Nompie', 'Mthombeni', 'nmbrotty@gmail.com', '+27 81 449 1343'),
('Esther', 'Mungai', 'muigai.esthern@gmail.com', '+254 111 874203');

-- -- -- Insert into customer_address
INSERT INTO customer_address (customer_id, address_id, address_status_id) VALUES
(1, 2, 1),
(2, 2, 1),
(3, 3, 1);

-- -- Insert into publisher
INSERT INTO publisher (name, contact_email, contact_phone) VALUES
('Gerald Publishing', 'gerald@publish.com', '0700987654'),
('Zablon Books', 'zablon@books.com', '0734567890');

-- Insert into book_languag
INSERT INTO book_language (language_name) VALUES 
('English'), ('Swahili'), ('Zulu');

-- -- Insert into author
INSERT INTO author (first_name, last_name, bio) VALUES
('Chinua', 'Achebe', 'Nigerian novelist and poet, best known for *Things Fall Apart*.'),
('Ngũgĩ', 'wa Thiong’o', 'Kenyan writer and academic, wrote *Decolonising the Mind*.'),
('Maya', 'Angelou', 'American poet and civil rights activist.');

-- -- Insert into book
INSERT INTO book (title, isbn, publication_year, price, language_id, publisher_id, stock_quantity) VALUES
('Things Fall Apart', '9780141023380', 1958, 15.99, 1, 1, 50),
('Petals of Blood', '9780435908444', 1977, 17.50, 2, 2, 30),
 ('I Know Why the Caged Bird Sings', '9780345514400', 1969, 18.00, 1, 1, 40);

-- -- Insert into book_author
INSERT INTO book_author (book_id, author_id) VALUES
(1, 1),
(2, 2),
(3, 3);

-- -- Insert into shipping_method
INSERT INTO shipping_method (method_name, shipping_cost) VALUE
('Standard Shipping', 5.00),
('Express Shipping', 10.00);

-- -- Insert into order_status
INSERT INTO order_status (status_name) VALUES
('Pending'), ('Shipped'), ('Delivered'), ('Cancelled');

-- -- Insert into cust_order
INSERT INTO cust_order (customer_id, shipping_method_id, order_status_id, shipping_address_id, billing_address_id)
 VALUES
(1, 1, 1, 1, 1),
 (2, 2, 2, 2, 2);

-- -- Insert into order_line
 INSERT INTO order_line (order_id, book_id, quantity, price_at_order_time) VALUES
 (1, 1, 2, 15.99),
(1, 2, 1, 17.50),
(2, 3, 1, 18.00);

-- Insert into order_history
 INSERT INTO order_history (order_id, status_id) VALUES
 (1, 1),
(1, 2),
(2, 2),
(2, 3);


-- use bookstoremanagementsystem;
-- Creating roles for different access levels
CREATE ROLE 'bookstoreAdmin', 'bookstoreManager', 'bookstoreStaff', 'bookstoreReporter';

-- We will Grant all privileges to admin role (full control)
GRANT ALL PRIVILEGES ON bookstoremanagementsystem.* TO 'bookstoreAdmin';

-- Grant manager role (can manage data but not structure)
GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE ON bookstoremanagementsystem.* TO 'bookstoreManager';

-- Grant staff role (limited to customer and order operations)
-- Customer and Order management access
-- First create the roles if they don't exist
CREATE ROLE IF NOT EXISTS 'bookstoreAdmin', 'bookstoreManager', 'bookstoreStaff', 'bookstoreReporter';

-- Grant permissions to staff role (corrected GRANT spelling)
GRANT SELECT, INSERT, UPDATE ON bookstoremanagementsystem.customer TO 'bookstoreStaff';
GRANT SELECT, INSERT, UPDATE ON bookstoremanagementsystem.customer_address TO 'bookstoreStaff';
GRANT SELECT, INSERT, UPDATE ON bookstoremanagementsystem.cust_order TO 'bookstoreStaff';
GRANT SELECT, INSERT, UPDATE ON bookstoremanagementsystem.order_line TO 'bookstoreStaff';    
GRANT SELECT, INSERT, UPDATE ON bookstoremanagementsystem.order_history TO 'bookstoreStaff';


-- Inventory management access for staff
GRANT SELECT, INSERT, UPDATE ON bookstoremanagementsystem.book TO 'bookstoreStaff';
GRANT SELECT, INSERT, UPDATE ON bookstoremanagementsystem.book_author TO 'bookstoreStaff';
GRANT SELECT, INSERT, UPDATE ON bookstoremanagementsystem.author TO 'bookstoreStaff';
GRANT SELECT, INSERT, UPDATE ON bookstoremanagementsystem.publisher TO 'bookstoreStaff';


-- Grant reporting role (read-only)
GRANT SELECT ON bookstoremanagementsystem.* TO 'bookstoreReporter';

-- Create users
CREATE USER IF NOT EXISTS 'admin_godswill'@'localhost' IDENTIFIED BY 'StrongAdminPass123!';
CREATE USER IF NOT EXISTS 'manager_Nompie'@'localhost' IDENTIFIED BY 'ManagerPass456!';
CREATE USER IF NOT EXISTS 'staff_Esther'@'localhost' IDENTIFIED BY 'StaffPass789!';
CREATE USER IF NOT EXISTS 'analyst_goddy'@'localhost' IDENTIFIED BY 'AnalystPass101!';

-- Assign roles to users
GRANT 'bookstoreAdmin' TO 'admin_godswill'@'localhost';
GRANT 'bookstoreManager' TO 'manager_Nompie'@'localhost';
GRANT 'bookstoreStaff' TO 'staff_Esther'@'localhost';
GRANT 'bookstoreReporter' TO 'analyst_goddy'@'localhost';

-- Set default roles
SET DEFAULT ROLE ALL TO
    'admin_godswill'@'localhost',
    'manager_Nompie'@'localhost',
    'staff_Esther'@'localhost',
    'analyst_goddy'@'localhost';

-- Create application user
CREATE USER IF NOT EXISTS 'bookstoremanagementsystem_app'@'%' IDENTIFIED BY 'AppSecurePass2025!';
GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE ON bookstoremanagementsystem.* TO 'bookstoremanagementsystem_app'@'%';

-- Create read replica user (replace 'replica-server-ip' with actual IP)
CREATE USER IF NOT EXISTS 'replica_user'@'replica-server-ip' IDENTIFIED BY 'ReplicaPass123!';
GRANT REPLICATION SLAVE, SELECT ON *.* TO 'replica_user'@'replica-server-ip';

-- Create backup user
CREATE USER IF NOT EXISTS 'backup_user'@'localhost' IDENTIFIED BY 'BackupPass456!';
GRANT SELECT, RELOAD, LOCK TABLES, REPLICATION CLIENT, SHOW VIEW, EVENT, TRIGGER ON *.* TO 'backup_user'@'localhost';

-- Flush privileges
FLUSH PRIVILEGES;


