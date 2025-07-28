## 📌 Sql_programming_project

## 📌 Overview
## Objectives
- Analyze regional business performance, resource efficiency, and capital usage through SQL programming and BI visualization using internal financial and operational data.
The goal is to identify high-performing regions, optimize human capital, and improve capital allocation strategies for long-term profitability.
- In addition, it also helps us assess the capabilities of employees in each region through the Area Sales Manager (ASM) to promote a culture of responsibility and continuous development among ASMs. By analyzing different aspects of financial performance across all network areas and ASM KPIs, we can gain insights to maintain performance and improve the capabilities of senior managers in the company
  
## Data Sources
Data is collected from various departments at the headquarters, including Sales and Operations, Accounting and ASM records.

-  File fact_txn_month_raw_data: Records the income and expenses incurred by the financial activities of the enterprise in the General Ledger.

-  File fact_kpi_month_raw_data: Records the final balance of card activities at the end of each month.

-  File fact_kpi_asm: raw data on ASM monthly sales performance.

## Output
The objective is to develop a comprehensive regional business performance analysis report and a thorough employee performance evaluation report. Furthermore, a dashboard will be established to facilitate the visualization and analysis of these insights, thereby enabling more effective data-driven decision-making and strategic planning.

## 📁 Project Structure  

## Sql_programming_project/  
│── **SQL Programming** 

**Data Processing: Dbeaver + Postgresql**
 ### 1️⃣ Use Dbeaver to import into the database
 
- File fact_txn_month_raw_data
<img width="1443" height="615" alt="image" src="https://github.com/user-attachments/assets/328a7a07-5180-4645-978c-4c579ef34f79" />

- File fact_kpi_month_raw_data
<img width="1327" height="599" alt="image" src="https://github.com/user-attachments/assets/c0e759c3-2ec7-48fd-9b7a-7cd3a9871e78" />

- File fact_kpi_asm
<img width="1191" height="882" alt="image" src="https://github.com/user-attachments/assets/dfef0ba1-131d-4c33-ac3c-9580d9f8645a" />

### 2️⃣ Create dimension tables by using PostgreSQL Data Definition Language (DDL)

- Table dim_province: Information about cities in each zone area
<img width="1474" height="615" alt="image" src="https://github.com/user-attachments/assets/d0ac8e9b-f1b2-4d53-a45e-8c8f00d4132d" /> 

- Table dim_report_item: Information about the criteria of the report table
<img width="1457" height="619" alt="image" src="https://github.com/user-attachments/assets/596d37c0-21a5-4946-8cbe-83f22ca3ce09" />

- Use PL/SQL programming to create a report that runs for each month in 2023.
  
- By providing the YYYYMM parameter, the system can dynamically generate monthly reports by extracting relevant data from the fact tables and joining it with the pre-defined dimension tables. This automated process ensures consistency, reduces manual intervention, and allows for scalable reporting across different time periods with accurate and up-to-date information. [View more](./final_code.sql)



│── **Power BI**: Power BI dashboard containing all visualizations and insights
**I connected Power BI to the PostgreSQL database using DirectQuery mode to retrieve and visualize the data, helping users gain a broader view of the report. [View more](Report_final.pdf)**

### 1️⃣ Introduction
- Identified key customer segments and purchasing behavior.  
- Analyzed regional sales performance to detect market trends.  

### 2️⃣ KQKD by Area 
- The financial performance of each region based on various indicators (income, expenses, profit, etc.).
- Compare performance across regions and support decision-making on strategy and resource allocation.

### 3️⃣ KQKD Analysis 
- Regional financial trends through indicators like profit, CIR, margin, and staff productivity.
- Compare performance across regions and support strategic business adjustments.

### 4️ KPI ASM Overview 
- KPI results of each ASM by region for the month, based on total scores and specific performance metrics.
- Evaluate and compare ASM performance to support ranking, rewards, or adjustments

### 5️⃣ KPI ASM Overview 
- Top 10 and Bottom 10 sales staff based on total score, scale score, and financial score, analyzed by region and individual.
- Identify top performers and underperformers to support performance evaluation and HR decisions.

### 6️⃣ Comments
- Analyze the financial performance of each region based on indicators such as income, expenses, profit, capital efficiency, and staff productivity.
- Support regional comparison and enable strategic decision-making and business operation adjustments.

### 7️⃣ Glossary
- A glossary explaining terms, abbreviations, and codes used in the financial analysis system.
- Assist users in understanding report content clearly and avoid confusion during data review and analysis.


