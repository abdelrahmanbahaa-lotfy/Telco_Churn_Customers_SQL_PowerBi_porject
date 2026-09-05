# Nexatel Customer Churn Analysis

A SQL Server + Power BI project that finds out why customers leave and which ones to focus on saving.

![Overview dashboard](images/overview_dashboard.png)

## The problem

Nexatel (a telecom brand used for this project) loses about **1 in 4 customers** to churn. That's roughly **$139K in lost monthly revenue**. The goal of this project is to find out who is leaving, why, and where to focus retention efforts first.

## The data

- Source: [IBM Telco Customer Churn dataset](https://github.com/IBM/telco-customer-churn-on-icp4d/blob/master/data/Telco-Customer-Churn.csv) (from IBM's own GitHub, not Kaggle)
- 7,043 customers, 21 columns (contract, billing, services, demographics)
- Tools used: SQL Server for the analysis, Power BI for the dashboard

## How I approached it

1. **Start with the baseline** — what's the overall churn rate before looking at anything else?
2. **Test one factor at a time** — contract type, tenure, services, payment method, demographics.
3. **Combine the strongest factors** — find the exact customer profile most likely to churn.
4. **Turn it into money** — how much revenue is actually at risk, not just how many customers.

## What I found

- Overall churn rate: **26.5%**
- Riskiest group: month-to-month + fiber optic + electronic check → **60% churn**
- Fiber optic customers churn more than double the rate of DSL customers
- Most of the lost revenue (**$113K of $139K**) comes from high-value customers
- New customers (first 6 months) churn the most — over 50%

![Deep dive dashboard](images/deep_dive_dashboard.png)

## Recommendations

1. **Focus on month-to-month + fiber optic + electronic check customers.** They churn the most by far. Offer them a discount to switch to an annual contract, or reach out before renewal.
2. **Get electronic-check customers onto automatic payment.** This payment method has the highest churn of all. A small incentive to switch to auto-pay could help.
3. **Protect high-value customers who don't have a partner or dependents.** They bring in the most revenue and are more likely to leave than customers with family ties.

![Recommendations dashboard](images/recommendations_dashboard.png)

## Files in this project

- `00` to `08` — SQL scripts, run in order (setup → cleaning → analysis)
- `images/` — dashboard screenshots and supporting query results

## Tools

SQL Server, Power BI, DAX, Power Query
