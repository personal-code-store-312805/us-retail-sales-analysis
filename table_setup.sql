CREATE DATABASE retail_sales;

CREATE TABLE retail_sales (
    id SERIAL PRIMARY KEY,
    month INTEGER NOT NULL,
    year INTEGER NOT NULL,
    naics_code TEXT,
    kind_of_business TEXT NOT NULL,
    industry TEXT NOT NULL,
    sales INTEGER DEFAULT NULL
);

COPY retail_sales 
FROM 'E:\retail_sales_analysis\us_monthly_retail_sales_preprocessed.csv'
WITH (FORMAT CSV, HEADER);

UPDATE retail_sales SET sales = NULL WHERE sales = 0;

SELECT * FROM retail_sales LIMIT 50;