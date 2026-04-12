/*Q1: Row Number per Customer
👉 For each customer, assign a sequence number to their orders based on order_date (earliest = 1).
👉 Output:
	customer_id
	order_id
	order_date
	row_number */

SELECT 
    customer_id,
    order_id,
    order_date,
    ROW_NUMBER() OVER (
        PARTITION BY customer_id 
        ORDER BY order_date ASC
    ) AS row_number
FROM orders;



/* Q2: Latest Order per Customer
👉 Find the most recent order for each customer.
👉 Important:
	Use window function (NOT GROUP BY)
	Return full row (not just date) */

WITH temp AS(
      SELECT customer_id,
	         order_id,
	         order_amount,
	         order_status,
	         order_date,
	         ROW_NUMBER() OVER (
	         PARTITION BY customer_id
		     ORDER BY order_date DESC
	         ) AS rn
FROM orders )

SELECT customer_id,  order_id, order_amount, order_status, order_date
FROM temp 
where rn = 1;





/*Q3: Rank Customers by Total Spend
👉 Step 1: Calculate total spend per customer
👉 Step 2: Rank customers (highest spend = rank 1)
👉 Output:
	customer_id
	total_spend
	rank */

WITH customer_spend AS(
SELECT customer_id, SUM(order_amount) AS total_spend
FROM orders
GROUP BY customer_id 
)

SELECT customer_id, total_spend,
DENSE_RANK() OVER (
ORDER BY total_spend DESC
)AS rank
FROM customer_spend ;




/*Q4: Compare RANK vs DENSE_RANK
👉 Using same total spend data:
	Apply RANK()
	Apply DENSE_RANK()
👉 Observe: What happens when 2 customers have same spend?
*/

--WITH RANK()
WITH customer_spend AS (
    SELECT 
        customer_id,
        SUM(order_amount) AS total_spend
    FROM orders
    GROUP BY customer_id
)

SELECT 
    customer_id,
    total_spend,
    RANK() OVER (ORDER BY total_spend DESC) AS rnk
FROM customer_spend;

--WITH DENSE_RANK()
WITH customer_spend AS (
    SELECT 
        customer_id,
        SUM(order_amount) AS total_spend
    FROM orders
    GROUP BY customer_id
)

SELECT 
    customer_id,
    total_spend,
    DENSE_RANK() OVER (ORDER BY total_spend DESC) AS drnk
FROM customer_spend;

/*
🔹 RANK()
          Same values get same rank
          Skips next rank after tie
          👉 Example: 1, 2, 2, 4
🔹 DENSE_RANK()
          Same values get same rank
          No rank skipping
          👉 Example: 1, 2, 2, 3
*/




/*
 Q5: Top 2 Orders per Customer
👉 For each customer: Find their top 2 highest order_amount
👉 Output:
	customer_id
	order_id
	order_amount

*/

WITH temp AS(SELECT customer_id, order_id, order_amount,
			 ROW_NUMBER() OVER (
			 PARTITION BY customer_id
			 ORDER BY order_amount DESC 
			 ) AS rn 
			 FROM orders 
			 )

SELECT customer_id, order_id, order_amount
FROM temp 
where rn <=2;




/*
 Q6: Running Total per Customer
👉 For each customer: Sort orders by date and Calculate cumulative sum of order_amount
👉 Output:
	customer_id
	order_id
	order_date
	running_total
*/
SELECT 
    customer_id,
    order_id,
    order_date,
    SUM(order_amount) OVER (
        PARTITION BY customer_id 
        ORDER BY order_date
    ) AS running_total
FROM orders;



/*
Q7: Previous Order Amount (LAG)
👉 For each order: Show previous order amount of same customer
👉 Output:
	customer_id
	order_id
	order_amount
	previous_order_amount
👉 If no previous → NULL
*/
SELECT 
    customer_id,
    order_id,
    order_amount,
    LAG(order_amount) OVER (
        PARTITION BY customer_id 
        ORDER BY order_date
    ) AS previous_order_amount
FROM orders;




/*
Q8: Order Difference
👉 For each order: Calculate difference between current and previous order
👉 Formula:current_order - previous_order
*/
SELECT 
    customer_id,
    order_id,
    order_amount,
    LAG(order_amount) OVER (
        PARTITION BY customer_id 
        ORDER BY order_date
    ) AS previous_order_amount,

    order_amount - LAG(order_amount) OVER (
        PARTITION BY customer_id 
        ORDER BY order_date
    ) AS order_difference
FROM orders;




/*
Q9: First Order Flag
👉 Mark orders:
	1 → if it is first order of customer
	0 → otherwise
👉 Based on order_date
*/
SELECT 
    customer_id,
    order_id,
    order_date,
    CASE 
        WHEN ROW_NUMBER() OVER (
            PARTITION BY customer_id 
            ORDER BY order_date
        ) = 1 
        THEN 1 
        ELSE 0 
    END AS first_order_flag
FROM orders;



/*
Q10: Deduplicate Orders 
👉 In dataset: Customer 102 has duplicate orders (same date & amount)
👉 Task:
	Keep only ONE record per:
	(customer_id, order_date, order_amount)
	Prefer latest (use order_id for tie-breaking)
👉 Output: Cleaned dataset
*/
WITH ranked_orders AS (
    SELECT 
        customer_id,
        order_id,
        order_amount,
        order_date,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id, order_date, order_amount
            ORDER BY order_id DESC
        ) AS rn
    FROM orders
)

SELECT 
    customer_id,
    order_id,
    order_amount,
    order_date
FROM ranked_orders
WHERE rn = 1;
      
      
     