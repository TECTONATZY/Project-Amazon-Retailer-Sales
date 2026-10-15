-- ============================================================
-- 05 | AVERAGE ORDER VALUE (AOV)
-- Business question : How much is an average order worth, and does it differ by segment?
-- KPI               : AOV = total revenue / number of orders
-- Dialect           : BigQuery Standard SQL
-- Expected result   : Overall AOV ~657.33; categories 654-663; regions 651-664
-- ============================================================

-- A) Overall AOV
SELECT
  ROUND(SUM(total_revenue) / COUNT(*), 2) AS aov
FROM `portofolio-project-510803.Amazon_Sales.Amazon_Sales`;

-- B) AOV by category
SELECT
  product_category,
  COUNT(*) AS total_orders,
  ROUND(SUM(total_revenue), 2) AS revenue,
  ROUND(SUM(total_revenue) / COUNT(*), 2) AS aov
FROM `portofolio-project-510803.Amazon_Sales.Amazon_Sales`
GROUP BY product_category
ORDER BY aov DESC;

-- C) AOV by region
SELECT
  customer_region,
  COUNT(*) AS total_orders,
  ROUND(SUM(total_revenue), 2) AS revenue,
  ROUND(SUM(total_revenue) / COUNT(*), 2) AS aov
FROM `portofolio-project-510803.Amazon_Sales.Amazon_Sales`
GROUP BY customer_region
ORDER BY aov DESC;
