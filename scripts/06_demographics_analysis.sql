/* ============================================================
   PURPOSE: Test whether demographic traits relate to churn.
   WHAT IT MEASURES:
     - Churn rate by gender
     - Churn rate by senior citizen status
     - Churn rate by partner status
     - Churn rate by dependents status
     - Churn rate by all 
   ============================================================ */

USE CustomerChurnIBM;
GO

--  Churn rate by gender
SELECT
    gender,
    COUNT(*)  AS customers,
    CAST(SUM(churn_flag) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS churn_rate_pct
FROM dbo.vw_telco_churn_clean
GROUP BY gender;

--  Churn rate by senior citizen status
SELECT
    CASE WHEN senior_citizen = 1 THEN 'Senior' ELSE 'Non-senior' END AS senior_status,
    COUNT(*)  AS customers,
    CAST(SUM(churn_flag) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS churn_rate_pct
FROM dbo.vw_telco_churn_clean
GROUP BY CASE WHEN senior_citizen = 1 THEN 'Senior' ELSE 'Non-senior' END;

--Churn rate by partner status
SELECT
    partner,
    COUNT(*)  AS customers,
    CAST(SUM(churn_flag) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS churn_rate_pct
FROM dbo.vw_telco_churn_clean
GROUP BY partner;

-- Churn rate by dependents status
SELECT
    dependents,
    COUNT(*)  AS customers,
    CAST(SUM(churn_flag) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS churn_rate_pct
FROM dbo.vw_telco_churn_clean
GROUP BY dependents;
GO

-- churn rate by all previous

SELECT
    CASE WHEN senior_citizen = 1 THEN 'Senior' ELSE 'Non-senior' END AS senior_status,
    partner,
    dependents,
    COUNT(*)  AS customers,
    CAST(SUM(churn_flag) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS churn_rate_pct
FROM dbo.vw_telco_churn_clean
GROUP BY CASE WHEN senior_citizen = 1 THEN 'Senior' ELSE 'Non-senior' END
, partner ,  dependents
ORDER BY CAST(SUM(churn_flag) * 100.0 / COUNT(*) AS DECIMAL(5,2)) DESC;
