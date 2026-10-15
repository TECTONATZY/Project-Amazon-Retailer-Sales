-- ============================================================
-- 02 | REGION CONTRIBUTION
-- Business question : Which regions contribute most to overall sales?
-- KPIs              : Revenue, orders, revenue share %
-- Dialect           : BigQuery Standard SQL
-- Expected result   : 4 rows; Middle East ~8.30M (top), Europe ~8.11M (lowest)
-- Note              : Dataset has no customer ID, so we count orders, not customers.
-- ============================================================
SELECT
  customer_region,
  ROUND(SUM(total_revenue), 2) AS revenue,
  COUNT(*) AS total_orders,
  ROUND(SUM(total_revenue) / SUM(SUM(total_revenue)) OVER () * 100, 1) AS revenue_share_pct
FROM `portofolio-project-510803.Amazon_Sales.Amazon_Sales`
GROUP BY customer_region
ORDER BY revenue DESC;
