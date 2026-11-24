-- ============================================================
-- SQL & Relational Database Design - Expanded Edition
-- Student: ____________________   Group: ________
-- DBMS: SQLite 3  (date differences use julianday())
-- Run:  sqlite3 salesdb.db < solutions.sql
-- Sections: Part I setup | Basic B01-B10 | Scenarios 1-6
-- Modification exercises (B10, 2.5-2.7, 3.8-3.10) run inside
-- BEGIN ... ROLLBACK so the clean reference data is restored.
-- ============================================================

-- ============================================================
-- PART I: TABLE CREATION
-- ============================================================

PRAGMA foreign_keys = ON;

CREATE TABLE Customers (
    CustomerID  INTEGER      PRIMARY KEY,
    FirstName   VARCHAR(50),
    LastName    VARCHAR(50),
    Country     VARCHAR(50),
    Score       INTEGER
);

CREATE TABLE Products (
    ProductID   INTEGER        PRIMARY KEY,
    Product     VARCHAR(100),
    Category    VARCHAR(50),
    Price       DECIMAL(10,2)
);

CREATE TABLE Employees (
    EmployeeID  INTEGER        PRIMARY KEY,
    FirstName   VARCHAR(50),
    LastName    VARCHAR(50),
    Department  VARCHAR(50),
    BirthDate   DATE,
    Gender      VARCHAR(10),
    Salary      DECIMAL(10,2),
    ManagerID   INTEGER        NULL,
    FOREIGN KEY (ManagerID) REFERENCES Employees(EmployeeID)
);

CREATE TABLE Orders (
    OrderID        INTEGER        PRIMARY KEY,
    ProductID      INTEGER        NOT NULL,
    CustomerID     INTEGER        NOT NULL,
    SalesPersonID  INTEGER        NOT NULL,
    OrderDate      DATE,
    ShipDate       DATE           NULL,
    OrderStatus    VARCHAR(30),
    ShipAddress    VARCHAR(150)   NULL,
    BillAddress    VARCHAR(150)   NULL,
    Quantity       INTEGER,
    Sales          DECIMAL(10,2),
    CreationTime   DATETIME,
    FOREIGN KEY (ProductID)     REFERENCES Products(ProductID),
    FOREIGN KEY (CustomerID)    REFERENCES Customers(CustomerID),
    FOREIGN KEY (SalesPersonID) REFERENCES Employees(EmployeeID)
);


-- ============================================================
-- PART I: REFERENCE DATA
-- ============================================================

INSERT INTO Customers (CustomerID, FirstName, LastName, Country, Score) VALUES
  (1, 'Ayla', 'Karimova', 'Azerbaijan', 720),
  (2, 'John', 'Miller', 'USA', 450),
  (3, 'Emma', 'Schmidt', 'Germany', 860),
  (4, 'Sara', 'Martin', 'France', 280),
  (5, 'Lukas', 'Weber', 'Germany', 550),
  (6, 'Noah', 'Adams', 'USA', 610),
  (7, 'Lea', 'Fischer', 'Germany', 680),
  (8, 'Sofia', 'Rossi', 'Italy', 700),
  (9, 'Ali', 'Hasanov', 'Azerbaijan', 330);

INSERT INTO Products (ProductID, Product, Category, Price) VALUES
  (101, 'Wireless Mouse', 'Electronics', 55),
  (102, 'Office Chair', 'Furniture', 230),
  (103, 'Laptop', 'Electronics', 850),
  (104, 'Notebook', 'Stationery', 12),
  (105, 'Smart Phone', 'Electronics', 420),
  (106, 'Standing Desk', 'Furniture', 380),
  (107, 'USB Hub', 'Electronics', 45),
  (108, 'Desk Lamp', 'Furniture', 65);

-- Maya Brown (12) is the manager, so she is inserted first.
INSERT INTO Employees (EmployeeID, FirstName, LastName, Department, BirthDate, Gender, Salary, ManagerID) VALUES
  (12, 'Maya', 'Brown', 'Sales', '1990-07-09', 'Female', 2400, NULL),
  (11, 'David', 'Lee', 'Sales', '1987-05-14', 'Male', 2200, 12),
  (13, 'Alex', 'Green', 'Support', '1994-11-21', 'Male', 1900, 12),
  (14, 'Omar', 'Ali', 'Sales', '1995-02-17', 'Male', 2100, 12),
  (15, 'Nina', 'Stone', 'Sales', '1998-08-03', 'Female', 2000, 12);

