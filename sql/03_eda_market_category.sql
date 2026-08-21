-- ============================================================
-- SUPERSTORE SALES & PROFITABILITY ANALYSIS
-- 03 - EDA MARKET & CATEGORY
-- ============================================================


-- ============================================================
-- 1. MARKET PERFORMANCE
-- Sales, Profit, Profit Margin, and Sales Contribution
-- ============================================================

WITH market_sales AS (
    SELECT
        market,
        SUM(sales) AS total_sales,
        SUM(profit) AS total_profit
    FROM orders
    GROUP BY market
),

market_performance AS (
    SELECT
        market,
        total_sales,
        total_profit,
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
    FROM market_sales
)

SELECT
    market,
    total_sales,
    total_profit,
    profit_margin_pct,
    sales_contribution_pct
FROM market_performance
ORDER BY total_sales DESC;


-- ============================================================
-- 2. CATEGORY PERFORMANCE
-- Sales, Profit, and Profit Margin
-- ============================================================

SELECT
    category,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    ROUND(
        SUM(profit) * 100.0
        / NULLIF(SUM(sales), 0),
        2
    ) AS profit_margin_pct
FROM orders
GROUP BY category
ORDER BY total_profit DESC;


-- ============================================================
-- 3. MARKET × CATEGORY PROFITABILITY
-- ============================================================

WITH market_category AS (
    SELECT
        market,
        category,
        SUM(sales) AS total_sales,
        SUM(profit) AS total_profit
    FROM orders
    GROUP BY market, category
)

SELECT
    market,
    category,
    total_sales,
    total_profit,
    ROUND(
        total_profit * 100.0
        / NULLIF(total_sales, 0),
        2
    ) AS profit_margin_pct
FROM market_category
ORDER BY market, profit_margin_pct DESC;


-- ============================================================
-- 4. MARKET × CATEGORY DISCOUNT & PROFITABILITY
-- ============================================================

WITH market_category AS (
    SELECT
        market,
        category,
        AVG(discount) AS avg_discount,
        SUM(sales) AS total_sales,
        SUM(profit) AS total_profit
    FROM orders
    GROUP BY market, category
)

SELECT
    market,
    category,
    ROUND(avg_discount * 100.0, 2) AS avg_discount_pct,
    total_sales,
    total_profit,
    ROUND(
        total_profit * 100.0
        / NULLIF(total_sales, 0),
        2
    ) AS profit_margin_pct
FROM market_category
ORDER BY market, avg_discount_pct DESC;


-- ============================================================
-- 5. MARKETS WITH BELOW-AVERAGE PROFIT MARGIN
-- ============================================================

WITH market_performance AS (
    SELECT
        market,
        SUM(sales) AS total_sales,
        SUM(profit) AS total_profit,
        SUM(profit) * 100.0
        / NULLIF(SUM(sales), 0) AS profit_margin_pct
    FROM orders
    GROUP BY market
)

SELECT
    market,
    total_sales,
    total_profit,
    ROUND(profit_margin_pct, 2) AS profit_margin_pct
FROM market_performance
WHERE profit_margin_pct < (
    SELECT AVG(profit_margin_pct)
    FROM market_performance
)
ORDER BY total_sales DESC;


-- ============================================================
-- 6. MARKET × CATEGORY: HIGHEST PROFIT CATEGORY
-- ============================================================

WITH market_category AS (
    SELECT
        market,
        category,
        SUM(profit) AS total_profit
    FROM orders
    GROUP BY market, category
),

category_rank AS (
    SELECT
        market,
        category,
        total_profit,
        DENSE_RANK() OVER (
            PARTITION BY market
            ORDER BY total_profit DESC
        ) AS rank_category
    FROM market_category
)

SELECT
    market,
    category,
    total_profit
FROM category_rank
WHERE rank_category = 1
ORDER BY market;


-- ============================================================
-- 7. MARKET × CATEGORY: LOWEST PROFIT MARGIN
-- ============================================================

WITH market_category AS (
    SELECT
        market,
        category,
        SUM(sales) AS total_sales,
        SUM(profit) AS total_profit
    FROM orders
    GROUP BY market, category
),

category_margin AS (
    SELECT
        market,
        category,
        total_sales,
        total_profit,
        total_profit * 100.0
        / NULLIF(total_sales, 0) AS profit_margin_pct
    FROM market_category
),

category_rank AS (
    SELECT
        *,
        DENSE_RANK() OVER (
            PARTITION BY market
            ORDER BY profit_margin_pct
        ) AS rank_lowest_margin
    FROM category_margin
)

SELECT
    market,
    category,
    total_sales,
    total_profit,
    ROUND(profit_margin_pct, 2) AS profit_margin_pct
FROM category_rank
WHERE rank_lowest_margin = 1
ORDER BY market;