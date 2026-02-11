USE anniedb;
GO

/* 1) Top 10 products by Profit ($) */
SELECT TOP 10
    dp.brand,
    dp.description,
    SUM(f.sales_dollars) AS revenue,
    SUM(f.cogs_dollars) AS cogs,
    SUM(f.profit_dollars) AS profit_dollars,
    CASE WHEN SUM(f.sales_dollars)=0 THEN NULL
         ELSE SUM(f.profit_dollars) / SUM(f.sales_dollars) END AS margin_pct
FROM dbo.fact_sales_profit f
JOIN dbo.dim_product dp ON dp.product_id = f.product_id
GROUP BY dp.brand, dp.description
ORDER BY profit_dollars DESC;
GO

/* 1b) Top 10 products by Margin (%) with minimum revenue filter */
SELECT TOP 10
    dp.brand,
    dp.description,
    SUM(f.sales_dollars) AS revenue,
    SUM(f.profit_dollars) AS profit_dollars,
    CASE WHEN SUM(f.sales_dollars)=0 THEN NULL
         ELSE SUM(f.profit_dollars) / SUM(f.sales_dollars) END AS margin_pct
FROM dbo.fact_sales_profit f
JOIN dbo.dim_product dp ON dp.product_id = f.product_id
GROUP BY dp.brand, dp.description
HAVING SUM(f.sales_dollars) >= 1000
ORDER BY margin_pct DESC;
GO

/* 2) Top 10 brands by Profit ($) */
SELECT TOP 10
    dp.brand,
    SUM(f.sales_dollars) AS revenue,
    SUM(f.cogs_dollars) AS cogs,
    SUM(f.profit_dollars) AS profit_dollars,
    CASE WHEN SUM(f.sales_dollars)=0 THEN NULL
         ELSE SUM(f.profit_dollars) / SUM(f.sales_dollars) END AS margin_pct
FROM dbo.fact_sales_profit f
JOIN dbo.dim_product dp ON dp.product_id = f.product_id
GROUP BY dp.brand
ORDER BY profit_dollars DESC;
GO

/* 2b) Top 10 brands by Margin (%) with minimum revenue filter */
SELECT TOP 10
    dp.brand,
    SUM(f.sales_dollars) AS revenue,
    SUM(f.profit_dollars) AS profit_dollars,
    CASE WHEN SUM(f.sales_dollars)=0 THEN NULL
         ELSE SUM(f.profit_dollars) / SUM(f.sales_dollars) END AS margin_pct
FROM dbo.fact_sales_profit f
JOIN dbo.dim_product dp ON dp.product_id = f.product_id
GROUP BY dp.brand
HAVING SUM(f.sales_dollars) >= 5000
ORDER BY margin_pct DESC;
GO

/* 3) Drop candidates: products and brands with negative total profit */
SELECT
    'PRODUCT' AS level_type,
    dp.brand,
    dp.description,
    SUM(f.sales_dollars) AS revenue,
    SUM(f.profit_dollars) AS profit_dollars,
    CASE WHEN SUM(f.sales_dollars)=0 THEN NULL
         ELSE SUM(f.profit_dollars) / SUM(f.sales_dollars) END AS margin_pct
FROM dbo.fact_sales_profit f
JOIN dbo.dim_product dp ON dp.product_id = f.product_id
GROUP BY dp.brand, dp.description
HAVING SUM(f.profit_dollars) < 0

UNION ALL

SELECT
    'BRAND' AS level_type,
    dp.brand,
    NULL AS description,
    SUM(f.sales_dollars) AS revenue,
    SUM(f.profit_dollars) AS profit_dollars,
    CASE WHEN SUM(f.sales_dollars)=0 THEN NULL
         ELSE SUM(f.profit_dollars) / SUM(f.sales_dollars) END AS margin_pct
FROM dbo.fact_sales_profit f
JOIN dbo.dim_product dp ON dp.product_id = f.product_id
GROUP BY dp.brand
HAVING SUM(f.profit_dollars) < 0
ORDER BY level_type, profit_dollars ASC;
GO
