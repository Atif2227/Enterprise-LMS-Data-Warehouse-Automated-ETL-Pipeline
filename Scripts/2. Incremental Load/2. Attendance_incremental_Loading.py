import warnings
warnings.filterwarnings("ignore")

import requests
import pandas as pd
import pyodbc
import urllib3
from datetime import datetime

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

# --- Credentials ---
username = "6b3661eb-7413-444c-9ee7-648d0a0915e6"
password = "6b3661eb-7413-444c-9ee7-648d0a0915e6"

# --- SQL Connection ---
conn = pyodbc.connect(
    "DRIVER={ODBC Driver 17 for SQL Server};"
    "SERVER=BRW03WFTATHASD;"
    "DATABASE=WFTD_data_warehouse;"
    "Trusted_Connection=yes;"
)

cursor = conn.cursor()
cursor.fast_executemany = True

# --- API ---
base_url = "https://ne-api.365.systems/odata/v2/Enrollments"
table_name = "Attendances"

# ✅ STEP 1: Get last CreatedAt
cursor.execute(f"SELECT MAX(CreatedAt) FROM {table_name}")
last_date = cursor.fetchone()[0]

if last_date is None:
    print("No data found. Run full load first.")
    exit()

# ✅ Convert to datetime
last_date_dt = datetime.fromisoformat(str(last_date))
last_date_str = last_date_dt.strftime("%Y-%m-%dT%H:%M:%SZ")

print(f"Last CreatedAt: {last_date_str}")

# ✅ ✅ STEP 2: DELETE overlap (important)
cursor.execute(f"""
DELETE FROM {table_name}
WHERE CreatedAt >= ?
""", str(last_date))

conn.commit()

print("✅ Overlapping attendance data removed")

# ✅ STEP 3: FETCH DATA
top = 2000
skip = 0
total_rows = 0

while True:

    url = (
        f"{base_url}?"
        f"$filter=CreatedAt ge {last_date_str}"   # ✅ FIXED
        f"&$expand=Attendances"
        f"&$top={top}&$skip={skip}"
    )

    try:
        response = requests.get(
            url,
            auth=(username, password),
            verify=False,
            timeout=120
        )

        data = response.json().get("value", [])

    except Exception as e:
        print(f"❌ API error: {e}")
        break

    if not data:
        break

    final_rows = []

    for row in data:
        user = row.get("UserLoginName")
        attendances = row.get("Attendances", [])

        for att in attendances:
            new_row = {"UserLoginName": user}

            for k, v in att.items():
                new_row[k] = v

            final_rows.append(new_row)

    if not final_rows:
        skip += top
        continue

    df = pd.DataFrame(final_rows)

    # ✅ Clean data
    df = df.astype(str)
    for col in df.columns:
        df[col] = df[col].str[:4000]

    # ✅ Insert
    cols = ",".join([f"[{c}]" for c in df.columns])
    placeholders = ",".join(["?"] * len(df.columns))

    cursor.executemany(
        f"INSERT INTO {table_name} ({cols}) VALUES ({placeholders})",
        df.values.tolist()
    )

    conn.commit()

    batch_count = len(df)
    total_rows += batch_count
    skip += top

    print(f"Inserted {batch_count} rows... Total new: {total_rows}")

print("✅ Incremental Attendances load complete (NO DUPLICATES)")