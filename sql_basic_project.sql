CREATE DATABASE sql_project_retail;
USE sql_project_retail;

-- create table
DROP TABLE IF EXISTS reatil_sales; 
CREATE TABLE retail_sales (
	transactions_id INT UNIQUE PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(15),
	age INT,
	category VARCHAR(15),
	quantiy INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT
    );

SELECT * FROM retail_sales;
LIMIT 10
SELECT COUNT(*) FROM retail_sales;


-- data cleaning
SELECT * FROM retail_sales
WHERE transactions_id IS NULL;

SELECT * FROM retail_sales
WHERE sale_date IS NULL;


SELECT * FROM retail_sales
WHERE
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
    price_per_unit IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    
    
-- Data exploration
-- How many sales we have? 
SELECT COUNT(*) AS total_sale From retail_sales;

-- How many unique customers we have?
SELECT COUNT(DISTINCT customer_id) AS total_sales FROM retail_sales;

-- how many unique categories we have
SELECT COUNT(DISTINCT category) AS total_sales FROM retail_sales;

-- which categories we have
SELECT DISTINCT category AS total_sales FROM retail_sales;

-- DATA ANALYSIS & BUSINESS KEY PROBLEMS & ANSWERKEY
-- QUES 1. write a sql querry to retrieve all columns for sales made on specific date.
SELECT * 
FROM retail_sales
WHERE sale_date = "2022-11-05";

-- Ques 2. write a sql query to retrieve all transactions where the category is 'clothing' and the quantity sold is more than 4 in the month of nov-2022

-- SUM OF QUANTITY OF CLOTHING
SELECT 
	category,
	SUM(quantiy)
FROM retail_sales
WHERE category = 'Clothing';

-- FULL SOLUTION
SELECT *
FROM retail_sales
WHERE 
	category = 'Clothing'
    AND
    DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
    AND 
    quantiy >= 4;
    
-- Ques 3. Write a sql query to calculate the total sales (tatal_sale) for each category
SELECT DISTINCT category AS total_sales FROM retail_sales;

SELECT
category,
SUM(total_sale) AS net_sale,
COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;

-- Ques 4. Write a SQL query to find the average of customers who purchase items from the 'beauty' category
SELECT
	ROUND(AVG(age), 2) as avg_age
    from retail_sales
    where category = "Beauty";
    
-- Ques 5. write a sql query to find all transactions where the total_sales is greater than 1000.

SELECT * 
FROM retail_sales
WHERE total_sale > 1000;

-- Ques 6. Write a SQL query to find the total number of transactions made by each gender in each category.

SELECT 
	category,gender,
    COUNT(*) as total_transaction
from retail_sales
GROUP BY category, gender
ORDER BY 1;

-- Ques 7. Write a sql query to calculate the average sale for each month. find out best selling month in each year.

SELECT 
	year,
    month, 
    avg_sale
FROM
(
SELECT 
	EXTRACT(YEAR FROM sale_date) AS year,
	EXTRACT(MONTH FROM sale_date) AS month,
	ROUND(AVG(total_sale),2) as avg_sale,
	RANK() OVER(
		PARTITION BY EXTRACT(YEAR FROM sale_date) 
        ORDER BY AVG(total_sale) DESC
        ) rnk
FROM retail_sales
GROUP BY year, month
) AS t1
WHERE rnk = 1;

-- Ques 8. Write a sql Querry to find the top 5 customers based on the highest total sales

SELECT 
	customer_id,
    SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- Ques 9. Write a sql query to find the number of unique customers who purchased items from each category

SELECT 
	category,
    COUNT( DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category;

-- Ques 10. Write a sql query to create each shift and number of orders (Example Mornig <=12, Afternoon between 12 & 17, Evening > 17)

WITH hourly_sale
As
(
SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
	END as shift
FROM retail_sales
) 
SELECT 
	shift,
	COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift;