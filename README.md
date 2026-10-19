# Week 1: Danny's Diner 🍣

## 1. Business Context

Danny's Diner is a restaurant serving three popular Japanese dishes: sushi, curry, and ramen. Danny wants to better understand customer purchasing behavior, spending patterns, and menu preferences to improve customer loyalty and deliver a more personalized dining experience.

This project uses SQL to analyze transaction data and generate insights to support customer relationship management and loyalty program decisions.

## 2. Objectives

- Calculate total spending and visit frequency for each customer.
- Identify customers' first purchases and most popular menu items.
- Analyze purchasing behavior before and after joining the loyalty program.
- Calculate customer loyalty points under different reward rules.
- Create customer-level datasets to support further analysis.

## 3. Dataset

The dataset is provided by the [8 Week SQL Challenge – Case Study #1](https://8weeksqlchallenge.com/case-study-1/).

| Table | Description |
|---|---|
| `sales` | Customer transactions, including order dates and product IDs |
| `menu` | Menu items, product names, and prices |
| `members` | Customer loyalty program membership dates |

The dataset contains transaction records for three customers, two of whom joined the loyalty program.

## 4. Tools

- PostgreSQL
- VS Code
- pgAdmin

## 5. SQL Techniques

- Data exploration and aggregation
- Table joins using `INNER JOIN` and `LEFT JOIN`
- Aggregate functions: `SUM`, `COUNT`
- Common Table Expressions (CTEs)
- Window functions: `RANK`, `DENSE_RANK`, `ROW_NUMBER`
- Conditional logic using `CASE WHEN`
- Date comparisons and date-based filtering
- Customer segmentation and loyalty points calculations

## 6. Business Questions

### A. Customer Spending and Visits
- How much did each customer spend?
- How many unique days did each customer visit the restaurant?

### B. Menu Preferences
- What was each customer's first purchased item?
- Which menu item was purchased most frequently overall?
- What was each customer's favorite menu item?

### C. Loyalty Program Analysis
- What did customers purchase immediately before and after joining the program?
- How many items did members purchase, and how much