-- Orders 201-204 (original) and 205-224 (additional). CreationTime = OrderDate + 10:00:00.
INSERT INTO Orders (OrderID, ProductID, CustomerID, SalesPersonID, OrderDate, ShipDate, OrderStatus,
                    ShipAddress, BillAddress, Quantity, Sales, CreationTime) VALUES
  (201, 101, 1, 11, '2026-10-04', '2026-10-06', 'Delivered', '10 Nizami St, Baku', '10 Nizami St, Baku', 2, 110, '2026-10-04 10:00:00'),
  (202, 103, 3, 12, '2026-10-08', '2026-10-18', 'Shipped', '22 Oak St, Berlin', '22 Oak St, Berlin', 1, 850, '2026-10-08 10:00:00'),
  (203, 102, 2, 11, '2026-10-12', NULL, 'Pending', NULL, '45 Main St, New York', 1, 230, '2026-10-12 10:00:00'),
  (204, 105, 5, 12, '2026-10-15', '2026-10-19', 'Delivered', '16 Park Rd, Munich', '16 Park Rd, Munich', 1, 420, '2026-10-15 10:00:00'),
  (205, 103, 3, 12, '2026-10-20', '2026-10-22', 'Delivered', '22 Oak St, Berlin', '22 Oak St, Berlin', 8, 6800, '2026-10-20 10:00:00'),
  (206, 105, 2, 11, '2026-10-21', '2026-10-23', 'Delivered', '45 Main St, New York', '9 Pine St, Boston', 3, 1260, '2026-10-21 10:00:00'),
  (207, 102, 6, 14, '2026-10-22', '2026-10-24', 'Delivered', '31 Oak St, Boston', '31 Oak St, Boston', 4, 920, '2026-10-22 10:00:00'),
  (208, 101, 4, 11, '2026-10-23', NULL, 'Pending', NULL, '8 Rue Lyon, Paris', 2, 110, '2026-10-23 10:00:00'),
  (209, 106, 1, 14, '2026-10-24', '2026-10-27', 'Delivered', '10 Nizami St, Baku', '10 Nizami St, Baku', 2, 760, '2026-10-24 10:00:00'),
  (210, 103, 6, 14, '2026-10-25', NULL, 'Cancelled', '31 Oak St, Boston', '31 Oak St, Boston', 2, 1700, '2026-10-25 10:00:00'),
  (211, 104, 5, 11, '2026-10-26', '2026-10-28', 'Delivered', '16 Park Rd, Munich', '16 Park Rd, Munich', 10, 120, '2026-10-26 10:00:00'),
  (212, 105, 3, 12, '2026-10-27', NULL, 'Pending', NULL, '22 Oak St, Berlin', 2, 840, '2026-10-27 10:00:00'),
  (213, 107, 2, 11, '2026-10-28', '2026-10-30', 'Shipped', '45 Main St, New York', '45 Main St, New York', 3, 135, '2026-10-28 10:00:00'),
  (214, 103, 8, 14, '2026-10-29', '2026-11-01', 'Delivered', '18 Via Roma, Milan', '18 Via Roma, Milan', 1, 850, '2026-10-29 10:00:00'),
  (215, 106, 5, 12, '2026-10-30', NULL, 'Pending', '16 Park Rd, Munich', '16 Park Rd, Munich', 1, 380, '2026-10-30 10:00:00'),
  (216, 101, 1, 11, '2026-11-02', '2026-11-04', 'Delivered', '10 Nizami St, Baku', '10 Nizami St, Baku', 1, 55, '2026-11-02 10:00:00'),
  (217, 102, 7, 14, '2026-11-03', '2026-11-05', 'Shipped', '9 River St, Berlin', '9 River St, Berlin', 1, 230, '2026-11-03 10:00:00'),
  (218, 105, 6, 14, '2026-11-04', NULL, 'Pending', '31 Oak St, Boston', NULL, 1, 420, '2026-11-04 10:00:00'),
  (219, 103, 3, 12, '2026-11-05', '2026-11-06', 'Shipped', '22 Oak St, Berlin', '22 Oak St, Berlin', 1, 850, '2026-11-05 10:00:00'),
  (220, 104, 2, 11, '2026-11-06', '2026-11-07', 'Delivered', '45 Main St, New York', '45 Main St, New York', 5, 60, '2026-11-06 10:00:00'),
  (221, 107, 6, 14, '2026-10-28', NULL, 'Shipped', '31 Oak St, Boston', '31 Oak St, Boston', 1, 45, '2026-10-28 10:00:00'),
  (222, 102, 4, 11, '2026-10-31', '2026-10-30', 'Shipped', '8 Rue Lyon, Paris', '8 Rue Lyon, Paris', 1, 230, '2026-10-31 10:00:00'),
  (223, 102, 2, 11, '2026-10-29', '2026-10-31', 'Delivered', '45 Main St, New York', '45 Main St, New York', 1, 230, '2026-10-29 10:00:00'),
  (224, 101, 3, 12, '2026-11-02', NULL, 'Pending', '22 Oak St, Berlin', '22 Oak St, Berlin', 2, 110, '2026-11-02 10:00:00');


-- Verification: expected 9 / 8 / 5 / 24
SELECT 'Customers' AS TableName, COUNT(*) AS Rows FROM Customers
UNION ALL SELECT 'Products',  COUNT(*) FROM Products
UNION ALL SELECT 'Employees', COUNT(*) FROM Employees
UNION ALL SELECT 'Orders',    COUNT(*) FROM Orders;
PRAGMA foreign_key_check;   -- no rows = all IDs valid


-- ============================================================
-- BASIC SQL TASKS B01-B10
-- ============================================================

-- B01  Explore a table
SELECT * FROM Customers;

SELECT FirstName, LastName, Country FROM Customers;


-- B02  Filter by country
SELECT CustomerID, FirstName, LastName, Country
FROM Customers
WHERE Country = 'Germany';


-- B03  Combine conditions
SELECT CustomerID, FirstName, LastName, Country, Score
FROM Customers
WHERE Score >= 300
  AND Country IN ('Germany', 'France');


-- B04  Sort products
SELECT ProductID, Product, Category, Price
FROM Products
ORDER BY Price DESC;


-- B05  Search within a range
SELECT Product, Price
FROM Products
WHERE Price BETWEEN 50 AND 300;


-- B06  Search text patterns
SELECT Product, Category
FROM Products
WHERE Product LIKE '%Phone%';


-- B07  Find distinct values
SELECT DISTINCT Category
FROM Products
ORDER BY Category;


-- B08  Connect customer orders
SELECT o.OrderID, c.FirstName, c.LastName
FROM Orders AS o
INNER JOIN Customers AS c ON c.CustomerID = o.CustomerID
ORDER BY o.OrderID;


-- B09  Summarize orders
SELECT OrderStatus,
       COUNT(*)   AS OrderCount,
       SUM(Sales) AS TotalSales
FROM Orders
GROUP BY OrderStatus
ORDER BY TotalSales DESC;


-- B10  Make a safe data change (practice copy)
-- Note: A WHERE clause restricts UPDATE and DELETE to the exact row(s) named. Without it, UPDATE would change the Price of every product and DELETE would remove every row of the table. Here WHERE ProductID = 900 touches only the test product; the previewing SELECT before and after proves that no other row was affected.
BEGIN;  -- practice copy: everything is rolled back at the end

