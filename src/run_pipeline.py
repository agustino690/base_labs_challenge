import os
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SQL_DIR = ROOT / "sql"

# Optional helper: run ingestion script
def run_ingestion():
    print("Running ingestion...")
    subprocess.run(["python", str(ROOT / "src" / "ingest_csv_to_sqlserver.py")], check=True)

if __name__ == "__main__":
    print("Pipeline helper.")
    print("1) Run SQL scripts manually in order:")
    for f in ["00_create_db.sql", "01_staging_tables.sql", "02_dimensions.sql", "03_fact_profit.sql", "04_reports.sql"]:
        print(f"   - sql/{f}")
    print("2) Run ingestion:")
    print("   python src/ingest_csv_to_sqlserver.py")
