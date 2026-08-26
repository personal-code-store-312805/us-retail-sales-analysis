-- Query 1: Top-performing industries in terms of sales for a year 2021, and how do their sales compare month-over-month?
WITH monthly_sales AS (
    SELECT year, month, industry, SUM(sales) AS total_sales
    FROM retail_sales
    WHERE year = 2021  
    GROUP BY year, month, industry
),
top_industries AS (
    SELECT year, month, industry, total_sales,
           RANK() OVER (PARTITION BY year, month ORDER BY total_sales DESC) AS industry_rank
    FROM monthly_sales
)
SELECT year, month, industry, total_sales
FROM top_industries
WHERE industry_rank = 1
ORDER BY year, month;

-- Query 2: Top-performing industries in terms of sales for a year 2022, and how do their sales compare month-over-month?
WITH monthly_sales AS (
    SELECT year, month, industry, SUM(sales) AS total_sales
    FROM retail_sales
    WHERE year = 2022  
    GROUP BY year, month, industry
),
top_industries AS (
    SELECT year, month, industry, total_sales,
           RANK() OVER (PARTITION BY year, month ORDER BY total_sales DESC) AS industry_rank
    FROM monthly_sales
)
SELECT year, month, industry, total_sales
FROM top_industries
WHERE industry_rank = 1
ORDER BY year, month;

-- Query 3: Top-performing industries in terms of sales for a year 2020, and how do their sales compare month-over-month?
WITH monthly_sales AS (
    SELECT year, month, industry, SUM(sales) AS total_sales
    FROM retail_sales
    WHERE year = 2020  
    GROUP BY year, month, industry
),
top_industries AS (
    SELECT year, month, industry, total_sales,
           RANK() OVER (PARTITION BY year, month ORDER BY total_sales DESC) AS industry_rank
    FROM monthly_sales
)
SELECT year, month, industry, total_sales
FROM top_industries
WHERE industry_rank = 1
ORDER BY year, month;
	
-- Query 4: Top-performing industries in terms of sales for a year 2019, and how do their sales compare month-over-month?
WITH monthly_sales AS (
    SELECT year, month, industry, SUM(sales) AS total_sales
    FROM retail_sales
    WHERE year = 2019  
    GROUP BY year, month, industry
),
top_industries AS (
    SELECT year, month, industry, total_sales,
           RANK() OVER (PARTITION BY year, month ORDER BY total_sales DESC) AS industry_rank
    FROM monthly_sales
)
SELECT year, month, industry, total_sales
FROM top_industries
WHERE industry_rank = 1
ORDER BY year, month;

-- Query 5: Which specific kind of businesses contribute the most to total sales, and how does their performance vary across industries?
SELECT kind_of_business, industry, SUM(sales) AS total_sales
FROM retail_sales
GROUP BY kind_of_business, industry
ORDER BY total_sales DESC;

-- Query 6: Is there any seasonality in sales for specific industries, and how do they perform month-over-month?
SELECT industry, year, month, SUM(sales) AS total_sales
FROM retail_sales
GROUP BY year, industry, month
ORDER BY year, industry, month;

-- Query 7: How does the sales distribution vary among industries based on their North American Industry Classification System (NAICS) codes?
SELECT naics_code, industry, SUM(sales) AS total_sales
FROM retail_sales
GROUP BY naics_code, industry
ORDER BY naics_code, total_sales DESC;

-- Query 8: Are there any outliers or significant changes in sales for specific industries during particular months or years?
SELECT industry, year, month, sales
FROM retail_sales
WHERE (industry, year, month) IN (
    SELECT industry, year, month
    FROM (
        SELECT industry, year, month, sales,
               LAG(sales) OVER (PARTITION BY industry ORDER BY year, month) AS prev_sales,
               LEAD(sales) OVER (PARTITION BY industry ORDER BY year, month) AS next_sales
        FROM retail_sales
    ) AS sales_analysis
    WHERE sales > 1.5 * COALESCE(prev_sales, 0) OR sales > 1.5 * COALESCE(next_sales, 0)
)
ORDER BY industry, year, month;

-- Query 9: Which businesses all-time average sale was above 10 billion dollars?
SELECT kind_of_business, AVG(sales) AS average_sale
FROM retail_sales
GROUP BY kind_of_business
HAVING AVG(sales) > 10000;

