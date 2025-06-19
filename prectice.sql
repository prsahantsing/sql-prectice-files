CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    amount DECIMAL(10, 2)
);
INSERT INTO Orders (order_id, customer_id, order_date, amount) VALUES
(1, 101, '2024-01-10', 250.00),
(2, 101, '2024-02-15', 450.00),
(3, 101, '2024-03-20', 150.00),
(4, 102, '2024-01-12', 700.00),
(5, 102, '2024-01-22', 200.00),
(6, 102, '2024-03-25', 500.00),
(7, 103, '2024-02-05', 100.00),
(8, 103, '2024-03-05', 300.00),
(9, 103, '2024-04-05', 400.00),
(10, 104, '2024-01-01', 900.00),
(11, 104, '2024-01-15', 800.00);
--he top 2 most expensive orders per customer based on amount.


select * from orders
select customer_id , sum(amount) as totalsales 
from 
orders 
group by customer_id  
where 


select t.customer_id , t.amount , t.rn 
from (
select customer_id ,amount , rank() over (partition by customer_id order by amount desc ) as rn 
from orders 
)t
where t.rn in (1,2)

select custmerid 
from orders 
where amount in 
(
select amount 
from sales 

select * from orders

--: Running Total with Partition (CTE)

with cte_running as 
(
    select customer_id , sum(amount) over (partition by customer_id order by order_date ) rn 
    from orders 
   )
   select o.amount ,o.customer_id  LEAD(r.rn ) over ( partition by o.customer_id order by o.order_date )as running_total
   from orders as o 
   join cte_running as r
   on r.customer_id = o.customer_id 


   SELECT * from orders


    select 
   customer_id,
    order_date,
    amount,
    SUM(amount) OVER (
        PARTITION BY customer_id
        ORDER BY order_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM orders;

-- Customers with Most Recent Order Amount > Their Average (Correlated Subquery)
select * from orders

with cte_avg_amount as 
(
select customer_id , avg(amount) as avg_amunt 
from orders 
group by customer_id 
) select order_id ,order_date
from orders 
where amount > avg_amount 
and order_date

with cte_avgtotal as 
(
        select customerid , 
        avg(totalamount) as avg_amount 
        from orders 
        group by customerid 
),cte_recent_orderdate as 
(
        select customerid ,
        max(orderdate) as recentorders
        from orders 
    group by customerid 
)
    select o.CustomerID ,
        o.orderdate ,
        o.TotalAmount,
        cro.recentorders,
        cat.avg_amount
        from orders  as o 
        join cte_avgtotal as cat 
        on cat.customerid = o.CustomerID
        join cte_recent_orderdate as cro
        on cro.CustomerID = o.CustomerID
where o.totalamount > cat.avg_amount 
and 
orderdate = cro.recentorders

drop index idx_customerid_totalamount on orders

create nonclustered columnstore index idx_orders_customer_id_totalamount_orderdate 
on orders(customerid , orderdate , totalamount )

select top 10 * from 
orders
-- Get the latest order for each customer using a correlated subquery.

select o.CustomerID 
from orders as o
where o.orderdate = 
(
select max(o2.orderdate) 
from orders as o2
where o.customerid = o2.customerid )

SELECT o.CustomerID 
FROM orders AS o
WHERE o.orderdate = (
    SELECT MAX(o2.orderdate) 
    FROM orders AS o2
    WHERE o.customerid = o2.customerid
);

--3. Find orders that are the highest for each customer (may return ties).

select top 10 * from orders

select o.customerid , totalamount , orderdate 
from orders as o
where o.totalamount = 
(
    select max(o2.totalamount) 
    from orders as o2
    where o2.customerid = o.customerid )
    order by orderdate desc


    -Find all orders that are the highest-value order placed by each customer in the last 6 months of their ordering activity.

    select  customerid ,orderid, max(totalamount) as highestvalue 
    from orders 
    group by customerid , OrderID
    having 



    select o,customerid , o.orderid , o.totalamount , o.orderdate
    from orders as o 
    where o.orderdate >=
    (
        select max(orderdate ) - interval '6 month'
        from orders o2
        where o,customerid = o2.customerid 
        )
        and 
        (   select max(totalamount)
        from orders as o3 
        where o3.customerid = o.customerid and 
        (select max(orderdate) - interval '6 month'
        from orders as o4
        where o4.customerid = 03.customerid ))

--Use a correlated subquery to get the maximum amount for each customer and filter only those rows.

select * from orders 

select O.customerid , O.orderid , O.TotalAmount 
    from 
  orders AS O
  where O.TotalAmount =
  (
            SELECT MAX(O2.TOTALAMOUNT) 
            FROM ORDERS AS O2
            WHERE O2.CUSTOMERID =O.CUSTOMERID
)
--. Find all orders that are higher than the customer's previous order.

SELECT 
    O.CUSTOMERID , O.ORDERID , O.TOTALAMOUNT 
    FROM ORDERS AS O
    WHERE O.TotalAmount > 



    SELECT o1.*
FROM orders o1
WHERE o1.TotalAmount > (
    SELECT o2.TotalAmount
    FROM orders o2
    WHERE o2.customerid = o1.customerid
      AND o2.orderdate < o1.orderdate
    ORDER BY o2.orderdate DESC
);
SELECT o1.*
FROM orders o1
WHERE o1.TotalAmount > (
    SELECT TOP 1 o2.TotalAmount
    FROM orders o2
    WHERE o2.customerid = o1.customerid
      AND o2.orderdate < o1.orderdate
    ORDER BY o2.CUSTOMERID 
);

-- Find customers whose latest order is also their lowest order.

SELECT O.CUSTOMERID , O.TOTALAMOUNT , O.ORDERDATE 
FROM ORDERS AS O 
WHERE O.ORDERDATE = 
(
        SELECT MAX(O2.ORDERDATE) 
        FROM ORDERS AS O2
        WHERE O2.CUSTOMERID = O.CUSTOMERID 
 )
 AND O.TOTALAMOUNT = 
 (
           SELECT MIN(O3.TOTALAMOUNT)
           FROM ORDERS AS O3 
           WHERE O3.CUSTOMERID = O.CUSTOMERID 
           )
  

  --4. 5. Find orders that are above the customer's average, but only if the customer has placed at least 5 orders.

  SELECT O.CUSTOMERID , O.TOTALAMOUNT , O.ORDERDATE , O.ORDERID
  FROM ORDERS AS O 
  WHERE O.TOTALAMOUNT > 
  (
                SELECT AVG(O2.TOTALAMOUNT)
                FROM ORDERS AS O2 
                WHERE O2.CUSTOMERID = O.CUSTOMERID 
)
AND (SELECT COUNT(*)
FROM ORDERS AS O3 
WHERE O3.CUSTOMERID = O.CUSTOMERID) 
>=5;






select * from sales.Customers

select * from dbo.sales 


--get sales by storeid 


create procedure pro_tsales_by_storeid @storeid int
as begin
select sum(revenue) as totalsales 
from dbo.Sales
where storeid = @storeid
end 
+
exec pro_tsales_by_storeid @storeid = 46


select * from dbo.sales

drop table customerlog

create table customerlog
(
customerid int ,
customerlog varchar (250) , 
joining_date datetime )

select * from customerlog


alter trigger trg_new_customer_log on dbo.sales
after insert 
as
begin
    insert into customer_log 
    (customerrid , customerlog , joining_date ) 
    select customerid , 
    'a new customer has just logged in ' + cast(customerid  as varchar), 
    GETDATE() 
    from inserted 
end

select * from dbo.sales


insert into dbo.sales
(customerid , ProductID , storeid )
values ( '101' , '51' , '84')



end 


