/* ============================================================
   PURPOSE: Combine the strongest individual risk factors to describe
            the "typical churner" instead of one variable at a time.
   WHAT IT MEASURES:
     - Churn rate for combined segments (contract + internet
       service + payment method), filtered to segments with a
       meaningful customer count, ranked by churn rate.
     - This is the query that supports the final "risk profile"
       narrative used in the report/dashboard conclusions.
   ============================================================ */

USE CustomerChurnIBM;
GO

SELECT
    contract,
    internet_service,
    payment_method,
    COUNT(*) AS customers,
    SUM(churn_flag) AS churned,
    CAST(SUM(churn_flag) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS churn_rate_pct,
    SUM(CASE WHEN churn = 'Yes' THEN monthly_charges ELSE 0 END) AS revenue_lost
FROM dbo.vw_telco_churn_clean
GROUP BY contract, internet_service, payment_method
HAVING COUNT(*) >= 30          
ORDER BY churn_rate_pct DESC;
GO
