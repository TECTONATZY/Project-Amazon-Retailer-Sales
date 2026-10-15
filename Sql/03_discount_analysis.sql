-- ============================================================
-- 03 | DISCOUNT ANALYSIS
-- Business question : Do higher discounts increase sales volume, or only reduce revenue?
-- KPIs              : Orders, revenue, units, avg units/order, avg revenue/order, discount leakage
-- Dialect           : BigQuery Standard SQL
-- Expected result   : 6 rows (0,5,10,15,20,30%); avg units/order ~3.0 in every band,
--                     while discount leakage climbs from 0 to ~1.86M.
-- Discount leakage  : (price x quantity) - total_revenue = revenue given away via discounts.
-- ============================================================
SELECT
  discount_percent,
  COUNT(*) AS total_orders,
  ROUND(SUM(total_revenue), 2) AS revenue,
  SUM(quantity_sold) AS units_sold,
  ROUND(AVG(quantity_sold), 2) AS avg_units_per_order,
  ROUND(AVG(total_revenue), 2) AS avg_revenue_per_order,
  ROUND(SUM(price * quantity_sold) - SUM(total_revenue), 2) AS discount_leakage
FROM `portofolio-project-510803.Amazon_Sales.Amazon_Sales`
GROUP BY discount_percent
ORDER BY discount_percent;
