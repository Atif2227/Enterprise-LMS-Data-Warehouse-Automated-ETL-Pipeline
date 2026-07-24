import requests
import pandas as pd
import pyodbc
import urllib3
import warnings

warnings.filterwarnings("ignore")
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

# ✅ Expand Rating + Publishing
base_url = "https://api.365.systems/odata/v2/Courses?$expand=Rating,Publishing"

table_name = "Courses"

top = 5000
skip = 0
first_batch = True

while True:
    url = f"{base_url}&$top={top}&$skip={skip}"

    try:
        response = requests.get(
            url,
            auth=(username, password),
            verify=False,
            timeout=120   # ✅ prevent hanging
        )

        data = response.json().get("value", [])

    except Exception as e:
        print(f"❌ API error: {e}")
        break

    if not data:
        break

    final_rows = []

    for row in data:
        course = row.copy()

        rating = course.pop("Rating", {})
        publishing = course.pop("Publishing", None)

        new_row = {}

        # ✅ Course fields
        for k, v in course.items():
            new_row[k] = v

        # ✅ Rating expand
        if isinstance(rating, dict):
            for k, v in rating.items():
                new_row[f"Rating_{k}"] = v

        # ✅ Publishing expand
        if isinstance(publishing, dict):
            # ✅ already structured
            for k, v in publishing.items():
                new_row[f"Publishing_{k}"] = v

        elif isinstance(publishing, str):
            # ✅ it's a link → fetch details (slow part)
            try:
                pub_resp = requests.get(
                    publishing,
                    auth=(username, password),
                    verify=False,
                    timeout=30
                )

                pub_data = pub_resp.json()

                if isinstance(pub_data, dict):
                    for k, v in pub_data.items():
                        new_row[f"Publishing_{k}"] = v

            except:
                # ✅ silently skip if fails
                pass

        # ✅ append row
        final_rows.append(new_row)

    df = pd.DataFrame(final_rows)

    # ✅ Clean data
    df = df.astype(str)
    for col in df.columns:
        df[col] = df[col].str[:4000]

    # ✅ Create table first time
    if first_batch:
        cols = [f"[{col}] NVARCHAR(MAX)" for col in df.columns]

        cursor.execute(f"""
        IF OBJECT_ID('{table_name}', 'U') IS NOT NULL
            DROP TABLE {table_name};

        CREATE TABLE {table_name} (
            {', '.join(cols)}
        )
        """)
        conn.commit()
        first_batch = False

    # ✅ Insert data
    cols = ",".join([f"[{c}]" for c in df.columns])
    placeholders = ",".join(["?"] * len(df.columns))

    cursor.executemany(
        f"INSERT INTO {table_name} ({cols}) VALUES ({placeholders})",
        df.values.tolist()
    )
    conn.commit()

    skip += top
    print(f"Inserted {len(df)} rows... skip={skip}")

print("✅ Courses with Rating + Publishing loaded")