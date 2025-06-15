CREATE SCHEMA SALES;

-- 2. Create tables within the SALES schema

-- Customers Table
CREATE TABLE SALES.Customers (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    Phone VARCHAR(20)
);

-- Products Table
CREATE TABLE SALES.Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10, 2)
);

-- Orders Table
CREATE TABLE SALES.Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES SALES.Customers(CustomerID)
);

-- OrderDetails Table
CREATE TABLE SALES.OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES SALES.Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES SALES.Products(ProductID)
);

-- 3. Insert sample data

-- Insert Customers
INSERT INTO SALES.Customers (CustomerID, FirstName, LastName, Email, Phone) VALUES
(1, 'John', 'Doe', 'john.doe@example.com', '123-456-7890'),
(2, 'Jane', 'Smith', 'jane.smith@example.com', '321-654-0987'),
(3, 'Alice', 'Johnson', 'alice.johnson@example.com', '555-000-1234');

-- Insert Products
INSERT INTO SALES.Products (ProductID, ProductName, Category, Price) VALUES
(101, 'Laptop', 'Electronics', 999.99),
(102, 'Headphones', 'Electronics', 199.99),
(103, 'Desk Chair', 'Furniture', 89.99),
(104, 'Monitor', 'Electronics', 149.99);

-- Insert Orders
INSERT INTO SALES.Orders (OrderID, CustomerID, OrderDate) VALUES
(1001, 1, '2025-05-01'),
(1002, 2, '2025-05-02'),
(1003, 1, '2025-05-03');

-- Insert OrderDetails
INSERT INTO SALES.OrderDetails (OrderDetailID, OrderID, ProductID, Quantity) VALUES
(5001, 1001, 101, 1),
(5002, 1001, 102, 2),
(5003, 1002, 103, 1),
(5004, 1003, 104, 1),
(5005, 1003, 102, 1);

SELECT * FROM SALES.CUSTOMERS 
SELECT * FROM SALES.PRODUCTS 
SELECT * FROM SALES.ORDERS 
SELECT  * FROM SALES.OrderDetails


SELECT OD.ORDERID , 
SUM(OD.QUANTITY * P.PRICE)AS TOTALSPENT
FROM SALES.ORDERDETAILS AS OD
LEFT JOIN SALES.PRODUCTS AS P 
ON P.PRODUCTID = OD.PRODUCTID
GROUP BY OD.ORDERID

CREATE CLUSTERED COLUMNSTORE INDEX IDX_TOTALSPENT
ON SALES.ORDERDETAILS

select * from sales.OrderDetails

create nonclustered index idx_orderid 
on sales.orderdetails(orderid)

select * from sales.OrderDetails
create columnstore index idx_customerid 
on sales.customers (customerid)

select * from sales.Customers

select customerid, firstname , lastname 
, email 
from sales.customers 
where customerid = 2
select * from sales.orders

with cte_totalspent as
(
    select 
        c.CustomerID 
        , sum(od.quantity * p.price) as totalspent
            from sales.customers as c 
            left join sales.Orders as o
            on o.customerid = c.CustomerID
  left join sales.orderdetails as od
  on od.orderid = o.orderid
   left join sales.Products as p 
  on p.productid = od.productid
  group by c.CustomerID
)
select cts.customerid , od.OrderDate,
coalesce(totalspent ,'0')
from cte_totalspent as cts
left join sales.orders as od
on od.customerid = cts.customerid

select* from sales.orders


CREATE TABLE Sales (
    SaleID INT IDENTITY(1,1) PRIMARY KEY,       -- Unique SaleID
    ProductID INT,                              -- Product ID
    StoreID INT,                                -- Store ID
    SaleDate DATE,                              -- Date of the Sale
    Quantity INT,                               -- Quantity Sold
    Revenue DECIMAL(10, 2),                     -- Revenue from the Sale
    CustomerID INT,                             -- Customer ID
    SalespersonID INT                           -- Salesperson ID
);
DECLARE @i INT = 0;

-- Loop to insert 100,000 rows into the Sales table
WHILE @i < 100000
BEGIN
    INSERT INTO Sales (ProductID, StoreID, SaleDate, Quantity, Revenue, CustomerID, SalespersonID)
    VALUES
    (
        ABS(CHECKSUM(NewID())) % 1000 + 1,         -- ProductID: Random product (1-1000)
        ABS(CHECKSUM(NewID())) % 100 + 1,          -- StoreID: Random store (1-100)
        DATEADD(DAY, ABS(CHECKSUM(NewID())) % 365, '2023-01-01'),  -- SaleDate: Random date within 1 year
        ABS(CHECKSUM(NewID())) % 10 + 1,           -- Quantity: Random quantity (1-10)
        (ABS(CHECKSUM(NewID())) % 100 + 1) * 10.0, -- Revenue: Random revenue (10 to 1000)
        ABS(CHECKSUM(NewID())) % 500 + 1,          -- CustomerID: Random customer (1-500)
        ABS(CHECKSUM(NewID())) % 50 + 1            -- SalespersonID: Random salesperson (1-50)
    );
    SET @i = @i + 1;
END;

select customerid , productid from sales 
where productid = 123

create nonclustered columnstore index idx_productid 
on sales (productid)


