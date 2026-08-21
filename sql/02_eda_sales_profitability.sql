-- ============================================================
-- SUPERSTORE SALES & PROFITABILITY ANALYSIS
-- 02 - EDA SALES & PROFITABILITY
-- ============================================================


-- ============================================================
-- 1. OVERALL BUSINESS KPIs
-- ============================================================

SELECT
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_name) AS total_customers,
    ROUND(
        SUM(sales) / NULLIF(COUNT(DISTINCT order_id), 0),
        2
    ) AS average_order_value,
    ROUND(
        SUM(profit) * 100.0 / NULLIF(SUM(sales), 0),
        2
    ) AS profit_margin_pct
FROM orders;


-- ============================================================
-- 2. YEARLY SALES AND PROFIT PERFORMANCE
-- ============================================================

SELECT
    EXTRACT(YEAR FROM order_date) AS year,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    ROUND(
        SUM(profit) * 100.0 / NULLIF(SUM(sales), 0),
        2
    ) AS profit_margin_pct
FROM orders
GROUP BY EXTRACT(YEAR FROM order_date)
ORDER BY year;


-- ============================================================
-- 3. YEAR-OVER-YEAR SALES GROWTH
-- ============================================================

WITH yearly_sales AS (
    SELECT
        EXTRACT(YEAR FROM order_date) AS year,
        SUM(sales) AS total_sales
    FROM orders
    GROUP BY EXTRACT(YEAR FROM order_date)
),

yearly_growth AS (
    SELECT
        year,
        total_sales,
        LAG(total_sales) OVER (
            ORDER BY year
        ) AS previous_year_sales
    FROM yearly_sales
)

SELECT
    year,
    total_sales,
    previous_year_sales,
    ROUND(
        (total_sales - previous_year_sales) * 100.0
        / NULLIF(previous_year_sales, 0),
        2
    ) AS yoy_growth_pct
FROM yearly_growth
ORDER BY year;


-- ============================================================
-- 4. YEARLY SALES, PROFIT, YOY GROWTH, AND PROFIT MARGIN
-- FINAL TREND ANALYSIS
-- ============================================================

WITH yearly_performance AS (
    SELECT
        EXTRACT(YEAR FROM order_date) AS year,
        SUM(sales) AS total_sales,
        SUM(profit) AS total_profit
    FROM orders
    GROUP BY EXTRACT(YEAR FROM order_date)
),

yearly_previous AS (
    SELECT
        year,
        total_sales,
        total_profit,
        LAG(total_sales) OVER (
            ORDER BY year
        ) AS previous_year_sales
    FROM yearly_performance
)

SELECT
    year,
    total_sales,
    total_profit,
    previous_year_sales,
    ROUND(
        (total_sales - previous_year_sales) * 100.0
        / NULLIF(previous_year_sales, 0),
        2
    ) AS yoy_growth_pct,
    ROUND(
        total_profit * 100.0
        / NULLIF(total_sales, 0),
        2
    ) AS profit_margin_pct
FROM yearly_previous
ORDER BY year;