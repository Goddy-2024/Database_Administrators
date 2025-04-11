#  Bookstore Database Design & SQL Programming
### By Database_Administrators Group

##  Overview

This project simulates a real-world bookstore system using **MySQL**. As Database Administrators, we have designed and implemeneted a relational database to manage books, authors, customers, orders, shipping methods, and more.

The project focuses on practical database skills including schema design, data loading, user management, and running queries for analysis.

---

##  Tools & Technologies

- **MySQL** – for building and managing the database
- **Draw.io (diagrams.net)** – for creating the Entity Relationship Diagram (ERD)

---

##  Prerequisites

To have successfully completed this project, we are familiar with:

- Basic SQL syntax and commands
- Table creation and relationships in MySQL
- Primary keys, foreign keys, and normalization
- Managing users and permissions in MySQL

---

##  Project Objective

To Design and implement a MySQL database for a bookstore with the following goals:

- Efficient data storage and retrieval
- Clear relationships between entities
- Secure user access control
- Capability for analytical queries

---

##  Tables Overview

| Table Name         | Description |
|--------------------|-------------|
| `book`             | Information about books |
| `author`           | List of authors |
| `book_author`      | Many-to-many relationship between books and authors |
| `book_language`    | Languages books are available in |
| `publisher`        | Book publishers |
| `customer`         | Customer details |
| `customer_address` | Links customers to addresses |
| `address_status`   | Status of an address (e.g. current, old) |
| `address`          | All addresses in the system |
| `country`          | Countries where customers are located |
| `cust_order`       | Orders placed by customers |
| `order_line`       | Books included in each order |
| `shipping_method`  | Available shipping methods |
| `order_history`    | Historical record of order changes |
| `order_status`     | Possible order statuses |

---

## 🛡️ User & Role Management

Roles to implement:

- `admin`: Full access to manage data
- `readonly_user`: Read-only access for reporting

Use `GRANT` and `REVOKE` statements to assign permissions based on roles.

---

## 🚀 Setup Instructions

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/bookstore-database.git
   cd bookstore-database
