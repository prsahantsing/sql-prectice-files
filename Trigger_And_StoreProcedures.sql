-- Departments
CREATE TABLE Departmentss (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100)
);

-- Employees
CREATE TABLE Employeess (
    EmployeeID INT PRIMARY KEY,
    FullName VARCHAR(100),
    DepartmentID INT,
    Salary DECIMAL(10,2),
    PerformanceScore INT,
    ManagerID INT NULL,
    FOREIGN KEY (DepartmentID) REFERENCES Departmentss(DepartmentID),
    FOREIGN KEY (ManagerID) REFERENCES Employeess(EmployeeID)
);

-- Sample data
INSERT INTO Departmentss VALUES 
(1, 'Sales'),
(2, 'Engineering'),
(3, 'HR'),
(4, 'Finance');

INSERT INTO Employeess VALUES 
(1, 'Alice Johnson', 1, 75000, 90, NULL),  -- Sales Manager
(2, 'Bob Smith', 1, 50000, 88, 1),
(3, 'Carol Lee', 1, 52000, 82, 1),
(4, 'David Kim', 2, 95000, 91, NULL),      -- Eng Manager
(5, 'Eva Brown', 2, 70000, 94, 4),
(6, 'Frank Hall', 2, 72000, 96, 4),
(7, 'Grace Wu', 3, 60000, 75, NULL),       -- HR Manager
(8, 'Hank Green', 3, 45000, 73, 7),
(9, 'Ivy Chen', 4, 80000, 87, NULL);       -- Finance Manager


select * from employeess
select * from departmentss

--? 1. CTE – Find Top Performer in Each Department



with cte_performancerating as 
(
select 
        employeeid , 
        fullname , departmentid , 
        salary , performancescore ,
        rank() over (partition by departmentid order by performancescore desc ) performancerank 
        from employeess
  ) 
        select employeeid , fullname , departmentid , salary , performancescore 
    , performancerank 
    from cte_performancerating
    where performancerank = 1;

    --? 2. Correlated Subquery – Employees Earning More Than Dept Avg

with cte_avgdepartmentsalary as 
(
    select departmentid , avg(salary) as avgsalaryperdept
    from employeess
    group by departmentid 
)
        select e.employeeid , e.salary ,e.departmentid
        from employeess as e
        join cte_avgdepartmentsalary as ads
        on ads.departmentid = e.departmentid 
        where salary > avgsalaryperdept

select
    e1.employeeid , e1.salary , e1.DepartmentID 
    from employeess as e1
    where e1.salary > 
            (
                select avg(e2.salary) 
                from employeess as e2
                where e2.DepartmentID = e1.DepartmentID )


--? 3. Correlated Subquery – Managers Earning Less Than Their Subordinates

select *  from employeess 
select * from departmentss

select e1.managerid , e1.salary 
from employeess as e1 
where 1.salary < 
        ( select min(e2.salary ) 
        from employeess as e2 
        where e2.employeeid = e1.employeeid )

        select 
        e1.employeeid , e1.salary , e2.managerid 
        from employeess as e1 
        join employeess as e2 
        on e.employeeid = e2.managerid 
        where e2.salary 


        select managerid , salary 
        from employeess as e1
        where e1.salary <
            (select e2.salary 
            from employeess as e2
            )

            update employeess
            set salary = 50000
            where employeeid = 1

            select * from employeess


            SELECT DISTINCT e1.EmployeeID, e1.fullname, e1.Salary
FROM Employeess e1
WHERE EXISTS (
    SELECT 1
    FROM Employeess e2
    WHERE e2.ManagerID = e1.EmployeeID
      AND e2.Salary > e1.Salary
);

/*Write a stored procedure GiveBonus that increases salary by:

10% if PerformanceScore >= 90

5% if PerformanceScore >= 80 AND < 90*/


create procedure prcd_GiveBonus 
as
begin
    update employeess
    set salary = salary * 1.10
    where performancescore >= 90
    end ;
    select * from employeess
    exec prcd_GiveBonus

create procedure prcd_getemployeesbydepartments @departmentid int
as 
begin
        select employeeid , fullname , salary , performancescore 
        from employeess 
        where departmentid = @departmentid 
end

exec prcd_getemployeesbydepartments  @departmentid = 2
select* from employeess

create procedure prcd_promotetomanager @employeeid int
as
begin
        declare @oldmanagerid int

      select @oldmanagerid = managerid
      from employeess
      where employeeid = @employeeid


        if @oldmanagerid is null
        begin
        print'the employee is still a manager or does not exist'
        end

        update employeess
        set managerid = null
        where employeeid = @employeeid 

        update employeess
        set managerid = @employeeid 
        where managerid = @oldmanagerid 
        and employeeid <> @employeeid 
end
exec prcd_promotetomanager @employeeid = 5
select * from employeess


-- Task 4: Trigger to prevent salary decrease
--Create a trigger PreventSalaryDecrease on Employeess that prevents updates if the new salary is lower than the old salary.

create trigger trg_PreventSalaryDecrease on employeess
for update
as
begin
        if exists (
            select 1 from inserted as i 
            join deleted as d on d.employeeid = i.employeeid 
            where i.salary < d.salary)
            begin
                    raiserror ('salary cannot be less then old salary. ',16,1)
                    rollback transaction;
                    end
end

update 
select * from employeess

update employeess
set salary = 50000
where employeeid = 1






