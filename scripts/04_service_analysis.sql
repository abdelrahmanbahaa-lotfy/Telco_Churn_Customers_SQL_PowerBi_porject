/* ============================================================
   PURPOSE: Test whether the type/number of subscribed services
            relates to churn.
   WHAT IT MEASURES:
     - Churn rate by internet service type (DSL/Fiber optic/No)
     - Churn rate by each add-on service (online security, backup,
       device protection, tech support, streaming TV/movies)
     - Churn rate by NUMBER of add-on services a customer has
       (0 to 6) — tests whether more add-ons = more "stickiness"
   ============================================================ */

USE CustomerChurnIBM;
GO

-- Churn rate by internet service type
SELECT
    internet_service,
    COUNT(*)  AS customers,
    SUM(churn_flag)  AS churned,
    CAST(SUM(churn_flag) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS churn_rate_pct
FROM dbo.vw_telco_churn_clean
GROUP BY internet_service
ORDER BY churn_rate_pct DESC;

-- Churn rate by online_security
SELECT
    online_security,
    COUNT(*)  AS customers,
    CAST(SUM(churn_flag) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS churn_rate_pct
FROM dbo.vw_telco_churn_clean
GROUP BY online_security
ORDER BY churn_rate_pct DESC;

-- Churn rate by tech_support 
SELECT
    tech_support,
    COUNT(*)  AS customers,
    CAST(SUM(churn_flag) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS churn_rate_pct
FROM dbo.vw_telco_churn_clean
GROUP BY tech_support
ORDER BY churn_rate_pct DESC;

-- Number of add-on services per customer vs churn rate
WITH addon_counts AS (
    SELECT
        customer_id,
        churn_flag,
        (CASE WHEN online_security   = 'Yes' THEN 1 ELSE 0 END +
         CASE WHEN online_backup     = 'Yes' THEN 1 ELSE 0 END +
         CASE WHEN device_protection = 'Yes' THEN 1 ELSE 0 END +
         CASE WHEN tech_support      = 'Yes' THEN 1 ELSE 0 END +
         CASE WHEN streaming_tv      = 'Yes' THEN 1 ELSE 0 END +
         CASE WHEN streaming_movies  = 'Yes' THEN 1 ELSE 0 END
        ) AS addon_count
    FROM dbo.vw_telco_churn_clean
)
SELECT
    addon_count,
    COUNT(*)  AS customers,
    SUM(churn_flag) AS churned,
    CAST(SUM(churn_flag) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS churn_rate_pct
FROM addon_counts
GROUP BY addon_count
ORDER BY addon_count;
GO
