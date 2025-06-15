

select CustomerID , 
productid 
from sales 
where productid = 123

drop index idx_productid on sales

select * from sales where 
SaleDate between '2023-05-01' and '2023-05-31';


drop index idx_salessa_saledate on sales
create nonclustered columnstore index idx_salessa_saledate 
on sales(saledate , customerid , productid );

select customerid  from sales 
where saledate between '2023-05-01' and '2023-05-31';

select * from sales 


--find the customers who ordered products worth more then 30000 with productid 87,688,767,25,95,343,388,716
--and in just 3 monnths jan, feb and march 

create nonclustered columnstore index idx_cutomerid_productid_revenue_saledate 
on sales(customerid , productid , revenue , saledate )


select 
		customerid , 
		productid,
		month(saledate) as salemonth ,
		sum(revenue) as totalrevenue
				from 
					  sales 
							group by	customerid ,
						productid ,
					month(saledate) 
               having productid in ('87','688','767','25','95','343','388','736')
			and month(saledate) in (1,2,3)
		and sum(revenue) > 1000;




		with cte_recursive_hain as              -----anchor number 
		(select 1 as n   ---getting data join 
		union all  ----recursive data
	 select n+1  
	 from  cte_recursive_hain
	 where n < 10
	 )
	select * from cte_recursive_hain 



	with  cte_loop as 
	(
		select 1 as n 
		union all 
		select n + 1 
		from cte_loop 
		where n < 11
		)
	select * from cte_loop


	select  * from sales 

	alter table sales 
	add category varchar (50)
	

	update Sales
	set category = 
	case 
	when revenue < 200 then 'LOW'
	WHEN REVENUE < 500 THEN 'MEDIUM'
	WHEN REVENUE > 500 THEN 'HIGH'
	END 
	FROM SALES 
	

	select * from sales 
	drop index idx_sales_category on sales 

	create nonclustered columnstore index idx_sales_category_custoemrid_revenue
	on sales (customerid , revenue , category)
	where category = 'high'



	drop index  idx_cutomerid_productid_revenue_saledate on sales

	select customerid , sum(revenue)as totalsum , category 
	from sales 
	group by CustomerID , category 
	having category = 'high';

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(100),
    ManagerID INT NULL
);
INSERT INTO Employees (EmployeeID, Name, ManagerID)
VALUES
(1, 'CEO', NULL),
(2, 'CTO', 1),
(3, 'CFO', 1),
(4, 'Dev Manager', 2),
(5, 'Finance Manager', 3),
(6, 'Developer 1', 4),
(7, 'Developer 2', 4),
(8, 'Accountant', 5);


select * from Employees

with cte_recursiv_ceo as
(
	select employeeid , name , managerid ,0 as level
	from employees  
	where managerid is null 
	union all 
	select e.employeeid , e.name , e.managerid , rc.level + 1 
	from employees as e 
	inner join cte_recursiv_ceo as rc on e.managerid = rc.employeeid
	)
	select * from cte_recursiv_ceo



	WITH EmployeeHierarchy AS (
    SELECT 
        EmployeeID,
        Name,
        ManagerID,
        0 AS Level
    FROM Employees
    WHERE ManagerID IS NULL  -- Start from CEO

    UNION ALL

    SELECT 
        e.EmployeeID,
        e.Name,
        e.ManagerID,
        eh.Level + 1
    FROM Employees e
    INNER JOIN EmployeeHierarchy eh ON e.ManagerID = eh.EmployeeID
)
SELECT * FROM EmployeeHierarchy
ORDER BY Level, EmployeeID;













