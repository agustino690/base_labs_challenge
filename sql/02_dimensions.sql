USE anniedb;
GO

IF OBJECT_ID('dbo.dim_product', 'U') IS NOT NULL DROP TABLE dbo.dim_product;
GO

CREATE TABLE dbo.dim_product (
    product_id            INT IDENTITY(1,1) PRIMARY KEY,
    brand                 NVARCHAR(200) NOT NULL,
    description           NVARCHAR(300) NOT NULL,
    size                  NVARCHAR(50) NULL,
    classification        NVARCHAR(100) NULL,
    created_ts            DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT uq_dim_product UNIQUE (brand, description, size)
);

INSERT INTO dbo.dim_product (brand, description, size, classification)
SELECT DISTINCT
    s.brand,
    s.description,
    s.size,
    s.classification
FROM dbo.stg_sales s
WHERE s.brand IS NOT NULL
  AND s.description IS NOT NULL;
GO
