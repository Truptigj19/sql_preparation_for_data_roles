# 📊 SQL Window Functions – Complete Guide

## 🔹 What is a Window Function?

Window function performs calculation across a set of rows related to the current row **without removing rows**.

👉 Unlike `GROUP BY`, it does NOT reduce rows.

---

## 🔹 Syntax

```sql
SELECT column_name,
       function() OVER (
           PARTITION BY column
           ORDER BY column
       )
FROM table_name;
```

---

## 🔹 Key Concepts

### 🔸 1. PARTITION BY

Divides data into groups

```sql
SELECT customer_id,
       SUM(order_amount) OVER (PARTITION BY customer_id) AS total_spend
FROM orders;
```

---

### 🔸 2. ORDER BY (inside OVER)

Defines order for calculations

```sql
SELECT customer_id,
       order_date,
       SUM(order_amount) OVER (
           PARTITION BY customer_id
           ORDER BY order_date
       ) AS running_total
FROM orders;
```

---

## 🔹 Types of Window Functions

---

### 🔸 A. Aggregate Functions

* SUM()
* AVG()
* COUNT()
* MAX()
* MIN()

```sql
SELECT customer_id,
       AVG(order_amount) OVER (PARTITION BY customer_id) AS avg_spend
FROM orders;
```

---

### 🔸 B. Ranking Functions

#### 1. ROW_NUMBER()

Unique rank

```sql
SELECT *,
       ROW_NUMBER() OVER (ORDER BY order_amount DESC) AS rn
FROM orders;
```

---

#### 2. RANK()

Same values → same rank, skips numbers

```sql
SELECT *,
       RANK() OVER (ORDER BY order_amount DESC) AS rank
FROM orders;
```

---

#### 3. DENSE_RANK()

Same values → same rank, no skipping

```sql
SELECT *,
       DENSE_RANK() OVER (ORDER BY order_amount DESC) AS rank
FROM orders;
```

---

### 🔸 C. Value Functions

#### 1. LAG() – Previous row

```sql
SELECT order_id,
       order_amount,
       LAG(order_amount) OVER (ORDER BY order_date) AS prev_order
FROM orders;
```

---

#### 2. LEAD() – Next row

```sql
SELECT order_id,
       order_amount,
       LEAD(order_amount) OVER (ORDER BY order_date) AS next_order
FROM orders;
```

---

### 🔸 D. First & Last Value

```sql
SELECT *,
       FIRST_VALUE(order_amount) OVER (ORDER BY order_date) AS first_order,
       LAST_VALUE(order_amount) OVER (
           ORDER BY order_date
           ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
       ) AS last_order
FROM orders;
```

---

## 🔹 Frame Clause (Important)

Defines window range

```sql
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
```

👉 Meaning:

* Start → first row
* End → current row

---

## 🔹 Interview Questions

---

### ✅ Running Total

```sql
SELECT customer_id,
       order_date,
       SUM(order_amount) OVER (
           PARTITION BY customer_id
           ORDER BY order_date
       ) AS running_total
FROM orders;
```

---

### ✅ Top 3 Orders per Customer

```sql
SELECT *
FROM (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY customer_id
               ORDER BY order_amount DESC
           ) AS rn
    FROM orders
) t
WHERE rn <= 3;
```

---

### ✅ Remove Duplicates

```sql
SELECT *
FROM (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY customer_id, order_date, order_amount
               ORDER BY order_id DESC
           ) AS rn
    FROM orders
) t
WHERE rn = 1;
```

---

## 🔹 GROUP BY vs Window Function

| Feature     | GROUP BY    | Window Function |
| ----------- | ----------- | --------------- |
| Rows        | Reduced     | Not reduced     |
| Use         | Aggregation | Row-level calc  |
| Flexibility | Low         | High            |

## 🔹 Conclusion

Window functions are very important for:

* Data Analysis
* Data Engineering
* SQL Interviews

