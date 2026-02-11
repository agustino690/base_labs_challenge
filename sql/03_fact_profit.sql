USE anniedb;
GO

IF OBJECT_ID('dbo.fact_sales_profit', 'U') IS NOT NULL DROP TABLE dbo.fact_sales_profit;
GO

CREATE TABLE dbo.fact_sales_profit (
    fact_id               BIGINT IDENTITY(1,1) PRIMARY KEY,
    sale_date             DATE NULL,
    product_id            INT NOT NULL,
    vendor_no             NVARCHAR(50) NULL,
    sales_qty             DECIMAL(18,4) NULL,
    sales_dollars         DECIMAL(18,4) NULL,
    unit_sell_price       DECIMAL(18,4) NULL,
    unit_cost             DECIMAL(18,4) NULL,
    cogs_dollars          DECIMAL(18,4) NULL,
    profit_dollars        DECIMAL(18,4) NULL,
    margin_pct            DECIMAL(18,6) NULL,
    created_ts            DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT fk_fact_product FOREIGN KEY (product_id) REFERENCES dbo.dim_product(product_id)
);
GO

;WITH base AS (
    SELECT
        s.sale_date,
        dp.product_id,
        s.vendor_no,
        s.sales_quantity AS sales_qty,
        s.sales_dollars,
        s.sales_price AS unit_sell_price,
        COALESCE(pp.purchase_price, pp.fallback_price, 0) AS unit_cost
    FROM dbo.stg_sales s
    INNER JOIN dbo.dim_product dp
        ON dp.brand = s.brand
       AND dp.description = s.description
       AND ISNULL(dp.size,'') = ISNULL(s.size,'')
    LEFT JOIN dbo.stg_purchase_prices pp
        ON pp.brand = s.brand
       AND pp.description = s.description
       AND ISNULL(pp.size,'') = ISNULL(s.size,'')
)
INSERT INTO dbo.fact_sales_profit (
    sale_date, product_id, vendor_no, sales_qty, sales_dollars,
    unit_sell_price, unit_cost, cogs_dollars, profit_dollars, margin_pct
)
SELECT
    sale_date,
    product_id,
    vendor_no,
    sales_qty,
    sales_dollars,
    unit_sell_price,
    unit_cost,
    (sales_qty * unit_cost) AS cogs_dollars,
    (sales_dollars - (sales_qty * unit_cost)) AS profit_dollars,
    CASE
        WHEN sales_dollars = 0 THEN NULL
        ELSE (sales_dollars - (sales_qty * unit_cost)) / sales_dollars
    END AS margin_pct
FROM base;
GO

/* Helpful indexes */
CREATE INDEX ix_fact_product_id ON dbo.fact_sales_profit(product_id);
CREATE INDEX ix_fact_sale_date ON dbo.fact_sales_profit(sale_date);
GO
