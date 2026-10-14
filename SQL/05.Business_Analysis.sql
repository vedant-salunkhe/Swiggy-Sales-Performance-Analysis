-- Swiggy Sales & Performance Analysis
-- 05.Business Analysis
-- Oracle SQL

-- 1. Transaction records
SELECT COUNT(*) AS transaction_records
FROM f_swiggy_orders;

-- 2. Total sales
SELECT SUM(price) AS total_sales
FROM f_swiggy_orders;

-- 3. Average item price
SELECT ROUND(AVG(price),2) AS average_item_price
FROM f_swiggy_orders;

-- 4. Average rating
SELECT ROUND(AVG(rating),2) AS average_rating
FROM f_swiggy_orders;

-- 5. Sales by state
SELECT l.state,SUM(f.price) AS total_sales
FROM f_swiggy_orders f
JOIN d_location l ON f.location_id = l.location_id
GROUP BY l.state
ORDER BY total_sales DESC;

-- 6. Sales by city
SELECT l.city,SUM(f.price) AS total_sales
FROM f_swiggy_orders f
JOIN d_location l ON f.location_id = l.location_id
GROUP BY l.city
ORDER BY total_sales DESC;

-- 7. Sales by category
SELECT c.category,SUM(f.price) AS total_sales
FROM f_swiggy_orders f
JOIN d_category c ON f.category_id = c.category_id
GROUP BY c.category
ORDER BY total_sales DESC;

-- 8. Sales by restaurant
SELECT r.restaurant_name,SUM(f.price) AS total_sales
FROM f_swiggy_orders f
JOIN d_restaurant r ON f.restaurant_id = r.restaurant_id
GROUP BY r.restaurant_name
ORDER BY total_sales DESC;

-- 9. Sales by dish
SELECT d.dish_name,SUM(f.price) AS total_sales
FROM f_swiggy_orders f
JOIN d_dish d ON f.dish_id = d.dish_id
GROUP BY d.dish_name
ORDER BY total_sales DESC;

-- 10. Year-wise sales
SELECT
    d.year,
    SUM(f.price) AS total_sales
FROM f_swiggy_orders f
JOIN d_date d ON f.date_id = d.date_id
GROUP BY d.year
ORDER BY d.year;

-- 11. Month-wise sales
SELECT d.month,d.month_name,SUM(f.price) AS total_sales
FROM f_swiggy_orders f
JOIN d_date d ON f.date_id = d.date_id
GROUP BY d.month, d.month_name
ORDER BY d.month;

-- 12. Top 10 restaurants
SELECT r.restaurant_name,SUM(f.price) AS total_sales
FROM f_swiggy_orders f
JOIN d_restaurant r ON f.restaurant_id = r.restaurant_id
GROUP BY r.restaurant_name
ORDER BY total_sales DESC
FETCH FIRST 10 ROWS ONLY;

-- 13. Top 10 dishes
SELECT d.dish_name,SUM(f.price) AS total_sales
FROM f_swiggy_orders f
JOIN d_dish d ON f.dish_id = d.dish_id
GROUP BY d.dish_name
ORDER BY total_sales DESC
FETCH FIRST 10 ROWS ONLY;

-- 14. Highest-rated restaurants
SELECT r.restaurant_name,MAX(f.rating) AS highest_rating
FROM f_swiggy_orders f
JOIN d_restaurant r ON f.restaurant_id = r.restaurant_id
GROUP BY r.restaurant_name
ORDER BY highest_rating DESC
FETCH FIRST 10 ROWS ONLY;

-- 15. Top 3 restaurants in every city
SELECT * FROM (
  SELECT l.city,r.restaurant_name,SUM(f.price) AS total_sales,
         ROW_NUMBER() OVER (PARTITION BY l.city ORDER BY SUM(f.price) DESC) AS rnk
FROM f_swiggy_orders f
JOIN d_location l ON f.location_id = l.location_id
JOIN d_restaurant r ON f.restaurant_id = r.restaurant_id
GROUP BY l.city, r.restaurant_name)
WHERE rnk <= 3;