INSERT INTO Products (ProductID, Product, Category, Price)
VALUES (900, 'Test Item', 'Test', 10.00);

SELECT * FROM Products WHERE ProductID = 900;

UPDATE Products SET Price = 15.00 WHERE ProductID = 900;

SELECT * FROM Products WHERE ProductID = 900;

DELETE FROM Products WHERE ProductID = 900;

SELECT COUNT(*) AS ProductsAfterDelete FROM Products;

ROLLBACK;



-- ============================================================
-- SCENARIO 1 - Customer loyalty and sales analysis
-- ============================================================

-- 1.1  High-score customers
SELECT FirstName, LastName, Country, Score
FROM Customers
WHERE Score > 500
ORDER BY Score DESC;


-- 1.2  Target countries
SELECT FirstName || ' ' || LastName AS CustomerName, Country, Score
FROM Customers
WHERE Country IN ('Germany', 'France', 'USA')
  AND Score >= 300;


-- 1.3  Purchase history
SELECT c.FirstName || ' ' || c.LastName AS CustomerName,
       o.OrderID, o.OrderDate, o.Sales
FROM Customers AS c
INNER JOIN Orders AS o ON o.CustomerID = c.CustomerID
ORDER BY o.OrderID;


-- 1.4  Inactive customers
SELECT c.CustomerID, c.FirstName || ' ' || c.LastName AS CustomerName, c.Country
FROM Customers AS c
LEFT JOIN Orders AS o ON o.CustomerID = c.CustomerID
WHERE o.OrderID IS NULL;


-- 1.5  Total customer spending
SELECT c.CustomerID,
       c.FirstName || ' ' || c.LastName AS CustomerName,
       c.Country,
       SUM(o.Sales) AS TotalSales
FROM Customers AS c
INNER JOIN Orders AS o ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName, c.Country
ORDER BY TotalSales DESC, c.CustomerID;


-- 1.6  Loyalty threshold
SELECT c.CustomerID,
       c.FirstName || ' ' || c.LastName AS CustomerName,
       c.Country,
       SUM(o.Sales) AS TotalSales
FROM Customers AS c
INNER JOIN Orders AS o ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName, c.Country
HAVING SUM(o.Sales) > 1000
ORDER BY TotalSales DESC, c.CustomerID;


-- 1.7  Top-five report
SELECT c.CustomerID,
       c.FirstName || ' ' || c.LastName AS CustomerName,
       c.Country,
       SUM(o.Sales) AS TotalSales
FROM Customers AS c
INNER JOIN Orders AS o ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName, c.Country
ORDER BY TotalSales DESC, c.CustomerID
LIMIT 5;



-- ============================================================
-- SCENARIO 2 - Order and delivery investigation
-- ============================================================

-- 2.1  October orders
SELECT OrderID, CustomerID, OrderDate, ShipDate, OrderStatus
FROM Orders
WHERE OrderDate BETWEEN '2026-10-01' AND '2026-10-31'
ORDER BY OrderDate, OrderID;


-- 2.2  Pending queue
SELECT *
FROM Orders
WHERE OrderStatus = 'Pending'
ORDER BY OrderDate ASC, OrderID;


-- 2.3  Late shipments
-- Note: SQLite has no DATEDIFF; julianday() converts a date to a day number, so the difference is in days.
SELECT o.OrderID,
       c.FirstName || ' ' || c.LastName AS CustomerName,
       o.OrderDate, o.ShipDate
FROM Orders AS o
INNER JOIN Customers AS c ON c.CustomerID = o.CustomerID
WHERE julianday(o.ShipDate) - julianday(o.OrderDate) > 7;


-- 2.4  Affected customers
SELECT DISTINCT c.CustomerID,
       c.FirstName || ' ' || c.LastName AS CustomerName,
       c.Country
FROM Orders AS o
INNER JOIN Customers AS c ON c.CustomerID = o.CustomerID
WHERE julianday(o.ShipDate) - julianday(o.OrderDate) > 7;


-- 2.5-2.7  Status, address correction and test-data removal (practice copy)
BEGIN;  -- practice copy, rolled back at the end

-- 2.5  Ensure OrderID 105 exists, preview, update, verify
INSERT OR IGNORE INTO Orders (OrderID, ProductID, CustomerID, SalesPersonID, OrderDate, ShipDate,
                              OrderStatus, ShipAddress, BillAddress, Quantity, Sales, CreationTime)
VALUES (105, 101, 1, 11, '2026-11-03', NULL, 'Pending', NULL, '10 Nizami St, Baku', 1, 55, '2026-11-03 10:00:00');

SELECT OrderID, OrderStatus, ShipDate FROM Orders WHERE OrderID = 105;   -- preview

UPDATE Orders SET OrderStatus = 'Shipped', ShipDate = '2026-11-05' WHERE OrderID = 105;

SELECT OrderID, OrderStatus, ShipDate FROM Orders WHERE OrderID = 105;   -- verify

-- 2.6  Ensure OrderID 110 exists, preview, update, verify
INSERT OR IGNORE INTO Orders (OrderID, ProductID, CustomerID, SalesPersonID, OrderDate, ShipDate,
                              OrderStatus, ShipAddress, BillAddress, Quantity, Sales, CreationTime)
VALUES (110, 104, 9, 14, '2026-11-04', NULL, 'Pending', NULL, '10 Nizami St, Baku', 1, 12, '2026-11-04 10:00:00');

SELECT OrderID, ShipAddress FROM Orders WHERE OrderID = 110;   -- preview

UPDATE Orders SET ShipAddress = '45 Main Street, Baku' WHERE OrderID = 110;

SELECT OrderID, ShipAddress FROM Orders WHERE OrderID = 110;   -- verify

-- 2.7  Temporary test record 999: create, preview, delete only this row
INSERT OR IGNORE INTO Orders (OrderID, ProductID, CustomerID, SalesPersonID, OrderDate, ShipDate,
                              OrderStatus, ShipAddress, BillAddress, Quantity, Sales, CreationTime)
