CREATE DATABASE ajeyscafes;
use ajeyscafes;

CREATE TABLE cafe_orders (
    order_id VARCHAR(50),
    outlet_name VARCHAR(100),
    city VARCHAR(50),
    order_datetime VARCHAR(50),
    item_name VARCHAR(100),
    quantity VARCHAR(50),
    price VARCHAR(50),
    payment_mode VARCHAR(50),
    customer_name VARCHAR(100),
    rating VARCHAR(50),
    franchise_owner VARCHAR(100)
);

set global local_infile = 1;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/ajeys_cafe_franchise_unclean_dataset.csv'
INTO TABLE cafe_orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


SELECT COUNT(*) AS total_rows
FROM cafe_orders;

SELECT COUNT(*) FROM cafe_orders;

SELECT
    order_id,
    outlet_name,
    city,
    order_datetime,
    item_name,
    quantity,
    price,
    payment_mode,
    customer_name,
    rating,
    franchise_owner,
    COUNT(*) AS duplicate_count
FROM cafe_orders
GROUP BY
    order_id,
    outlet_name,
    city,
    order_datetime,
    item_name,
    quantity,
    price,
    payment_mode,
    customer_name,
    rating,
    franchise_owner
HAVING COUNT(*) > 1;

SELECT distinct *
FROM cafe_orders;


SELECT
    LOWER(TRIM(outlet_name)) AS outlet_variant,
    COUNT(*) AS records
FROM cafe_orders
GROUP BY LOWER(TRIM(outlet_name))
ORDER BY outlet_variant;

set sql_safe_updates = 0;

UPDATE cafe_orders
SET outlet_name =
CASE
    WHEN LOWER(TRIM(outlet_name)) LIKE '%surat%' 
        THEN "Ajey's Cafe - Surat"

    WHEN LOWER(TRIM(outlet_name)) LIKE '%ahmedabad%'
      OR LOWER(TRIM(outlet_name)) LIKE '%ahmadabad%'
        THEN "Ajey's Cafe - Ahmedabad"

    WHEN LOWER(TRIM(outlet_name)) LIKE '%mumbai%'
        THEN "Ajey's Cafe - Mumbai"

    WHEN LOWER(TRIM(outlet_name)) LIKE '%pune%'
        THEN "Ajey's Cafe - Pune"

    WHEN LOWER(TRIM(outlet_name)) LIKE '%rajkot%'
        THEN "Ajey's Cafe - Rajkot"

    WHEN LOWER(TRIM(outlet_name)) LIKE '%delhi%'
        THEN "Ajey's Cafe - Delhi"

    WHEN LOWER(TRIM(outlet_name)) LIKE '%bangalore%'
      OR LOWER(TRIM(outlet_name)) LIKE '%bengaluru%'
      OR LOWER(TRIM(outlet_name)) LIKE '%banglore%'
        THEN "Ajey's Cafe - Bangalore"

    WHEN LOWER(TRIM(outlet_name)) LIKE '%baroda%'
      OR LOWER(TRIM(outlet_name)) LIKE '%vadodara%'
        THEN "Ajey's Cafe - Vadodara"

    ELSE NULL
END;

select city 
from cafe_orders where city like 'S%';

UPDATE cafe_orders
SET city =
CASE
    WHEN LOWER(TRIM(city)) = 'surat'
        THEN 'Surat'

    WHEN LOWER(TRIM(city)) = 'mumbai'
        THEN 'Mumbai'

    WHEN LOWER(TRIM(city)) = 'pune'
        THEN 'Pune'

    WHEN LOWER(TRIM(city)) = 'rajkot'
        THEN 'Rajkot'

    WHEN LOWER(TRIM(city)) IN ('bangalore', 'bengaluru')
        THEN 'Bengaluru'

    WHEN LOWER(TRIM(city)) IN ('ahmedabad', 'ahmadabad')
        THEN 'Ahmedabad'

    WHEN LOWER(TRIM(city)) = 'delhi'
        THEN 'Delhi'

    WHEN LOWER(TRIM(city)) IN ('baroda', 'vadodara')
        THEN 'Vadodara'

    WHEN LOWER(TRIM(city)) = 'new delhi'
        THEN 'New Delhi'

    ELSE NULL
