CREATE TABLE employee (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100),
    manager_id INT
);
INSERT INTO employee (employee_id, employee_name, manager_id) VALUES
(1, 'Alice', NULL),
(2, 'Bob', 1),
(3, 'Charlie', 1),
(4, 'David', 2),
(5, 'Eve', 2),
(6, 'Frank', 2),
(7, 'Grace', 3),
(8, 'Heidi', 3),
(9, 'Ivan', 3),
(10, 'Judy', 4),
(11, 'Karl', 4),
(12, 'Leo', 5),
(13, 'Mallory', 5),
(14, 'Niaj', 5),
(15, 'Olivia', 6),
(16, 'Peggy', 6),
(17, 'Quentin', 7),
(18, 'Rupert', 7),
(19, 'Sybil', 8),
(20, 'Trent', 8),
(21, 'Uma', 9),
(22, 'Victor', 9),
(23, 'Wendy', 10),
(24, 'Xavier', 10),
(25, 'Yvonne', 11),
(26, 'Zack', 11),
(27, 'Aaron', 12),
(28, 'Beth', 12),
(29, 'Cindy', 13),
(30, 'Derek', 13);

--find employees who have the same manager

select e.employee_id , e.manager_id , e.employee_name 
from employee as e
where e.employee_id = (
select distinct(e2.manager_id )
from employee as e2
where e2.manager_id  = e.employee_id 
)


select * from employee

SELECT e.employee_id, e.employee_name, e.manager_id
FROM employee e
WHERE e.manager_id IN (
    SELECT manager_id
    FROM employee
    WHERE manager_id IS NOT NULL
    GROUP BY manager_id
    HAVING COUNT(*) > 1
)
ORDER BY e.manager_id, e.employee_id;


drop table employee

CREATE TABLE employee_history (
    record_id INT PRIMARY KEY,
    employee_id INT,
    employee_name VARCHAR(100),
    hire_date DATE
);
INSERT INTO employee_history (record_id, employee_id, employee_name, hire_date) VALUES
(1, 101, 'Alice', '2015-01-15'),
(2, 101, 'Alice', '2018-03-10'),
(3, 101, 'Alice', '2022-09-01'),
(4, 102, 'Bob',   '2017-06-20'),
(5, 102, 'Bob',   '2020-01-01'),
(6, 103, 'Charlie', '2019-04-12'),
(7, 104, 'David', '2014-11-11'),
(8, 104, 'David', '2021-05-18'),
(9, 104, 'David', '2023-10-01');


select * from employee_history

---write a query to find the first and last record for each employees based on the hire date colum



with cte_employee_firstandlast_record as 
(
select 
        employee_id ,
        record_id ,
        employee_name , 
        hire_date ,
        row_number () over (partition by employee_id order by hire_date desc) as last_record , 
        row_number () over (partition by employee_id order by hire_date asc) as first_record 
from employee_history
)select * from cte_employee_firstandlast_record
where last_Record = 1 
or 
first_Record = 1
order by employee_id , hire_date 


drop table employee_history




        select 
            e.employee_id , 
            e.record_id , 
            e.employee_name , 
            e.hire_date , 
            efr.last_record , 
            efr.first_record
            from employee_history AS E
            left JOIN cte_employee_firstandlast_record AS efr 
            on efr.employee_id = e.employee_id 
            where efr.last_record = 1 
            or efr.first_record = 1 
            order by e.employee_id , e.hire_date 





            SELECT *
FROM (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY employee_id ORDER BY hire_date ASC) AS rn_first,
           ROW_NUMBER() OVER (PARTITION BY employee_id ORDER BY hire_date DESC) AS rn_last
    FROM employee_history
) sub
WHERE rn_first = 1 OR rn_last = 1
ORDER BY employee_id, hire_date;

select * from employee_history


where efr.first_Record = 1 




and efr.last_record = (select min(efr.last_record) from cte_employee_firstandlast_record)

CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY,
    customer_id INT,
    transaction_date DATE,
    amount DECIMAL(10, 2)
);
INSERT INTO transactions (transaction_id, customer_id, transaction_date, amount) VALUES
(1, 101, '2023-01-10', 150.00),
(2, 101, '2023-03-22', 200.00),
(3, 101, '2023-05-05', 180.00),
(4, 102, '2023-01-15', 300.00),
(5, 102, '2023-07-10', 350.00),
(6, 103, '2023-02-20', 400.00),
(7, 104, '2023-05-18', 220.00),
(8, 104, '2023-06-01', 180.00),
(9, 104, '2023-06-30', 250.00),
(10, 105, '2023-03-10', 500.00);

---find the most recent transecton of each customers
select * from transactions



with cte_recent_transaction_per_customer as 
(
select 
        customer_id ,
        amount,
        transaction_id , 
        transaction_Date ,
        rank() over (partition by customer_id  order by transaction_date desc ) recent_orders 
from transactions
)
        select tpc.customer_id , 
                tpc.amount ,
                tpc.transaction_Date,
                tpc.transaction_id , 
                tpc.recent_orders 
                from cte_recent_transaction_per_customer as tpc 
  where tpc.recent_orders = 1

  select * from transactions
  drop table transactions

---write a query to find the total salary of each departmetn and display departments
--with a total salary greater than a specified value(e.g. 50,000)

CREATE TABLE employee (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100),
    department_name VARCHAR(100),
    salary DECIMAL(10, 2)
);
INSERT INTO employee (employee_id, employee_name, department_name, salary) VALUES
(1, 'Alice', 'HR', 55000),
(2, 'Bob', 'IT', 60000),
(3, 'Charlie', 'IT', 52000),
(4, 'David', 'Finance', 45000),
(5, 'Eve', 'Finance', 47000),
(6, 'Frank', 'HR', 52000),
(7, 'Grace', 'Marketing', 40000),
(8, 'Heidi', 'Marketing', 38000),
(9, 'Ivan', 'Sales', 30000),
(10, 'Judy', 'Sales', 27000);

select * from employee


select * 
from (
        select 
               department_name , 
               sum(salary) as total_salary 
from employee
group by department_name
)t
    where t.total_salary > 100000

    drop table employee


]
CREATE TABLE orders1 (
    order_id INT PRIMARY KEY,
    customer_id INT,
    customer_name VARCHAR(100),
    order_date DATE,
    order_amount DECIMAL(10, 2)
);




INSERT INTO orders1 (order_id, customer_id, customer_name, order_date, order_amount) VALUES
(1, 101, 'Alice', '2023-01-10', 200.00),
(2, 101, 'Alice', '2023-01-15', 150.00),
(3, 101, 'Alice', '2023-02-01', 300.00),
(4, 102, 'Bob', '2023-01-12', 500.00),
(5, 102, 'Bob', '2023-01-25', 400.00),
(6, 103, 'Charlie', '2023-01-20', 100.00),
(7, 103, 'Charlie', '2023-02-05', 250.00),
(8, 103, 'Charlie', '2023-03-10', 300.00),
(9, 101, 'Alice', '2023-03-15', 100.00),
(10, 102, 'Bob', '2023-03-20', 600.00);


select * from orders1

----write a query to find the running total of orders for each customer sorted bt order date 

select 
        customer_id , 
        customer_name , 
        order_date , 
        order_amount ,
        order_id , 
        sum(order_Amount) over (partition by customer_id  order by order_date rows between unbounded preceding and current row  ) rn 
     from orders1

  drop table orders1
---write a query to find total number of employee hired per month and year
CREATE TABLE employees1 (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100),
    hire_date DATE
);
INSERT INTO employees1 (employee_id, employee_name, hire_date) VALUES
(1, 'Alice', '2023-01-10'),
(2, 'Bob', '2023-01-15'),
(3, 'Charlie', '2023-02-05'),
(4, 'David', '2023-02-20'),
(5, 'Eve', '2023-02-28'),
(6, 'Frank', '2023-03-01'),
(7, 'Grace', '2023-03-15'),
(8, 'Heidi', '2023-04-10'),
(9, 'Ivan', '2023-04-20'),
(10, 'Judy', '2023-04-25');

