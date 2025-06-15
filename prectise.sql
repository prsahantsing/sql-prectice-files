
create schema corre

CREATE TABLE corre.salespersons (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    region VARCHAR(50),
    join_date DATE
);

INSERT INTO corre.salespersons VALUES
(1, 'Alice', 'East', '2022-01-15'),
(2, 'Bob', 'East', '2022-03-10'),
(3, 'Charlie', 'West', '2022-01-01'),
(4, 'David', 'West', '2022-02-20'),
(5, 'Eve', 'North', '2022-01-05');

CREATE TABLE corre.sales (
    id INT PRIMARY KEY,
    salesperson_id INT,
    sale_amount DECIMAL(10, 2),
    sale_date DATE,
    FOREIGN KEY (salesperson_id) REFERENCES corre.salespersons(id)
);

INSERT INTO corre.sales VALUES
-- Alice (East)
(1, 1, 1200.00, '2022-02-01'),
(2, 1, 1300.00, '2022-03-01'),
(3, 1, 1500.00, '2022-04-01'),
(4, 1, 1100.00, '2022-05-01'),

-- Bob (East)
(5, 2, 1000.00, '2022-03-01'),
(6, 2, 1100.00, '2022-04-01'),
(7, 2, 900.00, '2022-05-01'),

-- Charlie (West)
(8, 3, 2000.00, '2022-02-01'),
(9, 3, 1900.00, '2022-03-01'),
(10, 3, 2100.00, '2022-04-01'),

-- David (West)
(11, 4, 1000.00, '2022-03-01'),
(12, 4, 950.00, '2022-04-01'),
(13, 4, 1100.00, '2022-05-01'),

-- Eve (North)
(14, 5, 1300.00, '2022-02-01'),
(15, 5, 1350.00, '2022-03-01'),
(16, 5, 1400.00, '2022-04-01'),
(17, 5, 1450.00, '2022-05-01');

select * from corre.sales
select * from corre.salespersons
-- Find the correlation between monthly sales and salesperson experience level, 
--and identify top performers whose performance consistently exceeds their regional average.

with cte_totalsales as 
(
select 
    s.salesperson_id ,sp.region ,
    sum(sale_amount)  as totalsales from 
        corre.sales as s
  join corre.salespersons as sp
  on sp.id = s.salesperson_id
  group by s.salesperson_id , sp.region
  ),cte_topbyregion as 
  (
        select cts.salesperson_id , 
                cts.region , 
                cts.totalsales , 
                rank() over (partition by region order by totalsales desc ) as regionrank 
        from cte_totalsales as cts 
   )
        select * from cte_topbyregion 
        where regionrank = 1
      
      drop schema corre

    drop table corre.salespersons
    drop table corre.sales\


    create schema corre 
    CREATE TABLE corre.employees (
    employee_id INT PRIMARY KEY,
    name VARCHAR(100),
    department_id INT
);

INSERT INTO corre.employees VALUES
(1, 'Alice', 101),
(2, 'Bob', 101),
(3, 'Charlie', 102),
(4, 'David', 102),
(5, 'Eva', 103),
(6, 'Frank', 103);


 CREATE TABLE corre.performance (
    id INT PRIMARY KEY,
    employee_id INT,
    performance_score DECIMAL(5,2),
    month DATE,
    FOREIGN KEY (employee_id) REFERENCES corre.employees(employee_id)
);

INSERT INTO corre.performance VALUES
(1, 1, 88.5, '2023-01-01'),
(2, 1, 91.0, '2023-02-01'),
(3, 1, 87.5, '2023-03-01'),
(4, 2, 84.0, '2023-01-01'),
(5, 2, 86.0, '2023-02-01'),
(6, 2, 85.0, '2023-03-01'),

(7, 3, 78.0, '2023-01-01'),
(8, 3, 82.0, '2023-02-01'),
(9, 3, 80.0, '2023-03-01'),
(10, 4, 75.0, '2023-01-01'),
(11, 4, 70.0, '2023-02-01'),
(12, 4, 72.0, '2023-03-01'),

(13, 5, 92.0, '2023-01-01'),
(14, 5, 95.0, '2023-02-01'),
(15, 5, 96.0, '2023-03-01'),
(16, 6, 89.0, '2023-01-01'),
(17, 6, 90.0, '2023-02-01'),
(18, 6, 88.0, '2023-03-01');

select * from corre.employees
select * from corre.performance
/*


For each employee:

Count how many months they outperformed their department.

Calculate the percentage of outperforming months.

Return:

Employee name

Department ID

Total months

Outperforming months

Outperformance percentage

Only show employees who outperformed in more than 50% of the months.

Order by outperformance percentage descending.*/

/*For each employee and month:

Get their performance score.

Calculate the average score for their department that month.

Mark whether the employee outperformed their department average in that month.*/
select * from corre.performance
select * from corre.employees






