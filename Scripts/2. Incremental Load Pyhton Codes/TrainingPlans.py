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

# ✅ EXPAND COURSES
base_url = "https://api.365.systems/odata/v2/TrainingPlans?$expand=Courses"

table_name = "TrainingPlans"

top = 1000
skip = 0
first_batch = True

while True:
    url = f"{base_url}&$top={top}&$skip={skip}"

    response = requests.get(
        url,
        auth=(username, password),
        verify=False
    )

    data = response.json().get("value", [])

    if not data:
        break

    final_rows = []

    for row in data:
        plan = row.copy()
        courses = plan.pop("Courses", [])

        # flatten
        for c in courses:
            new_row = {}

            # TrainingPlan fields
            new_row["TrainingPlanId"] = plan.get("Id")
            new_row["TrainingPlanTitle"] = plan.get("Title")
            new_row["CourseCatalogId"] = plan.get("CourseCatalogId")

            new_row["TrainingPlanCreatedAt"] = plan.get("CreatedAt")
            new_row["TrainingPlanModifiedAt"] = plan.get("ModifiedAt")

            # Course fields
            for k, v in c.items():
                new_row[f"Course_{k}"] = v

            final_rows.append(new_row)

    if not final_rows:
        skip += top
        continue

    df = pd.DataFrame(final_rows)

    # ✅ Clean data
    df = df.astype(str)
    for col in df.columns:
        df[col] = df[col].str[:4000]

    # ✅ Create table
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

    # ✅ Insert
    cols = ",".join([f"[{c}]" for c in df.columns])
    placeholders = ",".join(["?"] * len(df.columns))

    cursor.executemany(
        f"INSERT INTO {table_name} ({cols}) VALUES ({placeholders})",
        df.values.tolist()
    )
    conn.commit()

    skip += top
    print(f"Inserted {len(df)} rows... skip={skip}")

print("✅ TrainingPlans loaded")