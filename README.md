# Superstore Sales & Profitability Analysis

An end-to-end **Data Analytics & Business Intelligence project** analyzing Superstore sales, profitability, market performance, product performance, discount impact, and loss-making products using **PostgreSQL, SQL, DAX, and Power BI**.

The project transforms transactional sales data into an interactive Power BI dashboard that supports both **high-level business monitoring and detailed product-level investigation**.

---

## 📌 Project Overview

Superstore experienced consistent sales and profit growth between 2011 and 2014. However, the analysis reveals that revenue growth alone does not fully represent business performance.

Profitability varies significantly across:

* Markets
* Product categories
* Products
* Discount levels
* Return behavior

The analysis therefore focuses on identifying **where revenue is generated, where profit is created, and where profitability is being lost**.

---

## 🎯 Business Objectives

This project aims to answer the following business questions:

1. How did sales and profit perform over time?
2. Which markets contribute the most to sales and profitability?
3. Which market-category combinations perform best?
4. How does discounting affect profitability?
5. Which products generate the largest losses?
6. Which markets have the highest proportion of loss-making products?
7. Which categories show stronger or weaker profitability?
8. How do returns relate to category performance?
9. What actions could improve sustainable profitability?

---

# 🗃️ Dataset

The project uses the **Superstore transactional dataset** covering the period **2011–2014**.

### Dataset Summary

| Metric                |  Value |
| --------------------- | -----: |
| Transactions          | 51,290 |
| Unique Orders         | 25,035 |
| Unique Customers      |    795 |
| Unique Products       |  3,788 |
| Markets               |      7 |
| Categories            |      3 |
| Total Sales           | $7.84M |
| Total Profit          | $1.47M |
| Overall Profit Margin | 18.74% |

### Product Categories

* Furniture
* Office Supplies
* Technology

### Markets

* Africa
* APAC
* Canada
* EMEA
* EU
* LATAM
* US

---

# 🛠️ Tools & Technologies

| Tool       | Purpose                                     |
| ---------- | ------------------------------------------- |
| PostgreSQL | Data querying and analysis                  |
| SQL        | Data validation and exploratory analysis    |
| Power BI   | Interactive dashboard and visualization     |
| DAX        | KPIs and dynamic business insights          |
| GitHub     | Version control and portfolio documentation |

---

# 🔄 Analytical Workflow

```text
Raw Transactional Data
        ↓
Data Validation
        ↓
Exploratory Data Analysis
        ↓
Business & Profitability Analysis
        ↓
Power BI Data Modeling
        ↓
Interactive Dashboard
        ↓
Dynamic Business Insights
        ↓
Drill-Through Investigation
        ↓
Business Recommendations
```

---

# 📂 Project Structure

```text
superstore-sales-profitability-analysis/
│
├── README.md
│
├── sql/
│   ├── 01_data_validation.sql
│   ├── 02_eda_sales_profitability.sql
│   ├── 03_eda_market_category.sql
│   ├── 04_eda_product_discount.sql
│   └── 05_final_analysis.sql
│
├── powerbi/
│   └── Superstore_Sales_Profitability.pbix
│
└── screenshots/
    ├── executive_overview.png
    ├── executive_overview_filter_year_market.png
    ├── executive_overview_filter_year_category.png
    ├── tooltip_discount.png
    ├── tooltip_loss_making.png
    ├── tooltip_market.png
    └── drillthrough_product_detail.png
└── docummentation/
    └── business_insights
```

---

# 🧹 1. Data Validation

The first SQL stage validates the quality and consistency of the dataset before analysis.

### Validation includes:

* Total row count
* Duplicate checking
* NULL value checking
* Date range validation
* Unique order validation
* Unique customer validation
* Unique product validation
* Market validation
* Category validation
* Numeric field validation

The purpose of this stage is to ensure that the dataset is sufficiently reliable before performing business analysis.

SQL implementation:

```text
sql/01_data_validation.sql
```

---

# 📊 2. EDA — Sales & Profitability

The second analysis stage focuses on overall business performance.

### Analysis includes:

* Annual sales
* Annual profit
* Year-over-Year sales growth
* Profit margin
* Sales and profit trends

### Annual Performance

| Year |  Sales |   Profit | YoY Sales Growth | Profit Margin |
| ---- | -----: | -------: | ---------------: | ------------: |
| 2011 | $1.38M | $248.94K |                — |        18.05% |
| 2012 | $1.68M | $307.42K |           22.01% |        18.27% |
| 2013 | $2.11M | $408.51K |           25.31% |        19.38% |
| 2014 | $2.67M | $504.17K |           26.65% |        18.88% |

