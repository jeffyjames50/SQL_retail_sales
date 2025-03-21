--SQL Reatail Sales Analysis-P1
CREATE DATABASE sql_project_p1;

--Create TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales(
			transactions_id	INT PRIMARY KEY,
			sale_date DATE,
			sale_time TIME,
			customer_id INT,
			gender VARCHAR(15),
			age INT,
			category VARCHAR(25),
			quantiy INT,
			price_per_unit FLOAT,
			cogs FLOAT,
			total_sale FLOAT

);

SELECT * FROM retail_sales
LIMIT 10;

--count number of rows
SELECT COUNT(*) FROM retail_sales;

--Data Cleaning
--checking for NULL values
SELECT * FROM retail_sales
where transactions_id IS NULL;

SELECT * FROM retail_sales
where sale_date IS NULL;


SELECT * FROM retail_sales
where sale_time IS NULL;

--checking for NULL values
SELECT * FROM retail_sales
where 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

--Deleting rows with NULL values
DELETE FROM retail_sales
where 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

--Data EXploration

--Total number of sales?

SELECT COUNT(*) as total_sales FROM retail_sales;

--Total number of customers?

SELECT COUNT(DISTINCT customer_id) as customer_count FROM retail_sales;

--Total number of categories?

SELECT COUNT(DISTINCT category) as category_count FROM retail_sales;


--Data Analysis

-- Q.1 Write a SQL query to retrieve all columns for sales made on 2022-11-05

SELECT * 
FROM retail_sales
where sale_date = '2022-11-05'

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022

SELECT * 
FROM retail_sales
where 
	category = 'Clothing'
	AND
	TO_CHAR(sale_date,'YYYY-MM')='2022-11'
	AND
	quantiy >3;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT category, SUM(total_sale) AS net_sale, COUNT(*) as total_orders
FROM retail_sales
GROUP BY category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT ROUND(AVG(age),2) AS average_age
FROM retail_sales
where category = 'Beauty';

--Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT * 
FROM retail_sales
WHERE total_sale>1000;
--Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT category,gender, COUNT(transactions_id) AS total_transactions
FROM retail_sales
GROUP BY category,gender
ORDER BY 1,2

--Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year 
SELECT year,month,avg_sale FROM
(
SELECT 
    EXTRACT(YEAR FROM sale_date) AS year, 
    EXTRACT(MONTH FROM sale_date) AS month,
    AVG(total_sale) AS avg_sale,
    RANK() OVER (PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank
FROM retail_sales
GROUP BY 1, 2
) as t1
where t1.rank=1;

--ORDER BY 1,3 DESC;

--Q.8 Write a SQL query to find the top 5 customers based on the highest total sales

SELECT customer_id,SUM(total_sale) as total_sale
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sale DESC
LIMIT 5

--Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT category, COUNT( DISTINCT customer_id ) as no_of_unique_customers
FROM retail_sales
GROUP BY category

--Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

WITH shift_based_sale AS(
SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time)<12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon' --Between includes 12 and 17
		ELSE 'Evening'
	END as shift
from retail_sales

)
SELECT
	shift,
	COUNT(shift_based_sale.transactions_id) as total_orders
FROM shift_based_sale
GROUP BY shift
	
--End of Project
