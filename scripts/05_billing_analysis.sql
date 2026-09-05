/* ============================================================
   PURPOSE: Test whether how a customer pays / is billed relates
            to churn.
   WHAT IT MEASURES:
     - Churn rate by payment method (Electronic check / Mailed
       check / Bank transfer / Credit card)
     - Churn rate by paperless billing (Yes/No)
     - Average monthly charges: churned vs stayed customers
   ============================================================ */

USE CustomerChurnIBM;
GO

-- Churn rate by payment method
SELECT
    payment_method,
    COUNT(*)  AS customers,
    SUM(churn_flag)  AS churned,
    CAST(SUM(churn_flag) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS churn_rate_pct
FROM dbo.vw_telco_churn_clean
GROUP BY payment_method
ORDER BY churn_rate_pct DESC;

-- Churn rate by paperless billing
SELECT
    paperless_billing,
    COUNT(*)  AS customers,
    CAST(SUM(churn_flag) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS churn_rate_pct
FROM dbo.vw_telco_churn_clean
GROUP BY paperless_billing
ORDER BY churn_rate_pct DESC;

-- Monthly charges: churned vs stayed (is price a factor?)
SELECT
    churn,
    COUNT(*) AS customers,
    AVG(monthly_charges) AS avg_monthly_charges,
    MIN(monthly_charges) AS min_monthly_charges,
    MAX(monthly_charges)  AS max_monthly_charges
FROM dbo.vw_telco_churn_clean
GROUP BY churn;
GO
