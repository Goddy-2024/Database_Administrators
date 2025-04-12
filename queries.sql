-- 1.1 Get all books with their authors
SELECT 
    b.book_id, 
    b.title, 
    GROUP_CONCAT(CONCAT(a.first_name, ' ', a.last_name) SEPARATOR ', ') AS authors,
    b.price,
    p.name AS publisher
FROM 
    book b
JOIN 
    book_author ba ON b.book_id = ba.book_id
JOIN 
    author a ON ba.author_id = a.author_id
JOIN 
    publisher p ON b.publisher_id = p.publisher_id
GROUP BY 
    b.book_id
LIMIT 10;

-- 1.2 Get customer information with addresses
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    c.phone,
    a.street,
    a.city,
    a.state,
    a.postal_code,
    co.country_name
FROM 
    customer c
JOIN 
    customer_address ca ON c.customer_id = ca.customer_id
JOIN 
    address a ON ca.address_id = a.address_id
JOIN 
    country co ON a.country_id = co.country_id
LIMIT 10;
 -- 2. Business Analysis Queries

-- 2.1 Sales by month
SELECT 
    YEAR(co.order_date) AS year,
    MONTH(co.order_date) AS month,
    COUNT(DISTINCT co.order_id) AS total_orders,
    SUM(ol.quantity * ol.price_at_order_time) AS total_sales
FROM 
    cust_order co
JOIN 
    order_line ol ON co.order_id = ol.order_id
GROUP BY 
    YEAR(co.order_date), MONTH(co.order_date)
ORDER BY 
    year DESC, month DESC;

-- 2.2 Top selling books
SELECT 
    b.book_id,
    b.title,
    SUM(ol.quantity) AS total_sold,
    SUM(ol.quantity * ol.price_at_order_time) AS revenue
FROM 
    order_line ol
JOIN 
    book b ON ol.book_id = b.book_id
GROUP BY 
    b.book_id, b.title
ORDER BY 
    total_sold DESC
LIMIT 10;

-- 2.3 Customer purchase history
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(DISTINCT co.order_id) AS total_orders,
    SUM(ol.quantity * ol.price_at_order_time) AS total_spent
FROM 
    customer c
JOIN 
    cust_order co ON c.customer_id = co.customer_id
JOIN 
    order_line ol ON co.order_id = ol.order_id
GROUP BY 
    c.customer_id, customer_name
ORDER BY 
    total_spent DESC
LIMIT 10;
 -- 3. Inventory Management Queries

-- 3.1 Low stock alert
SELECT 
    book_id,
    title,
    stock_quantity
FROM 
    book
WHERE 
    stock_quantity < 5
ORDER BY 
    stock_quantity ASC;

-- 3.2 Books by language
SELECT 
    bl.language_name,
    COUNT(b.book_id) AS book_count
FROM 
    book b
JOIN 
    book_language bl ON b.language_id = bl.language_id
GROUP BY 
    bl.language_name
ORDER BY 
    book_count DESC;

-- 3.3 Publisher performance
SELECT 
    p.publisher_id,
    p.name AS publisher_name,
    COUNT(b.book_id) AS books_published,
    SUM(b.stock_quantity) AS total_inventory
FROM 
    publisher p
JOIN 
    book b ON p.publisher_id = b.publisher_id
GROUP BY 
    p.publisher_id, p.name
ORDER BY 
    books_published DESC;
-- 4. Order Processing Queries

-- 4.1 Current pending orders
SELECT 
    co.order_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    co.order_date,
    os.status_name,
    sm.method_name AS shipping_method
FROM 
    cust_order co
JOIN 
    customer c ON co.customer_id = c.customer_id
JOIN 
    order_status os ON co.order_status_id = os.order_status_id
JOIN 
    shipping_method sm ON co.shipping_method_id = sm.shipping_method_id
WHERE 
    os.status_name IN ('Pending', 'Processing')
ORDER BY 
    co.order_date ASC;

-- 4.2 Order details with shipping address
SELECT 
    co.order_id,
    co.order_date,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    a.street,
    a.city,
    a.state,
    a.postal_code,
    co.country_name,
    os.status_name,
    oh.status_date AS last_status_update
FROM 
    cust_order co
JOIN 
    customer c ON co.customer_id = c.customer_id
JOIN 
    address a ON co.shipping_address_id = a.address_id
JOIN 
    country co ON a.country_id = co.country_id
JOIN 
    order_status os ON co.order_status_id = os.order_status_id
JOIN 
    order_history oh ON co.order_id = oh.order_id
WHERE 
    co.order_id = 1; -- Replace with actual order ID
-- 5. Advanced Analytical Queries

-- 5.1 Monthly sales growth
WITH monthly_sales AS (
    SELECT 
        YEAR(order_date) AS year,
        MONTH(order_date) AS month,
        SUM(ol.quantity * ol.price_at_order_time) AS monthly_sales
    FROM 
        cust_order co
    JOIN 
        order_line ol ON co.order_id = ol.order_id
    GROUP BY 
        YEAR(order_date), MONTH(order_date)
)
SELECT 
    year,
    month,
    monthly_sales,
    LAG(monthly_sales) OVER (ORDER BY year, month) AS prev_month_sales,
    ROUND((monthly_sales - LAG(monthly_sales) OVER (ORDER BY year, month)) / 
        LAG(monthly_sales) OVER (ORDER BY year, month) * 100, 2) AS growth_percentage
FROM 
    monthly_sales
ORDER BY 
    year DESC, month DESC;

-- 5.2 Customer retention analysis
SELECT 
    first_year,
    COUNT(DISTINCT customer_id) AS new_customers,
    SUM(CASE WHEN years_active > 0 THEN 1 ELSE 0 END) AS retained_year1,
    ROUND(SUM(CASE WHEN years_active > 0 THEN 1 ELSE 0 END) / COUNT(DISTINCT customer_id) * 100, 2) AS retention_rate
FROM (
    SELECT 
        c.customer_id,
        YEAR(MIN(co.order_date)) AS first_year,
        COUNT(DISTINCT YEAR(co.order_date)) - 1 AS years_active
    FROM 
        customer c
    JOIN 
        cust_order co ON c.customer_id = co.customer_id
    GROUP BY 
        c.customer_id
) AS customer_stats
GROUP BY 
    first_year
ORDER BY 
    first_year;
-- 6. Testing User Permissions

-- Test staff permissions (run as staff_Esther)
-- Should work:
SELECT * FROM customer WHERE customer_id = 1;
UPDATE book SET stock_quantity = stock_quantity - 1 WHERE book_id = 1;

-- Should fail (no delete permission):
DELETE FROM customer WHERE customer_id = 1;

-- Test reporter permissions (run as analyst_goddy)
-- Should work:
SELECT * FROM cust_order LIMIT 10;

-- Should fail (no update permission):
UPDATE book SET price = 19.99 WHERE book_id = 1;
