
select * from dbo.Employees0

select e1.employeeid , e1.salary , e1.department
from dbo.employees0 as e1
where salary =		
			(select max(salary) 
			from dbo.employees0 as e2
			where e1.department =e2.department )


