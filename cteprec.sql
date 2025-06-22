-- Product table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(100),
    Category NVARCHAR(50)
);
--a new producttable has beenn created 
-- Sales table
CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    ProductID INT,
    Quantity INT,
    Price DECIMAL(10, 2),
    SaleDate DATE
);
--a new  sales table has been created so far 

INSERT INTO Products (ProductID, ProductName, Category) VALUES
(1, 'Laptop', 'Electronics'),
(2, 'Smartphone', 'Electronics'),
(3, 'Desk Chair', 'Furniture'),
(4, 'Bluetooth Speaker', 'Electronics'),
(5, 'Notebook', 'Stationery');


INSERT INTO Sales (SaleID, ProductID, Quantity, Price, SaleDate) VALUES
-- January 2025
(1, 1, 5, 800.00, '2025-01-10'),
(2, 2, 10, 500.00, '2025-01-12'),
(3, 3, 20, 100.00, '2025-01-15'),

-- February 2025
(4, 1, 4, 800.00, '2025-02-10'),
(5, 3, 40, 100.00, '2025-02-13'),
(6, 4, 10, 300.00, '2025-02-14'),
(7, 5, 100, 5.00, '2025-02-28'),

-- March 2025
(8, 2, 5, 500.00, '2025-03-05'),
(9, 3, 10, 100.00, '2025-03-06'),
(10, 4, 8, 300.00, '2025-03-07'),
(11, 1, 3, 800.00, '2025-03-08'),

-- Ties in April 2025
(12, 1, 2, 1000.00, '2025-04-01'),  -- Revenue: 2000
(13, 2, 4, 500.00, '2025-04-02'),   -- Revenue: 2000

-- May 2025
(14, 5, 50, 10.00, '2025-05-01'),
(15, 4, 7, 300.00, '2025-05-10');

---everything is ready to performe sql cte task to ffetch the maxrevenue product by month wise 

select * from products
select * from sales

/*Write a query to find the top revenue-generating product for each month (based on total revenue: Quantity * Price), and include:

Month (format: YYYY-MM)

ProductName

TotalRevenue*/
select * from sales


WITH CTE_TOTALSALESBYMONTH AS 
(
select productid ,
        sum(quantity * price) as totalrevenue ,
        format(saledate , 'yyyy-MM') as salesmonths
    from sales
    group by productid , 
    format(saledate , 'yyyy-MM')
), cte_productranking as 
(
        SELECT pr.PRODUCTID , pr.totalrevenue , pr.SALESMONTHS ,p.productname ,
        ROW_NUMBER() OVER (partition by pr.salesmonths ORDER BY pr.totalrevenue desc ) AS PRODUCTRANK
        FROM CTE_TOTALSALESBYMONTH as pr
        join products as p
        on p.productid = pr.productid
        )
select * from cte_productranking
where PRODUCTRANK = 1