END;

SELECT franchise_owner, COUNT(*) AS records
FROM cafe_orders	
GROUP BY franchise_owner;

set sql_safe_updates = 0;

UPDATE cafe_orders
SET customer_name =
    NULLIF(
        CONCAT_WS(
            ' ',
            NULLIF(TRIM(SUBSTRING_INDEX(customer_name, ' ', 1)), ''),
            NULLIF(
                TRIM(
                    SUBSTRING(
                        customer_name,
                        LENGTH(SUBSTRING_INDEX(customer_name, ' ', 1)) + 1
                    )
                ),
                ''
            )
        ),
        ''
    );
    
 UPDATE cafe_orders
SET customer_name =
    CONCAT(
        UPPER(LEFT(TRIM(customer_name), 1)),
        LOWER(SUBSTRING(TRIM(customer_name), 2))
    );   
    
select order_datetime 
from cafe_orders;


UPDATE cafe_orders
SET franchise_owner =
    CASE
        WHEN LOWER(TRIM(franchise_owner)) = 'ajey shah'
        THEN 'Ajey Shah'
        ELSE NULL
    END;

UPDATE cafe_orders
SET franchise_owner = 'Ajey Shah'
WHERE franchise_owner IS NULL;

select franchise_owner from cafe_orders;

select * from cafe_orders;

ALTER TABLE cafe_orders
MODIFY COLUMN order_datetime DATE;

desc cafe_orders;

SET SQL_SAFE_UPDATES = 0;

-- Outlet Names standardize karna
UPDATE cafe_orders
SET outlet_name =
CASE
    WHEN LOWER(TRIM(outlet_name)) LIKE '%surat%' THEN "Ajey's Cafe - Surat"
    WHEN LOWER(TRIM(outlet_name)) LIKE '%ahmedabad%' OR LOWER(TRIM(outlet_name)) LIKE '%ahmadabad%' THEN "Ajey's Cafe - Ahmedabad"
    WHEN LOWER(TRIM(outlet_name)) LIKE '%mumbai%' THEN "Ajey's Cafe - Mumbai"
    WHEN LOWER(TRIM(outlet_name)) LIKE '%pune%' THEN "Ajey's Cafe - Pune"
    WHEN LOWER(TRIM(outlet_name)) LIKE '%rajkot%' THEN "Ajey's Cafe - Rajkot"
    WHEN LOWER(TRIM(outlet_name)) LIKE '%delhi%' THEN "Ajey's Cafe - Delhi"
    WHEN LOWER(TRIM(outlet_name)) LIKE '%bangalore%' OR LOWER(TRIM(outlet_name)) LIKE '%bengaluru%' OR LOWER(TRIM(outlet_name)) LIKE '%banglore%' THEN "Ajey's Cafe - Bangalore"
    WHEN LOWER(TRIM(outlet_name)) LIKE '%baroda%' OR LOWER(TRIM(outlet_name)) LIKE '%vadodara%' THEN "Ajey's Cafe - Vadodara"
    ELSE outlet_name
END;

-- City Names standardize karna
UPDATE cafe_orders
SET city =
CASE
    WHEN LOWER(TRIM(city)) = 'surat' THEN 'Surat'
    WHEN LOWER(TRIM(city)) = 'mumbai' THEN 'Mumbai'
    WHEN LOWER(TRIM(city)) = 'pune' THEN 'Pune'
    WHEN LOWER(TRIM(city)) = 'rajkot' THEN 'Rajkot'
    WHEN LOWER(TRIM(city)) IN ('bangalore', 'bengaluru') THEN 'Bengaluru'
    WHEN LOWER(TRIM(city)) IN ('ahmedabad', 'ahmadabad') THEN 'Ahmedabad'
    WHEN LOWER(TRIM(city)) = 'delhi' THEN 'Delhi'
    WHEN LOWER(TRIM(city)) IN ('baroda', 'vadodara') THEN 'Vadodara'
    WHEN LOWER(TRIM(city)) = 'new delhi' THEN 'New Delhi'
    ELSE city
END;

select * from cafe_orders
where order_id = 1;