select * from employees1

---write a query to find total number of employee hired per month and year---

create nonclustered columnstore index idx_employees1_hire_date 
on employees1( hire_date )

drop index idx_employees1_emp_id_empname_hire_date on employees1

with cte_countinmonths as 
(
    select 
        e1.months ,
        count(e1.employee_id) as hired_per_month
        from (
                select
                        employee_name ,
                        employee_id , month(hire_date) as months
                from employees1
                )as e1
    group by e1.months
),cte_countinyear as 
(
        select 
            count(e2.employee_id) as hired_per_year,
            e2.years
        from (
              select 
                employee_id  ,
                 year(hire_date) as years
 from employees1) e2
group by e2.years
)
        select
        cc.hired_per_month ,
        cc.months,
        ccy.years ,
        ccy.hired_per_year
        from employees1 as e
        left join cte_countinmonths as cc
        on cc.months = month(e.hire_date)
        left join cte_countinyear as ccy
        on ccy.years = year(e.hire_date)

        SELECT 
    YEAR(hire_date) AS hire_year,
    MONTH(hire_date) AS hire_month,
    COUNT(employee_id) AS hired_per_month_year
FROM employees1
GROUP BY 
    YEAR(hire_date),
    MONTH(hire_date)
ORDER BY 
    hire_year,
    hire_month;

    select 
    year(hire_date) as hire_year,
    month(hire_date) as hire_month,
    count(employee_id) as hired_per_month_year
    from employees1
    group by year(hire_date),month(hire_date)
    order by hire_year,
    hire_month

    drop table employees1


-- 1. Create the employees table
CREATE TABLE employees1 (
    emp_id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10, 2),
    department_id INT
);

-- 2. Insert sample data
INSERT INTO employees1 (emp_id, name, salary, department_id) VALUES
(1, 'Alice', 60000, 10),
(2, 'Bob', 55000, 10),
(3, 'Charlie', 70000, 10),
(4, 'David', 80000, 20),
(5, 'Eve', 75000, 20),
(6, 'Frank', 65000, 20),
(7, 'Grace', 40000, 30),
(8, 'Heidi', 45000, 30),
(9, 'Ivan', 50000, 30),
(10, 'Judy', 85000, 10);


select * from employees1

--write a query to display all employees who earn more than the average salary for their department

select emp_id , salary ,department_id
from employees1 as e
    where salary >
    (
            select avg(e1.salary)
            from employees1 as e1
            where e1.department_id = e.department_id )

            SELECT emp_id, salary, department_id
FROM employees1 e
WHERE salary > (
    SELECT AVG(e1.salary)
    FROM employees1 e1
    WHERE e1.department_id = e.department_id
);

drop table employees1


-- 1. Create the employee table
CREATE TABLE employee (
    emp_id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10, 2)
);

-- 2. Insert sample data
INSERT INTO employee (emp_id, name, salary) VALUES
(1, 'Alice', 50000),
(2, 'Bob', 60000),
(3, 'Charlie', 70000),
(4, 'David', 60000),
(5, 'Eve', 80000),
(6, 'Frank', 50000),
(7, 'Grace', 90000);

--write a query to get the second lowest salary from the employee table without using limit or offset

select* from employee

select * from 
(
select emp_id , name , salary , 
        dense_rank() over (order by salary ) as secondlowestsalary
   from employee
   )t
        where t.secondlowestsalary = 2



        SELECT *
FROM employee
ORDER BY emp_id
OFFSET 3 ROWS FETCH NEXT 3 ROWS ONLY;


-- Drop tables if they already exist (optional cleanup)
DROP TABLE IF EXISTS orders1;
DROP TABLE IF EXISTS product1;
-- Create the products table
CREATE TABLE products1 (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100)
);

