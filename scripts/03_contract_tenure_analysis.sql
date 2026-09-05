/* ============================================================
   PURPOSE: Test whether contract type and how long a customer
            has stayed relate to churn.
   WHAT IT MEASURES:
     - Churn rate per contract type (Month-to-month/One year/Two year)
     - Churn rate per tenure bucket (0-6m / 7-12m / 1-2y / 2+y)
     - Average tenure per contract type (does a longer contract
       correlate with customers actually staying longer?)
   ============================================================ */

USE CustomerChurnIBM;
GO

-- Churn rate by contract type
SELECT
    contract,
    COUNT(*)  AS customers,
    SUM(churn_flag) AS churned,
    CAST(SUM(churn_flag) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS churn_rate_pct
FROM dbo.vw_telco_churn_clean
GROUP BY contract
ORDER BY churn_rate_pct DESC;        -- we need to make offers for Month-to-month cust 
                                     -- to make contracts one or two year
--  Churn rate by tenure bucket
SELECT
    tenure_group,
    COUNT(*)  AS customers,
    SUM(churn_flag)  AS churned,
    CAST(SUM(churn_flag) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS churn_rate_pct
FROM dbo.vw_telco_churn_clean
GROUP BY tenure_group
ORDER BY
    CASE tenure_group
        WHEN '0-6 months'  THEN 1
        WHEN '7-12 months' THEN 2
        WHEN '1-2 years'   THEN 3
        ELSE 4
    END;

-- Average tenure per contract type (proves/disproves commitment effect)
SELECT
    contract,
    AVG(CAST(tenure AS DECIMAL(10,2))) AS avg_tenure_months
FROM dbo.vw_telco_churn_clean
GROUP BY contract
ORDER BY avg_tenure_months DESC;

-- Cross-tab: contract x tenure bucket churn rate (combined risk view)
SELECT
    contract,
    tenure_group,
    COUNT(*)  AS customers,
    CAST(SUM(churn_flag) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS churn_rate_pct
FROM dbo.vw_telco_churn_clean
GROUP BY contract, tenure_group
ORDER BY contract, churn_rate_pct DESC;
GO
