-- Swiggy Sales & Performance Analysis
-- 02.Create Star Schema Tables
-- Oracle SQL

CREATE TABLE d_date(
    date_id NUMBER PRIMARY KEY,
    full_date DATE NOT NULL,
    day NUMBER,
    week NUMBER,
    month NUMBER,
    month_name VARCHAR2(10),
    quarter NUMBER,
    year NUMBER
);

CREATE TABLE d_location(
    location_id NUMBER PRIMARY KEY,
    state VARCHAR2(100),
    city VARCHAR2(100),
    location VARCHAR2(150)
);

CREATE TABLE d_restaurant(
    restaurant_id NUMBER PRIMARY KEY,
    restaurant_name VARCHAR2(150)
);

CREATE TABLE d_category(
    category_id NUMBER PRIMARY KEY,
    category VARCHAR2(150)
);

CREATE TABLE d_dish(
    dish_id NUMBER PRIMARY KEY,
    dish_name VARCHAR2(250)
);

CREATE TABLE f_swiggy_orders(
    order_id NUMBER PRIMARY KEY,
    date_id NUMBER,
    location_id NUMBER,
    restaurant_id NUMBER,
    category_id NUMBER,
    dish_id NUMBER,
    price NUMBER(6,1),
    rating NUMBER(4,1),
    rating_count NUMBER(5),

    FOREIGN KEY (date_id) REFERENCES d_date(date_id),
    FOREIGN KEY (location_id) REFERENCES d_location(location_id),
    FOREIGN KEY (restaurant_id) REFERENCES d_restaurant(restaurant_id),
    FOREIGN KEY (category_id) REFERENCES d_category(category_id),
    FOREIGN KEY (dish_id) REFERENCES d_dish(dish_id)
);