-- Create the orders table
CREATE TABLE orders1 (
    order_id INT PRIMARY KEY,
    product_id INT,
    quantity INT,
    order_date DATE,
    FOREIGN KEY (product_id) REFERENCES products1(product_id)
);

-- Insert sample data into products
INSERT INTO products1 (product_id, product_name) VALUES
(1, 'Laptop'),
(2, 'Mouse'),
(3, 'Keyboard'),
(4, 'Monitor'),
(5, 'Webcam'),
(6, 'USB Cable');

-- Insert sample data into orders
INSERT INTO orders1 (order_id, product_id, quantity, order_date) VALUES
(101, 1, 2, '2024-01-10'),
(102, 2, 5, '2024-01-12'),
(103, 4, 1, '2024-02-05'),
(104, 1, 1, '2024-03-20');

--write a query to list all products that have never been ordered (assumingon order table and products table 

select * from orders1
select * from products1


select 
        product_id , 
        product_name 
        from products1 as p
where not exists
(
        select 1
        from orders1 as o2
        where o2.product_id = p.product_id )



        -- Drop table if it already exists
DROP TABLE IF EXISTS employee;

-- Create the employees table
CREATE TABLE employee(
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100),
    manager_id INT,
    FOREIGN KEY (manager_id) REFERENCES employee(employee_id)
);

-- Insert sample employee data
INSERT INTO employee (employee_id, employee_name, manager_id) VALUES
(1, 'Alice', NULL),      -- Top-level manager (no manager)
(2, 'Bob', 1),           -- Reports to Alice
(3, 'Charlie', 1),       -- Reports to Alice
(4, 'Diana', 2),         -- Reports to Bob
(5, 'Eve', 2),           -- Reports to Bob
(6, 'Frank', 3),         -- Reports to Charlie
(7, 'Grace', 3),         -- Reports to Charlie
(8, 'Hank', NULL);       -- Not reporting to anyone and not a manager

--write a query to find all the employees whio are also  managers 

select * from employee

select 
       employee_id 
from employee as e
where employee_id in
(
            select
            manager_id 
            from employee as e2
            where  e2.manager_id = e.employee_id  )
SELECT DISTINCT e.employee_id, e.employee_name
FROM employee e
WHERE e.employee_id IN (
    SELECT manager_id FROM employee WHERE manager_id IS NOT NULL
);
-- Drop table if it already exists
DROP TABLE IF EXISTS employee;

-- Create the employees table
CREATE TABLE employee (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100),
    join_date DATE
);

-- Insert sample data into employees table
INSERT INTO employee (employee_id, employee_name, join_date) VALUES
(1, 'Alice', '2023-05-10'),
(2, 'Bob', '2023-05-15'),
(3, 'Charlie', '2023-06-20'),
(4, 'Diana', '2023-05-05'),
(5, 'Eve', '2024-01-01'),
(6, 'Frank', '2024-01-20'),
(7, 'Grace', '2023-07-07'),
(8, 'Hank', '2023-06-18'),
(9, 'Ivy', '2024-02-10'),
(10, 'Jack', '2024-02-28');


select * from employee

--write a query to find employees who have joined in the same month and year
select
        employee_id , 
        employee_id ,
        month(join_date) as joining_month,
        year(join_date) as joining_year,
        DENSE_RANK() over(order by month(join_date) , year(join_date))
from employee 
group by month(join_date) , year(join_date)





select 
        month(join_date) as joining_month , 
        year(join_date) as joining_year , 
        count(*) as emp_count 
        from 
     employee
    group by month(join_date), year(join_date)
    having count(*) > 1



    SELECT *
FROM employee e
WHERE EXISTS (
    SELECT 1
    FROM employee e2
    WHERE MONTH(e2.join_date) = MONTH(e.join_date)
      AND YEAR(e2.join_date) = YEAR(e.join_date)
      AND e2.employee_id <> e.employee_id
);


