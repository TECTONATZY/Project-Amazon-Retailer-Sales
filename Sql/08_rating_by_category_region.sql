-- ============================================================
-- 08 | RATING BY CATEGORY AND REGION
-- Business question : Is customer satisfaction different across categories or regions?
-- KPIs              : Avg rating, low-rating share (rating <= 2)
-- Dialect           : BigQuery Standard SQL
-- Expected result   : Every segment averages ~3.0 (2.97-3.02); overall low-rating share ~26.5%
-- ============================================================

-- A) By category
SELECT
  product_category,
  COUNT(*) AS total_orders,
  ROUND(AVG(rating), 3) AS avg_rating,
  ROUND(COUNTIF(rating <= 2) / COUNT(*) * 100, 1) AS low_rating_pct
FROM `portofolio-project-510803.Amazon_Sales.Amazon_Sales`
GROUP BY product_category
ORDER BY avg_rating DESC;

-- B) By region
SELECT
  customer_region,
  COUNT(*) AS total_orders,
  ROUND(AVG(rating), 3) AS avg_rating,
  ROUND(COUNTIF(rating <= 2) / COUNT(*) * 100, 1) AS low_rating_pct
FROM `portofolio-project-510803.Amazon_Sales.Amazon_Sales`
GROUP BY customer_region
ORDER BY avg_rating DESC;

-- C) Category x region (look for a standout combination)
SELECT
  product_category,
  customer_region,
  COUNT(*) AS total_orders,
  ROUND(AVG(rating), 3) AS avg_rating
FROM `portofolio-project-510803.Amazon_Sales.Amazon_Sales`
GROUP BY product_category, customer_region
ORDER BY avg_rating DESC;
