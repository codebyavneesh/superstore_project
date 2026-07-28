# 🛒 Superstore Sales Analytics

![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![Power BI](https://img.shields.io/badge/Power%20BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
![Pandas](https://img.shields.io/badge/Pandas-150458?style=for-the-badge&logo=pandas&logoColor=white)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen?style=for-the-badge)

End-to-end data analytics project on the Superstore dataset — covering database design, advanced SQL analysis, Python-based data cleaning/EDA, and an interactive Power BI dashboard. 📊

## 🎯 Project Overview

This project analyzes retail sales data to uncover insights around revenue, profitability, customer behavior, shipping performance, and regional/category trends. The pipeline goes from raw CSV → cleaned data → MySQL database → SQL analysis → Python EDA → Power BI dashboard.

## 🛠️ Tech Stack

- 🐍 **Python** — Pandas, NumPy, Matplotlib, Seaborn (data cleaning, feature engineering, EDA)
- 🔗 **SQLAlchemy** — loading cleaned data into MySQL
- 🗄️ **MySQL** — schema design and advanced SQL analysis
- 📈 **Power BI** — interactive multi-page dashboard

## 💡 Skills Demonstrated

- Data Cleaning & Preprocessing (handling missing values, feature engineering)
- Exploratory Data Analysis (EDA) with Matplotlib & Seaborn
- Database Design (schema design, normalization)
- Python–MySQL Connectivity (SQLAlchemy)
- Advanced SQL (Window Functions, CTEs, LAG, Running Totals, Ranking)
- Business Analytics (CLV, Pareto/80-20 analysis, YoY growth, cohort-style repeat customer analysis)
- Data Visualization & Dashboarding (Power BI — KPIs, drill-through, filters, multi-page reports)
- Version Control & Documentation (Git/GitHub, README structuring)

## 📁 Folder Structure

```
superstore_project/
│
├── data/
│   ├── row_data/              # Raw dataset
│   │   └── row_superstore.csv
│   └── cleaned_data/          # Cleaned dataset after preprocessing
│       └── cleaned_superstore.csv
│
├── scripts/
│   ├── data_cleaning_and_feature_engg.ipynb   # Data cleaning + feature engineering
│   ├── EDA.ipynb                              # Exploratory Data Analysis & charts
│   └── load_data.py                           # Loads cleaned data into MySQL (SQLAlchemy)
│
├── sql/
│   ├── schema_design.sql      # Database schema design
│   └── sql_queries.sql        # 20 advanced SQL analysis queries
│
├── images/
│   ├── chart_images/          # EDA chart screenshots
│   └── dashboard_images/      # Power BI dashboard screenshots
│
└── dashboard/
    └── superstore_dashboard.pbix   # Power BI dashboard file
```

## 🔄 Workflow

1. **Data Cleaning & Feature Engineering** (`data_cleaning_and_feature_engg.ipynb`) — Cleaned the raw Superstore dataset and engineered features required for downstream analysis.
2. **Exploratory Data Analysis** (`EDA.ipynb`) — Analyzed the cleaned dataset and built visualizations to understand sales, profit, and customer patterns.
3. **Load to MySQL** (`load_data.py`) — Loaded the cleaned dataset into a `sales` table in MySQL using SQLAlchemy.
4. **Schema Design** (`schema_design.sql`) — Designed the database schema for the sales data.
5. **SQL Analysis** (`sql_queries.sql`) — Wrote 20 advanced SQL queries (window functions, CTEs, running totals) covering revenue, profitability, customer, shipping, and regional analysis.
6. **Power BI Dashboard** (`superstore_dashboard.pbix`) — Built a 3-page interactive dashboard summarizing key business insights.

## 🧮 SQL Analysis — 20 Advanced Queries

| # | Query |
|---|---|
| 1 | Top Revenue States (with orders, profit, avg order value) |
| 2 | Loss-Making Products (positive sales, negative profit) |
| 3 | Customer Lifetime Value (CLV) |
| 4 | Shipping Performance Analysis by Ship Mode |
| 5 | Monthly Sales Trend (Window Functions — growth %, running total) |
| 6 | Category Contribution Analysis (revenue % & profit %) |
| 7 | Top 5 Products per Category (Window Function) |
| 8 | High Discount Impact on Profit |
| 9 | Regional Performance Dashboard |
| 10 | Repeat Customer Analysis |
| 11 | Pareto Analysis (80/20 Rule) |
| 12 | Year-over-Year Sales Growth |
| 13 | Profit Margin Ranking within Category |
| 14 | State-wise Best Selling Category |
| 15 | Order Size Analysis (Small/Medium/Large) |
| 16 | Customer Purchase Gap (LAG function) |
| 17 | Revenue Concentration — Top 10 Customers |
| 18 | Consistently Loss-Making States |
| 19 | Discount Effectiveness by Range |
| 20 | Executive Business Report (Region-wise KPI summary) |

## 📊 Power BI Dashboard

The dashboard has 3 pages:

**Page 1 — Executive Overview**
- KPIs: Total Revenue (13M), Total Profit (1.47M), Total Orders (51K), Profit Margin % (11.61), Total Customers (5K), Total Quantity (178K)
- Total Revenue by Segment (donut chart)
- Total Revenue, Total Profit & Total Customers by Order Month (trend line)
- Total Profit and Total Revenue by Category

**Page 2 — Product Analysis**
- Total Revenue by Top 10 Products
- Total Revenue and Total Profit by Sub-Category
- Total Profit by Bottom 10 Products
- Total Profit by Discount (scatter)

**Page 3 — Regional & Shipping Analysis**
- KPIs: Total Revenue, Total Profit, Profit Margin %, Total Customers
- Sum of Shipping Cost by Ship Mode
- Total Revenue by Customer Type (Repeat vs One-Time)
- Total Revenue, Total Orders and Total Profit by Region

Filters available: Segment, Category, City, Ship Mode, Country, Year.

## 🖼️ Dashboard Preview

**Page 1 — Executive Overview** 🏆
![Executive Overview](https://raw.githubusercontent.com/codebyavneesh/superstore_project/main/superstore_project/images/dashboard_images/image1.png)

**Page 2 — Product Analysis** 📦
![Product Analysis](https://raw.githubusercontent.com/codebyavneesh/superstore_project/main/superstore_project/images/dashboard_images/image2.png)

**Page 3 — Regional & Shipping Analysis** 🚚
![Regional & Shipping Analysis](https://raw.githubusercontent.com/codebyavneesh/superstore_project/main/superstore_project/images/dashboard_images/image3.png)

## 🚀 How to Run

1. Place the raw dataset in `data/row_data/`.
2. Run `scripts/data_cleaning_and_feature_engg.ipynb` to generate the cleaned dataset in `data/cleaned_data/`.
3. Run `scripts/EDA.ipynb` for exploratory analysis and charts.
4. Run `scripts/load_data.py` to load the cleaned data into MySQL (`sales` table).
5. Execute `sql/schema_design.sql` to set up the schema, then run queries from `sql/sql_queries.sql`.
6. Open `dashboard/superstore_dashboard.pbix` in Power BI Desktop to view/refresh the dashboard.

## 👤 Author

**codebyavneesh**

[![GitHub](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/codebyavneesh)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://linkedin.com/in/codebyavneesh)
