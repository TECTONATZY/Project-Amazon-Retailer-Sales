-- ============================================================
-- 06 | MONTH-OVER-MONTH (MoM) GROWTH
-- Business question : Is revenue growing or shrinking versus the previous month?
-- KPI               : MoM growth % = (this month - last month) / last month x 100
-- Technique         : Step 1 aggregate to one row per month (CTE),
--                     Step 2 apply LAG() on that monthly table.
-- Dialect           : BigQuery Standard SQL
-- Expected result   : 24 rows; first row NULL (no previous month);
--                     growth ranges roughly -15% to +10%, average ~0%.
-- ============================================================
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
