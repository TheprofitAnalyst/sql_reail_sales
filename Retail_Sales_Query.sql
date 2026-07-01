#Create database for retail sales analysis
CREATE DATABASE retail_project;

#Create table for the dataset
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales (
        transactions_id	INT PRIMARY KEY,
        sale_date DATE,	
        sale_time TIME,	
        customer_id	INT,
        gender VARCHAR(15),	
        age INT,	
        category VARCHAR(15),	
        quantity INT,	
        price_per_unit FLOAT,	
        cogs FLOAT,	
        total_sale FLOAT
		);

#Total number of sales
SELECT COUNT(*) FROM retail_sales;

#Data Exploration
-- How many sales do we have
SELECT COUNT(*) AS TotalSales FROM retail_sales;

-- How many customer do we have
	SELECT COUNT(DISTINCT customer_id) TotalCustomer FROM retail_sales;

-- Hoe many category do we have
	SELECT DISTINCT category FROM retail_sales;	

#Data Analysis
-- (1) Write a SQL query to retrieve all columns for sales made on '2022-11-05.
	
    SELECT * FROM retail_sales
	WHERE sale_date = '2022-11-05';

-- (2) Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022.

	SELECT * FROM retail_sales
	WHERE category = 'Clothing'
		AND quantity >= 4
		AND sale_date >= '2022-11-01'
		AND sale_date < '2022-12-01';

-- (3) Write a SQL query to calculate the total sales (total_sale) for each category

	SELECT 
		category,
        SUM(total_sale) net_sales
	FROM retail_sales
    GROUP BY 1;
    
-- (4) Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

	SELECT 
		ROUND(AVG(age),2) avg_age
	FROM retail_sales
    WHERE category = 'Beauty';
    
-- (5) Write a SQL query to find all transactions where the total_sale is greater than 1000.

	SELECT * FROM retail_sales
    WHERE total_sale > 1000;

-- (6) Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

	SELECT 
		category,
        SUM(CASE WHEN gender = 'Female' THEN 1 END) AS 'Female',
        SUM(CASE WHEN gender = 'Male' THEN 1 END) AS 'Male',
        COUNT(*) total_trans 
	FROM retail_sales
    GROUP BY 1;
    
-- (7) Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
    
	 WITH monthly_sales AS (
		SELECT
			YEAR(sale_date) AS year_sale,
			MONTH(sale_date) AS month_no,
			ROUND(AVG(total_sale), 2) AS avg_sales
		FROM retail_sales
		GROUP BY
			YEAR(sale_date),
			MONTH(sale_date)
		)
		SELECT year_sale, month_no, avg_sales FROM 
			(
			SELECT *, RANK() OVER (PARTITION BY year_sale ORDER BY avg_sales DESC) AS sales_rank
			FROM monthly_sales
			) AS ranked
			WHERE sales_rank = 1;
            
-- (8) Write a SQL query to find the top 5 customers based on the highest total sales

	SELECT 
		customer_id,
        SUM(total_sale) TotalSale
	FROM retail_sales
    GROUP BY 1
    ORDER BY 2 DESC
    LIMIT 5;
			
-- (9) Write a SQL query to find the number of unique customers who purchased items from each category.	

	SELECT category,
		COUNT(DISTINCT customer_id) UniqueCustomer
	FROM retail_sales
    GROUP BY 1;
    
-- (10) Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
        
	WITH hourly_sales AS (
    SELECT 
		CASE
			WHEN HOUR(sale_time) < 12 THEN 'Morning'
            WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
		END AS shift
		FROM retail_sales
		)
    SELECT 
		shift, 
		COUNT(*) TotalOrder
    FROM hourly_sales
    GROUP BY 1;
    
-- End of project.
		
	
		
		
		
		
		
		

















