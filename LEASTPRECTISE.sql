-- 1. Create Products Table
CREATE TABLE Products01 (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10, 2),
    Stock INT
);

-- 2. Insert sample data into Products
INSERT INTO Products01 VALUES
(6, 'Laptop', NULL, 1200.00, 10),
(2, 'Headphones', 'Electronics', 150.00, 50),
(3, 'Desk Chair', 'Furniture', 200.00, 20),
(4, 'Coffee Mug', 'Kitchenware', 12.50, 100),
(5, 'Notebook', 'Stationery', 3.00, 200);

-- 3. Create Sales Table
CREATE TABLE Sales01 (
    SaleID INT PRIMARY KEY,
    ProductID INT,
    Quantity INT,
    SaleDate DATE,
    FOREIGN KEY (ProductID) REFERENCES Products01(ProductID)
);

-- 4. Insert sample sales data
INSERT INTO Sales01 VALUES
(6, 1, null, '2025-06-01'),
(2, 2, 3, '2025-06-01'),
(3, 5, 

10, '2025-06-02'),
(4, 3, 2, '2025-06-03'),
(5, 4, 5, '2025-06-03');

select * from Products01
select * from sales01

--productid headphone total revenue :

alter procedure pro_producttotalrevenue @productname varchar(50) = 'Headphones'
as
begin
----totalrevenue of products ---
declare @totalrevenue float
--prepare & cleanup data 

select 
   @totalrevenue =  sum(p.price * s.quantity) 
from products01 as p
join sales01 as s
on p.productid = s.productid 
where  productname  = @productname

print 'totalrevenue for' +' ' + @productname + ':' + cast(@totalrevenue as varchar)

    ---latest order by product --
    IF EXISTS( SELECT 1 FROM PRODUCTS01 WHERE CATEGORY  IS NULL AND PRODUCTNAME = PRODUCTNAME )
BEGIN 
PRINT('UPDATING NULLS TO ZERO' );
UPDATE Products01 
SET CATEGORY = 'ELECTRONICS'
WHERE CATEGORY  IS NULL AND PRODUCTNAME = @productname
end 

else 
begin 
PRINT ('NO NULL CATEGORY FOUND')
end 

    select 
    productname , 
s.saleid , 
max(saledate) as letestorder
from products01 as p
join sales01 as s
on s.productid = p.productid 
group by productname , s.saleid
having productname = @productname
end 



exec pro_producttotalrevenue
@productname = 'Headphones'

exec pro_producttotalrevenue @productname = 'desk chair'





select * from products01
select * from sales01

CREATE DATABASE BookStore;
GO

USE BookStore;
GO

-- Authors Table
CREATE TABLE Authors (
    AuthorID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100),
    Country NVARCHAR(50)
);

-- Books Table
CREATE TABLE Books (
    BookID INT PRIMARY KEY IDENTITY(1,1),
    Title NVARCHAR(200),
    AuthorID INT FOREIGN KEY REFERENCES Authors(AuthorID),
    Price DECIMAL(10, 2),
    PublishedYear INT
);

-- Sales Table
CREATE TABLE Sales0 (
    SaleID INT PRIMARY KEY IDENTITY(1,1),
    BookID INT FOREIGN KEY REFERENCES Books(BookID),
    Quantity INT,
    SaleDate DATE
);

-- Authors
INSERT INTO Authors (Name, Country)
VALUES 
('George Orwell', 'UK'),
('Jane Austen', 'UK'),
('Mark Twain', 'USA');

-- Books
INSERT INTO Books (Title, AuthorID, Price, PublishedYear)
VALUES 
('1984', 1, 15.99, 1949),
('Pride and Prejudice', 2, 12.99, 1813),
('Adventures of Huckleberry Finn', 3, 10.99, 1884);

-- Sales
INSERT INTO Sales0 (BookID, Quantity, SaleDate)
VALUES 
(1, 5, '2024-06-01'),
(2, 3, '2024-06-02'),
(3, 7, '2024-06-03'),
(1, 2, '2024-06-05');

SELECT * FROM Authors 
SELECT * FROM BOOKS
SELECT * FROM SALES
-- Get All Books by a Specific Author

SELECT B.BOOKID , A.AuthorID
FROM BOOKS AS B
JOIN AUTHORS AS A 
ON A.AUTHORID = B.AUTHORID


alter  procedure prs_authorofbooks @name varchar(50) = 'Jane Austen'
as
begin
SELECT B.BOOKID , B.Title , A.AUTHORID 
FROM BOOKS  AS B
JOIN Authors AS A
on a.authorid = b.AuthorID
WHERE NAME = @name 
---Get Total Sales by Book

select 
        sum(b.price*s.quantity ) as totalsales
        from books as b 
        join Sales as s 
        on s.bookid = b.bookid
        where b.bookid  = 1
end

exec prs_authorofbooks @name = 'Jane Aus from books
select * from authors
select * from sales 
'
drop table authors
drop table books
drop table sales

CREATE TABLE Employees0 (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Email NVARCHAR(100),
    Department NVARCHAR(50),
    Salary DECIMAL(10,2),
    HireDate DATE
);



INSERT INTO Employees0(FirstName, LastName, Email, Department, Salary, HireDate)
VALUES 
('John', 'Doe', 'john.doe@example.com', 'HR', 50000.00, '2022-01-15'),
('Jane', 'Smith', 'jane.smith@example.com', 'Finance', 65000.00, '2021-11-01'),
('Mike', 'Brown', 'mike.brown@example.com', 'IT', 72000.00, '2020-05-23'),
('Sara', 'Wilson', 'sara.wilson@example.com', 'Marketing', 48000.00, '2023-03-12');

select * from employees0

--Insert New Employee
create procedure pre_inserta_new_employees 
@firstname  varchar(50) , 
@lastname varchar(50) ,
@email varchar(50) , 
@department varchar(50) , 
@salary float , 
@hiredate date 
as
begin 
INSERT INTO EMPLOYEES0 (FIRSTNAME , LASTNAME , EMAIL , DEPARTMENT , SALARY , HIREDATE )
VALUES 
(@FIRSTNAME , @lastname , @EMAIL , @DEPARTMENT , @salary ,@HIREDATE)
END 

EXEC pre_inserta_new_employees
@FIRSTNAME = 'Tanmay' ,
@LASTNAME = 'singh',
@EMAIL = 'tanmay23@gmail.com' ,
@DEPARTMENT = 'HR',
@SALARY = 80000,
@HIREDATE = '2024-07-01'

--. Get Employee by ID

SELECT * FROM EMPLOYEES0



CREATE PROCEDURE PROS_EMPLOYEEDETAILS @EMPLOYEEID INT 
AS 
BEGIN 
SELECT FIRSTNAME , LASTNAME , EMAIL , DEPARTMENT , SALARY , HIREDATE 
FROM EMPLOYEES0
WHERE EMPLOYEEID = @EMPLOYEEID 
END 


EXEC PROS_EMPLOYEEDETAILS
@EMPLOYEEID = 2

--Update Employee Salary

CREATE PROCEDURE PROS_NEW_SALARY 
@NEWSALARY DECIMAL (10,2),
@EMPLOYEEID INT 
AS BEGIN 
UPDATE  EMPLOYEES0
SET SALARY = @NEWSALARY 
WHERE EMPLOYEEID = @EMPLOYEEID 
END

EXEC PROS_NEW_SALARY 
@EMPLOYEEID = 2 , @NEWSALARY = 90000


SELECT * FROM EMPLOYEES0




create schema pro
CREATE TABLE pro.Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    City VARCHAR(50)
);

CREATE TABLE pro.Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName VARCHAR(100),
    Price DECIMAL(10, 2),
    Stock INT
);

CREATE TABLE pro.Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT FOREIGN KEY REFERENCES pro.Customers(CustomerID),
    ProductID INT FOREIGN KEY REFERENCES pro.Products(ProductID),
    Quantity INT,
    OrderDate DATE
);


-- Insert Customers
INSERT INTO pro.Customers (Name, Email, City) VALUES
('Alice Smith', 'alice@example.com', 'New York'),
('Bob Johnson', 'bob@example.com', 'Los Angeles'),
('Charlie Rose', 'charlie@example.com', 'Chicago');

-- Insert Products
INSERT INTO pro.Products (ProductName, Price, Stock) VALUES
('Laptop', 1200.00, 10),
('Headphones', 150.00, 50),
('Mouse', 25.00, 100);

-- Insert Orders
INSERT INTO pro.Orders (CustomerID, ProductID, Quantity, OrderDate) VALUES
(1, 1, 1, '2025-06-01'),
(1, 2, 2, '2025-06-03'),
(2, 3, 3, '2025-06-05');

select * from pro.Customers
select * from pro.products 
select * from pro.Orders

-- Get All Orders from a Given City

alter procedure proc_ordersovercity @city varchar(50) = 'New York' , @currentstock int ,productid int 
as
begin

select o.orderid , c.CustomerID , c.city 
from pro.orders as o
join pro.Customers as c 
on c.customerid = o.customerid 
where c.city = @city
end

--Check Product Stock Before Order

alter procedure pro_stock_availability @quantity int , @productid int 
as 
begin 
  declare @currentstock int 
  select @currentstock = stock
  from pro.products 
  where productid = @productid 

if @currentstock is null 
begin 
        raiserror('product not found' , 16 ,1);
        return;
end 
if 
@currentstock > @quantity 
begin 
 raiserror('product has sufficient quatity ',16,1,@currentstock)
 return;
 end 
 end;

 exec pro_stock_availability @productid = 1, @quantity = 49







EXEC proc_ordersovercity
@CITY = 'Los Angeles'



select * from dbo.Sales01



create table productlogs ( productid int , productlog varchar(100) , date datetime  )
select * from productlogs

create trigger trg_new_product_add 
on dbo.sales01
after insert 
as
begin
        insert into productlogs 
        select productid , 
        'A NEW PRODUCT ID HAS BEE ADDED WITH PRODUCTID : ' + CAST(PRODUCTID AS VARCHAR ) ,
        GETDATE()
        FROM inserted
end

select * from productlogs
SELECT * FROM DBO.SALES01

INSERT INTO DBO.Sales01 (Saleid , productid , quantity , saledate )
values ( 7 , 6 , 10 , '2025-06-15' )


