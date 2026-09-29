# Industrial Sensor Analytics & Predictive Maintenance

An end-to-end data analytics project using **SQL** and **Python (Pandas & Matplotlib)** to analyze industrial machine sensor logs, identify downtime drivers, calculate equipment KPIs, and classify machine risk levels for operational optimization.

---

## 📌 Project Overview

Unplanned downtime in manufacturing leads to significant production losses. This project analyzes time-series sensor data (vibration, temperature, output units, and downtime minutes) collected across various production lines and machines. 

The goal is to move from reactive maintenance to proactive risk classification using data-driven insights.
<img width="895" height="498" alt="dashboard_screenshot" src="https://github.com/user-attachments/assets/ef7c482d-cf3b-4f24-b504-61ac340ca7cc" />

---

## 🛠️ Tools & Technologies Used

- **SQL (MSSQL / MySQL / PostgreSQL compatible):** Data quality checks, KPI aggregations, risk classification, ranking window functions, and views.
- **Python (Jupyter Notebook):** Exploratory Data Analysis (EDA), statistical summary, feature engineering, correlation analysis, and visualization.
- **Libraries:** `pandas`, `matplotlib`

---

## 💾 Dataset Schema

The dataset `industrial_sensor_data.csv` contains 500 records with the following attributes:

| Column Name | Data Type | Description |
| :--- | :--- | :--- |
| `Timestamp` | Datetime | Date and time of the sensor log |
| `Machine_ID` | String | Unique identifier for each machine (e.g., M-101) |
| `Production_Line` | String | Factory line (Line-A, Line-B, Line-C) |
| `Vibration_mm_s` | Float | Machine vibration speed in mm/s |
| `Temperature_C` | Float | Operating temperature in Celsius |
| `Output_Units` | Integer | Units produced during the log interval |
| `Downtime_Minutes` | Float | Unplanned machine stop time in minutes |

---

## 📊 Key Analysis & Insights

### 1. Data Quality & Profiling
- Verified **0 missing values** and **0 duplicate records** across the 500 sensor logs.
- Engineered features such as `Date`, `Hour`, and categorical `Risk_Level`.

### 2. Statistical Highlights
- **Average Machine Vibration:** $4.56\text{ mm/s}$ (Max observed: $11.00\text{ mm/s}$)
- **Average Machine Temperature:** $76.15^\circ\text{C}$ (Max observed: $100.95^\circ\text{C}$)
- **Average Downtime per Log:** $12.54\text{ minutes}$

### 3. Risk Level Matrix
Operating risks were categorized using sensor threshold logic:
- 🔴 **Critical:** Vibration $\ge 7\text{ mm/s}$ AND Temperature $\ge 85^\circ\text{C}$
- 🟠 **High:** Vibration $> 5\text{ mm/s}$ AND Temperature $\ge 75^\circ\text{C}$
- 🟡 **Medium:** Vibration $> 3\text{ mm/s}$ AND Temperature $\ge 65^\circ\text{C}$
- 🟢 **Normal:** All other operating conditions

### 4. Machine Ranking & Outlier Detection
- Applied SQL Window Functions (`RANK() OVER(...)`) to rank machines by total downtime.
- Identified statistical downtime outliers using the $2\sigma$ upper threshold:
$$\text{Threshold} = \text{Mean}(\text{Downtime}) + 2 \times \text{StdDev}(\text{Downtime})$$

---

## 📄 SQL Implementation

The SQL script `Industrial Analytics project.sql` performs the following key tasks:
1. **Database & Table Setup:** Initializes the schema.
2. **Data Cleaning:** Checks for nulls and duplicate `Timestamp` + `Machine_ID` pairs.
3. **Aggregations:** Computes overall KPIs, per-machine performance, and line output rankings.
4. **CTE & Risk CTE:** Implements Common Table Expressions for risk segmentation and downtime ranking.
5. **Views:** Creates `vw_machine_performance` for easy reporting integration.

---

## 📈 Python Analytics & Visualization

The Python analysis notebook includes:
- **Correlation Analysis:** Identified strong positive correlation ($r = 0.87$) between `Vibration_mm_s` and `Downtime_Minutes`.
- **Downtime by Machine:** Bar chart highlighting machines contributing most to factory downtime.
- **Scatter Plot:** Visualizing the relationship between machine vibration and recorded downtime.

---
## 📉 Power BI Dashboard Features
- **Key Metric Cards:** Total Downtime Minutes, Average Vibration, Average Temperature, and Production Units.
- **Risk Level Slicers:** Dynamic filtering by Machine Risk Level (Critical, High, Medium, Normal).
- **Line & Machine Drill-downs:** Downtime distribution across Production Lines and individual Machine IDs.


## 📁 Repository Structure

```text
├── industrial_sensor_data.csv       # Source dataset
├── Industrial Analytics project.sql  # SQL queries for KPIs and CTEs
├── Industrial_Analytics.ipynb      # Python notebook for EDA & plots
└── README.md                       # Project documentation
