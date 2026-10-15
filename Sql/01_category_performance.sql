--WHICH PRODUCT BEST SALES IN CATEGORY ?
SELECT
  product_category,
  COUNT(*) AS total_orders,
  ROUND(SUM(total_revenue), 2) AS revenue,
  ROUND(AVG(rating), 2) AS avg_rating,
  SUM(quantity_sold) AS total_units_sold
FROM `portofolio-project-510803.Amazon_Sales.Amazon_Sales`
GROUP BY product_category
ORDER BY revenue DESC;
