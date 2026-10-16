Select * from portofolio-project-510803.Amazon_Sales.Amazon_Sales;

-- Which category of product get a good sales ?
select product_category,
   count(distinct order_id) as total_orders,
   sum(total_revenue) as Revenue,
   avg(rating) as rating,
   sum(quantity_sold) as total_sold
from portofolio-project-510803.Amazon_Sales.Amazon_Sales
group by product_category
order by Revenue desc;

--WHICH REGIONS MOST CONTRIBUTE OVERALL SALES ?
SELECT customer_region, 
    sum(total_revenue) as Revenue,
    count(distinct order_id) as customer
from portofolio-project-510803.Amazon_Sales.Amazon_Sales
group by 1
order by Revenue desc

-- How do different discount levels relate to revenue  and sales volume
SELECT
    discount_percent,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(total_revenue) AS total_revenue,
    SUM(quantity_sold) AS units_sold,
    AVG(total_revenue) AS avg_revenue_per_record
FROM portofolio-project-510803.Amazon_Sales.Amazon_Sales
GROUP BY discount_percent
ORDER BY discount_percent;

-- Monthly Revenue Trend
SELECT
    DATE_TRUNC('month', order_date::date) AS sales_month,
    SUM(total_revenue) AS total_revenue,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(quantity_sold) AS units_sold
FROM  portofolio-project-510803.Amazon_Sales.Amazon_Sales
GROUP BY DATE_TRUNC('month', order_date::date)
ORDER BY sales_month;



-- Overall AOV
SELECT
  ROUND(SUM(total_revenue) / COUNT(*), 2) AS aov
FROM `portofolio-project-510803.Amazon_Sales.Amazon_Sales`;

-- AOV by category (swap in customer_region for the regional view)
SELECT
  product_category,
  COUNT(*) AS total_orders,
  ROUND(SUM(total_revenue), 2) AS revenue,
  ROUND(SUM(total_revenue) / COUNT(*), 2) AS aov
FROM `portofolio-project-510803.Amazon_Sales.Amazon_Sales`
GROUP BY product_category
ORDER BY aov DESC;


--Month-over-month growth
WITH monthly AS (
  SELECT
    DATE_TRUNC(DATE(order_date), MONTH) AS sales_month,
    SUM(total_revenue) AS revenue
  FROM `portofolio-project-510803.Amazon_Sales.Amazon_Sales`
  GROUP BY sales_month
),
with_prev AS (
  SELECT
    sales_month,
    revenue,
    LAG(revenue) OVER (ORDER BY sales_month) AS prev_month_revenue
  FROM monthly
)
SELECT
  sales_month,
  ROUND(revenue, 2) AS revenue,
  ROUND(prev_month_revenue, 2) AS prev_month_revenue,
  ROUND(SAFE_DIVIDE(revenue - prev_month_revenue, prev_month_revenue) * 100, 2) AS mom_growth_pct
FROM with_prev
ORDER BY sales_month;

--Year-over-year growth
WITH monthly AS (
  SELECT
    DATE_TRUNC(DATE(order_date), MONTH) AS sales_month,
    SUM(total_revenue) AS revenue
  FROM `portofolio-project-510803.Amazon_Sales.Amazon_Sales`
  GROUP BY sales_month
),
with_prev AS (
  SELECT
    sales_month,
    revenue,
    LAG(revenue, 12) OVER (ORDER BY sales_month) AS same_month_last_year
  FROM monthly
)
SELECT
  sales_month,
  ROUND(revenue, 2) AS revenue,
  ROUND(same_month_last_year, 2) AS same_month_last_year,
  ROUND(SAFE_DIVIDE(revenue - same_month_last_year, same_month_last_year) * 100, 2) AS yoy_growth_pct
FROM with_prev
ORDER BY sales_month;

WITH yearly AS (
  SELECT
    EXTRACT(YEAR FROM DATE(order_date)) AS sales_year,
    SUM(total_revenue) AS revenue
  FROM `portofolio-project-510803.Amazon_Sales.Amazon_Sales`
  GROUP BY sales_year
)
SELECT
  sales_year,
  ROUND(revenue, 2) AS revenue,
  ROUND(SAFE_DIVIDE(revenue - LAG(revenue) OVER (ORDER BY sales_year),
                    LAG(revenue) OVER (ORDER BY sales_year)) * 100, 2) AS yoy_growth_pct
FROM yearly
ORDER BY sales_year;

--Rating by category and region
-- By category
SELECT
  product_category,
  COUNT(*) AS total_orders,
  ROUND(AVG(rating), 3) AS avg_rating,
  ROUND(COUNTIF(rating <= 2) / COUNT(*) * 100, 1) AS low_rating_pct
FROM `portofolio-project-510803.Amazon_Sales.Amazon_Sales`
GROUP BY product_category
ORDER BY avg_rating DESC;

-- WHICH REGION HAS BEST SALES PERFORMANCE
SELECT
  customer_region,
  COUNT(*) AS total_orders,
  ROUND(AVG(rating), 3) AS avg_rating,
  ROUND(COUNTIF(rating <= 2) / COUNT(*) * 100, 1) AS low_rating_pct
FROM `portofolio-project-510803.Amazon_Sales.Amazon_Sales`
GROUP BY customer_region
ORDER BY avg_rating DESC;

-- Category BY region (to look for a standout combination)
SELECT
  product_category,
  customer_region,
  COUNT(*) AS total_orders,
  ROUND(AVG(rating), 3) AS avg_rating
FROM `portofolio-project-510803.Amazon_Sales.Amazon_Sales`
GROUP BY product_category, customer_region
ORDER BY avg_rating DESC;

