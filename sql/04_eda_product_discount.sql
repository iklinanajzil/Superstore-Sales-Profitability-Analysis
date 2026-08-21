-- ============================================================
-- SUPERSTORE SALES & PROFITABILITY ANALYSIS
-- 04 - EDA PRODUCT & DISCOUNT
-- ============================================================


-- ============================================================
-- 1. PRODUCT PERFORMANCE
-- Sales, Profit, and Profit Margin per Product
-- ============================================================

WITH product_performance AS (
    SELECT
        category,
        product_name,
        SUM(sales) AS total_sales,
        SUM(profit) AS total_profit
    FROM orders
    GROUP BY category, product_name
)

SELECT
    category,
    product_name,
    total_sales,
    total_profit,
    ROUND(
        total_profit * 100.0
        / NULLIF(total_sales, 0),
        2
    ) AS profit_margin_pct
FROM product_performance
WHERE total_sales > 0
ORDER BY total_sales DESC;


-- ============================================================
-- 2. TOP 10 PRODUCTS BY SALES
-- ============================================================

SELECT
    category,
    product_name,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM orders
GROUP BY category, product_name
ORDER BY total_sales DESC
LIMIT 10;


-- ============================================================
-- 3. TOP PRODUCT BY SALES IN EACH CATEGORY
-- ============================================================

WITH product_sales AS (
    SELECT
        category,
        product_name,
        SUM(sales) AS total_sales
    FROM orders
    GROUP BY category, product_name
),

product_rank AS (
    SELECT
        category,
        product_name,
        total_sales,
        DENSE_RANK() OVER (
            PARTITION BY category
            ORDER BY total_sales DESC
        ) AS rank_product
    FROM product_sales
)

SELECT
    category,
    product_name,
    total_sales
FROM product_rank
WHERE rank_product = 1
ORDER BY category;


-- ============================================================
-- 4. LOSS-MAKING PRODUCTS
-- ============================================================

WITH product_performance AS (
    SELECT
        category,
        product_name,
        SUM(sales) AS total_sales,
        SUM(profit) AS total_profit
    FROM orders
    GROUP BY category, product_name
)

SELECT
    category,
    product_name,
    total_sales,
    total_profit,
    ROUND(
        total_profit * 100.0
        / NULLIF(total_sales, 0),
        2
    ) AS profit_margin_pct
FROM product_performance
WHERE total_profit < 0
ORDER BY total_profit;


-- ============================================================
-- 5. LOSS-MAKING PRODUCTS BY MARKET
-- Count and total loss
-- ============================================================

WITH market_product AS (
    SELECT
        market,
        product_name,
        SUM(profit) AS total_profit
    FROM orders
    GROUP BY market, product_name
),

loss_products AS (
    SELECT
        market,
        product_name,
        total_profit
    FROM market_product
    WHERE total_profit < 0
)

SELECT
    market,
    COUNT(DISTINCT product_name) AS loss_making_products,
    ROUND(
        SUM(total_profit),
        2
    ) AS total_loss
FROM loss_products
GROUP BY market
ORDER BY total_loss;


-- ============================================================
-- 6. TOP 10 PRODUCTS WITH THE LARGEST TOTAL LOSSES
-- ============================================================

WITH product_loss AS (
    SELECT
        market,
        category,
        product_name,
        SUM(sales) AS total_sales,
        SUM(profit) AS total_profit
    FROM orders
    GROUP BY market, category, product_name
)

SELECT
    market,
    category,
    product_name,
    ROUND(total_sales, 2) AS total_sales,
    ROUND(total_profit, 2) AS total_profit,
    ROUND(
        total_profit * 100.0
        / NULLIF(total_sales, 0),
        2
    ) AS profit_margin_pct
FROM product_loss
WHERE total_profit < 0
ORDER BY total_profit
LIMIT 10;


-- ============================================================
-- 7. PRODUCT PERFORMANCE BY DISCOUNT
-- ============================================================

WITH product_discount AS (
    SELECT
        category,
        product_name,
        AVG(discount) AS avg_discount,
        SUM(sales) AS total_sales,
        SUM(profit) AS total_profit
    FROM orders
    GROUP BY category, product_name
)

SELECT
    category,
    product_name,
    ROUND(avg_discount * 100.0, 2) AS avg_discount_pct,
    ROUND(total_sales, 2) AS total_sales,
    ROUND(total_profit, 2) AS total_profit,
    ROUND(
        total_profit * 100.0
        / NULLIF(total_sales, 0),
        2
    ) AS profit_margin_pct
FROM product_discount
ORDER BY avg_discount DESC;


-- ============================================================
-- 8. DISCOUNT GROUP ANALYSIS
-- ============================================================

WITH product_discount AS (
    SELECT
        category,
        product_name,
        AVG(discount) AS avg_discount,
        SUM(sales) AS total_sales,
        SUM(profit) AS total_profit
    FROM orders
    GROUP BY category, product_name
),

discount_group AS (
    SELECT
        *,
        CASE
            WHEN avg_discount < 0.10
                THEN 'Low Discount'
            WHEN avg_discount < 0.30
                THEN 'Medium Discount'
            ELSE 'High Discount'
        END AS discount_group
    FROM product_discount
)

SELECT
    discount_group,
    COUNT(*) AS product_count,
    ROUND(SUM(total_sales), 2) AS total_sales,
    ROUND(SUM(total_profit), 2) AS total_profit,
    ROUND(
        SUM(total_profit) * 100.0
        / NULLIF(SUM(total_sales), 0),
        2
    ) AS profit_margin_pct
FROM discount_group
GROUP BY discount_group
ORDER BY
    CASE discount_group
        WHEN 'Low Discount' THEN 1
        WHEN 'Medium Discount' THEN 2
        WHEN 'High Discount' THEN 3
    END;


-- ============================================================
-- 9. DETAILED DISCOUNT BAND ANALYSIS
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
-- 10. DISCOUNT BAND × CATEGORY
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
    COUNT(*) AS row_count,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(
        SUM(profit) * 100.0
        / NULLIF(SUM(sales), 0),
        2
    ) AS profit_margin_pct
FROM discount_band
GROUP BY category, discount_band
ORDER BY
    category,
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
-- 11. EXTREME LOSS-MAKING TRANSACTIONS
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
LIMIT 30;