UPDATE cafe_orders
SET city = REPLACE(outlet_name, 'Ajey''s Cafe - ', '');


UPDATE cafe_orders
SET item_name = TRIM(item_name);

UPDATE cafe_orders
SET quantity = 1
WHERE quantity <= 0 OR quantity IS NULL;

UPDATE cafe_orders
SET payment_mode =
CASE
    WHEN LOWER(TRIM(payment_mode)) IN ('card', 'card ') THEN 'Debit/Credit Card'
    WHEN LOWER(TRIM(payment_mode)) IN ('cash') THEN 'Cash'
    WHEN LOWER(TRIM(payment_mode)) IN ('upi') THEN 'UPI'
    WHEN LOWER(TRIM(payment_mode)) IN ('netbanking') THEN 'NetBanking'
    WHEN LOWER(TRIM(payment_mode)) IN ('credit card') THEN 'Credit Card'
    WHEN LOWER(TRIM(payment_mode)) IN ('debit card') THEN 'Debit Card'
    ELSE CONCAT(UPPER(LEFT(TRIM(payment_mode), 1)), LOWER(SUBSTRING(TRIM(payment_mode), 2)))
END;

UPDATE cafe_orders
SET customer_name = 
    CASE 
        WHEN customer_name IS NULL OR TRIM(customer_name) = '' THEN 'Unknown'
        ELSE CONCAT(UPPER(LEFT(TRIM(customer_name), 1)), LOWER(SUBSTRING(TRIM(customer_name), 2)))
    END;
    
UPDATE cafe_orders
SET rating = NULL
WHERE rating < 1 OR rating > 5;


UPDATE cafe_orders
SET franchise_owner =
    CASE
        WHEN LOWER(TRIM(franchise_owner)) = 'ajey shah'
        THEN 'Ajey Shah'
    END;
    
UPDATE cafe_orders
SET franchise_owner = 'Ajey Shah';

SET SQL_SAFE_UPDATES = 0;

-- Step 1: Saare formats se time ko hata kar sirf date (YYYY-MM-DD) me convert karein
UPDATE cafe_orders
SET order_datetime = 
CASE
    -- Agar format 'YYYY-MM-DD' se shuru ho raha hai
    WHEN order_datetime REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}' 
        THEN SUBSTRING(order_datetime, 1, 10)
        
    -- Agar format 'DD/MM/YYYY' hai
    WHEN order_datetime REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}' 
        THEN DATE_FORMAT(STR_TO_DATE(order_datetime, '%d/%m/%Y'), '%Y-%m-%d')
        
    -- Agar format 'DD-Mon-YYYY' hai
    WHEN order_datetime REGEXP '^[0-9]{2}-[A-Za-z]{3}-[0-9]{4}' 
        THEN DATE_FORMAT(STR_TO_DATE(order_datetime, '%d-%b-%Y'), '%Y-%m-%d')
        
    ELSE DATE(order_datetime)
END;

ALTER TABLE cafe_orders
MODIFY COLUMN quantity INT;


describe cafe_orders;

SET SQL_SAFE_UPDATES = 0;

UPDATE cafe_orders
SET payment_mode = 'Unknown'
WHERE payment_mode IS NULL OR TRIM(payment_mode) = '';

SET SQL_SAFE_UPDATES = 0;
    -
-- Step 1: Out-of-range ratings (1 se kam ya 5 se zyada, jaise 0, 6) ko NULL mark karna
UPDATE cafe_orders
SET rating = NULL
WHERE rating < 1 OR rating > 5;

UPDATE cafe_orders
SET price = NULL
WHERE price < 0;

UPDATE cafe_orders t1
JOIN (
    SELECT item_name, AVG(price) as avg_price
    FROM cafe_orders
    WHERE price IS NOT NULL AND price >= 0
    GROUP BY item_name
) t2 ON t1.item_name = t2.item_name
SET t1.price = t2.avg_price
WHERE t1.price IS NULL;

SELECT * FROM cafe_orders;

UPDATE cafe_orders
SET customer_name = TRIM(REGEXP_REPLACE(customer_name, '[[:space:]]+', ' '))
WHERE customer_name IS NOT NULL;