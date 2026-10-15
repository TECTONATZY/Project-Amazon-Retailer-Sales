-- ============================================================
-- 04 | MONTHLY REVENUE TREND
-- Business question : How does revenue move month by month?
-- KPIs              : Revenue, orders, units per month
-- Dialect           : BigQuery Standard SQL
-- Expected result   : 24 rows (Jan 2022 - Dec 2023)
-- Note              : If order_date is already DATE type, DATE() is harmless.
-- ============================================================
SELECT
  DATE_TRUNC(DATE(order_date), MONTH) AS sales_month,
  ROUND(SUM(total_revenue), 2) AS revenue,
  COUNT(*) AS total_orders,
  SUM(quantity_sold) AS units_sold
FROM `portofolio-project-510803.Amazon_Sales.Amazon_Sales`
GROUP BY sales_month
ORDER BY sales_month;
