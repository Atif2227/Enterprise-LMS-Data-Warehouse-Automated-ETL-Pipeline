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

base_url = "https://api.365.systems/odata/v2/Enrollments/IncludeDeletedUsers()"
table_name = "Enrollments"

# ✅ STEP 1: Get last CreatedAt
cursor.execute(f"SELECT MAX(CreatedAt) FROM {table_name}")
result = cursor.fetchone()[0]

if result is None:
    print("No data found. Run full load first.")
    exit()

# ✅ Convert to ISO format
last_date_dt = datetime.fromisoformat(str(result))
last_date = last_date_dt.strftime("%Y-%m-%dT%H:%M:%SZ")

print(f"Last CreatedAt: {last_date}")

# ✅ STEP 2: Delete overlap to prevent duplicates
cursor.execute(f"""
DELETE FROM {table_name}
WHERE CreatedAt >= ?
""", str(result))

conn.commit()

print("✅ Overlapping data removed")

# ✅ STEP 3: Fetch incremental data
top = 5000
skip = 0
total_rows = 0

while True:

    url = (
        f"{base_url}?"
        f"$filter=CreatedAt ge {last_date}"
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

    # ✅ Expand Roles INCLUDING blank roles
    for row in data:

        roles = row.get("Roles")

        # ✅ Case 1: Roles is list
        if isinstance(roles, list):

            # ✅ Empty list → preserve enrollment row
            if len(roles) == 0:
                new_row = row.copy()
                new_row["Role"] = None
                final_rows.append(new_row)

            else:
                for r in roles:
                    new_row = row.copy()

                    if isinstance(r, dict):
                        new_row["Role"] = r.get("Name")
                    else:
                        new_row["Role"] = r

                    final_rows.append(new_row)

        # ✅ Case 2: Roles is object
        elif isinstance(roles, dict):

            new_row = row.copy()
            new_row["Role"] = roles.get("Name")
            final_rows.append(new_row)

        # ✅ Case 3: Roles is None/string
        else:

            new_row = row.copy()
            new_row["Role"] = roles
            final_rows.append(new_row)

    df = pd.DataFrame(final_rows)

    # ✅ Remove original Roles column
    if "Roles" in df.columns:
        df = df.drop(columns=["Roles"])

    # ✅ Preserve NULL properly
    df = df.where(pd.notnull(df), None)

    # ✅ Safe conversion
    for col in df.columns:
        df[col] = df[col].apply(
            lambda x: str(x)[:4000] if x is not None else None
        )

    # ✅ Insert into SQL
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

print("✅ Incremental load complete (NO DUPLICATES)")