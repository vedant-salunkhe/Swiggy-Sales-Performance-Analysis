-- Swiggy Sales & Performance Analysis
-- 1.Raw Data Import & Cleaning
-- Oracle SQL

-- Raw dataset was imported into SWIGGY_TABLE using SQL Developer.
-- Rename the imported table to the project source table.
RENAME swiggy_table TO swiggy_t;

-- View raw data
SELECT * FROM swiggy_t;

-- Check null values
SELECT
    COUNT(*) AS total_rows,
    COUNT(state) AS state_present,
    COUNT(city) AS city_present,
    COUNT(order_date) AS order_date_present,
    COUNT(restaurant_name) AS restaurant_name_present,
    COUNT(location) AS location_present,
    COUNT(category) AS category_present,
    COUNT(dish_name) AS dish_name_present,
    COUNT(price) AS price_present,
    COUNT(rating) AS rating_present,
    COUNT(rating_count) AS rating_count_present
FROM swiggy_t;

-- Count missing values by column
SELECT
    COUNT(*) - COUNT(state) AS missing_state,
    COUNT(*) - COUNT(city) AS missing_city,
    COUNT(*) - COUNT(order_date) AS missing_order_date,
    COUNT(*) - COUNT(restaurant_name) AS missing_restaurant_name,
    COUNT(*) - COUNT(location) AS missing_location,
    COUNT(*) - COUNT(category) AS missing_category,
    COUNT(*) - COUNT(dish_name) AS missing_dish_name,
    COUNT(*) - COUNT(price) AS missing_price,
    COUNT(*) - COUNT(rating) AS missing_rating,
    COUNT(*) - COUNT(rating_count) AS missing_rating_count
FROM swiggy_t;

-- Check duplicate records
SELECT
    state,city,order_date,restaurant_name,location,
    category,dish_name,price,rating,rating_count,
    COUNT(*) AS duplicate_count
FROM swiggy_t
GROUP BY 
    state,city,order_date,restaurant_name,location,
    category,dish_name,price,rating,rating_count 
HAVING COUNT(*) > 1;

-- Identify duplicate rows using ROW_NUMBER
SELECT * FROM (
SELECT s.*,
    ROW_NUMBER() OVER (PARTITION BY state,city,order_date,restaurant_name,location,
                                    category,dish_name,price,rating,rating_count
            ORDER BY ROWID) AS rn 
FROM swiggy_t s )
WHERE rn > 1;

-- Delete duplicate rows, keeping the first occurrence
DELETE FROM swiggy_t
WHERE ROWID IN (
SELECT rid  FROM (
    SELECT ROWID AS rid,ROW_NUMBER() OVER (PARTITION BY state,city,order_date,restaurant_name,location,
                                           category,dish_name,price,rating,rating_count
                ORDER BY ROWID) AS rn
FROM swiggy_t)
WHERE rn > 1);

COMMIT;

-- Post-cleaning record count
SELECT COUNT(*) AS cleaned_records
FROM swiggy_t;