# Data & Analytics Case Study

## 1) Objective

This challenge analyzes wholesale business to understand **profitability** at product and brand level.

Using the case-study CSV files, the solution:

1. Ingests data into a **relational SQL database**.
2. Transforms data to calculate:
   - **Profit ($)**
   - **Margin (%)**
3. Produces reporting outputs:
   - Top 10 products by profit and margin
   - Top 10 brands by profit and margin
   - Products/brands that are losing money (drop candidates)

Data source: PwC case-study files page  
https://www.pwc.com/us/en/careers/university-relations/data-and-analytics-case-studies-files.html

---

## 2) Tech Stack

- **Python 3.12**
- **SQL Server** (relational database)
- **SQLAlchemy + pyodbc** for ingestion
- **Pandas** for CSV loading
- **VS Code** as development environment
- **Git/GitHub** for version control

---

## 3) Repository Structure

```text
base_labs_challenge/
├─ README.md
├─ requirements.txt
├─ .gitignore
├─ sql/
│  ├─ 00_create_db.sql
│  ├─ 01_staging_tables.sql
│  ├─ 02_dimensions.sql
│  ├─ 03_fact_profit.sql
│  └─ 04_reports.sql
├─ src/
│  ├─ ingest_csv_to_sqlserver.py
│  └─ run_pipeline.py
└─ docs/
   └─ assumptions.md