select
        e1.employee_id , 
        e1.employee_name , 
        month(e1.join_date) as joining_month,
        year(e1.join_date) as joining_year,
        DENSE_RANK() over (order by 
                month(join_date) , year(join_date)
from employee as e1
join employee as e2
on e1.employee_id = e2.employee_id 
order by month(e1.join_date) , year(e1.join_date)



-- Drop the table if it already exists
DROP TABLE IF EXISTS Employee;

-- Create the Employees table
CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(100),
    Age INT,
    DepartmentID INT
);
-- Insert sample employee data


-- Insert sample employee data with DOB

-- Drop the table if it already exists
DROP TABLE IF EXISTS Employees;

-- Create the Employees table with Date of Birth

select * from Employee
--write a query to get a list of employees who are older then the average age of employees in their department

select 
    employeeid , 
    month(dateofbirth) as agemonth , 
    year(dateofbirth) as ageyear,
    DATEDIFF('DD',1994,2025)
from Employee
where dateofbirth




select employeeid ,
(CURRENT_DATE - dateofbirth)
from Employee

SELECT Name, DateOfBirth,
       DATEDIFF(YEAR, DateOfBirth, GETDATE()) 
         - CASE 
             WHEN MONTH(DateOfBirth) > MONTH(GETDATE()) 
                  OR (MONTH(DateOfBirth) = MONTH(GETDATE()) AND DAY(DateOfBirth) > DAY(GETDATE()))
             THEN 1 ELSE 0 
           END AS Age
FROM Employee;


select * from employee



with cte_employeesage as 
(
select 
           e1.employeeid 
         , e1.dateofbirth , 
          datediff(year , e1.dateofbirth , getdate()) as ageinyears
   from employee as e1
), cte_avgageperdepartment as 
(
select 
         avg(ageinyears) as avgage
        ,departmentid
  from employee as e
        join cte_employeesage as ce
        on ce.employeeid = e.employeeid 
group by departmentid 
)
         select e.employeeid , 
                    e.departmentid , 
                    e.dateofbirth , 
                    capd.avgage ,
                    ce.ageinyears
         from employee as e 
                left join cte_employeesage as ce
                 on ce.employeeid = e.employeeid 
                 left join cte_avgageperdepartment as capd
                  on capd.departmentid = e.departmentid 
         where ce.ageinyears > capd.avgage 
         order by e.DepartmentID
                    





    














   where datediff(year , e1.dateofbirth , getdate())  > 
    (
    select avg(datediff(year , e2.d
    
    
    ateofbirth , getdate()) )
    from employee as e2
    where e2.employeeid = e1.employeeid
    )
            


drop table employee


-- Create the employees table
CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(100),
    HireDate DATE
);

-- Insert sample data
INSERT INTO Employee (EmployeeID, Name, HireDate) VALUES
(1, 'Alice Johnson', '2005-06-15'),
(2, 'Bob Smith', '2010-08-01'),
(3, 'Charlie Brown', '2003-04-20'),
(4, 'David Lee', '2018-12-03'),
(5, 'Emma Watson', '2003-04-20'); -- Same date as Charlie to test multiple longest-tenured employees

-- Query to find employees with the longest tenure


select * from Employee

select 
           e1.employeeid , e1.HireDate
           from employee as e1
           where e1.hiredate =
  (
               select max(e2.hiredate)  from
               employee as e2
               where e2.hiredate = e1.HireDate  
               )order by e1.hiredate
select * from employee

select employeeid , hiredate 
from employee as e1 
where hiredate = 
(    
     select min(hiredate) 
     from employee )



-- Step 1: Create the Sample Table
CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(255) -- This column will have NULL values
);

-- Step 2: Insert Sample Data (including NULL values)
INSERT INTO Customer (CustomerID, Name, Email) VALUES
(1, 'Alice Johnson', 'alice@email.com'),
(2, 'Bob Smith', NULL), -- NULL value
(3, 'Charlie Brown', 'charlie@email.com'),
(4, 'David Lee', NULL); -- NULL value

---write a query to delete all record from a table where the column value is null

select * from customer

