# Data Cleaning Project – Dirty Cafe Sales Dataset

This project focuses on cleaning a messy café sales dataset using SQL. The dataset contains sales transactions with inconsistent and missing data in important fields like Quantity, Price Per Unit, and Transaction Date. The goal is to use SQL queries to detect, fix, and standardize these issues.

## Dataset Description
(https://www.kaggle.com/datasets/ahmedmohamed2003/cafe-sales-dirty-data-for-cleaning-training)
- The dataset includes columns such as Transaction ID, Item name, Quantity, Price Per Unit, Total Spent, Payment Method, Location, and Transaction Date. Many of these fields have irregularities — for example, some quantities or prices are listed as 'UNKNOWN' or missing.

## Approach
Using SQL Server, I wrote queries to clean and transform the data step-by-step. For example, invalid quantities were set to null, then calculated where possible. Price per unit was standardized with one decimal place and missing prices were filled based on the typical price of the item. Transaction dates were validated and invalid entries replaced with nulls, and then decomposed into separate year, month, and day columns.

## How to run
Run the SQL script provided in this repository in your SQL Server environment. Follow the script sequentially to observe how the data is cleaned.

## Author
Maroua Boumchich