VALUES (999, 101, 1, 11, '2026-11-07', NULL, 'Pending', NULL, NULL, 1, 55, '2026-11-07 10:00:00');

SELECT OrderID, OrderStatus FROM Orders WHERE OrderID = 999;   -- preview

DELETE FROM Orders WHERE OrderID = 999;

SELECT COUNT(*) AS Rows_with_ID_999 FROM Orders WHERE OrderID = 999;   -- verify

SELECT COUNT(*) AS OrdersInPracticeCopy FROM Orders;   -- 24 + 105 + 110 = 26

ROLLBACK;   -- restore the clean reference data

SELECT COUNT(*) AS OrdersAfterRollback FROM Orders;   -- back to 24


-- 2.8  Status distribution
SELECT OrderStatus, COUNT(*) AS OrderCount
FROM Orders
GROUP BY OrderStatus
ORDER BY OrderCount DESC, OrderStatus;


-- 2.9  Unshipped records
SELECT o.OrderID,
       c.FirstName || ' ' || c.LastName AS CustomerName,
       o.OrderDate, o.OrderStatus
FROM Orders AS o
INNER JOIN Customers AS c ON c.CustomerID = o.CustomerID
WHERE o.ShipDate IS NULL
ORDER BY o.OrderDate, o.OrderID;



-- ============================================================
-- SCENARIO 3 - Products and employee performance
-- ============================================================

-- 3.1  Affordable products
SELECT Product, Category, Price
FROM Products
WHERE Price BETWEEN 50 AND 300
ORDER BY Price ASC;


-- 3.2  Premium electronics
SELECT ProductID, Product, Category, Price
FROM Products
WHERE Category = 'Electronics'
  AND Price > 500;


-- 3.3  Product sales
SELECT p.Product, p.Category, o.Quantity, o.Sales
FROM Products AS p
INNER JOIN Orders AS o ON o.ProductID = p.ProductID
ORDER BY o.OrderID;


-- 3.4  Best-selling products
SELECT p.ProductID, p.Product, SUM(o.Quantity) AS TotalQuantity
FROM Products AS p
INNER JOIN Orders AS o ON o.ProductID = p.ProductID
GROUP BY p.ProductID, p.Product
ORDER BY TotalQuantity DESC, p.ProductID
LIMIT 5;


-- 3.5  Unsold items
SELECT p.ProductID, p.Product, p.Category, p.Price
FROM Products AS p
LEFT JOIN Orders AS o ON o.ProductID = p.ProductID
WHERE o.OrderID IS NULL;


-- 3.6  Employee performance
SELECT e.EmployeeID,
       e.FirstName || ' ' || e.LastName AS EmployeeName,
       e.Department,
       SUM(o.Sales) AS TotalSales
FROM Employees AS e
INNER JOIN Orders AS o ON o.SalesPersonID = e.EmployeeID
GROUP BY e.EmployeeID, e.FirstName, e.LastName, e.Department
ORDER BY e.EmployeeID;


-- 3.7  Top-performing staff
SELECT e.EmployeeID,
       e.FirstName || ' ' || e.LastName AS EmployeeName,
       e.Department,
       SUM(o.Sales) AS TotalSales
FROM Employees AS e
INNER JOIN Orders AS o ON o.SalesPersonID = e.EmployeeID
GROUP BY e.EmployeeID, e.FirstName, e.LastName, e.Department
HAVING SUM(o.Sales) > 5000
ORDER BY TotalSales DESC;


-- 3.8-3.10  New product, price correction and inventory column (practice copy)
BEGIN;  -- practice copy, rolled back at the end

-- 3.8  Insert the new product
INSERT INTO Products (ProductID, Product, Category, Price)
VALUES (501, 'Wireless Keyboard', 'Electronics', 75);

SELECT * FROM Products WHERE ProductID = 501;

-- 3.9  Correct the price
UPDATE Products SET Price = 90 WHERE ProductID = 501;

SELECT * FROM Products WHERE ProductID = 501;

-- 3.10  Add the inventory column
ALTER TABLE Products ADD COLUMN StockQuantity INTEGER;

SELECT * FROM Products WHERE ProductID = 501;   -- StockQuantity is NULL until filled

ROLLBACK;   -- restore the reference structure and data

SELECT COUNT(*) AS ProductsAfterRollback FROM Products;   -- back to 8


-- 3.11  Combined directory
SELECT FirstName, LastName FROM Customers
UNION
SELECT FirstName, LastName FROM Employees
ORDER BY LastName, FirstName;


-- 3.12  Category performance
SELECT p.Category,
       SUM(o.Quantity) AS TotalQuantity,
       SUM(o.Sales)    AS TotalSales
FROM Products AS p
INNER JOIN Orders AS o ON o.ProductID = p.ProductID
GROUP BY p.Category
HAVING SUM(o.Sales) > 2000
ORDER BY TotalSales DESC;



-- ============================================================
-- SCENARIO 4 - Targeted campaign planning
-- ============================================================

-- 4.1  Campaign sales register
SELECT o.OrderID, o.OrderDate, c.CustomerID,
       c.FirstName || ' ' || c.LastName AS CustomerName,
       c.Country, p.Product, p.Category,
       e.FirstName || ' ' || e.LastName AS EmployeeName,
       o.Quantity, o.Sales
FROM Orders AS o
INNER JOIN Customers AS c ON c.CustomerID  = o.CustomerID
INNER JOIN Products  AS p ON p.ProductID   = o.ProductID
INNER JOIN Employees AS e ON e.EmployeeID  = o.SalesPersonID
WHERE o.OrderStatus IN ('Shipped','Delivered') AND o.ShipDate IS NOT NULL AND o.ShipDate >= o.OrderDate
  AND o.OrderDate BETWEEN '2026-10-01' AND '2026-10-31'
  AND c.Country IN ('Germany','France','USA')
ORDER BY c.Country, o.OrderDate, o.OrderID;


