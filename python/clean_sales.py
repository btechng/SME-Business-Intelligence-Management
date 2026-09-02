import pandas as pd
from pathlib import Path

RAW = Path("../data/raw/sales_transactions.csv")
OUT = Path("../data/processed/sales_cleaned.csv")

df = pd.read_csv(RAW)

# Standardize text fields
text_cols = ["customer_name", "customer_type", "product", "category"]
for col in text_cols:
    df[col] = df[col].astype(str).str.strip()

# Convert dates and numeric columns
df["date"] = pd.to_datetime(df["date"], errors="coerce")
numeric_cols = ["quantity", "unit_cost", "unit_price", "revenue", "total_cost", "profit"]
for col in numeric_cols:
    df[col] = pd.to_numeric(df[col], errors="coerce")

# Remove impossible/invalid records
df = df.dropna(subset=["transaction_id", "date", "product", "quantity", "revenue"])
df = df[df["quantity"] > 0]
df = df[df["revenue"] >= 0]

# Recalculate financial metrics from source fields
df["revenue"] = (df["quantity"] * df["unit_price"]).round(2)
df["total_cost"] = (df["quantity"] * df["unit_cost"]).round(2)
df["profit"] = (df["revenue"] - df["total_cost"]).round(2)
df["profit_margin_pct"] = ((df["profit"] / df["revenue"]) * 100).round(2)

# Add management-friendly dimensions
df["month"] = df["date"].dt.to_period("M").astype(str)
df["quarter"] = "Q" + df["date"].dt.quarter.astype(str)
df["year"] = df["date"].dt.year

df.to_csv(OUT, index=False)
print(f"Saved {len(df):,} cleaned rows to {OUT}")
