/* ============================================================
   PURPOSE: Translate churn from a customer-count problem into a
            financial-impact problem.
   WHAT IT MEASURES:
     - Total monthly revenue lost from churned customers
     - Churn rate by customer value tier (Low/Medium/High, based
       on monthly_charges)
     - Which value tier contributes the most lost revenue
   ============================================================ */

USE CustomerChurnIBM;
GO

-- Total monthly revenue lost due to churn
SELECT
    SUM(monthly_charges) AS total_monthly_revenue,
    SUM(CASE WHEN churn = 'Yes' THEN monthly_charges ELSE 0 END) AS monthly_revenue_lost,
    CAST(
        SUM(CASE WHEN churn = 'Yes' THEN monthly_charges ELSE 0 END) * 100.0
        / SUM(monthly_charges) AS DECIMAL(5,2)
    ) AS pct_revenue_lost
FROM dbo.vw_telco_churn_clean;

--  Churn rate by customer value tier
SELECT
    monthly_value_tier,
    COUNT(*) AS customers,
    SUM(churn_flag) AS churned,
    CAST(SUM(churn_flag) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS churn_rate_pct,
    SUM(CASE WHEN churn = 'Yes' THEN monthly_charges ELSE 0 END) AS revenue_lost_in_tier
FROM dbo.vw_telco_churn_clean
GROUP BY monthly_value_tier
ORDER BY
    CASE monthly_value_tier WHEN 'High' THEN 1 WHEN 'Medium' THEN 2 ELSE 3 END;

--Top 20 highest-value customers who churned 
SELECT TOP 20
    customer_id,
    contract,
    internet_service,
    tenure,
    monthly_charges,
    total_charges
FROM dbo.vw_telco_churn_clean
WHERE churn = 'Yes'
ORDER BY monthly_charges DESC;
