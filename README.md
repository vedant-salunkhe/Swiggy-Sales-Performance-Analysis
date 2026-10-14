Swiggy Sales & Performance Analysis

Project Overview

This project analyzes Swiggy sales and restaurant performance data using Oracle SQL and Power BI.

The goal was to clean the raw data, organize it into a star-schema data model, analyze sales performance using SQL, and build an interactive Power BI dashboard.

Tools & Technologies

- Oracle SQL
- Oracle SQL Developer
- Power BI
- DAX

Dataset

The dataset contains approximately 197K transaction records with information about states, cities, restaurants, locations, categories, dishes, prices, ratings, and rating counts.

Project Workflow

1. Imported the raw dataset into Oracle SQL Developer.
2. Checked for missing values and duplicate records.
3. Cleaned and validated the data.
4. Created a star schema with one fact table and five dimension tables.
5. Loaded and validated the tables.
6. Used SQL to analyze sales and restaurant performance.
7. Built an interactive Power BI dashboard.

Data Model

Fact table: F_SWIGGY_ORDERS

Dimension tables:
- D_DATE
- D_LOCATION
- D_RESTAURANT
- D_CATEGORY
- D_DISH

Key Business Insights

- The top five states contribute approximately 32.8% of total sales.
- The top ten restaurants contribute approximately 34% of total sales.
- Karnataka is the leading state by sales, with approximately ₹5.5M.
- KFC is the leading restaurant by sales, with approximately ₹4.2M.
- The Recommended category contributes approximately 13.6% of total sales.

Dashboard

The Power BI report contains two pages:

- Sales Performance Overview — KPI cards, sales trends, top-performing states, restaurants, categories, and dishes.
- Detailed Sales Analysis — detailed sales and rating data for further analysis.

Skills Demonstrated

SQL data cleaning, data validation, joins, aggregations, window functions, star-schema modeling, DAX, Power BI dashboards, KPI development, and business analysis.
