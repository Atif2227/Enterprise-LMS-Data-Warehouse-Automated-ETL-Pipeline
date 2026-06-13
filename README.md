# 🚀 Enterprise LMS Data Warehouse & Automated ETL Pipeline

**Role:** Data Engineer, BI Consultant & Analytics Architect  
**Domain:** Learning Management System Analytics  
**Objective:** Build scalable ETL pipelines and enterprise reporting using Python, SQL Server & Power BI  

---

# Introduction

The Enterprise LMS Data Warehouse is an end-to-end data engineering solution designed to transform raw LMS API data into a centralized, reliable, and analytics-ready data platform.

The project was developed to overcome limitations of fragmented LMS reporting environments where data was distributed across multiple Power BI files, stored in complex API structures, and lacked a centralized data warehouse.

Using a custom-built Python ETL framework, SQL Server data warehouse layer, and optimized Power BI semantic model, the solution enables automated data ingestion, historical analysis from 2015–2026, incremental data refresh, and high-performance enterprise dashboards.

The pipeline was designed without traditional ETL platforms such as SSIS, Azure Data Factory, or Microsoft Fabric, demonstrating how a production-grade data platform can be built using core engineering technologies.

---

# 🔗 View Scripts

👉 **[LMS Tables Loading](https://github.com/Atif2227/Enterprise-LMS-Data-Warehouse-Automated-ETL-Pipeline/blob/main/Scripts/1.%20LMS%20All%20Tables%20Loading/LMS%20Tables%20Loading.ipynb)**  
👉 **[Incremental Loading](https://github.com/Atif2227/Enterprise-LMS-Data-Warehouse-Automated-ETL-Pipeline/tree/main/Scripts/2.%20Incremental%20Load)** 
👉 **[Run Batch File](https://github.com/Atif2227/Enterprise-LMS-Data-Warehouse-Automated-ETL-Pipeline/tree/main/Scripts/3.%20Run%20Batch%20FIle)** 
👉 **[ALL LMS SQL Views](https://github.com/Atif2227/Enterprise-LMS-Data-Warehouse-Automated-ETL-Pipeline/blob/main/Scripts/4.%20SQL%20Views/All%20LMS%20Tables%20Views.sql)**

---

# 🧩 Tech Stack

- **Programming:** Python  
- **Data Engineering:** Custom ETL Pipeline  
- **API Integration:** OData APIs, JSON Processing  
- **Database:** SQL Server  
- **Data Processing:** Pandas, PyODBC  
- **Automation:** Batch Scripts, Windows Task Scheduler  
- **Visualization:** Power BI  

---

# 🎯 Business Impact

- **95%+ Reduction in Power BI Report Load Time**
- **2015–2026 Historical Data Consolidation**
- **Automated Daily Data Refresh Pipeline**
- **Centralized LMS Enterprise Data Warehouse**
- **Incremental Loading with Zero Data Loss**
- **Enterprise Reporting Enabled Without ETL Tools**

---

# ⚠️ Problem Statement

The organization had access to LMS data through APIs but faced several challenges:

- API-based data was not directly usable for reporting
- Data contained complex nested JSON structures
- Historical data was spread across multiple years
- Separate Power BI reports contained only limited year ranges
- No centralized data warehouse existed
- DirectQuery performance limitations slowed reporting
- No automated ETL process was available
- No ETL tools (MSBI-SSIS, Azure Data Factory-ADF, or Microsoft Fabric) were provided

As a result:

- Year-over-year analysis was difficult
- Reports were slow and inefficient
- Data consistency issues occurred
- Manual reporting effort increased

This project solved these challenges using a custom **Python + SQL Server + Power BI analytics architecture**.

---

# 🧠 Solution Overview

## Data Engineering

Built a complete custom ETL pipeline to extract, transform, and load LMS data.

### Extraction

- Connected LMS APIs using Python requests
- Implemented OData API integration
- Used:

  - `$top`
  - `$skip`
  - `$expand`

- Extracted multi-year datasets (2015–2026)
- Managed API pagination and nested responses

---

## Data Transformation

Processed complex API responses into structured relational data.

### Key Transformations:

- Flattened nested JSON objects
- Expanded user roles into separate records
- Extracted attendance information
- Parsed enrollment relationships
- Standardized schemas and column names
- Cleaned NULL values and inconsistent records

---

## Data Loading

Loaded transformed data into SQL Server.

### Optimization Techniques:

- Used PyODBC for database connectivity
- Implemented batch inserts
- Enabled fast execution using:

`fast_executemany`

- Designed a scalable loading strategy for large datasets

---

# 🏗️ Data Warehouse Design

Created a centralized SQL Server data warehouse layer.

## Fact Tables

- `Fact_Enrollments`

## Dimension Tables

- `Dim_Users`
- `Dim_Courses`
- `Dim_Categories`
- `Dim_Roles`
- `Dim_Departments`
- `Fact_Attendances`

---

# 🔥 End-to-End Architecture
    ┌───────────────────────────┐
    │       LMS API (OData)     │
    │   JSON / Nested Data      │
    └─────────────┬─────────────┘
                  ↓

    ┌───────────────────────────┐
    │     Python ETL Pipeline   │
    │ Extract | Transform |Load │
    └─────────────┬─────────────┘
                  ↓

    ┌───────────────────────────┐
    │      SQL Server DW        │
    │ Fact & Dimension Tables   │
    └─────────────┬─────────────┘
                  ↓

    ┌───────────────────────────┐
    │     SQL Views Layer       │
    │ Semantic Transformation   │
    └─────────────┬─────────────┘
                  ↓

    ┌───────────────────────────┐
    │        Power BI           │
    │ Dashboards & Analytics    │
    └───────────────────────────┘

    
---

# 🔄 Incremental Data Pipeline

Designed a production-ready incremental refresh mechanism.

## Approach:

- Used `RegistrationDate` and `CreatedAt`as a change tracking field
- Retrieved the latest loaded timestamp
- Extracted only new and modified records
- Removed overlapping records
- Reloaded controlled window

## Outcome:

✅ No duplicate records  
✅ No missing data  
✅ Faster daily refresh  
✅ Reliable production pipeline  

---

# 📊 Power BI Analytics Layer

Built an optimized Power BI reporting model.

## Data Model

### Fact Tables

- Enrollments

### Dimension Tables

- Users
- Courses
- Categories
- Catalogs
- Sessions
- Attendances

---

## Dashboard Capabilities

- Course analytics
- User engagement tracking
- Attendance analysis
- Learning trends
- Historical year comparison

---

# ⚡ Performance Optimization

Identified reporting bottlenecks and optimized the analytics layer.

Implemented:

- SQL View optimization
- Data model improvements
- Efficient relationships
- Reduced unnecessary DirectQuery dependency

### Result:

- Over **95% faster report performance**
- Improved dashboard responsiveness
- Better user experience

---

# 🤖 Automation Framework

Created an automated execution framework.

Implemented:

- Python pipeline scripts
- Batch execution files
- Windows Task Scheduler automation

Enabled:

- Scheduled refresh
- Hands-free pipeline execution
- Continuous data availability

---

# 📊 Results & ROI

- Built an enterprise-level LMS data warehouse
- Consolidated 10+ years of historical learning data
- Automated API-to-dashboard workflow
- Improved Power BI performance by 95%+
- Eliminated dependency on traditional ETL platforms
- Enabled scalable reporting architecture

---

# 💡 Data Engineering Value

- Converted raw API data into structured analytics assets
- Designed a reusable ETL framework
- Implemented production-grade incremental loading
- Created scalable warehouse architecture
- Delivered enterprise BI capability using lightweight technologies

---

# 🧩 Technical Skills Demonstrated

- Python ETL Development
- API Integration
- JSON Data Processing
- SQL Server Data Warehousing
- Data Modeling
- Incremental Loading
- Power BI Optimization
- Automation Engineering

---

# 📁 Project Structure

```text
project-root/
│
├── api/
│   └── LMS API extraction scripts
│
├── etl/
│   ├── extraction/
│   ├── transformation/
│   └── loading/
│
├── sql/
│   ├── tables/
│   ├── views/
│   └── procedures/
│
├── automation/
│   ├── batch files
│   └── scheduler configs
│
├── dashboards/
│   └── Power BI files (.pbix)
│
├── images/
│   └── dashboard screenshots
│
└── README.md
```

---

# 👤 Consultant

**Atif Noorul Hasan** <br />

Data Engineering Consultant <br />
Business Intelligence | Data Analytics | Data Warehouse Design <br />

🔗 Website – https://atifdata.com <br />
✉️ Email – atif@atifdata.com

---

## 🚀 Final Summary

Designed and implemented an enterprise-scale LMS ETL pipeline using Python and SQL Server, enabling automated API ingestion, incremental loading, centralized data warehousing, and high-performance Power BI reporting with over 95% improvement in dashboard performance.
