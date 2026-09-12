SQL LEARNING – ZOMATO DATASET

1. SELECT & FROM
- SELECT → chooses columns.
- FROM → tells SQL which table to use.

Example:
SELECT name
FROM zomato;

SELECT name, location
FROM zomato;

SELECT *
FROM zomato;


2. ALIASING (AS)
- AS gives a temporary name to a column in the result.
- It does NOT change the original column name.

Example:
SELECT name AS restaurant_name
FROM zomato;


3. DISTINCT
- DISTINCT returns unique values.
- With multiple columns, it returns unique combinations.

Example:
SELECT DISTINCT location
FROM zomato;

SELECT DISTINCT location, rest_type
FROM zomato;


4. COUNT()
- COUNT(*) → counts total rows.
- COUNT(column) → counts non-NULL values.
- COUNT(DISTINCT column) → counts unique non-NULL values.

Example:
SELECT COUNT(*) AS total_restaurants
FROM zomato;

SELECT COUNT(name) AS restaurants_with_name
FROM zomato;

SELECT COUNT(DISTINCT location) AS unique_locations
FROM zomato;


5. WHERE
- WHERE filters rows based on a condition.

Comparison operators:
>   Greater than
<   Less than
>=  Greater than or equal
<=  Less than or equal
=   Equal
<>  Not equal

Example:
SELECT name, votes
FROM zomato
WHERE votes > 500;


6. AND
- AND means ALL conditions must be true.

Example:
SELECT name, location, votes
FROM zomato
WHERE location = 'Banashankari'
AND votes > 500;


7. OR
- OR means at least ONE condition must be true.

Example:
SELECT name, location
FROM zomato
WHERE location = 'Banashankari'
OR location = 'Indiranagar';


8. NOT
- NOT excludes a condition.

Example:
SELECT name, location
FROM zomato
WHERE NOT location = 'Banashankari';


9. PARENTHESES
- Use parentheses when combining AND and OR.
- They make the condition clear and control the logic.

Example:
SELECT name, location, online_order
FROM zomato
WHERE (location = 'Banashankari'
OR location = 'Indiranagar')
AND online_order = 'Yes';


10. BETWEEN
- BETWEEN filters a range.
- Both starting and ending values are included.

Example:
SELECT name, votes
FROM zomato
WHERE votes BETWEEN 100 AND 500;

Same as:
WHERE votes >= 100
AND votes <= 500;


11. LIKE
- LIKE is used for pattern matching in text.
- % → any number of characters.
- _ → exactly one character.

Examples:

-- Starts with Cafe
SELECT name
FROM zomato
WHERE name LIKE 'Cafe%';

-- Ends with Cafe
SELECT name
FROM zomato
WHERE name LIKE '%Cafe';

-- Contains Cafe
SELECT name
FROM zomato
WHERE name LIKE '%Cafe%';

-- Starts with C and has exactly 5 characters
SELECT name
FROM zomato
WHERE name LIKE 'C____';


12. NOT LIKE
- NOT LIKE returns values that do NOT match a pattern.

Example:
SELECT name
FROM zomato
WHERE name NOT LIKE 'Cafe%';


13. IN
- IN is used to match multiple specific values.
- It is cleaner than writing many OR conditions.

Example:
SELECT name, location
FROM zomato
WHERE location IN
('Banashankari', 'Indiranagar', 'Koramangala');


14. NOT IN
- NOT IN excludes multiple specific values.

Example:
SELECT name, location
FROM zomato
WHERE location NOT IN
('Banashankari', 'Indiranagar');


15. NULL
- NULL means missing or unknown value.
- NULL is NOT 0.
- NULL is NOT an empty string.

To find NULL:
SELECT name, location
FROM zomato
WHERE location IS NULL;

To find non-NULL:
SELECT name, location
FROM zomato
WHERE location IS NOT NULL;

Important:
Do NOT use:
WHERE location = NULL

Use:
WHERE location IS NULL


16. AGGREGATE FUNCTIONS
Aggregate functions perform calculations on multiple rows.

Main aggregate functions:

COUNT() → count
AVG()   → average
SUM()   → total
MIN()   → minimum
MAX()   → maximum

Examples:

SELECT COUNT(*) AS total_restaurants
FROM zomato;

SELECT AVG(votes) AS average_votes
FROM zomato;

SELECT SUM(votes) AS total_votes
FROM zomato;

SELECT MIN(votes) AS minimum_votes
FROM zomato;

SELECT MAX(votes) AS maximum_votes
FROM zomato;


17. AGGREGATE + WHERE
- WHERE can filter rows before applying an aggregate function.

Example:
SELECT AVG(votes) AS average_votes
FROM zomato
WHERE location = 'Banashankari';

Example:
SELECT MAX(votes) AS maximum_votes
FROM zomato
WHERE location = 'Banashankari';

Example:
SELECT SUM(votes) AS total_votes
FROM zomato
WHERE online_order = 'Yes';


18. ROUND()
- ROUND() is used to round numerical values.

Syntax:
ROUND(number, decimal_places)

Examples:

ROUND(123.4567, 2)
→ 123.46

ROUND(123.4567, 0)
→ 123

ROUND(1234567, -5)
→ 1200000

Positive number → rounds digits after decimal.
Negative number → rounds digits to the left of decimal.


Example with Zomato:
SELECT ROUND(AVG(votes), 2) AS average_votes
FROM zomato;


19. ARITHMETIC OPERATORS
SQL supports:

+ → Addition
- → Subtraction
* → Multiplication
/ → Division

Examples:

SELECT name, votes,
       votes + 10 AS votes_plus_10
FROM zomato;

