/* anniedb - staging tables */
USE anniedb;
GO

IF OBJECT_ID('dbo.stg_sales', 'U') IS NOT NULL DROP TABLE dbo.stg_sales;
IF OBJECT_ID('dbo.stg_purchases', 'U') IS NOT NULL DROP TABLE dbo.stg_purchases;
IF OBJECT_ID('dbo.stg_purchase_prices', 'U') IS NOT NULL DROP TABLE dbo.stg_purchase_prices;
IF OBJECT_ID('dbo.stg_vendor_invoices', 'U') IS NOT NULL DROP TABLE dbo.stg_vendor_invoices;
IF OBJECT_ID('dbo.stg_beginning_inventory', 'U') IS NOT NULL DROP TABLE dbo.stg_beginning_inventory;
IF OBJECT_ID('dbo.stg_ending_inventory', 'U') IS NOT NULL DROP TABLE dbo.stg_ending_inventory;
GO

/* NOTE:
   CSV column names may vary by file version.
   These tables use flexible columns to avoid ingestion failures.
*/

CREATE TABLE dbo.stg_sales (
    invoice_no            NVARCHAR(100) NULL,
    sale_date             DATE NULL,
    store                 NVARCHAR(100) NULL,
    brand                 NVARCHAR(200) NULL,
    description           NVARCHAR(300) NULL,
    size                  NVARCHAR(50) NULL,
    sales_quantity        DECIMAL(18,4) NULL,
    sales_dollars         DECIMAL(18,4) NULL,
    sales_price           DECIMAL(18,4) NULL,
    volume                DECIMAL(18,4) NULL,
    classification        NVARCHAR(100) NULL,
    excise_tax            DECIMAL(18,4) NULL,
    vendor_no             NVARCHAR(50) NULL,
    vendor_name           NVARCHAR(200) NULL,
    load_ts               DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);

CREATE TABLE dbo.stg_purchase_prices (
    brand                 NVARCHAR(200) NULL,
    description           NVARCHAR(300) NULL,
    size                  NVARCHAR(50) NULL,
    volume                DECIMAL(18,4) NULL,
    classification        NVARCHAR(100) NULL,
    purchase_price        DECIMAL(18,4) NULL,
    fallback_price        DECIMAL(18,4) NULL,
    load_ts               DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);

CREATE TABLE dbo.stg_purchases (
    invoice_no            NVARCHAR(100) NULL,
    purchase_date         DATE NULL,
    vendor_no             NVARCHAR(50) NULL,
    vendor_name           NVARCHAR(200) NULL,
    brand                 NVARCHAR(200) NULL,
    description           NVARCHAR(300) NULL,
    size                  NVARCHAR(50) NULL,
    quantity              DECIMAL(18,4) NULL,
    dollars               DECIMAL(18,4) NULL,
    load_ts               DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);

CREATE TABLE dbo.stg_vendor_invoices (
    invoice_no            NVARCHAR(100) NULL,
    vendor_no             NVARCHAR(50) NULL,
    vendor_name           NVARCHAR(200) NULL,
    invoice_date          DATE NULL,
    dollars               DECIMAL(18,4) NULL,
    load_ts               DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);

CREATE TABLE dbo.stg_beginning_inventory (
    inventory_date        DATE NULL,
    store                 NVARCHAR(100) NULL,
    brand                 NVARCHAR(200) NULL,
    description           NVARCHAR(300) NULL,
    size                  NVARCHAR(50) NULL,
    on_hand_qty           DECIMAL(18,4) NULL,
    on_hand_dollars       DECIMAL(18,4) NULL,
    load_ts               DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);

CREATE TABLE dbo.stg_ending_inventory (
    inventory_date        DATE NULL,
    store                 NVARCHAR(100) NULL,
    brand                 NVARCHAR(200) NULL,
    description           NVARCHAR(300) NULL,
    size                  NVARCHAR(50) NULL,
    on_hand_qty           DECIMAL(18,4) NULL,
    on_hand_dollars       DECIMAL(18,4) NULL,
    load_ts               DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);
GO
