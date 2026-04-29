# End-to-End Superstore Sales Analysis Project

This project is an end-to-end Business Intelligence and Data Analytics solution built using **PostgreSQL + Power BI** on the Superstore Sales dataset.

The project covers the complete analytics workflow from **raw data cleaning → SQL-based EDA → analytical views creation → Power BI transformation → data modeling → DAX measures → interactive dashboard development → business insight generation**.

The objective of this project is to analyze sales performance, profitability, customer behavior, product performance, and regional trends to support better business decision-making.

---

# 📌 Project Objective

The goal of this project is to transform raw retail sales data into meaningful business insights by building a complete analytics pipeline.

This project helps answer important business questions such as:

* Which product categories drive the highest revenue?
* Which states generate high sales but low profit?
* Is business growth sustainable over time?
* Which products are profitable and which are loss-making?
* How do discounts impact profitability?
* Which customer segments contribute the most revenue?

---

# 📂 Dataset Description

The dataset contains historical sales transactions of a Superstore business including key columns :
* Order ID
* Order Date
* Ship Date
* Ship Mode
* Customer ID
* State
* Product ID
* Category
* Sub-Category
* Sales
* Quantity
* Discount
* Profit

---

# 🛠️ Tools & Technologies Used

### Database & SQL

* PostgreSQL
* pgAdmin 4

### Business Intelligence

* Power BI
* Power Query
* DAX (Data Analysis Expressions)

### Version Control

* Git
* GitHub

---

# 🔄 Project Workflow

The project was completed in the following phases:

## 1. Data Loading

## 2. Data Cleaning (SQL)
* Removing duplicate records
* Dropping unnecessary columns
* Handling null and blank values
* Standardizing names and date formats
* Fixing inconsistent values

## 3. Exploratory Data Analysis (EDA)
* Sales and Profit Analysis
* Time Series Analysis
* State-Level Performance
* Product Performance
* Customer Segmentation
* Discount Impact Analysis

## 4. SQL Views Creation
* sales_summary
* sales_by_year
* monthly_sales
* category_performance
* state_performance
* yoy_sales_growth
* category_contribution

## 5. Power Query Transformations
* Date hierarchy creation
* Month Name and Month Number formatting
* Year-Month columns
* Customer segmentation fields
* Profit Margin calculations
* Conditional transformation for better reporting

### Data Modeling
* Star-schema implementation using fact-tables and dimension-tables


### DAX Measures Created
* Total Sales
* Total Profit
* Total Orders
* Average Order Value
* Profit Margin %
* YoY Growth %
* Repeat Customer %
* Customer Segment Contribution %

## 6. Dashboard Development
Built 4 fully interactive Power BI dashboards + centralized slicer panel for filtering.

## 1. Executive Dashboard

Provides high-level business overview using:

* KPI Cards
* Category Contribution
* State Performance
* Profit Margin Analysis
* Revenue vs Profit Insights

## 2. Sales & Profit Trend Dashboard

Focused on time-series analysis using:

* Monthly Sales Trend
* Monthly Profit Trend
* YoY Growth %
* MoM Growth %
* Peak Sales Period Analysis

## 3. Product Dashboard

Focused on product performance analysis using:

* Top/Bottom Products
* Category Performance
* Sub-Category Analysis
* Product Profitability Analysis

## 4. Customer Dashboard

Focused on customer behavior analysis using:

* Top Customers Table
* Customer Segmentation
* Repeat vs One-Time Customers
* Discount vs Profit Analysis

## 5. Slicer Panel

Centralized filtering panel for:

* Year
* State
* Category
* Sub-Category
* Customer Segment

---

# 💡 Key Business Insights Derived

* Office Supplies contributed the highest share of total sales, making it the most revenue-driving category, but its low profitability significantly impacted overall profit.
* High-sales states like Texas, Florida, and Illinois showed poor profit margins, indicating discount-heavy selling and operational inefficiencies.
* Sales increased slightly from 2016 to 2017, but profit declined sharply due to low margins in Office Supplies.
* Technology generated lower sales than Office Supplies but delivered the strongest profit margins and the best sales-profit balance.
* 2014 was the peak-performing year with the highest sales and profit, after which Year-over-Year sales growth consistently declined.
* March, September, and November were identified as the strongest performing months, showing clear seasonal sales patterns.
* Products like Phones, Copiers, Papers, and Chairs generated the highest sales, but Phones and Chairs showed weaker profitability compared to Copiers and Papers.
* Sub-categories like Binders, Fasteners, and Supplies showed low or negative profit margins despite strong overall category sales.
* Most customers were repeat buyers (above 95%), indicating strong customer retention and loyalty.
* Higher discount rates increased sales volume but reduced profit margins, showing the trade-off between revenue growth and profitability.
* Medium-value customers contributed nearly 50% of total revenue, making them the most important customer segment for business growth.

---

# 🚀 Final Outcome

This project demonstrates complete end-to-end Business Intelligence workflow by combining:

### SQL for Data Preparation + Power BI for Decision Intelligence

It reflects real-world analytics practices used by Data Analysts and Business Intelligence professionals for transforming raw business data into actionable strategic insights.

---

# 📎 Repository Contents

* Raw Dataset CSV
* Cleaned Dataset
* SQL Cleaning Script
* SQL EDA Script
* SQL Views Script
* Power BI Dashboard File (.pbix)
* Dashboard Screenshots
* README.md

---

# ⭐ If You Found This Useful

Feel free to star the repository and connect with me for more Data Analytics and Power BI projects.