-- Query 10: Which kind of businesses within the automotive industry had the highest sales revenue for 2022?
SELECT kind_of_business, SUM(sales) AS total_sales
FROM retail_sales
WHERE industry = 'Automotive' AND year = 2022
GROUP BY kind_of_business
ORDER BY total_sales DESC;

-- Query 11: What is the contribution percentage of each business in the automotive industry this year?
WITH automotive_sales AS (
    SELECT kind_of_business, SUM(sales) AS total_sales
    FROM retail_sales
    WHERE industry = 'Automotive' AND year = 2022  
    GROUP BY kind_of_business
),
total_sales_automotive AS (
    SELECT SUM(sales) AS total_sales_automotive
    FROM retail_sales
    WHERE industry = 'Automotive' AND year = 2022
)
SELECT kind_of_business, 
       ROUND((total_sales / total_sales_automotive.total_sales_automotive) * 100, 2) AS contribution_percentage
FROM automotive_sales
CROSS JOIN total_sales_automotive;

-- Query 12: What are the year-over-year growth rates for each industry per year?
-- Method 1: Using Self-Join
WITH total_sales AS (
    SELECT year, industry, SUM(sales) AS sales_sum
    FROM retail_sales
    GROUP BY 1, 2
)
SELECT curr.industry, prev.year AS previous_year, curr.year AS current_year,
       (curr.sales_sum - prev.sales_sum) / prev.sales_sum * 100 AS YoY
FROM total_sales AS curr
JOIN total_sales AS prev 
  ON curr.year = prev.year + 1 AND curr.industry = prev.industry
ORDER BY industry, curr.year DESC;

-- Method 2: Using Window Functions
SELECT year, industry,
       (sales - LAG(sales) OVER (PARTITION BY industry ORDER BY year)) / 
       LAG(sales) OVER (PARTITION BY industry ORDER BY year) * 100 AS growth_rate
FROM retail_sales
ORDER BY industry, year;

-- Query 13: What are the yearly total sales for women's clothing stores and men's clothing stores?
SELECT year,
       SUM(CASE WHEN kind_of_business = 'Women''s clothing stores' THEN sales ELSE 0 END) AS women_sales,
       SUM(CASE WHEN kind_of_business = 'Men''s clothing stores' THEN sales ELSE 0 END) AS men_sales
FROM retail_sales
GROUP BY year;

-- Query 14: What is the yearly ratio of total sales for women's clothing stores to total sales for men's clothing stores?
SELECT year, 
       ROUND(women_sales * 1.0 / NULLIF(men_sales, 0), 2) AS Women_to_Men_ratio
FROM (
    SELECT year,
           SUM(CASE WHEN kind_of_business = 'Women''s clothing stores' THEN sales ELSE 0 END) AS women_sales,
           SUM(CASE WHEN kind_of_business = 'Men''s clothing stores' THEN sales ELSE 0 END) AS men_sales
    FROM retail_sales
    GROUP BY 1
) subquery;

-- Query 15: What is the year-to-date total sale of each month for 2019, 2020, 2021, and 2022 for the women's clothing stores?
SELECT rs.month, rs.year, rs.sales,
       (SELECT SUM(sales)
        FROM retail_sales rs2
        WHERE rs2.year = rs.year
          AND rs2.month <= rs.month
          AND rs2.kind_of_business = 'Women''s clothing stores'
       ) AS ytd_sales
FROM retail_sales AS rs
WHERE rs.kind_of_business = 'Women''s clothing stores'
  AND rs.year IN (2019, 2020, 2021, 2022);

-- Query 16: What is the month-over-month growth rate of women's clothing businesses in 2022?
-- Method 1: Fetching previous sales alongside current sales
SELECT month, sales AS current_sales,
       LAG(sales, 1) OVER (ORDER BY month) AS prev_sales
FROM retail_sales
WHERE kind_of_business = 'Women''s clothing stores' AND year = 2022;

-- Method 2: Calculating the actual growth rate percentage
SELECT month, sales AS current_sales,
       LAG(sales, 1) OVER (ORDER BY month) AS prev_sales,
       (sales - LAG(sales, 1) OVER (ORDER BY month)) / LAG(sales, 1) OVER (ORDER BY month) * 100 AS growth_rate
FROM retail_sales
WHERE kind_of_business = 'Women''s clothing stores' AND year = 2022;