WITH orders AS (
    SELECT 1 AS order_id, 101 AS customer_id, 'DELIVERED' AS order_status, 500 AS order_amount, '2023-01-05' AS order_date UNION ALL
    SELECT 2, 102, 'CANCELLED', 300, '2023-01-10' UNION ALL
    SELECT 3, 101, 'DELIVERED', 700, '2023-02-15' UNION ALL
    SELECT 4, 103, 'PENDING', 400, '2023-02-20' UNION ALL
    SELECT 5, 104, 'DELIVERED', 1200, '2023-03-01' UNION ALL
    SELECT 6, 102, 'DELIVERED', 800, '2023-03-05' UNION ALL
    SELECT 7, 101, 'CANCELLED', 200, '2023-03-10' UNION ALL
    SELECT 8, 105, 'DELIVERED', 1500, '2023-03-15' UNION ALL
    SELECT 9, 106, 'PENDING', 600, '2023-03-20' UNION ALL
    SELECT 10, 104, 'DELIVERED', 900, '2023-03-25'
)
SELECT * FROM orders;


--Q1:Find total number of orders for each order_status.
SELECT order_status, COUNT(*) AS total_orders
FROM orders
GROUP BY order_status;


--Q2:Find total revenue generated only from DELIVERED orders.
SELECT SUM(order_amount) as total_revenue_by_deliverd
from orders
where order_status = 'DELIVERED';


--Q3:Find total number of orders placed after '2023-02-01'.
SELECT COUNT(*) AS total_orders
FROM orders
WHERE order_date > '2023-02-01';

--Q4:Find total revenue and total orders for each customer_id.
SELECT customer_id, SUM(order_amount) as total_revenue, Count(*) as total_orders
FROM orders
group by customer_id;

--Q5:Find customers who have placed more than 1 order.
SELECT customer_id
FROM orders
GROUP BY customer_id
--HAVING COUNT(*) > 1;

--Q6:Find total revenue for each order_status where revenue is greater than 1000.
select order_status, sum(order_amount) AS total_revenue
from orders
group by order_status
having sum(order_amount) > 1000


--Q7:Find the average order amount for each customer_id.
Find the average order amount for each customer_id
select customer_id, avg(order_amount) as avg_order_amount
from orders
group by customer_id;



WITH orders AS (
    SELECT 1 AS order_id, 101 AS customer_id, 'DELIVERED' AS order_status, 500 AS order_amount, '2023-01-05' AS order_date UNION ALL
    SELECT 2, 102, 'CANCELLED', 300, '2023-01-10' UNION ALL
    SELECT 3, 101, 'DELIVERED', 700, '2023-02-15' UNION ALL
    SELECT 4, 103, 'PENDING', 400, '2023-02-20' UNION ALL
    SELECT 5, 104, 'DELIVERED', 1200, '2023-03-01' UNION ALL
    SELECT 6, 102, 'DELIVERED', 800, '2023-03-05' UNION ALL
    SELECT 7, 101, 'CANCELLED', 200, '2023-03-10' UNION ALL
    SELECT 8, 105, 'DELIVERED', 1500, '2023-03-15' UNION ALL
    SELECT 9, 106, 'PENDING', 600, '2023-03-20' UNION ALL
    SELECT 10, 104, 'DELIVERED', 900, '2023-03-25'
)
--Q8:Find total revenue generated in the month of March 2023.
select sum(order_amount) as total_revenue
from orders
where order_date BETWEEN '2023-03-01' AND '2023-03-31'  

