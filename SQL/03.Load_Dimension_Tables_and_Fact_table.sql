-- Swiggy Sales & Performance Analysis
-- 03.Load Dimension Tables and Fact Table
-- Oracle SQL

-- Date dimension
INSERT INTO d_date(date_id, full_date, day, week, month, month_name, quarter, year)
SELECT ROW_NUMBER() OVER (ORDER BY order_date),
       order_date,
       TO_NUMBER(TO_CHAR(order_date, 'DD')),
       TO_NUMBER(TO_CHAR(order_date, 'WW')),
       TO_NUMBER(TO_CHAR(order_date, 'MM')),
       TO_CHAR(order_date, 'MONTH'),
       TO_NUMBER(TO_CHAR(order_date, 'Q')),
       TO_NUMBER(TO_CHAR(order_date, 'YYYY'))
FROM ( SELECT DISTINCT order_date FROM swiggy_t
WHERE order_date IS NOT NULL);

-- Location dimension
INSERT INTO d_location(location_id, state, city, location)
SELECT ROW_NUMBER() OVER (ORDER BY state, city, location),
    state,city,location
FROM (SELECT DISTINCT state, city, location FROM swiggy_t);

-- Restaurant dimension
INSERT INTO d_restaurant(restaurant_id, restaurant_name)
SELECT
    ROW_NUMBER() OVER (ORDER BY restaurant_name),
    restaurant_name
FROM (SELECT DISTINCT restaurant_name FROM swiggy_t);

-- Category dimension
INSERT INTO d_category(category_id, category)
SELECT
    ROW_NUMBER() OVER (ORDER BY category),
    category
FROM(SELECT DISTINCT category FROM swiggy_t);

-- Dish dimension
INSERT INTO d_dish(dish_id, dish_name)
SELECT
    ROW_NUMBER() OVER (ORDER BY dish_name),
    dish_name
FROM (SELECT DISTINCT dish_name FROM swiggy_t);

--Fact table

INSERT INTO f_swiggy_orders
                          (order_id, date_id, location_id, restaurant_id,
                          category_id, dish_id, price, rating, rating_count)
SELECT
    ROW_NUMBER() OVER (ORDER BY s.order_date),
    d.date_id,
    l.location_id,
    r.restaurant_id,
    c.category_id,
    di.dish_id,
    s.price,
    s.rating,
    s.rating_count
FROM swiggy_t s
JOIN d_date d ON s.order_date = d.full_date
JOIN d_location l ON s.state = l.state AND s.city = l.city AND s.location = l.location
JOIN d_restaurant r ON s.restaurant_name = r.restaurant_name
JOIN d_category c ON s.category = c.category
JOIN d_dish di ON s.dish_name = di.dish_name;


COMMIT;