-- 4.2  Priority electronics orders
SELECT o.OrderID, c.CustomerID,
       c.FirstName || ' ' || c.LastName AS CustomerName,
       c.Country, c.Score, p.Product, o.Sales
FROM Orders AS o
INNER JOIN Customers AS c ON c.CustomerID = o.CustomerID
INNER JOIN Products  AS p ON p.ProductID  = o.ProductID
WHERE o.OrderStatus IN ('Shipped','Delivered') AND o.ShipDate IS NOT NULL AND o.ShipDate >= o.OrderDate
  AND o.OrderDate BETWEEN '2026-10-01' AND '2026-10-31'
  AND c.Country IN ('Germany','France','USA')
  AND p.Category = 'Electronics'
  AND (c.Score >= 500 OR o.Sales >= 1000)
ORDER BY o.OrderID;


-- 4.3  Affordable products to promote
SELECT ProductID, Product, Category, Price
FROM Products
WHERE Category = 'Electronics'
  AND Price BETWEEN 40 AND 100
  AND (Product LIKE '%Wireless%' OR Product LIKE '%USB%')
ORDER BY Price, ProductID;


-- 4.4  Unique recipient list
SELECT DISTINCT c.CustomerID, c.FirstName, c.LastName, c.Country, c.Score
FROM Customers AS c
INNER JOIN Orders   AS o ON o.CustomerID = c.CustomerID
INNER JOIN Products AS p ON p.ProductID  = o.ProductID
WHERE c.Country IN ('Germany','France','USA')
  AND c.Score >= 500
  AND p.Category = 'Electronics'
  AND o.OrderStatus IN ('Shipped','Delivered') AND o.ShipDate IS NOT NULL AND o.ShipDate >= o.OrderDate
  AND o.OrderDate BETWEEN '2026-10-01' AND '2026-10-31'
ORDER BY c.CustomerID;


-- 4.5  High-value accounts
SELECT c.CustomerID,
       c.FirstName || ' ' || c.LastName AS CustomerName,
       COUNT(o.OrderID) AS OrderCount,
       SUM(o.Quantity)  AS TotalQuantity,
       SUM(o.Sales)     AS TotalSales
FROM Customers AS c
INNER JOIN Orders AS o ON o.CustomerID = c.CustomerID
WHERE c.Country IN ('Germany','France','USA')
  AND o.OrderStatus IN ('Shipped','Delivered') AND o.ShipDate IS NOT NULL AND o.ShipDate >= o.OrderDate
  AND o.OrderDate BETWEEN '2026-10-01' AND '2026-10-31'
GROUP BY c.CustomerID, c.FirstName, c.LastName
HAVING COUNT(o.OrderID) >= 2 AND SUM(o.Sales) >= 1000
ORDER BY TotalSales DESC, c.CustomerID;


-- 4.6  Country-category demand
SELECT c.Country, p.Category,
       COUNT(o.OrderID) AS OrderCount,
       SUM(o.Quantity)  AS TotalQuantity,
       SUM(o.Sales)     AS TotalSales
FROM Orders AS o
INNER JOIN Customers AS c ON c.CustomerID = o.CustomerID
INNER JOIN Products  AS p ON p.ProductID  = o.ProductID
WHERE o.OrderStatus IN ('Shipped','Delivered') AND o.ShipDate IS NOT NULL AND o.ShipDate >= o.OrderDate
  AND o.OrderDate BETWEEN '2026-10-01' AND '2026-10-31'
  AND c.Country IN ('Germany','France','USA')
GROUP BY c.Country, p.Category
HAVING SUM(o.Sales) > 500
ORDER BY TotalSales DESC, c.Country, p.Category;


-- 4.7  Customers without eligible activity
SELECT c.CustomerID,
       c.FirstName || ' ' || c.LastName AS CustomerName,
       c.Country, c.Score
FROM Customers AS c
LEFT JOIN Orders AS o
       ON o.CustomerID = c.CustomerID
      AND o.OrderStatus IN ('Shipped','Delivered') AND o.ShipDate IS NOT NULL AND o.ShipDate >= o.OrderDate
      AND o.OrderDate BETWEEN '2026-10-01' AND '2026-10-31'
WHERE c.Country IN ('Germany','France','USA')
  AND o.OrderID IS NULL
ORDER BY c.CustomerID;


-- 4.8  Cross-category buyers (INTERSECT)
SELECT o.CustomerID AS CustomerID
FROM Orders AS o
INNER JOIN Customers AS c ON c.CustomerID = o.CustomerID
INNER JOIN Products  AS p ON p.ProductID  = o.ProductID
WHERE o.OrderStatus IN ('Shipped','Delivered') AND o.ShipDate IS NOT NULL AND o.ShipDate >= o.OrderDate AND o.OrderDate BETWEEN '2026-10-01' AND '2026-10-31' AND c.Country IN ('Germany','France','USA')
  AND p.Category = 'Electronics'
INTERSECT
SELECT o.CustomerID AS CustomerID
FROM Orders AS o
INNER JOIN Customers AS c ON c.CustomerID = o.CustomerID
INNER JOIN Products  AS p ON p.ProductID  = o.ProductID
WHERE o.OrderStatus IN ('Shipped','Delivered') AND o.ShipDate IS NOT NULL AND o.ShipDate >= o.OrderDate AND o.OrderDate BETWEEN '2026-10-01' AND '2026-10-31' AND c.Country IN ('Germany','France','USA')
  AND p.Category = 'Furniture'
ORDER BY CustomerID;


-- 4.9  Combined campaign audiences (UNION)
SELECT o.CustomerID AS CustomerID
FROM Orders AS o
INNER JOIN Customers AS c ON c.CustomerID = o.CustomerID
INNER JOIN Products  AS p ON p.ProductID  = o.ProductID
WHERE o.OrderStatus IN ('Shipped','Delivered') AND o.ShipDate IS NOT NULL AND o.ShipDate >= o.OrderDate AND o.OrderDate BETWEEN '2026-10-01' AND '2026-10-31' AND c.Country IN ('Germany','France','USA')
  AND p.Category = 'Electronics'
UNION
SELECT o.CustomerID AS CustomerID
FROM Orders AS o
INNER JOIN Customers AS c ON c.CustomerID = o.CustomerID
INNER JOIN Products  AS p ON p.ProductID  = o.ProductID
WHERE o.OrderStatus IN ('Shipped','Delivered') AND o.ShipDate IS NOT NULL AND o.ShipDate >= o.OrderDate AND o.OrderDate BETWEEN '2026-10-01' AND '2026-10-31' AND c.Country IN ('Germany','France','USA')
  AND p.Category = 'Furniture'
ORDER BY CustomerID;


-- 4.10  Furniture cross-sell list (EXCEPT)
SELECT o.CustomerID AS CustomerID
FROM Orders AS o
INNER JOIN Customers AS c ON c.CustomerID = o.CustomerID
INNER JOIN Products  AS p ON p.ProductID  = o.ProductID
WHERE o.OrderStatus IN ('Shipped','Delivered') AND o.ShipDate IS NOT NULL AND o.ShipDate >= o.OrderDate AND o.OrderDate BETWEEN '2026-10-01' AND '2026-10-31' AND c.Country IN ('Germany','France','USA')
  AND p.Category = 'Electronics'
EXCEPT
SELECT o.CustomerID AS CustomerID
FROM Orders AS o
INNER JOIN Customers AS c ON c.CustomerID = o.CustomerID
INNER JOIN Products  AS p ON p.ProductID  = o.ProductID
WHERE o.OrderStatus IN ('Shipped','Delivered') AND o.ShipDate IS NOT NULL AND o.ShipDate >= o.OrderDate AND o.OrderDate BETWEEN '2026-10-01' AND '2026-10-31' AND c.Country IN ('Germany','France','USA')
  AND p.Category = 'Furniture'
ORDER BY CustomerID;



-- ============================================================
-- SCENARIO 5 - Fulfilment exception desk
-- ============================================================

-- 5.1  Pending work queue
SELECT o.OrderID, o.OrderDate,
       c.FirstName || ' ' || c.LastName AS CustomerName,
       c.Country, p.Product, o.Quantity, o.Sales,
       e.FirstName || ' ' || e.LastName AS EmployeeName,
       o.ShipAddress
FROM Orders AS o
INNER JOIN Customers AS c ON c.CustomerID = o.CustomerID
INNER JOIN Products  AS p ON p.ProductID  = o.ProductID
INNER JOIN Employees AS e ON e.EmployeeID = o.SalesPersonID
WHERE o.OrderStatus = 'Pending'
  AND o.OrderDate <= '2026-11-07'
ORDER BY o.OrderDate, o.OrderID;


-- 5.2  Overdue pending shipments
SELECT o.OrderID,
       c.FirstName || ' ' || c.LastName AS CustomerName,
       o.OrderDate, p.Product,
       e.FirstName || ' ' || e.LastName AS EmployeeName,
       o.Sales
FROM Orders AS o
INNER JOIN Customers AS c ON c.CustomerID = o.CustomerID
INNER JOIN Products  AS p ON p.ProductID  = o.ProductID
INNER JOIN Employees AS e ON e.EmployeeID = o.SalesPersonID
WHERE o.OrderStatus = 'Pending'
  AND o.ShipDate IS NULL
  AND o.OrderDate < '2026-10-31'      -- more than 7 days before 2026-11-07
ORDER BY o.OrderDate, o.OrderID;


-- 5.3  Missing delivery addresses
SELECT o.OrderID, c.CustomerID,
       c.FirstName || ' ' || c.LastName AS CustomerName,
       e.FirstName || ' ' || e.LastName AS EmployeeName,
       o.ShipAddress
FROM Orders AS o
INNER JOIN Customers AS c ON c.CustomerID = o.CustomerID
INNER JOIN Employees AS e ON e.EmployeeID = o.SalesPersonID
WHERE o.OrderStatus = 'Pending'
  AND (o.ShipAddress IS NULL OR o.ShipAddress = '')
ORDER BY o.OrderID;


-- 5.4  Different billing addresses
SELECT o.OrderID,
       c.FirstName || ' ' || c.LastName AS CustomerName,
       o.ShipAddress, o.BillAddress, o.OrderStatus
FROM Orders AS o
INNER JOIN Customers AS c ON c.CustomerID = o.CustomerID
WHERE o.OrderStatus <> 'Cancelled'
  AND o.ShipAddress IS NOT NULL AND o.ShipAddress <> ''
  AND o.BillAddress IS NOT NULL AND o.BillAddress <> ''
  AND o.ShipAddress <> o.BillAddress
ORDER BY o.OrderID;


-- 5.5  Inconsistent shipment records
SELECT o.OrderID, o.OrderStatus, o.OrderDate, o.ShipDate,
       c.FirstName || ' ' || c.LastName AS CustomerName,
       e.FirstName || ' ' || e.LastName AS EmployeeName
FROM Orders AS o
INNER JOIN Customers AS c ON c.CustomerID = o.CustomerID
INNER JOIN Employees AS e ON e.EmployeeID = o.SalesPersonID
WHERE o.ShipDate < o.OrderDate
   OR (o.OrderStatus IN ('Shipped','Delivered') AND o.ShipDate IS NULL)
ORDER BY o.OrderID;


-- 5.6  Late dispatch
SELECT o.OrderID,
       c.FirstName || ' ' || c.LastName AS CustomerName,
       p.Product, o.OrderDate, o.ShipDate,
       CAST(julianday(o.ShipDate) - julianday(o.OrderDate) AS INTEGER) AS DaysToShip
FROM Orders AS o
INNER JOIN Customers AS c ON c.CustomerID = o.CustomerID
INNER JOIN Products  AS p ON p.ProductID  = o.ProductID
WHERE o.OrderStatus <> 'Cancelled'
  AND o.ShipDate IS NOT NULL
  AND o.ShipDate >= o.OrderDate
  AND julianday(o.ShipDate) - julianday(o.OrderDate) > 7
