use ajeyscafes;


#1. Har outlet (city-wise) ka total revenue nikaalo

select outlet_name , city , sum(quantity * price) as total_revenue
from cafe_orders
group by outlet_name ,city
order by total_revenue desc;

# 2. Sabse zyada bikne wala item kaun sa hai (overall aur outlet-wise)

select outlet_name ,item_name, sum(quantity) as total_quantity
from cafe_orders
group by outlet_name , item_name
order by total_quantity desc
limit 5;


#3. Month-wise / year-wise sales trend dikhao

SELECT 
    YEAR(order_datetime) AS order_year, 
    COUNT(*) AS total_orders, 
    SUM(quantity * price) AS total_revenue
FROM cafe_orders
GROUP BY YEAR(order_datetime)
ORDER BY order_year;

#4. Month-wise / year-wise sales trend dikhao

select DATE_FORMAT(order_datetime, '%M') AS order_month , count(*) as total_orders , 
sum(quantity * price) as total_revenue
from cafe_orders
group by order_month
order by order_month;

#5. Payment mode ka distribution (UPI vs Cash vs Card) nikaalo

SELECT 
    payment_mode, 
    COUNT(*) AS transaction_count, 
    SUM(quantity * price) AS total_revenue
FROM cafe_orders
GROUP BY payment_mode
ORDER BY transaction_count DESC;

#6. Average order value (AOV) per outlet calculate karo

select outlet_name , sum(quantity * price) / count(distinct order_id) as AOV
from cafe_orders
group by outlet_name
order by AOV DESC;

#7. Rating aur sales ke beech koi correlation hai kya, check karo

SELECT 
    rating,
    COUNT(*) AS total_orders,
    ROUND(SUM(quantity * price),2) AS total_revenue,
    ROUND(AVG(quantity * price),2) AS avg_revenue_per_order
FROM cafe_orders
WHERE rating IS NOT NULL
GROUP BY rating
ORDER BY rating;

#8. Kaunsa outlet sabse zyada profitable/growing hai (year-over-year)? 

select outlet_name, 
year(order_datetime) as year_over_year,
round(sum(quantity * price),2)
from cafe_orders
group by outlet_name , year(order_datetime)
order by outlet_name , year_over_year desc;

#9. Weekday vs weekend sales pattern kaisa hai?

select 
case 
when dayofweek(order_datetime) in (1,7) then "Weekend"
else "Weekday"
end as day_type,
count(order_id) as total_orders,
sum(quantity * price) as total_revenue,
count(distinct order_datetime) as total_days,
round(sum(quantity * price)/count(distinct order_datetime),2) as total_revenue_per_day
from cafe_orders
where order_datetime is not null 
group by day_type
order by day_type;

#10. Kaunse items low-rated hain but high-selling — improvement chahiye?:-

select item_name , 
sum(quantity) as total_sold_qty , 
round(avg(rating) , 2) as avg_rating , 
round(sum(quantity * price) ,2) as total_revenue
from cafe_orders
group by item_name 
order by total_sold_qty desc , avg_rating asc;

#11. Customer repeat-purchase pattern nikaalo (agar naam clean ho jaye)

select customer_name , count(order_id) as total_orders , 
round(sum(quantity * price) , 2) as total_spent 
from cafe_orders
group by customer_name
having total_orders > 1
order by total_orders desc
limit 10;

#12.Window functions use karo — har outlet ka rank by revenue (RANK() OVER (PARTITION BY ... ORDER BY ...)):-

select outlet_name, sum(quantity * price) as total_revenue ,
					rank() over (order by SUM(quantity * price) desc) as revenue_rank
from cafe_orders
group by outlet_name;

#13. Month-over-month growth % nikaalo (LAG() window function):-

with monthly_sales as (
select date_format(order_datetime , '%y-%m') as order_month,
sum(quantity * cast(price as decimal(8 , 2))) as total_revenue 
from cafe_orders
group by date_format(order_datetime , '%y-%m')
)

select 
order_month , round(total_revenue , 2) as current_month_revenue,
round(LAG(total_revenue,1) over(order by order_month) , 2) as prev_month_revenue,
round((total_revenue - LAG(total_revenue,1) over(order by order_month))/ LAG(total_revenue,1) over(order by order_month) * 100 , 2)
as mom_growth_percentage
from monthly_sales
order by order_month;

#14. Subquery/CTE se "outlets jinka revenue average se kam hai" nikaalo

with outlet_revenue as(
select outlet_name , sum(quantity * cast(price as decimal(8 , 2))) as total_revenue
from cafe_orders
group by outlet_name
)
select outlet_name , round(total_revenue , 2) as total_revenue
from outlet_revenue
where total_revenue < (select avg(total_revenue) 
from outlet_revenue)
order by total_revenue asc;

#15.Self-join ya EXISTS use karke repeat customers dhundo 
  
SELECT DISTINCT TRIM(c1.customer_name) AS customer_name
FROM cafe_orders c1
WHERE c1.customer_name IS NOT NULL 
  AND TRIM(c1.customer_name) != '' 
  AND c1.customer_name != 'Unknown'
  AND EXISTS (
      SELECT 1 
      FROM cafe_orders c2 
      WHERE TRIM(c2.customer_name) = TRIM(c1.customer_name) 
        AND c2.order_id <> c1.order_id
  );

#16. Stored procedure banao jo kisi bhi outlet ka monthly report generate kare

DELIMITER //

CREATE PROCEDURE GetOutletMonthlyReport (IN p_outlet_name VARCHAR(100))
BEGIN
    SELECT 
        DATE_FORMAT(order_datetime, '%Y-%m') AS order_month,
        COUNT(order_id) AS total_orders,
        SUM(quantity) AS total_items_sold,
        ROUND(SUM(quantity * CAST(price AS DECIMAL(10,2))), 2) AS total_revenue,
        ROUND(AVG(quantity * CAST(price AS DECIMAL(10,2))), 2) AS average_order_value
    FROM cafe_orders
    WHERE outlet_name = p_outlet_name
    GROUP BY DATE_FORMAT(order_datetime, '%Y-%m')
    ORDER BY order_month DESC;
END //
DELIMITER ;

CALL GetOutletMonthlyReport('Ajey''s Cafe - Surat');
