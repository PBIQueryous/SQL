--// Title: SQL Assessment
--// Author: Imran Haq (Business Intelligence and Data Analytics Officer)

--// Optional: view UnprocessedOrders (fact table)
SELECT * FROM UnProcessedOrders AS unp;

/*** copy UnprocessedOrders data to Products (dim table) ***/
SET IDENTITY_INSERT Products ON         -- enable data insert
INSERT INTO Products                    -- insert into destination Products columns
(
    ID,
    Name
)
SELECT DISTINCT                         -- select distinct values to copy from desired columns in UnProcessedOrders table
    p.ProductID,
    p.ProductName
FROM UnProcessedOrders AS p
ORDER BY p.ProductID
SET IDENTITY_INSERT Products OFF;       -- disable data insert

/*** copy UnprocessedOrders to Customers (dim table)  ***/
SET IDENTITY_INSERT Customers ON        -- enable data insert
INSERT INTO Customers                   -- insert into destination Customers columns 
(
    ID,
    CustomerName,
    CustomerEmailAddress
)
SELECT DISTINCT
    c.CustomerID,                       -- select distinct values to copy from desired columns in UnProcessedOrders table
    CONCAT( c.CustomerFirstName, ' ', c.CustomerLastName ) AS CustomerName,	-- concat First and Last name to single column
    c.CustomerEmailAddress
FROM UnProcessedOrders AS c
ORDER BY c.CustomerID
SET IDENTITY_INSERT Customers OFF;      -- disable data insert

/*** copy UnprocessedOrders to Orders (fact table)  ***/
SET IDENTITY_INSERT Orders ON           -- enable data insert
INSERT INTO Orders                      -- insert into destination Orders columns
(
    ID,
    Customer_FK,
    Product_FK,
    OrderDescription
)
SELECT                                  -- select all values to copy from desired columns in UnProcessedOrders table
    o.OrderID,
    o.CustomerID AS Customer_FK,
    o.ProductID AS Product_FK,
    o.OrderDescription
FROM UnProcessedOrders AS o
ORDER BY o.OrderID
SET IDENTITY_INSERT Orders OFF;         -- disable data insert

/*** Optional: view results in Orders, Products and Customers tables ***/
SELECT * FROM Orders;                   -- view Orders table
SELECT * FROM Products;                 -- view Products table
SELECT * FROM Customers;                -- view Customers table