ORDER BY DaysToShip DESC, o.OrderID;


-- 5.7  Pending workload balance
SELECT e.EmployeeID,
       e.FirstName || ' ' || e.LastName AS EmployeeName,
       COUNT(o.OrderID)           AS PendingOrderCount,
       COALESCE(SUM(o.Sales), 0)  AS PendingSales
FROM Employees AS e
LEFT JOIN Orders AS o
       ON o.SalesPersonID = e.EmployeeID
      AND o.OrderStatus = 'Pending'
      AND o.ShipDate IS NULL
WHERE e.Department = 'Sales'
GROUP BY e.EmployeeID, e.FirstName, e.LastName
ORDER BY e.EmployeeID;


-- 5.8  Customers needing one combined follow-up
SELECT c.CustomerID,
       c.FirstName || ' ' || c.LastName AS CustomerName,
       COUNT(o.OrderID) AS PendingOrderCount,
       SUM(o.Sales)     AS PendingSales
FROM Customers AS c
INNER JOIN Orders AS o ON o.CustomerID = c.CustomerID
WHERE o.OrderStatus = 'Pending'
  AND o.ShipDate IS NULL
GROUP BY c.CustomerID, c.FirstName, c.LastName
HAVING COUNT(o.OrderID) >= 2
ORDER BY c.CustomerID;


-- 5.9  Priority support list
SELECT o.OrderID,
       c.FirstName || ' ' || c.LastName AS CustomerName,
       c.Country, p.Product, o.Sales, o.OrderStatus, o.OrderDate, o.ShipDate
FROM Orders AS o
INNER JOIN Customers AS c ON c.CustomerID = o.CustomerID
INNER JOIN Products  AS p ON p.ProductID  = o.ProductID
WHERE o.OrderStatus <> 'Cancelled'
  AND c.Country IN ('Germany','USA')
  AND o.Sales >= 500
  AND (
        (o.OrderStatus = 'Pending' AND o.ShipDate IS NULL)
     OR (o.ShipDate IS NOT NULL
         AND o.ShipDate >= o.OrderDate
         AND julianday(o.ShipDate) - julianday(o.OrderDate) > 7)
      )
ORDER BY o.OrderID;


-- 5.10  Ready-to-dispatch checklist
SELECT o.OrderID,
       c.FirstName || ' ' || c.LastName AS CustomerName,
       c.Country, p.Product, o.Quantity, o.ShipAddress,
       e.FirstName || ' ' || e.LastName AS EmployeeName
FROM Orders AS o
INNER JOIN Customers AS c ON c.CustomerID = o.CustomerID
INNER JOIN Products  AS p ON p.ProductID  = o.ProductID
INNER JOIN Employees AS e ON e.EmployeeID = o.SalesPersonID
WHERE o.OrderStatus = 'Pending'
  AND o.ShipDate IS NULL
  AND o.ShipAddress IS NOT NULL
  AND o.ShipAddress <> ''
ORDER BY c.Country, o.OrderDate, o.OrderID;



-- ============================================================
-- SCENARIO 6 - Sales team review and customer retention
-- ============================================================

-- 6.1  Reporting lines (self join)
SELECT e.EmployeeID,
       e.FirstName || ' ' || e.LastName AS EmployeeName,
       e.Department, e.ManagerID,
       m.FirstName || ' ' || m.LastName AS ManagerName
FROM Employees AS e
LEFT JOIN Employees AS m ON m.EmployeeID = e.ManagerID
ORDER BY e.EmployeeID;


-- 6.2  October scorecard
SELECT e.EmployeeID,
       e.FirstName || ' ' || e.LastName AS EmployeeName,
       COUNT(o.OrderID)           AS OrderCount,
       COALESCE(SUM(o.Quantity),0) AS TotalQuantity,
       COALESCE(SUM(o.Sales),0)    AS TotalSales
FROM Employees AS e
LEFT JOIN Orders AS o
       ON o.SalesPersonID = e.EmployeeID
      AND o.OrderStatus IN ('Shipped','Delivered') AND o.ShipDate IS NOT NULL AND o.ShipDate >= o.OrderDate
      AND o.OrderDate BETWEEN '2026-10-01' AND '2026-10-31'
WHERE e.Department = 'Sales'
GROUP BY e.EmployeeID, e.FirstName, e.LastName
ORDER BY TotalSales DESC, e.EmployeeID;


-- 6.3  Direct-report teams
SELECT m.EmployeeID AS ManagerID,
       m.FirstName || ' ' || m.LastName AS ManagerName,
       COUNT(DISTINCT e.EmployeeID)      AS DirectSalesStaffCount,
       COUNT(o.OrderID)                  AS TeamOrderCount,
       COALESCE(SUM(o.Sales), 0)         AS TeamSales
FROM Employees AS m
INNER JOIN Employees AS e
        ON e.ManagerID = m.EmployeeID
       AND e.Department = 'Sales'
LEFT JOIN Orders AS o
       ON o.SalesPersonID = e.EmployeeID
      AND o.OrderStatus IN ('Shipped','Delivered') AND o.ShipDate IS NOT NULL AND o.ShipDate >= o.OrderDate
      AND o.OrderDate BETWEEN '2026-10-01' AND '2026-10-31'
GROUP BY m.EmployeeID, m.FirstName, m.LastName
ORDER BY m.EmployeeID;


-- 6.4  Staff meeting the monthly target
SELECT e.EmployeeID,
       e.FirstName || ' ' || e.LastName AS EmployeeName,
       COUNT(o.OrderID) AS OrderCount,
       SUM(o.Sales)     AS TotalSales
FROM Employees AS e
INNER JOIN Orders AS o ON o.SalesPersonID = e.EmployeeID
WHERE e.Department = 'Sales'
  AND o.OrderStatus IN ('Shipped','Delivered') AND o.ShipDate IS NOT NULL AND o.ShipDate >= o.OrderDate
  AND o.OrderDate BETWEEN '2026-10-01' AND '2026-10-31'
