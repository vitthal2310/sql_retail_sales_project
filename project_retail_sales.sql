
--create TABLE
drop TABLE if exists retails_sales;
CREATE TABLE retails_sales

(transactions_id int PRIMARY KEY,
sale_date date,
sale_time time,
customer_id	INT,
gender VARCHAR(50),
age	int,
category  varchar(50),
quantiy	int,
price_per_unit	int,
cogs	float,
total_sale float
)

SELECT * from retails_sales;

SELECT count(*) from retails_sales; -- to check all data imporeted or NOT

--- check null value

SELECT * from retails_sales
where transactions_id is null;

SELECT * from retails_sales
where 
      transactions_id is null
	  or
	  sale_date is NULL
	  or 
	  sale_time is null
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

---data cleaning (delete null value )
DELETE FROM retails_sales

where 
      transactions_id is null
	  or
	  sale_date is NULL
	  or 
	  sale_time is null
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

-- data exploration

-- how many sales we have
select count(*) as total_sales from retails_sales;

--how many unique customer we have ?
select count(distinct customer_id) as total_sales FROM retails_sales;

select distinct category FROM retails_sales;

-- Data analysit & Business key problem & answer

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the highest total sales day in each month. Output: year, month, sale_date, total_sales_of_the_day
-- Q.9 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.10 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.11 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
select * from retails_sales
WHERE sale_date='2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than or equal to 4 in the month of Nov-2022
select * from retails_sales
where 
category='Clothing' 
and 
quantiy >=4
and 
sale_date>='2022-11-01'
and
sale_date< '2022-12-01';

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select 
category, 
sum(total_sale) as total_sale,
count(*) as total_orders
from retails_sales
group by category;

--or group by 1st slected i.e category
SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1

 Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT
round(avg(age),2) as average_age
from retails_sales
where category='Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * from retails_sales
where total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transactions_id) made by each gender in each category.
SELECT
gender,
category,
count(*) as total_trans
from retails_sales
group by gender, category;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT *
FROM (
    SELECT 
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER (
            PARTITION BY 
			EXTRACT(YEAR FROM sale_date) --- no comma here
            ORDER BY AVG(total_sale) DESC
        ) AS rnk
    FROM retails_sales
    GROUP BY 
        EXTRACT(YEAR FROM sale_date),
        EXTRACT(MONTH FROM sale_date)
) t
WHERE rnk = 1;

--8 Write a SQL query to find the highest total sales day in each month.
--Output: year, month, sale_date, total_sales_of_the_day
select *
from (
       select
	        extract(year from sale_date) as year,
			extract(month from sale_date) as month,
			extract(day from sale_date) as day,
			sum(total_sale) as total_sales_of_the_day,
			rank() over(
                       partition by 
					   extract(year from sale_date),
					   extract(month from sale_date)
					   order by sum(total_sale) DESC
			          ) as rnk
       FROM retails_sales
	   group by 
	   extract(year from sale_date),
	   extract(month from sale_date),
	   extract(day from sale_date)
	   ) t 
WHERE rnk= 1;

-- Q.9 Write a SQL query to find the top 5 customers based on the highest total sales 
select 
customer_id,
sum(total_sale) as total_sale
from retails_sales
group by 1
order by 2 desc
limit 5;

-- Q.10 Write a SQL query to find the number of unique customers who purchased items from each category.
select 
category,
count(distinct customer_id) as unique_customer
from retails_sales
group by category;

-- Q.11 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
select 
       case
	       when extract(hour from sale_time)  <12 then 'Morning'
		   when extract(hour from sale_time) BETWEEN 12 and 17 then 'Afternoon'
		   else 'Evening'
	   end as shift_name,
	   count(*) as total_order
from retails_sales
group by
        case
	       when extract(hour from sale_time)  <12 then 'Morning'
		   when extract(hour from sale_time) BETWEEN 12 and 17 then 'Afternoon'
		   else 'Evening'
		end;

-- end of project  		