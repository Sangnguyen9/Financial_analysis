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
  
<img width="1441" height="807" alt="image" src="https://github.com/user-attachments/assets/8706ac85-c176-4ea4-821d-2f59e5af79c1" />

### 2️⃣ KQKD by Area 
- The financial performance of each region based on various indicators (income, expenses, profit, etc.).
- Compare performance across regions and support decision-making on strategy and resource allocation.

<img width="1394" height="806" alt="image" src="https://github.com/user-attachments/assets/6993fb1c-c60a-4b0d-91c6-776d6a19847f" />

### 3️⃣ KQKD Analysis 
- Regional financial trends through indicators like profit, CIR, margin, and staff productivity.
- Compare performance across regions and support strategic business adjustments.

<img width="1400" height="756" alt="image" src="https://github.com/user-attachments/assets/9fadcef4-782c-420c-8468-d22d9fd7179b" />


### 4️ KPI ASM Overview 
- KPI results of each ASM by region for the month, based on total scores and specific performance metrics.
- Evaluate and compare ASM performance to support ranking, rewards, or adjustments

<img width="1391" height="781" alt="image" src="https://github.com/user-attachments/assets/3580feca-0672-498e-95b4-f584e1eebd72" />

### 5️⃣ Top 10, Bot 10 Sale name
- Top 10 and Bottom 10 sales staff based on total score, scale score, and financial score, analyzed by region and individual.
- Identify top performers and underperformers to support performance evaluation and HR decisions.

<img width="1382" height="787" alt="image" src="https://github.com/user-attachments/assets/64ed44f5-5605-4182-9d89-3730eae19a84" />

### 7️⃣ Glossary
- A glossary explaining terms, abbreviations, and codes used in the financial analysis system.
- Assist users in understanding report content clearly and avoid confusion during data review and analysis.

<img width="1398" height="755" alt="image" src="https://github.com/user-attachments/assets/ebdc4ac1-2f2f-4bb2-bdbf-a715e43c23dc" />

## 📌 Conclusion

Through this personal project, I not only enhanced my SQL Programming abilities but also gained practical experience in structuring, storing, and accessing data efficiently. Additionally, I became more familiar with data visualization by connecting to a database and utilizing Power BI to present insights. Most importantly, the project deepened my understanding of how data analysis can support business growth. It enabled me to communicate key insights clearly and effectively, especially to decision-makers and management teams.

**As this is my first project, there may inevitably be some mistakes. I truly welcome any feedback or suggestions you may have—feel free to reach out to me at hoangsang19980702@gmail.com.**

