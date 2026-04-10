WITH customers AS (
    SELECT 101 AS customer_id, 'Alice' AS customer_name, 'India' AS country UNION ALL
    SELECT 102, 'Bob', 'India' UNION ALL
    SELECT 103, 'Charlie', 'USA' UNION ALL
    SELECT 104, 'David', 'UK' UNION ALL
    SELECT 105, 'Eva', 'India' UNION ALL
    SELECT 106, 'Frank', 'Germany'
),

orders AS (
    SELECT 1 AS order_id, 101 AS customer_id, 500 AS order_amount, 'DELIVERED' AS order_status, DATE '2023-01-05' AS order_date UNION ALL
    SELECT 2, 102, 300, 'CANCELLED', DATE '2023-01-10' UNION ALL
    SELECT 3, 101, 700, 'DELIVERED', DATE '2023-02-15' UNION ALL
    SELECT 4, 103, 400, 'PENDING', DATE '2023-02-20' UNION ALL
    SELECT 5, 104, 1200, 'DELIVERED', DATE '2023-03-01' UNION ALL
    SELECT 6, 102, 800, 'DELIVERED', DATE '2023-03-05' UNION ALL
    SELECT 7, 101, 200, 'CANCELLED', DATE '2023-03-10' UNION ALL
    SELECT 8, 105, 1500, 'DELIVERED', DATE '2023-03-15' UNION ALL
    SELECT 9, 106, 600, 'PENDING', DATE '2023-03-20'
)


--Q1: Order Status Count (Pivot Style)..Find count of orders for each status (DELIVERED, CANCELLED, PENDING) in separate columns.
select customer_id, 
       count(case when order_status = 'DELIVERED' then 1 end) as deliverd_count,
	   count(case when order_status = 'CANCELLED' then 1 end) as cancelled_count,
	   count(case when order_status = 'PENDING' then 1 end) as pending_count
from orders
group by customer_id

/*Q2: Customer Segmentation by Spend
Classify customers:
HIGH ? total spend > 1500
MEDIUM ? 800–1500
LOW ? < 800 */
select 
    c.customer_id,
    c.customer_name,
    coalesce(SUM(o.order_amount), 0) AS total_spend,
    CASE 
        WHEN coalesce(SUM(o.order_amount), 0) > 1500 then 'HIGH'
        WHEN coalesce(SUM(o.order_amount), 0) BETWEEN 800 AND 1500 then 'MEDIUM'
        ELSE 'LOW'
    end as customer_segment
from customers c
LEFT JOIN orders o 
    on c.customer_id = o.customer_id
group by c.customer_id, c.customer_name;

--Q3: Delivered vs Cancelled Revenue..Find total DELIVERED revenue and CANCELLED revenue in same row.
SELECT
    SUM(CASE WHEN order_status = 'DELIVERED' THEN order_amount ELSE 0 END) AS delivered_revenue,
    SUM(CASE WHEN order_status = 'CANCELLED' THEN order_amount ELSE 0 END) AS cancelled_revenue
FROM orders;

/* Q4: Active vs Inactive Customers
Active → at least 1 order
Inactive → no orders */
select    c.customer_id,
    c.customer_name,
    c.country,
    case
        when count(o.order_id) > 0 then 'Active'
        else 'Inactive'
    end as customer_status,
    count(o.order_id) as total_orders
from customers c
LEFT JOIN orders o on c.customer_id = o.customer_id
group by c.customer_id, c.customer_name, c.country
order by customer_status, c.customer_id;


/* Q5: Customers with More Delivered than Cancelled Orders
Find customers where:delivered_count > cancelled_count */
select
    c.customer_name,
    sum(case when o.order_status = 'delivered' then 1 else 0 end) as delivered_count,
    sum(case when o.order_status = 'cancelled' then 1 else 0 end) as cancelled_count
from customers c
join orders o on c.customer_id = o.customer_id
group by c.customer_id, c.customer_name
having delivered_count > cancelled_count;

/*Q6: Percentage of Delivered Orders per Customer
For each customer:% of delivered orders = delivered_orders / total_orders*/
select
    c.customer_name,
    count(o.order_id) as total_orders,
    sum(case when o.order_status = 'delivered' then 1 else 0 end) as delivered_orders,
    round(
        sum(case when o.order_status = 'delivered' then 1 else 0 end) * 100.0
		/ count(o.order_id), 2) as delivered_pct
from customers c
join orders o on c.customer_id = o.customer_id
group by c.customer_id, c.customer_name;

/*Q7: High-Value Months
Find months where total revenue > 2000
Use order_date*/

select
    date_format(order_date, '%y-%m') as month,
    sum(order_amount) as total_revenue
from orders
group by date_format(order_date, '%y-%m')
having sum(order_amount) > 2000;

/*Q8: Customers with Only One Order Type

Find customers who have orders of only one type (only delivered OR only cancelled OR only pending)*/
select
    c.customer_name,
    min(o.order_status) as only_order_type
from customers c
join orders o on c.customer_id = o.customer_id
group by c.customer_id, c.customer_name
having count(distinct o.order_status) = 1;

/* Q9: Revenue Contribution Category
Classify each customer:
TOP → contributes > 40% of total revenue
MEDIUM → 10–40%
LOW → < 10% */
--Requires multi-step thinking

SELECT
    c.customer_name,
    SUM(o.order_amount) AS cust_revenue,
    ROUND(SUM(o.order_amount) * 100.0 / (SELECT SUM(order_amount) FROM orders), 2) AS contribution_pct,
    CASE
        WHEN SUM(o.order_amount) * 100.0 / (SELECT SUM(order_amount) FROM orders) > 40 THEN 'TOP'
        WHEN SUM(o.order_amount) * 100.0 / (SELECT SUM(order_amount) FROM orders) BETWEEN 10 AND 40 THEN 'MEDIUM'
        ELSE 'LOW'
    END AS category
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name;

/*Q10: Conditional Aggregation + HAVING (Important 🔥)
Find customers whose:
delivered revenue > cancelled revenue
AND total orders > 1*/
select
    c.customer_name,
    sum(case when o.order_status = 'delivered' then o.order_amount else 0 end) as delivered_rev,
    sum(case when o.order_status = 'cancelled' then o.order_amount else 0 end) as cancelled_rev,
    count(o.order_id) as total_orders
from customers c
join orders o on c.customer_id = o.customer_id
group by c.customer_id, c.customer_name
having delivered_rev > cancelled_rev
   and total_orders > 1;