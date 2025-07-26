# Financial_analysis
# 📌 Financial analysis
**Power BI, SQL Programming, Data Visualization**  

## 📌 Objective  

Analyze regional business performance, resource efficiency, and capital usage through SQL programming and BI visualization using internal financial and operational data.
The goal is to identify high-performing regions, optimize human capital, and improve capital allocation strategies for long-term profitability.

## 📁 Project Structure  

Financial_analysis_project/  
│── **Financial_analysis.pbix**: Power BI dashboard containing all visualizations and insights  
│── **SQL Programming** 

     1. Design Capital Structure DIM Table: Build a dimension (DIM) table to store capital structure criteria.
     <img width="1194" height="796" alt="image" src="https://github.com/user-attachments/assets/ab5b53c0-7e84-41b7-be5f-6aa939cf5d5c" />

     2. Build Daily Balance FACT Table: Create a FACT table to store daily customer balances of deposits and loans, broken down by term and product type.
     <img width="1098" height="599" alt="image" src="https://github.com/user-attachments/assets/7de7658d-24bf-4289-979a-92c4af67ea56" />

     3. Create Capital Source & Usage Summary Table: Build a summary table to track capital sources and usages based on the criteria defined in step 1.
               
     4. Write Summary Report Script: Write a SQL script to generate the final summary report output.
     <img width="1339" height="871" alt="image" src="https://github.com/user-attachments/assets/1e9bccdb-809f-4b3c-a300-5a3bbfca27fb" />

     5. Create Views and Connect to BI Tools: Create SQL views for reporting purposes and use Direct Query mode to connect them to Power BI or Tableau for data visualization.
     <img width="1210" height="763" alt="image" src="https://github.com/user-attachments/assets/34db9184-6fc1-47c8-8c00-6d8369b7b506" />

│── **Dataset/**: Processed data exported from File Excel for offline use  
│── **README.md**: Project documentation  

---  

## 📊 Key Contributions  

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

### 6️⃣ Glossary
- A glossary explaining terms, abbreviations, and codes used in the financial analysis system.
- Assist users in understanding report content clearly and avoid confusion during data review and analysis.
---  

## 🛠️ Tools Used  
- **Power BI, SQL Programming (PostgreSQL)**
- **Data Processing:** Stored procedures with monthly backdate execution
- **Visualization:** Power BI charts  
- **Statistical Analysis:** Descriptive statistics for trend evaluation  

---  
📌 **All insights and interactive charts can be accessed in `Financial_analysis.pbix`.**