### Key Finding

Sales increased from approximately **$1.38M in 2011 to $2.67M in 2014**, while profit increased from approximately **$248.94K to $504.17K**.

This indicates strong and consistent business growth.

SQL implementation:

```text
sql/02_eda_sales_profitability.sql
```

---

# 🌎 3. EDA — Market & Category Analysis

The third analysis stage evaluates performance across markets and product categories.

### Market Analysis

| Market |    Sales | Profit Margin | Sales Contribution |
| ------ | -------: | ------------: | -----------------: |
| APAC   |   $2.00M |        21.85% |             25.54% |
| EU     |   $1.80M |        20.66% |             23.01% |
| LATAM  |   $1.56M |        14.17% |             19.95% |
| US     |   $1.31M |        21.94% |             16.65% |
| EMEA   | $575.79K |         7.62% |              7.34% |
| Africa | $538.36K |        16.51% |              6.87% |
| Canada |  $50.33K |        35.40% |              0.64% |

### Key Findings

* **APAC** is the largest market by sales contribution.
* **EU** is the second-largest contributor.
* **EMEA** has relatively weak profitability.
* **Canada** has the highest profit margin but contributes only a small portion of total sales.

---

## Category Performance

| Category        |   Sales |    Profit | Profit Margin |
| --------------- | ------: | --------: | ------------: |
| Furniture       | ~$2.41M | ~$286.78K |        11.90% |
| Office Supplies | ~$2.79M | ~$518.47K |        18.57% |
| Technology      | ~$2.64M | ~$663.78K |        25.10% |

### Key Finding

**Technology** has the strongest profitability with an approximately **25.10% profit margin**.

Furniture has the lowest category profit margin at approximately **11.90%**.

---

## Market × Category Analysis

The analysis also compares profitability across combinations of:

> **Market × Category**

This reveals that the same category can perform very differently across markets.

For example, Technology shows:

* Canada: **42.32%**
* US: **38.09%**
* APAC: **28.19%**
* EU: **24.06%**
* LATAM: **18.58%**
* EMEA: **9.00%**

This indicates that market-specific conditions can have a significant impact on category profitability.

SQL implementation:

```text
sql/03_eda_market_category.sql
```

---

# 📦 4. EDA — Product & Discount Analysis

The fourth SQL stage focuses on product-level profitability and the relationship between discount and profit.

### Product Analysis

The analysis identifies:

* Highest-sales products
* Most profitable products
* Loss-making products
* Product profit margins
* Product performance by category

Several products generate significant negative profit despite having sales.

Examples include:

* Cubify CubeX 3D Printer Double Head Print
* Lexmark MX611dhe Monochrome Laser Printer
* Cubify CubeX 3D Printer Triple Head Print
* Motorola Smart Phone, Cordless
* Samsung Smart Phone, Cordless
* Apple Smart Phone, Full Size

---

# 💸 Discount Analysis

One of the strongest findings from the analysis is the relationship between discount and profitability.

| Discount Band |    Sales |    Profit | Profit Margin |
| ------------- | -------: | --------: | ------------: |
| 0%            |   $4.28M |    $1.77M |        41.36% |
| 1–10%         |   $1.11M |  $339.77K |        30.50% |
| 11–20%        |   $1.05M |  $173.25K |        16.53% |
| 21–30%        | $243.10K |  -$21.16K |        -8.70% |
| 31–40%        | $503.46K | -$166.12K |       -33.00% |
| 41–50%        | $345.90K | -$214.83K |       -62.11% |
| 51–60%        | $168.94K | -$173.42K |      -102.65% |
| 61–70%        | $121.92K | -$197.48K |      -161.97% |
| >70%          |  $13.30K |  -$41.68K |      -313.47% |

### Key Finding

Profitability declines sharply as discount increases.

The calculated profit margin becomes negative starting from the **21–30% discount band**.

This suggests that aggressive discounting can significantly erode profitability.

SQL implementation:

```text
sql/04_eda_product_discount.sql
```

---

# 🔎 5. Final Analysis

The final analysis consolidates the most important business issues identified throughout the EDA process.

The analysis focuses on:

* Loss-making products
* Loss-making products by market
* Percentage of loss-making products
* Total loss by market
* Loss-making transactions
* High-loss products
* Discount impact on loss-making transactions

SQL implementation:

```text
sql/05_final_analysis.sql
```

---

# ⚠️ Loss-Making Products

The proportion of loss-making products varies considerably across markets.