GROUP BY e.EmployeeID, e.FirstName, e.LastName
HAVING COUNT(o.OrderID) >= 2 AND SUM(o.Sales) >= 1000
ORDER BY TotalSales DESC, e.EmployeeID;


-- 6.5  Customer and country coverage
SELECT e.EmployeeID,
       e.FirstName || ' ' || e.LastName AS EmployeeName,
       COUNT(DISTINCT o.CustomerID) AS DistinctCustomers,
       COUNT(DISTINCT c.Country)    AS DistinctCountries
FROM Employees AS e
LEFT JOIN Orders AS o
       ON o.SalesPersonID = e.EmployeeID
      AND o.OrderStatus IN ('Shipped','Delivered') AND o.ShipDate IS NOT NULL AND o.ShipDate >= o.OrderDate
      AND o.OrderDate BETWEEN '2026-10-01' AND '2026-10-31'
LEFT JOIN Customers AS c ON c.CustomerID = o.CustomerID
WHERE e.Department = 'Sales'
GROUP BY e.EmployeeID, e.FirstName, e.LastName
ORDER BY e.EmployeeID;


-- 6.6  Staff without qualifying October sales
SELECT e.EmployeeID,
       e.FirstName || ' ' || e.LastName AS EmployeeName,
       e.Department
FROM Employees AS e
LEFT JOIN Orders AS o
       ON o.SalesPersonID = e.EmployeeID
      AND o.OrderStatus IN ('Shipped','Delivered') AND o.ShipDate IS NOT NULL AND o.ShipDate >= o.OrderDate
      AND o.OrderDate BETWEEN '2026-10-01' AND '2026-10-31'
WHERE e.Department = 'Sales'
  AND o.OrderID IS NULL
ORDER BY e.EmployeeID;


-- 6.7  Returning customers (INTERSECT)
SELECT o.CustomerID AS CustomerID FROM Orders AS o WHERE o.OrderStatus IN ('Shipped','Delivered') AND o.ShipDate IS NOT NULL AND o.ShipDate >= o.OrderDate AND o.OrderDate BETWEEN '2026-10-01' AND '2026-10-31'
INTERSECT
SELECT o.CustomerID AS CustomerID FROM Orders AS o WHERE o.OrderStatus IN ('Shipped','Delivered') AND o.ShipDate IS NOT NULL AND o.ShipDate >= o.OrderDate AND o.OrderDate BETWEEN '2026-11-01' AND '2026-11-07'
ORDER BY CustomerID;


-- 6.8  Customers not yet returning (EXCEPT)
-- Note: Interpretation: these customers had no qualifying sale by 2026-11-07. This is not proof of permanent inactivity.
SELECT o.CustomerID AS CustomerID FROM Orders AS o WHERE o.OrderStatus IN ('Shipped','Delivered') AND o.ShipDate IS NOT NULL AND o.ShipDate >= o.OrderDate AND o.OrderDate BETWEEN '2026-10-01' AND '2026-10-31'
EXCEPT
SELECT o.CustomerID AS CustomerID FROM Orders AS o WHERE o.OrderStatus IN ('Shipped','Delivered') AND o.ShipDate IS NOT NULL AND o.ShipDate >= o.OrderDate AND o.OrderDate BETWEEN '2026-11-01' AND '2026-11-07'
ORDER BY CustomerID;


-- 6.9  Customers new to the comparison period (EXCEPT, reversed)
-- Note: Interpretation: these customers have no qualifying October sale. This does not mean they are first-time buyers in their whole history.
SELECT o.CustomerID AS CustomerID FROM Orders AS o WHERE o.OrderStatus IN ('Shipped','Delivered') AND o.ShipDate IS NOT NULL AND o.ShipDate >= o.OrderDate AND o.OrderDate BETWEEN '2026-11-01' AND '2026-11-07'
EXCEPT
SELECT o.CustomerID AS CustomerID FROM Orders AS o WHERE o.OrderStatus IN ('Shipped','Delivered') AND o.ShipDate IS NOT NULL AND o.ShipDate >= o.OrderDate AND o.OrderDate BETWEEN '2026-10-01' AND '2026-10-31'
ORDER BY CustomerID;


-- 6.10  Two-period sales register (UNION ALL)
SELECT 'October 2026' AS PeriodLabel, o.OrderID AS OrderID, o.OrderDate AS OrderDate, c.CustomerID AS CustomerID,
       c.FirstName || ' ' || c.LastName AS CustomerName,
       e.FirstName || ' ' || e.LastName AS EmployeeName,
       o.Sales AS Sales
FROM Orders AS o
INNER JOIN Customers AS c ON c.CustomerID = o.CustomerID
INNER JOIN Employees AS e ON e.EmployeeID = o.SalesPersonID
WHERE o.OrderStatus IN ('Shipped','Delivered') AND o.ShipDate IS NOT NULL AND o.ShipDate >= o.OrderDate AND o.OrderDate BETWEEN '2026-10-01' AND '2026-10-31'
UNION ALL
SELECT 'November 01-07' AS PeriodLabel, o.OrderID AS OrderID, o.OrderDate AS OrderDate, c.CustomerID AS CustomerID,
       c.FirstName || ' ' || c.LastName AS CustomerName,
       e.FirstName || ' ' || e.LastName AS EmployeeName,
       o.Sales AS Sales
FROM Orders AS o
INNER JOIN Customers AS c ON c.CustomerID = o.CustomerID
INNER JOIN Employees AS e ON e.EmployeeID = o.SalesPersonID
WHERE o.OrderStatus IN ('Shipped','Delivered') AND o.ShipDate IS NOT NULL AND o.ShipDate >= o.OrderDate AND o.OrderDate BETWEEN '2026-11-01' AND '2026-11-07'
ORDER BY OrderDate, OrderID;

