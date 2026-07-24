import requests
import pandas as pd
import pyodbc
import urllib3
import warnings
warnings.filterwarnings("ignore")

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

username = "6b3661eb-7413-444c-9ee7-648d0a0915e6"
password = "6b3661eb-7413-444c-9ee7-648d0a0915e6"

conn = pyodbc.connect(
    "DRIVER={ODBC Driver 17 for SQL Server};"
    "SERVER=BRW03WFTATHASD;"
    "DATABASE=WFTD_data_warehouse;"
    "Trusted_Connection=yes;"
)
cursor = conn.cursor()
cursor.fast_executemany = True

base_url = "https://api.365.systems/odata/v2/CourseCatalogs"
table_name = "CourseCatalogs"

top = 5000
skip = 0
first_batch = True

while True:
    url = f"{base_url}?$top={top}&$skip={skip}"

    response = requests.get(
        url,
        auth=(username, password),
        verify=False
    )

    data = response.json().get("value", [])

    if not data:
        break

    df = pd.DataFrame(data)

    df = df.astype(str).applymap(lambda x: x[:4000])

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

    if not df.empty:
        cols = ",".join([f"[{c}]" for c in df.columns])
        placeholders = ",".join(["?"] * len(df.columns))

        cursor.executemany(
            f"INSERT INTO {table_name} ({cols}) VALUES ({placeholders})",
            df.values.tolist()
        )
        conn.commit()

    skip += top
    print(f"Inserted {len(df)} rows... skip={skip}")

print("✅ CourseCatalogs loaded")