| Market | Loss-Making Products | Loss-Making % |
| ------ | -------------------: | ------------: |
| EMEA   |                  586 |        35.62% |
| APAC   |                  573 |        29.95% |
| LATAM  |                  512 |        27.39% |
| Africa |                  420 |        26.14% |
| EU     |                  411 |        22.14% |
| US     |                  299 |        16.24% |
| Canada |                    0 |         0.00% |

### Key Finding

EMEA has the highest proportion of loss-making products at **35.62%**.

APAC generates the largest total loss from loss-making products at approximately **-$114.91K**.

This demonstrates that strong overall market performance can still contain significant product-level profitability issues.

---

# 💡 Key Findings

The main findings from the complete analysis are:

### 1. Strong Revenue Growth

Sales increased consistently from **$1.38M in 2011 to $2.67M in 2014**.

### 2. APAC Leads Sales Contribution

APAC contributes approximately **25.54%** of total sales.

### 3. Technology Is the Most Profitable Category

Technology achieves approximately **25.10% profit margin**.

### 4. Discount Has a Strong Negative Relationship with Profitability

Profit margin decreases from **41.36% at 0% discount** to **-313.47% at discounts above 70%**.

### 5. High-Discount Transactions Can Generate Significant Losses

Profitability becomes negative starting around the **21–30% discount range**.

### 6. Loss-Making Products Exist Even Within Profitable Categories

Technology is the most profitable category overall, but several Technology products generate substantial losses.

### 7. EMEA Has the Highest Proportion of Loss-Making Products

Approximately **35.62%** of products in EMEA generate negative profit.

### 8. Furniture Requires Further Investigation

Furniture has the lowest overall profit margin and the highest return rate.

---

# 📖 Business Story

Superstore demonstrates strong and consistent revenue growth between 2011 and 2014. However, the analysis shows that revenue growth alone does not fully represent business health.

The largest profitability concern is associated with high discount levels. As discounts increase, profit margins decline significantly and become negative at higher discount levels.

At the same time, product-level analysis reveals that individual products can generate substantial losses even within profitable categories such as Technology.

Market performance also varies considerably. APAC and EU contribute the largest shares of revenue, while EMEA shows relatively weak profitability and a high proportion of loss-making products.

Furniture presents another area requiring attention because it combines the lowest category-level profit margin with the highest return rate.

Overall, the business has a strong growth foundation, but future growth should focus on **profitable and sustainable growth rather than sales growth alone**.

---

# 🎯 Business Recommendations

## 1. Establish Discount Governance

Review discount policies, particularly discounts above **20%**.

Discount decisions should consider:

* Product margin
* Category
* Market
* Shipping cost
* Customer segment
* Expected sales volume

---

## 2. Investigate Loss-Making Products

Conduct a detailed review of consistently loss-making products.

Potential actions include:

* Repricing
* Reducing excessive discounts
* Reviewing shipping costs
* Negotiating supplier costs
* Reviewing product positioning
* Discontinuing products only after further investigation

---

## 3. Prioritize Profitable Categories

Technology demonstrates the strongest profitability.

The company should prioritize profitable Technology products while continuing to monitor product-level exceptions.

---

## 4. Develop Market-Specific Strategies

APAC and EU should remain important growth markets due to their combination of high sales contribution and healthy profitability.

EMEA requires additional investigation due to its low profit margin and high proportion of loss-making products.

---

## 5. Investigate Furniture Returns

Furniture combines:

> **Lowest Category Profit Margin + Highest Return Rate**

Management should investigate potential causes such as:

* Product quality
* Shipping damage
* Product expectations
* Product descriptions
* Product mix

---

# 📊 Power BI Dashboard

The SQL analysis was transformed into an interactive Power BI dashboard.

The dashboard contains:

* KPI cards
* Sales & Profit trend
* Market performance
* Category performance
* Discount profitability analysis
* Loss-making product analysis
* Return rate analysis
* Dynamic business insights
* Interactive slicers
* Custom tooltips
* Product drill-through

---

# 🖥️ Dashboard Screenshots

## Executive Overview — Unfiltered

The main Executive Overview provides a complete high-level view of business performance without applying additional filters.

![Executive Overview](screenshots/executive_overview.png)

---

## Executive Overview — Year & Market Filter

The dashboard supports dynamic filtering by **Year and Market**.

![Executive Overview Year Market Filter](screenshots/executive_overview_filter_year_market.png)

When filters are applied, the KPIs, charts, and business insights update according to the selected context.

---

## Executive Overview — Year & Category Filter

The dashboard can also be filtered by **Year and Category**.

![Executive Overview Year Category Filter](screenshots/executive_overview_filter_year_category.png)

This allows users to investigate category-specific performance over a selected period.