select * from customer
where email is null

delete from customer
where email is null



drop table order
-- Create the Products table
CREATE TABLE Product (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100)
);

-- Create the Orders table
CREATE TABLE Order1 (
    OrderID INT PRIMARY KEY,
    OrderDate DATE
);

-- Create the OrderDetails table to link Orders and Products
CREATE TABLE OrderDetail (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Order1(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

-- Insert products
INSERT INTO Product (ProductID, ProductName) VALUES
(1, 'Laptop'),
(2, 'Mouse'),
(3, 'Keyboard'),
(4, 'Monitor'),
(5, 'USB Cable');

-- Insert orders
INSERT INTO Order1 (OrderID, OrderDate) VALUES
(101, '2025-06-01'),
(102, '2025-06-02'),
(103, '2025-06-03');

-- Insert order details
INSERT INTO OrderDetail (OrderDetailID, OrderID, ProductID, Quantity) VALUES
(1, 101, 1, 1),
(2, 101, 2, 2),
(3, 101, 3, 1),
(4, 102, 2, 1),
(5, 102, 4, 1),
(6, 103, 1, 1),
(7, 103, 5, 3);

select * from order1
select * from product
select * from orderdetail
--write a query to find all pair of products that were ordered together at least once 

select orderid , 
productid 
from orderdetails




with cte_ordercount as 
(
select orderid , count(orderid) ordercount
from orderdetail
group by orderid
having count(orderid) >= 2
)
select o.productid , p.ProductName , o.orderid
from OrderDetail as o
join cte_ordercount as co
on co.orderid = o.orderid
join product as p 
on p.productid = o.productid
where o.orderid in (select orderid from cte_ordercount)


--write a query to find all pair of products that were ordered together at least once 

WITH cte_ordercount AS (
    SELECT orderid
    FROM orderdetail
    GROUP BY orderid
    HAVING COUNT(orderid) >= 2
)
SELECT 
    LEAST(o1.productid, o2.productid) AS productid1,
    GREATEST(o1.productid, o2.productid) AS productid2,
    p1.ProductName AS Product1,
    p2.ProductName AS Product2,
    COUNT(*) AS PairCount
FROM orderdetail o1
JOIN orderdetail o2 ON o1.orderid = o2.orderid
JOIN cte_ordercount co ON co.orderid = o1.orderid
JOIN product p1 ON p1.productid = o1.productid
JOIN product p2 ON p2.productid = o2.productid
WHERE o1.productid < o2.productid
GROUP BY 
    LEAST(o1.productid, o2.productid),
    GREATEST(o1.productid, o2.productid),
    p1.ProductName,
    p2.ProductName
ORDER BY PairCount DESC;






SELECT 
    LEAST(o1.productid, o2.productid) AS productid1,
    GREATEST(o1.productid, o2.productid) AS productid2
    from orderdetail as o1
    join orderdetail as o2 on o1.orderid = o2.orderid
    where o1.productid = o2.productid

select * from orderdetail







--select * from order1
select * from orderdetail
select * from Product



----write a query to find all pair of products that were ordered together at least once 

with cte_countorderid as 
(
select orderid , count(orderid) as ordercount 
from orderdetail
group by orderid
) 
        select 
        least(od.productid , od2.productid) product1 ,
        GREATEST(od.productid , od2.productid ) as product2

        drop table order1
        -- Create the 'customers' table
CREATE TABLE customer01 (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100)
);

-- Insert sample data into 'customers'
INSERT INTO customer01 (customer_id, customer_name) VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie');

-- Create the 'orders' table
CREATE TABLE order01 (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES customer01(customer_id)
);

-- Insert sample data into 'orders'
INSERT INTO order01 (order_id, customer_id, order_date, total_amount) VALUES
(101, 1, '2025-01-15', 150.00),
(102, 1, '2025-01-20', 200.00),
(103, 2, '2025-01-25', 250.00),
(104, 2, '2025-02-05', 300.00),
(105, 3, '2025-02-10', 350.00),
(106, 3, '2025-02-15', 400.00);


select  *from order01
select * from customer01


--write a query to find the average order value oby customer for each month

select 
            customer_id , 
            month(order_date) as ordermonth , 
            year(order_date ) as orderyear,
            avg(total_amount) as avg_ordervalue 
from order01
group by customer_id,
month(order_date), year(order_date)

select  *from order01
drop table order01



CREATE TABLE order01 (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE
);
-- Customer 1: Orders every month for the past 12 months
INSERT INTO order01 (OrderID, CustomerID, OrderDate) VALUES
(1, 1, '2024-07-15'),
(2, 1, '2024-08-10'),
(3, 1, '2024-09-12'),
(4, 1, '2024-10-05'),
(5, 1, '2024-11-20'),
(6, 1, '2024-12-01'),
(7, 1, '2025-01-14'),
(8, 1, '2025-02-18'),
(9, 1, '2025-03-03'),
(10, 1, '2025-04-21'),
(11, 1, '2025-05-19'),
(12, 1, '2025-06-01');

-- Customer 2: Missed March and April
INSERT INTO order01 (OrderID, CustomerID, OrderDate) VALUES
(13, 2, '2024-07-02'),
(14, 2, '2024-08-17'),
(15, 2, '2024-09-25'),
(16, 2, '2024-10-10'),
(17, 2, '2024-11-30'),
(18, 2, '2024-12-03'),
(19, 2, '2025-01-05'),
(20, 2, '2025-02-15'),
(21, 2, '2025-05-05'),
(22, 2, '2025-06-03');

-- Customer 3: Many orders, but not all months
INSERT INTO order01 (OrderID, CustomerID, OrderDate) VALUES
(23, 3, '2025-01-10'),
(24, 3, '2025-01-20'),
(25, 3, '2025-03-15'),
(26, 3, '2025-03-28'),
(27, 3, '2025-06-01');

select * from order01

---write a query to find customers who made a purcahse every month for the past year

select 
customerid ,
        count(distinct(month(orderdate))) as uniqueordermonth
from order01
group by customerid 
having count(distinct(month(orderdate))) >=12
        order by customerid 

select * from order01
order by orderdate

select 
        distinct(month(orderdate)) as uniquemonthorder,
        distinct(year(orderdate) as uniqueorderyear
from order01


select month(orderdate) as ordermonth ,
year(orderdate) as orderyear 
from order01 
group by month(orderdate)


WITH orders_last_year AS (
    SELECT 
        CustomerID,
        DATE_TRUNC('month', OrderDate) AS order_month
    FROM order01
    WHERE OrderDate >= DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '12 months'
),
customer_months AS (
    SELECT 
        CustomerID,
        COUNT(DISTINCT order_month) AS active_months
    FROM orders_last_year
    GROUP BY CustomerID
)
SELECT CustomerID
FROM customer_months
WHERE active_months = 12;


    SELECT 
        CustomerID,
        DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)  AS order_month
    FROM order01

WITH orders_last_year AS (
    SELECT 
        CustomerID,
        CAST(DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS DATE) AS order_month
    FROM order01
    WHERE OrderDate >= DATEADD(MONTH, -12, CAST(GETDATE() AS DATE))
),
customer_months AS (
    SELECT 
        CustomerID,
        COUNT(DISTINCT( order_month)) AS active_months
    FROM orders_last_year
    GROUP BY CustomerID
)
SELECT CustomerID , active_months
FROM customer_months
WHERE active_months = 12;


with cte_year_order as 
(
select 
customerid , 
cast(DATEFROMPARTS(year(orderdate) , month(orderdate) , 1) as date ) as orderdate 
from order01
where orderdate >= 
                dateadd(month , -12 , cast(getdate() as date ))
 ) , cte_ordercount as 
   (
            select customerid, 
            count(distinct(month(orderdate))) as activemonth
from cte_year_order
group by customerid 
)

        select customerid 
        from cte_ordercount 
        where activemonth = 12



