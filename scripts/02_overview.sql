/* ============================================================
   PURPOSE: Establish the reference numbers (baseline) that every
            other file will be compared against.
   WHAT IT MEASURES:
     - Total customer count
     - Overall churn rate (%)
     - Average tenure: overall, and split by churn vs stayed
     - Average monthly charges: overall, and split by churn vs stayed
   ============================================================ */

USE CustomerChurnIBM;
GO

-- Total customers + overall churn count/rate
SELECT
    COUNT(*) AS total_customers,
    SUM(churn_flag) AS churned_customers,
    CAST(SUM(churn_flag) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS churn_rate_pct
FROM dbo.vw_telco_churn_clean;

-- Average tenure: overall vs by churn status
SELECT
    churn,
    COUNT(*) AS customers,
    AVG(CAST(tenure AS DECIMAL(10,2)))  AS avg_tenure_months
FROM dbo.vw_telco_churn_clean
GROUP BY churn;

-- Average monthly charges: overall vs by churn status
SELECT
    churn,
    COUNT(*) AS customers,
    AVG(monthly_charges) AS avg_monthly_charges,
    AVG(total_charges) AS avg_total_charges
FROM dbo.vw_telco_churn_clean
GROUP BY churn;
GO
