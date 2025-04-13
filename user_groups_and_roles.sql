-- use bookstoremanagementsystem;
-- Creating roles for different access levels
CREATE ROLE 'bookstoreAdmin', 'bookstoreManager', 'bookstoreStaff', 'bookstoreReporter';

-- We will Grant all privileges to admin role (full control)
GRANT ALL PRIVILEGES ON bookstoremanagementsystem.* TO 'bookstoreAdmin';

-- Grant manager role (can manage data but not structure)
GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE ON bookstoremanagementsystem.* TO 'bookstoreManager';

-- Grant staff role (limited to customer and order operations)
-- Customer and Order management access
--  The CREATE USER IF NOT EXISTS statement in MySQL is used to create a new user only if the specified user does not already exist
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
-- Default roles help enforce the principle of least privilege by ensuring users only have access to the privileges defined in their roles.
SET DEFAULT ROLE ALL TO
    'admin_godswill'@'localhost',
    'manager_Nompie'@'localhost',
    'staff_Esther'@'localhost',
    'analyst_goddy'@'localhost';

-- Create application user
CREATE USER IF NOT EXISTS 'bookstoremanagementsystem_app'@'%' IDENTIFIED BY 'AppSecurePass2025!';
GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE ON bookstoremanagementsystem.* TO 'bookstoremanagementsystem_app'@'%';

-- Create read replica user (replace 'replica-server-ip' with actual IP)
-- Replica users are essential in MySQL replication because they allow the replica server to connect to the source server securely and perform replication tasks
CREATE USER IF NOT EXISTS 'replica_user'@'replica-server-ip' IDENTIFIED BY 'ReplicaPass123!';
GRANT REPLICATION SLAVE, SELECT ON *.* TO 'replica_user'@'replica-server-ip';

-- Create backup user 
CREATE USER IF NOT EXISTS 'backup_user'@'localhost' IDENTIFIED BY 'BackupPass456!';
GRANT SELECT, RELOAD, LOCK TABLES, REPLICATION CLIENT, SHOW VIEW, EVENT, TRIGGER ON *.* TO 'backup_user'@'localhost';

-- Flush privileges :This command ensures that any manual changes to the grant tables are applied immediately without needing to restart the MySQL server
FLUSH PRIVILEGES;
