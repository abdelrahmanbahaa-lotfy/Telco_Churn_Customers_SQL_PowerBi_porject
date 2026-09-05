/* ============================================================
   PURPOSE: Inspect data quality issues, then build a CLEAN VIEW
            (vw_telco_churn_clean) on top of the raw table.
   WHAT IT MEASURES:
     - Duplicate customer_id count
     - NULL / blank counts for total_charges
     - Row-level check: which customers have blank total_charges
   WHY A VIEW AND NOT ALTERING THE RAW TABLE:
     Keeps the original bulk-loaded data untouched (raw layer),
     while giving every analysis file a single, reliable, typed
     source to query from.
   ============================================================ */

USE CustomerChurnIBM;
GO

--  Check for duplicate customer_id
SELECT customer_id, COUNT(*) AS occurrences
FROM dbo.telco_customer_churn
GROUP BY customer_id
HAVING COUNT(*) > 1;


--  Inspect those specific rows (expected: tenure = 0, brand-new customers)
SELECT customer_id, tenure, monthly_charges, total_charges
FROM dbo.telco_customer_churn
WHERE LTRIM(RTRIM(total_charges)) = '';

--  Distinct value check on categorical columns prone to typos/variants
SELECT DISTINCT contract FROM dbo.telco_customer_churn;
SELECT DISTINCT internet_service FROM dbo.telco_customer_churn;
SELECT DISTINCT payment_method FROM dbo.telco_customer_churn;
SELECT DISTINCT churn FROM dbo.telco_customer_churn;
GO

/* ------------------------------------------------------------
   CLEAN VIEW
   - total_charges: blank -> NULL, then safely cast to decimal
   - churn_flag: Yes/No -> 1/0 for easy aggregation
   - tenure_group: buckets used across multiple analysis files
   - monthly_value_tier: High/Medium/Low based on monthly_charges
   ------------------------------------------------------------ */
CREATE OR ALTER VIEW dbo.vw_telco_churn_clean AS
SELECT
    customer_id,
    gender,
    senior_citizen,
    partner,
    dependents,
    tenure,
    phone_service,
    multiple_lines,
    internet_service,
    online_security,
    online_backup,
    device_protection,
    tech_support,
    streaming_tv,
    streaming_movies,
    contract,
    paperless_billing,
    payment_method,
    monthly_charges,
    TRY_CAST(NULLIF(LTRIM(RTRIM(total_charges)), '') AS DECIMAL(10,2)) AS total_charges,
    churn,
    CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END AS churn_flag,
    CASE
        WHEN tenure <= 6                    THEN '0-6 months'
        WHEN tenure BETWEEN 7 AND 12        THEN '7-12 months'
        WHEN tenure BETWEEN 13 AND 24       THEN '1-2 years'
        ELSE '2+ years'
    END AS tenure_group,
    CASE
        WHEN monthly_charges < 35  THEN 'Low'
        WHEN monthly_charges < 70  THEN 'Medium'
        ELSE 'High'
    END AS monthly_value_tier
FROM dbo.telco_customer_churn;
GO

-- Verify the view: row count should match raw table
SELECT COUNT(*) AS rows_in_view FROM dbo.vw_telco_churn_clean;
GO

SELECT * FROM dbo.vw_telco_churn_clean;
