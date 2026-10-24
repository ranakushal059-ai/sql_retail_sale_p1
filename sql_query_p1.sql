use sql_project_P1;
select*from retail_sales;

select count(*) from retail_sales;

-- DATA CLEANING
SELECT *
FROM retail_sales 
WHERE age IS NULL;

select *
from retail_sales
where
	transaction_id is null 
    or
    sale_date is null
    or
    sale_date is null
    or
    customer_id is null
    or
    gender is null
    or
    age is null
    or
    category is null
    or
    quantiy is null
    or
    price_per_unit is null
    or 
    cogs is null
    or
    total_sale is null;
    
    
select *
from retail_sales
where
    quantiy is null
    or
    price_per_unit is null
    or 
    cogs is null
    or
    total_sale is null;


DELETE FROM retail_sales
WHERE transaction_id IN (679, 746, 1225);
    
    
set @avg_age = (select round(avg(age)) from retail_sales)
select @avg_age;  

update retail_sales
set age = @avg_age 
where age is null;

SET SQL_SAFE_UPDATES = 0;



-- DATA EXPLORATION

-- HOW MANY SALES WE HAVE?
select count(*) total_sale 
from retail_sales;

-- HOW MANY unique customer WE HAVE?
select count(distinct customer_id) customer_id
from retail_sales;

-- HOW MANY unique catagory WE HAVE?
select count(distinct category) category
from retail_sales;


-- DATA ANALYZSIS
/**
1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**
2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
**/


-- 1.Write a SQL query to retrieve all columns for sales made on '2022-11-05.
select *
from retail_sales
where sale_date = '2022-11-05';

-- 2.Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
select *
from retail_sales
where category = 'Clothing'
and quantiy >= 4
and sale_date between'2022-11-01' and '2022-11-30';


-- 3.Write a SQL query to calculate the total sales (total_sale) for each category.**:
select category , sum(total_sale) as total_sale_category
from retail_sales
group by category;



-- 4.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
select category , round(avg(age), 2)as avg_age
from retail_sales
where category = 'Beauty'
group by category;

select round(avg(age), 2) as avg_age
from retail_sales
where category = 'Beauty'


-- 5.Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
select*
from retail_sales
where total_sale > 1000;

-- 6.Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
select gender, category , count(*) as total_gender
from retail_sales
group by gender, category;


-- 7.Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
SELECT
    sale_year,
    sale_month,
    avg_total_sale
FROM (
    SELECT
        EXTRACT(YEAR FROM sale_date) AS sale_year,
        EXTRACT(MONTH FROM sale_date) AS sale_month,
        ROUND(AVG(total_sale), 2) AS avg_total_sale,
        RANK() OVER (
            PARTITION BY EXTRACT(YEAR FROM sale_date)
            ORDER BY AVG(total_sale) DESC
        ) AS rnk
    FROM retail_sales
    GROUP BY sale_year, sale_month
) AS t1
WHERE rnk = 1;
    
    
-- 8.Write a SQL query to find the top 5 customers based on the highest total sales **:
select 
	customer_id,
    sum(total_sale) as total_sale
from retail_sales
group by customer_id
order by total_sale desc
limit 5;



-- 9.Write a SQL query to find the number of unique customers who purchased items from each category.**:
SELECT
    category,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category;

-- 10.Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