---

# 💬 Interactive Tooltips

Custom report-page tooltips were created to provide additional context without overcrowding the main dashboard.

## Market Tooltip

The Market tooltip provides additional information about the selected market.

![Market Tooltip](screenshots/Tooltip_market.png)

---

## Discount Tooltip

The Discount tooltip provides additional information about profitability at different discount levels.

![Discount Tooltip](screenshots/tooltip_discount.png)

---

## Loss-Making Tooltip

The Loss-Making tooltip provides additional context about loss-making product performance.

![Loss-Making Tooltip](screenshots/tooltip_loss_making.png)

---

# 🔎 Product Detail Drill-Through

The dashboard includes a **Product Detail Drill-Through** page.

Users can select a product from the main dashboard and navigate to a dedicated product-level analysis page.

![Product Detail Drill Through](screenshots/drillthrough_product_detail.png)

The drill-through page allows deeper investigation of:

* Product performance
* Sales
* Profit
* Profit Margin
* Discount
* Market
* Category
* Loss-making transactions

This creates a clear analytical workflow:

```text
Executive Overview
       ↓
Identify Business Issue
       ↓
Select Product
       ↓
Drill Through
       ↓
Product Detail
       ↓
Investigate Root Cause
```

---

# 📌 Dynamic Business Insights

The Power BI dashboard also contains dynamic text generated using DAX.

The **Key Findings**, **Business Story**, and **Recommendations** respond to the current filter context.

For example:

```text
Year = 2014
Market = APAC
Category = Technology
```

will produce insights based specifically on that filtered context.

This allows the dashboard to move beyond static reporting toward an interactive **decision-support tool**.

---

# 🧠 Skills Demonstrated

## SQL

* CTE
* `GROUP BY`
* Aggregation
* `SUM()`
* `AVG()`
* `COUNT()`
* `COUNT(DISTINCT)`
* Window functions
* `LAG()`
* `NULLIF()`
* Conditional filtering
* Profit margin calculations
* Business-oriented analytical queries

## Power BI

* Data modeling
* Relationships
* KPI cards
* Interactive charts
* Slicers
* Cross-filtering
* Report-page tooltips
* Drill-through
* Dashboard layout
* Dynamic text

## DAX

* Measures
* `CALCULATE()`
* `SUMX()`
* `DIVIDE()`
* `SELECTEDVALUE()`
* Filter context
* Dynamic KPIs
* Dynamic key findings
* Dynamic business story
* Dynamic recommendations

## Business Analytics

* Sales trend analysis
* Profitability analysis
* Market analysis
* Category analysis
* Product analysis
* Discount analysis
* Loss-making product analysis
* Return analysis
* Business storytelling
* Data-driven recommendations

---

# ⚠️ Analytical Limitations

The analysis identifies patterns and relationships within the dataset but does not establish causality.

For example, the relationship between discount and negative profitability does not necessarily mean that discounting alone caused every loss.

Other factors may include:

* Product cost
* Shipping cost
* Product mix
* Market conditions
* Customer segment
* Transaction characteristics
* Data quality

Some extreme product-level profit values should therefore be investigated further before making major business decisions.

---

# 🚀 Future Improvements

Potential future improvements include:

* Customer segmentation
* Customer Lifetime Value analysis
* Sales forecasting
* Profit forecasting
* Return prediction
* Product profitability scoring
* Market profitability forecasting
* Automated data refresh
* Anomaly detection
* Statistical analysis of discount impact
* Predictive modeling for loss-making transactions

---

# 📁 Repository Contents

### SQL

The `sql/` folder contains the complete analytical workflow:

```text
01_data_validation.sql
02_eda_sales_profitability.sql
03_eda_market_category.sql
04_eda_product_discount.sql
05_final_analysis.sql
```

### Power BI

The `powerbi/` folder contains the final interactive dashboard:

```text
superstore_sales_profitability.pbix
```

### Screenshots

The `screenshots/` folder contains evidence of:

* Executive Overview
* Filter interactions
* Custom tooltips
* Product drill-through

---

# 👤 Author

**Iklina Najzil Muhsinina**

Information Systems Student — Universitas Jember

### Interests

* Data Analytics
* Business Intelligence
* Business Analysis
* Data-driven Decision Making
* Artificial Intelligence

---

# ⭐ Project Takeaway

> **Strong revenue growth is valuable, but sustainable business performance requires understanding not only where revenue comes from, but also where profit is created and where profitability is lost.**

This project demonstrates how **SQL + Power BI + DAX** can be combined to transform transactional data into actionable business insights and decision-support tools.
