-- ============================================================
-- SUPERSTORE SALES & PROFITABILITY ANALYSIS
-- 01 - DATA VALIDATION
-- ============================================================


-- ============================================================
-- 1. BASIC DATASET OVERVIEW
-- ============================================================

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT order_id) AS unique_orders,
    COUNT(DISTINCT customer_name) AS unique_customers,
    COUNT(DISTINCT product_name) AS unique_products,
    COUNT(DISTINCT market) AS unique_markets,
    COUNT(DISTINCT category) AS unique_categories,
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date
FROM orders;


-- ============================================================
-- 2. CHECK NULL VALUES
-- ============================================================

SELECT
    COUNT(*) FILTER (WHERE order_id IS NULL) AS null_order_id,
    COUNT(*) FILTER (WHERE order_date IS NULL) AS null_order_date,
    COUNT(*) FILTER (WHERE ship_date IS NULL) AS null_ship_date,
    COUNT(*) FILTER (WHERE ship_mode IS NULL) AS null_ship_mode,
    COUNT(*) FILTER (WHERE customer_name IS NULL) AS null_customer_name,
    COUNT(*) FILTER (WHERE market IS NULL) AS null_market,
    COUNT(*) FILTER (WHERE category IS NULL) AS null_category,
    COUNT(*) FILTER (WHERE product_name IS NULL) AS null_product_name,
    COUNT(*) FILTER (WHERE sales IS NULL) AS null_sales,
    COUNT(*) FILTER (WHERE quantity IS NULL) AS null_quantity,
    COUNT(*) FILTER (WHERE discount IS NULL) AS null_discount,
    COUNT(*) FILTER (WHERE profit IS NULL) AS null_profit
FROM orders;


-- ============================================================
-- 3. CHECK DUPLICATE ROWS
-- ============================================================

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT (
        order_id,
        order_date,
        product_id,
        product_name,
        sales,
        quantity,
        discount,
        profit
    )) AS unique_row_combinations
FROM orders;


-- ============================================================
-- 4. CHECK DUPLICATE ORDER IDs
-- ============================================================

SELECT
    order_id,
    COUNT(*) AS row_count
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1
ORDER BY row_count DESC;


-- ============================================================
-- 5. CHECK NUMERIC VALUE RANGES
-- ============================================================

SELECT
    MIN(sales) AS min_sales,
    MAX(sales) AS max_sales,
    MIN(quantity) AS min_quantity,
    MAX(quantity) AS max_quantity,
    MIN(discount) AS min_discount,
    MAX(discount) AS max_discount,
    MIN(profit) AS min_profit,
    MAX(profit) AS max_profit,
    MIN(shipping_cost) AS min_shipping_cost,
    MAX(shipping_cost) AS max_shipping_cost
FROM orders;


-- ============================================================
-- 6. CHECK INVALID DISCOUNT VALUES
-- Discount should normally be between 0 and 1
-- ============================================================

SELECT *
FROM orders
WHERE discount < 0
   OR discount > 1;


-- ============================================================
-- 7. CHECK INVALID QUANTITY VALUES
-- ============================================================

SELECT *
FROM orders
WHERE quantity <= 0;


-- ============================================================
-- 8. CHECK INVALID SALES VALUES
-- ============================================================

SELECT *
FROM orders
WHERE sales < 0;


-- ============================================================
-- 9. CHECK INVALID ORDER DATE
-- ============================================================

SELECT *
FROM orders
WHERE order_date IS NULL
   OR order_date > CURRENT_DATE;


-- ============================================================
-- 10. CHECK SHIP DATE BEFORE ORDER DATE
-- ============================================================

SELECT *
FROM orders
WHERE ship_date < order_date;


-- ============================================================
-- 11. CHECK CATEGORY VALUES
-- ============================================================

SELECT
    category,
    COUNT(*) AS row_count
FROM orders
GROUP BY category
ORDER BY row_count DESC;


-- ============================================================
-- 12. CHECK MARKET VALUES
-- ============================================================

SELECT
    market,
    COUNT(*) AS row_count
FROM orders
GROUP BY market
ORDER BY row_count DESC;


-- ============================================================
-- 13. CHECK YEAR CONSISTENCY
-- Compare stored year column with order_date
-- ============================================================

SELECT COUNT(*) AS inconsistent_year_rows
FROM orders
WHERE year <> EXTRACT(YEAR FROM order_date);


-- ============================================================
-- 14. FINAL DATA QUALITY SUMMARY
-- ============================================================

SELECT
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (
        WHERE order_id IS NULL
           OR order_date IS NULL
           OR customer_name IS NULL
           OR market IS NULL
           OR category IS NULL
           OR product_name IS NULL
           OR sales IS NULL
           OR quantity IS NULL
           OR discount IS NULL
           OR profit IS NULL
    ) AS rows_with_nulls,

    COUNT(*) FILTER (
        WHERE discount < 0 OR discount > 1
    ) AS invalid_discount_rows,

    COUNT(*) FILTER (
        WHERE quantity <= 0
    ) AS invalid_quantity_rows,

    COUNT(*) FILTER (
        WHERE sales < 0
    ) AS invalid_sales_rows,

    COUNT(*) FILTER (
        WHERE ship_date < order_date
    ) AS invalid_shipping_dates

FROM orders;