with cte_month1 as 
(
select employee_id ,month(month) as month1
from corre.performance
where month(month) = 1
), cte_month2 as
(
select employee_id ,month(month) as month2
from corre.performance
where month(month) = 2
),cte_month3 as 
(
select employee_id ,month(month) as month3
from corre.performance
where month(month) = 3
)
select 
        p1.employee_id , 
        p1.performance_score ,  
        month(p1.month) as month1 ,
        avg(p1.performance_score) over (partition by e.department_id,cm1.month1) as avgdepartment_Score_month1,
        p2.employee_id ,
        p2.performance_score ,
        month(p2.month) as month2 , 
        e.department_id , 
        avg(p2.performance_score) over (partition by e.department_id,cm2.month2) as avgdepartment_Score_month2
from corre.performance as p1
join corre.performance as p2
on p1.employee_id = p2.employee_id 
join corre.employees as e 
on e.employee_id = p1.employee_id 
join cte_month1 as cm1 
on cm1.employee_id = p1.employee_id 
join cte_month2 as cm2
on cm2.employee_id = p2.employee_id 
where month(p1.month) <> month(p2.month) and p1.performance_score <> p2.performance_score
order by p1.employee_id , p2.employee_id



WITH perf_with_avg AS (
    SELECT
        p.employee_id,
        e.name,
        e.department_id,
        MONTH(p.month) AS month,
        p.performance_score,
        AVG(p.performance_score) OVER (
            PARTITION BY e.department_id, MONTH(p.month)
        ) AS dept_avg_score
    FROM corre.performance p
    JOIN corre.employees e ON p.employee_id = e.employee_id
),
flagged AS (
    SELECT 
        *,
        CASE 
            WHEN performance_score > dept_avg_score THEN 1 
            ELSE 0 
        END AS outperformed
    FROM perf_with_avg
),
agg_result AS (
    SELECT
        employee_id,
        name,
        department_id,
        COUNT(*) AS total_months,
        SUM(outperformed) AS outperform_months,
        ROUND(100.0 * SUM(outperformed) / COUNT(*), 2) AS outperform_percentage
    FROM flagged
    GROUP BY employee_id, name, department_id
)
SELECT *
FROM agg_result
WHERE outperform_percentage > 50
ORDER BY outperform_percentage DESC;


select * from corre.performance
select * from corre.employees

with declaremonths as 
(
select cp.employee_id ,cp.performance_score ,  month(cp.month) as months 
from corre.performance as cp
),month1 as 
select d1.employee_id , d1.performance_score 
from declaremonths as d1
where d1.months = 1
)
--, month2p as (
    select d2.employee_id , d2.performance_score 
from declaremonths as d2
where d2.months = 2

),month3p as 
(
  select employee_id , performance_score , 
from declaremonths as d3
where d3.months = 3





with cte_months as 
(
        select
                p.employee_id , p.performance_score , month(p.month) as months 
        from corre.performance as p 
        where month(p.month) = 1
        ), cte_secondmonth as 
        (
        select 
                p1.employee_id , p1.performance_score , month(p1.month) as months1
        from corre.performance as p1
        where month(month) = 2
       ) , marchperfo as 
       ( select 
                p2.employee_id , p2.performance_score , month(p2.month) as monthmar
       from corre.performance as p2
       where month(p2.month) = 3
       ), avgperfomance as 
       (
       select
                e.department_id , 
                avg(performance_score) as avgscore
       from corre.performance as p
       join corre.employees as e 
       on e.employee_id =   p.employee_id
       group by e.department_id 
       )
            SELECT 
                     CM.EMPLOYEE_ID , CM.PERFORMANCE_SCORE  as Jan_Performance_Score
                   , CM2.performance_score AS FEB_PERFORMANCE_Score ,
                     cm3.performance_score as Mar_Performance_Score ,
                     e.department_id , 
                     AVGP.avgscore
          FROM cte_months AS CM
          LEFT JOIN cte_secondmonth AS CM2
          ON CM2.EMPLOYEE_ID = CM.employee_id
          left join marchperfo as cm3 
          on cm3.employee_id = cm.employee_id 
          join corre.employees as E
          ON E.EMPLOYEE_ID = CM.EMPLOYEE_ID 
          LEFT JOIN avgperfomance AS AVGP
          ON AVGP.DEPARTMENT_ID = E.DEPARTMENT_ID 





          select * from corre.performance 
          select * from corre.employees


          create view vie_customer_details as 
          (
                        select p.employee_id , p.performance_score , p.month ,
                        e.department_id , e.name 
                        from corre.performance as p 
                        join corre.employees as e 
                        on e.employee_id = p.employee_id 
                        where month(month) = 2
                        )


                        select* from vie_customer_details

                        select * from corre.performance


                        select
                            employee_id , 
                            avg(performance_Score) as avg_performance_per_monht  
                        from corre.performance 
                        group by employee_id 
                        having employee_id = 2