-- 16. Top 3 dishes per category
SELECT * FROM (
    SELECT c.category,di.dish_name,SUM(f.price) AS total_sales,
           ROW_NUMBER() OVER (PARTITION BY c.category ORDER BY SUM(f.price) DESC) AS rnk
FROM f_swiggy_orders f
JOIN d_dish di ON f.dish_id = di.dish_id
JOIN d_category c ON f.category_id = c.category_id
GROUP BY c.category, di.dish_name)
WHERE rnk <= 3;

-- 17. Restaurant performance segmentation
SELECT l.state,l.city,l.location,r.restaurant_name,
    ROUND(AVG(f.rating), 2) AS avg_rating,
    CASE
        WHEN AVG(f.rating) >= 4.5 THEN 'Excellent'
        WHEN AVG(f.rating) >= 4.0 THEN 'Good'
        WHEN AVG(f.rating) >= 3.0 THEN 'Average'
        ELSE 'Needs Improvement'
    END AS performance
FROM f_swiggy_orders f
JOIN d_restaurant r ON f.restaurant_id = r.restaurant_id
JOIN d_location l ON f.location_id = l.location_id
WHERE f.rating IS NOT NULL
GROUP BY l.state, l.city, l.location, r.restaurant_name
ORDER BY avg_rating DESC;

-- 18. High-rated / low-sales restaurants

WITH restaurant_sales AS(
SELECT restaurant_id,SUM(price) AS total_sales FROM f_swiggy_orders 
GROUP BY restaurant_id)
SELECT r.restaurant_name,SUM(f.price) AS total_sales,
       ROUND(AVG(f.rating),2) AS avg_rating FROM f_swiggy_orders f 
JOIN d_restaurant r ON f.restaurant_id = r.restaurant_id 
GROUP BY r.restaurant_name 
HAVING avg(f.rating)>=4 AND SUM(f.price) < ( 
SELECT AVG(total_sales) FROM restaurant_sales)
ORDER BY total_sales;

-- 19. Monthly sales ranking
SELECT d.month,d.month_name,SUM(f.price) AS total_sales,
    RANK() OVER (ORDER BY SUM(f.price) DESC) AS rnk
FROM f_swiggy_orders f
JOIN d_date d ON f.date_id = d.date_id
GROUP BY d.month, d.month_name
ORDER BY rnk;

-- 20. Category contribution %
SELECT c.category,SUM(f.price) AS category_sales,
    ROUND(SUM(f.price) * 100 / (
    SELECT SUM(price) FROM f_swiggy_orders),2) AS contribution_percentage
FROM f_swiggy_orders f
JOIN d_category c ON f.category_id = c.category_id
GROUP BY c.category
ORDER BY contribution_percentage DESC;

-- 21. State ranking
SELECT l.state,SUM(f.price) AS total_sales,
    DENSE_RANK() OVER (ORDER BY SUM(f.price) DESC) AS rnk
FROM f_swiggy_orders f
JOIN d_location l ON f.location_id = l.location_id
GROUP BY l.state
ORDER BY rnk;

-- 22. Running total sales
SELECT d.month,d.month_name,
    SUM(f.price) AS total_sales,
    SUM(SUM(f.price)) OVER (ORDER BY d.month) AS running_sales
FROM f_swiggy_orders f
JOIN d_date d ON f.date_id = d.date_id
GROUP BY d.month, d.month_name
ORDER BY d.month;

-- 23. Top restaurant in each state
SELECT * FROM (
    SELECT r.restaurant_name,l.state,
        SUM(f.price) AS total_sales,
        ROW_NUMBER() OVER (PARTITION BY l.state ORDER BY SUM(f.price) DESC) AS rnk
FROM f_swiggy_orders f
JOIN d_restaurant r ON f.restaurant_id = r.restaurant_id
JOIN d_location l ON f.location_id = l.location_id
GROUP BY r.restaurant_name, l.state)
WHERE rnk = 1
ORDER BY total_sales DESC;





