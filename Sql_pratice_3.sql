CREATE TABLE customers (
    customer_id INT,
    customer_name VARCHAR(50),
    country VARCHAR(50)
);

INSERT INTO customers (customer_id, customer_name, country)
VALUES
(101, 'Alice', 'India'),
(102, 'Bob', 'India'),
(103, 'Charlie', 'USA'),
(104, 'David', 'UK'),
(105, 'Eva', 'India'),
(106, 'Frank', 'Germany');


--Q1:basic join..Get all orders with corresponding customer_name.
select c.customer_id , c.customer_name, o.order_id
from customers c
inner join orders o
on c.customer_id = o.customer_id

--Q2:Orders Count per Customer..Find total number of orders for each customer..Include customer name
select c.customer_id, c.customer_name, count(o.order_id) as total_orders
from customers c
inner join orders o
on c.customer_id = o.customer_id
group by c.customer_id, c.customer_name


--Q3:Customers with No Orders..Find customers who have never placed any order.
select c.customer_id, c.customer_name
from customers c
left join orders o
on c.customer_id = o.customer_id
where o.order_id IS NULL;


--Q4:Total Revenue per Customer..Find total order amount for each customer..Include customers with zero revenue
select c.customer_id, c.customer_name, sum(order_amount) as total_revenue
from customers c
left join orders o
on c.customer_id = o.customer_id
group by c.customer_id, c.customer_name;

--Q5:Delivered Revenue per Customer..Find total revenue from DELIVERED orders for each customer..Include customers with zero delivered revenue
select c.customer_id, c.customer_name, sum(o.order_amount) as total_revenue
from customers c 
left join orders o
on c.customer_id = o.customer_id and 
o.order_status = 'DELIVERED'
group by c.customer_id, c.customer_name


--Q6:Customers with Only Cancelled Orders..Find customers who have placed orders but all of them are CANCELLED.
select c.customer_id, c.customer_name
from customers c 
join orders o
on c.customer_id = o.customer_id
group by c.customer_id, c.customer_name
having count(*) = count(case when order_status = 'CANCELLED' then 1 end)

select * from customers 
select * from orders


--Q7: Top Spending Customer..Find customer with highest total order amount.
select top 1 c.customer_id, c.customer_name, sum(o.order_amount) as total_spending
from customers c
join orders o
on c.customer_id = o.customer_id
group by c.customer_id, c.customer_name
order by total_spending DESC;

--Q8: Country-wise Revenue..Find total revenue grouped by country.
select c.country, sum(o.order_amount) as total_revenue
from customers c
join orders o
on c.customer_id = o.customer_id
group by c.country

--Q9: Customers with At Least 1 Delivered Order..Find customers who have at least one DELIVERED order..Avoid duplicates
select distinct c.customer_id, c.customer_name
from customers c
join orders o
on c.customer_id = o.customer_id
where o.order_status = 'DELIVERED'

--Q10: Mismatch Detection..Find orders where customer_id does NOT exist in customers table..Real-world: data quality check
select o.*
from orders o
left join customers c
on o.customer_id = c.customer_id
where c.customer_id is null;