SELECT name, votes,
       votes - 10 AS votes_minus_10
FROM zomato;

SELECT name, votes,
       votes * 2 AS double_votes
FROM zomato;

SELECT name, votes,
       votes / 2.0 AS half_votes
FROM zomato;


20. AGGREGATE vs ARITHMETIC
- Aggregate functions work across multiple rows.
- Arithmetic usually performs calculations between values in the same row.

Example of aggregate:
SELECT AVG(votes)
FROM zomato;

Example of row-level arithmetic:
SELECT name, votes, votes * 2 AS double_votes
FROM zomato;


21. ORDER BY
- ORDER BY is used to sort the result.

ASC → ascending (default)
DESC → descending

Examples:

-- Lowest to highest
SELECT name, votes
FROM zomato
ORDER BY votes ASC;

-- Highest to lowest
SELECT name, votes
FROM zomato
ORDER BY votes DESC;


22. MULTIPLE COLUMN SORTING
- We can sort using more than one column.
- The second column is used as a tie-breaker.

Example:
SELECT name, votes
FROM zomato
ORDER BY votes DESC, name ASC;


23. GROUP BY
- GROUP BY creates groups of rows having the same value.
- It is commonly used with aggregate functions.

Example:
SELECT location, COUNT(*) AS restaurant_count
FROM zomato
GROUP BY location;

Meaning:
→ Group restaurants by location.
→ Count restaurants in each location.


24. GROUP BY WITH AVG
Example:

SELECT location,
       AVG(votes) AS average_votes
FROM zomato
GROUP BY location;


25. GROUP BY WITH MULTIPLE COLUMNS
- GROUP BY can contain multiple columns.
- It creates groups based on unique combinations.

Example:
SELECT location,
       rest_type,
       COUNT(*) AS restaurant_count
FROM zomato
GROUP BY location, rest_type;


26. GROUP BY + ORDER BY
- GROUP BY creates groups.
- Aggregate calculates values.
- ORDER BY sorts the grouped result.

Example:
SELECT location,
       COUNT(*) AS restaurant_count
FROM zomato
GROUP BY location
ORDER BY restaurant_count DESC;


27. HAVING
- HAVING filters groups.
- WHERE filters individual rows.
- HAVING is mainly used with aggregate functions.

Example:
SELECT location,
       COUNT(*) AS restaurant_count
FROM zomato
GROUP BY location
HAVING COUNT(*) > 50;


28. WHERE vs HAVING

WHERE:
- Filters rows.
- Used before GROUP BY.
- Cannot normally use aggregate functions.

HAVING:
- Filters groups.
- Used after GROUP BY.
- Used with aggregate functions.

Example:

SELECT location,
       COUNT(*) AS restaurant_count
FROM zomato
WHERE online_order = 'Yes'
GROUP BY location
HAVING COUNT(*) > 20;


29. SQL EXECUTION ORDER

For a simple query:

FROM
→ WHERE
→ SELECT
→ ORDER BY
→ LIMIT

For a grouped query:

FROM
→ WHERE
→ GROUP BY
→ HAVING
→ SELECT
→ ORDER BY
→ LIMIT


30. COMPLETE QUERY EXAMPLE

SELECT location,
       COUNT(*) AS restaurant_count
FROM zomato
WHERE online_order = 'Yes'
GROUP BY location
HAVING COUNT(*) > 20
ORDER BY restaurant_count DESC;


Meaning:

1. FROM → take data from zomato.
2. WHERE → keep only restaurants with online ordering.
3. GROUP BY → group them by location.
4. HAVING → keep locations having more than 20 restaurants.
5. SELECT → show location and restaurant count.
6. ORDER BY → show highest count first.


31. VIEW
- A VIEW is a saved SQL query.
- It works like a virtual table.
- It stores the query, not a separate copy of the data.

Example:

CREATE VIEW zomato_location_summary AS
SELECT location,
       COUNT(*) AS restaurant_count,
       AVG(votes) AS average_votes
FROM zomato
GROUP BY location;

Then:

SELECT *
FROM zomato_location_summary;


32. IMPORTANT INTERVIEW POINTS

- SELECT chooses columns.
- FROM chooses the table.
- WHERE filters rows.
- GROUP BY creates groups.
- HAVING filters groups.
- ORDER BY sorts the result.
- DISTINCT removes duplicates.
- AS creates a temporary alias.
- COUNT(*) counts rows.
- COUNT(column) counts non-NULL values.
- COUNT(DISTINCT column) counts unique non-NULL values.
- NULL means missing/unknown data.
- Use IS NULL, not = NULL.
- BETWEEN includes both endpoints.
- LIKE is used for text pattern matching.
- % means any number of characters.
- _ means exactly one character.
- IN is useful for multiple specific values.
- Aggregate functions summarize multiple rows.
- WHERE runs before GROUP BY.
- HAVING runs after GROUP BY.
- ORDER BY default is ASC.
- SQL execution order is different from written order.


33. QUICK REVISION

SELECT      → choose columns
FROM        → choose table
AS          → temporary alias
DISTINCT    → unique values
WHERE       → filter rows
AND         → all conditions true
OR          → at least one condition true
NOT         → exclude condition
BETWEEN     → inclusive range
LIKE        → text pattern
%           → any number of characters
_           → exactly one character
IN          → multiple specific values
IS NULL     → missing values
IS NOT NULL → available values
COUNT       → count
AVG         → average
SUM         → total
MIN         → minimum
MAX         → maximum
ROUND       → round numbers
ORDER BY    → sort
GROUP BY    → create groups
HAVING      → filter groups
CREATE VIEW → save query as virtual table