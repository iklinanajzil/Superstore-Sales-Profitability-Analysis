-- ============================================================
-- SUPERSTORE SALES & PROFITABILITY ANALYSIS
-- 05 - FINAL ANALYSIS
-- ============================================================


-- ============================================================
-- 1. EXECUTIVE KPI
-- ============================================================

SELECT
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
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
-- 2. YEARLY BUSINESS PERFORMANCE
-- ============================================================

WITH yearly AS (
    SELECT
        EXTRACT(YEAR FROM order_date) AS year,
        SUM(sales) AS total_sales,
        SUM(profit) AS total_profit
    FROM orders
    GROUP BY EXTRACT(YEAR FROM order_date)
),

yearly_growth AS (
    SELECT
        *,
        LAG(total_sales) OVER (
            ORDER BY year
        ) AS previous_year_sales
    FROM yearly
)

SELECT
    year,
    ROUND(total_sales, 2) AS total_sales,
    ROUND(total_profit, 2) AS total_profit,
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
FROM yearly_growth
ORDER BY year;


-- ============================================================
-- 3. MARKET PERFORMANCE
-- ============================================================

WITH market AS (
    SELECT
        market,
        SUM(sales) AS total_sales,
        SUM(profit) AS total_profit
    FROM orders
    GROUP BY market
)

SELECT
    market,
    ROUND(total_sales, 2) AS total_sales,
    ROUND(total_profit, 2) AS total_profit,
    ROUND(
        total_profit * 100.0
        / NULLIF(total_sales, 0),
        2
    ) AS profit_margin_pct,
    ROUND(
        total_sales * 100.0
        / NULLIF(SUM(total_sales) OVER (), 0),
        2
    ) AS sales_contribution_pct
FROM market
ORDER BY total_sales DESC;


-- ============================================================
-- 4. MARKET × CATEGORY PERFORMANCE
-- ============================================================

SELECT
    market,
    category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(
        SUM(profit) * 100.0
        / NULLIF(SUM(sales), 0),
        2
    ) AS profit_margin_pct
FROM orders
GROUP BY market, category
ORDER BY total_profit DESC;


-- ============================================================
-- 5. TOP 10 PRODUCTS BY SALES
-- ============================================================

SELECT
    category,
    product_name,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(
        SUM(profit) * 100.0
        / NULLIF(SUM(sales), 0),
        2
    ) AS profit_margin_pct
FROM orders
GROUP BY category, product_name
ORDER BY total_sales DESC
LIMIT 10;


-- ============================================================
-- 6. TOP 10 PRODUCTS BY PROFIT
-- ============================================================

SELECT
    category,
    product_name,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(
        SUM(profit) * 100.0
        / NULLIF(SUM(sales), 0),
        2
    ) AS profit_margin_pct
FROM orders
GROUP BY category, product_name
ORDER BY total_profit DESC
LIMIT 10;


-- ============================================================
-- 7. TOP 10 LOSS-MAKING PRODUCTS
-- ============================================================

SELECT
    market,
    category,
    product_name,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(
        SUM(profit) * 100.0
        / NULLIF(SUM(sales), 0),
        2
    ) AS profit_margin_pct
FROM orders
GROUP BY market, category, product_name
HAVING SUM(profit) < 0
ORDER BY total_profit
LIMIT 10;


-- ============================================================
-- 8. LOSS-MAKING PRODUCTS BY MARKET
-- ============================================================

WITH market_product AS (
    SELECT
        market,
        product_name,
        SUM(profit) AS total_profit
    FROM orders
    GROUP BY market, product_name
)

SELECT
    market,
    COUNT(*) FILTER (
        WHERE total_profit < 0
    ) AS loss_making_products,
    ROUND(
        SUM(
            CASE
                WHEN total_profit < 0
                THEN total_profit
                ELSE 0
            END
        ),
        2
    ) AS total_loss
FROM market_product
GROUP BY market
ORDER BY total_loss;


-- ============================================================
-- 9. DISCOUNT BAND PERFORMANCE
-- ============================================================

WITH discount_band AS (
    SELECT
        CASE
            WHEN discount = 0 THEN '0%'
            WHEN discount <= 0.10 THEN '1-10%'
            WHEN discount <= 0.20 THEN '11-20%'
            WHEN discount <= 0.30 THEN '21-30%'
            WHEN discount <= 0.40 THEN '31-40%'
            WHEN discount <= 0.50 THEN '41-50%'
            WHEN discount <= 0.60 THEN '51-60%'
            WHEN discount <= 0.70 THEN '61-70%'
            ELSE '>70%'
        END AS discount_band,
        sales,
        profit
    FROM orders
)

SELECT
    discount_band,
    COUNT(*) AS row_count,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(
        SUM(profit) * 100.0
        / NULLIF(SUM(sales), 0),
        2
    ) AS profit_margin_pct
FROM discount_band
GROUP BY discount_band
ORDER BY
    CASE discount_band
        WHEN '0%' THEN 1
        WHEN '1-10%' THEN 2
        WHEN '11-20%' THEN 3
        WHEN '21-30%' THEN 4
        WHEN '31-40%' THEN 5
        WHEN '41-50%' THEN 6
        WHEN '51-60%' THEN 7
        WHEN '61-70%' THEN 8
        WHEN '>70%' THEN 9
    END;


-- ============================================================
-- 10. CATEGORY PERFORMANCE BY DISCOUNT BAND
-- ============================================================

WITH discount_band AS (
    SELECT
        category,
        CASE
            WHEN discount = 0 THEN '0%'
            WHEN discount <= 0.10 THEN '1-10%'
            WHEN discount <= 0.20 THEN '11-20%'
            WHEN discount <= 0.30 THEN '21-30%'
            WHEN discount <= 0.40 THEN '31-40%'
            WHEN discount <= 0.50 THEN '41-50%'
            WHEN discount <= 0.60 THEN '51-60%'
            WHEN discount <= 0.70 THEN '61-70%'
            ELSE '>70%'
        END AS discount_band,
        sales,
        profit
    FROM orders
)

SELECT
    category,
    discount_band,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(
        SUM(profit) * 100.0
        / NULLIF(SUM(sales), 0),
        2
    ) AS profit_margin_pct
FROM discount_band
GROUP BY category, discount_band
ORDER BY category,
    CASE discount_band
        WHEN '0%' THEN 1
        WHEN '1-10%' THEN 2
        WHEN '11-20%' THEN 3
        WHEN '21-30%' THEN 4
        WHEN '31-40%' THEN 5
        WHEN '41-50%' THEN 6
        WHEN '51-60%' THEN 7
        WHEN '61-70%' THEN 8
        WHEN '>70%' THEN 9
    END;


-- ============================================================
-- 11. EXTREME LOSS TRANSACTIONS
-- ============================================================

SELECT
    order_id,
    order_date,
    market,
    category,
    product_name,
    sales,
    quantity,
    discount,
    profit,
    shipping_cost
FROM orders
WHERE profit < 0
ORDER BY profit
LIMIT 10;