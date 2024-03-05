select *
from Walmart_Sales

------------------------------------------------------------------------------------

---add column time, day_name, month name

select  Time
from Walmart_Sales

alter table Walmart_Sales
add truncated_time time(0)

update Walmart_Sales
set truncated_time = CONVERT(time, Time) 

select truncated_time
from Walmart_Sales

alter table Walmart_Sales
add Time_of_day varchar(50)


UPDATE Walmart_Sales
SET Time_of_day = CASE
                      WHEN truncated_time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
                      WHEN truncated_time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
                      ELSE 'Evening'
                  END;

select *
from Walmart_Sales


----add day_name

select date
from Walmart_Sales

alter table Walmart_Sales
add DayName varchar(50)


UPDATE Walmart_Sales
SET Dayname =  DATENAME(dw, date)


-----add monthname

alter table Walmart_Sales
add MonthName varchar(50)


UPDATE Walmart_Sales
SET MonthName =  datename (MONTH, date)


-------------------------------------------------------------------------------------------------------------------------------------------------------------


--How many unique cities does the data have?

select distinct City
from Walmart_Sales

---In which city is each branch?

select distinct City, Branch
from Walmart_Sales



---------------------------------------------------------------------

---1. How many unique product lines does the data have?

select *
from Walmart_Sales

select distinct [Product line]
from Walmart_Sales


---2. What is the most common payment method?
select *
from Walmart_Sales

select Payment, count(*) as frequency
from Walmart_Sales
group by payment
ORDER BY frequency DESC

----3. What is the most selling product line?
SELECT [Product line],SUM(quantity) as qty
FROM Walmart_Sales
GROUP BY [Product line]
ORDER BY qty DESC;

----4. What is the total revenue by month?

select *
from Walmart_Sales

select monthname as month ,sum(total) as total_revenue
from Walmart_Sales
group by monthname
order by total_revenue


----5.What month had the largest COGS?

select monthname as month ,sum(cogs) as total_cogs
from Walmart_Sales
group by monthname
order by total_cogs


---6.What product line had the largest revenue?
select [Product line]  ,sum(Total) as total_revenue
from Walmart_Sales
group by [Product line]
order by total_revenue desc

----7. What is the city with the largest revenue?

select City  ,sum(Total) as total_revenue
from Walmart_Sales
group by City
order by total_revenue desc

---8.What product line had the largest VAT?
select [Product line]  ,sum([Tax 5%]) as total_tax
from Walmart_Sales
group by [Product line]
order by total_tax desc

---9.  Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average quantity

SELECT 
	AVG(quantity) AS avg_qnty
FROM Walmart_Sales


SELECT [product line],
	CASE
		WHEN AVG(quantity) > 5.5 THEN 'Good'
        ELSE 'Bad'
    END AS remark
FROM Walmart_Sales
GROUP BY [Product line];
--or
SELECT [Product line],
    CASE
        WHEN avg(quantity) > (SELECT AVG(Quantity) FROM walmart_sales) THEN 'Good'
        ELSE 'Bad'
    END AS Product_Status
FROM 
    Walmart_Sales
GROUP BY 
    [Product line];


----10. Which branch sold more products than average product sold?
select *
from Walmart_Sales

SELECT [Branch]
FROM Walmart_Sales
GROUP BY [Branch]
HAVING avg(quantity) > (SELECT AVG(Quantity) FROM walmart_sales);


SELECT 
	branch, 
    SUM(quantity) AS qnty
FROM Walmart_Sales
GROUP BY branch
HAVING avg(quantity) > (SELECT AVG(quantity) FROM Walmart_Sales);


----11. What is the most common product line by gender?

select [Product line], Gender,  sum(quantity) as total_quantity
from Walmart_Sales
group by [Product line],Gender
order by total_quantity desc

SELECT
	gender,
    [Product line],
    COUNT(gender) AS total_cnt
FROM Walmart_Sales
GROUP BY gender, [Product line]
ORDER BY total_cnt DESC;

----12. -- What is the average rating of each product line

select [Product line], round( avg( rating), 2) as avg_rating
from Walmart_Sales
group by [Product line]




----------------------------------------SALES----------------------------------------------------------------------------------------------------------------------
--1. Number of sales made in each time of the day per weekday

select *
from Walmart_Sales


SELECT time_of_day, COUNT(*) AS total_sales
FROM Walmart_Sales
WHERE DayName = 'Sunday'
GROUP BY time_of_day 
ORDER BY total_sales DESC;

---2. Which of the customer types brings the most revenue?
select [Customer type], sum(total) as total_revenue
from Walmart_Sales
group by [Customer type]
order by total_revenue desc

---3 Which city has the largest tax/VAT percent?
select city, round(sum([Tax 5%]) ,0) as totalTax
from Walmart_Sales
group by city
order by totalTax desc

---4. Which customer type pays the most in VAT?
select [Customer type], round(sum([Tax 5%]) ,0) as totalTax
from Walmart_Sales
group by [Customer type]
order by totalTax desc


-------------------------------------------------CUSTOMERS--------------------------------------------------------------------------------------
---1.How many unique customer types does the data have?
select distinct [Customer type]
from Walmart_Sales

---2 How many unique payment methods does the data have?
select distinct Payment
from Walmart_Sales

---3.What is the most common customer type?
select [Customer type], count(*) as total_number
from Walmart_Sales
group by [Customer type]
order by total_number desc

---4. Which customer type buys the most?
select [Customer type], count(Quantity) as total_quantity
from Walmart_Sales
group by [Customer type]
order by total_quantity desc

---5. What is the gender of most of the customers?
select Gender, count(*) as gender_ct
from Walmart_Sales
group by Gender
order by  gender_ct desc

---6. What is the gender distribution per branch?
select Gender, count(Gender) as gender_ct
from Walmart_Sales
where Branch = 'A'
group by Gender
order by  gender_ct desc

---7 Which time of the day do customers give most ratings?
SELECT
	time_of_day, AVG(rating) AS avg_rating
FROM Walmart_Sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;

---8. Which time of the day do customers give most ratings per branch?
SELECT time_of_day, round(AVG(rating), 2) AS avg_rating
FROM Walmart_Sales
where branch = 'A'
GROUP BY time_of_day
ORDER BY avg_rating DESC;

---9. Which day fo the week has the best avg ratings?
select DayName, round(AVG(rating), 2) AS avg_rating
from Walmart_Sales
GROUP BY DayName
ORDER BY avg_rating DESC;

---10. Which day of the week has the best average ratings per branch?
select DayName, round(AVG(rating), 2) AS avg_rating
from Walmart_Sales
where branch = 'c'
GROUP BY DayName
ORDER BY avg_rating DESC;





