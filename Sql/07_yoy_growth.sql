-- ============================================================
-- 07 | YEAR-OVER-YEAR (YoY) GROWTH
-- Business question : Is revenue higher than the same period last year?
-- KPI               : YoY growth % = (this period - same period last year) / same period last year x 100
-- Technique         : LAG(revenue, 12) looks back 12 monthly rows.
--                     Safe here because all 24 months exist; with gaps, use a self-join instead.
-- Dialect           : BigQuery Standard SQL
-- Expected result   : A) 24 rows, first 12 NULL, then -4.7% to +7.1%
--                     B) 2022 ~16.39M, 2023 ~16.48M, YoY ~ +0.54%
-- ============================================================

-- A) Monthly YoY
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

-- B) Full-year YoY
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
