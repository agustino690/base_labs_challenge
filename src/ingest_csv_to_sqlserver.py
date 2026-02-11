import os
import glob
import pandas as pd
from dotenv import load_dotenv
from sqlalchemy import create_engine, text

load_dotenv()

SQL_CONN_STR = os.getenv("SQL_CONN_STR")
DATA_DIR = os.getenv("DATA_DIR", "./data")

if not SQL_CONN_STR:
    raise ValueError("Missing SQL_CONN_STR in environment (.env).")

engine = create_engine(SQL_CONN_STR, fast_executemany=True)

TABLE_MAP = {
    "sales": "stg_sales",
    "purchases": "stg_purchases",
    "purchase_prices": "stg_purchase_prices",
    "invoice_purchases": "stg_vendor_invoices",
    "vendor_invoices": "stg_vendor_invoices",
    "beginv": "stg_beginning_inventory",
    "beginning_inventory": "stg_beginning_inventory",
    "endinv": "stg_ending_inventory",
    "ending_inventory": "stg_ending_inventory",
}

def normalize_cols(df: pd.DataFrame) -> pd.DataFrame:
    df.columns = (
        df.columns.str.strip()
        .str.lower()
        .str.replace(" ", "_")
        .str.replace(r"[^a-z0-9_]", "", regex=True)
    )
    return df

def detect_table(file_name: str) -> str:
    low = file_name.lower()
    for key, table in TABLE_MAP.items():
        if key in low:
            return table
    raise ValueError(f"Could not map file to staging table: {file_name}")

def truncate_staging_tables():
    tables = [
        "stg_sales",
        "stg_purchases",
        "stg_purchase_prices",
        "stg_vendor_invoices",
        "stg_beginning_inventory",
        "stg_ending_inventory",
    ]
    with engine.begin() as conn:
        for t in tables:
            conn.execute(text(f"IF OBJECT_ID('dbo.{t}','U') IS NOT NULL TRUNCATE TABLE dbo.{t};"))
    print("Staging tables truncated.")

def load_csv_to_stage(file_path: str):
    file_name = os.path.basename(file_path)
    target_table = detect_table(file_name)

    df = pd.read_csv(file_path, encoding="latin1", low_memory=False)
    df = normalize_cols(df).drop_duplicates()

    # best-effort numeric/date conversions (won't fail hard if columns absent)
    for c in ["sales_quantity", "sales_dollars", "sales_price", "purchase_price", "fallback_price",
              "quantity", "dollars", "on_hand_qty", "on_hand_dollars", "volume", "excise_tax"]:
        if c in df.columns:
            df[c] = pd.to_numeric(df[c], errors="coerce")

    for c in ["sale_date", "purchase_date", "invoice_date", "inventory_date"]:
        if c in df.columns:
            df[c] = pd.to_datetime(df[c], errors="coerce").dt.date

    df.to_sql(target_table, engine, schema="dbo", if_exists="append", index=False, chunksize=10000)
    print(f"Loaded {len(df):,} rows -> dbo.{target_table} from {file_name}")

def main():
    files = glob.glob(os.path.join(DATA_DIR, "*.csv"))
    if not files:
        raise RuntimeError(f"No CSV files found in {DATA_DIR}")

    truncate_staging_tables()
    for f in files:
        load_csv_to_stage(f)

    print("Ingestion finished successfully.")

if __name__ == "__main__":
    main()
