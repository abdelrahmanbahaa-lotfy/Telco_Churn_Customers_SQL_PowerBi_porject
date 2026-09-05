/* ============================================================
   PURPOSE: Create the database, create the raw staging table,
            and bulk-load the Telco Customer Churn CSV into it.
   NOTE: This is the RAW layer. No cleaning happens here on
         purpose 
   ============================================================ */


create Database CustomerChurnIBM;


use CustomerChurnIBM;


CREATE TABLE telco_customer_churn (
	customer_id varchar(10) ,
	gender varchar(10) ,
	senior_citizen int ,
	partner varchar(10) , 
	dependents varchar(10) ,
	tenure int ,
	phone_service varchar(10) ,
	multiple_lines varchar(30) ,
	internet_service varchar(30) ,
	online_security varchar(50) ,
	online_backup varchar(50) ,
	device_protection varchar(50) ,
	tech_support varchar(50) ,
	streaming_tv varchar(50) ,
	streaming_movies varchar(50) ,
	contract varchar(50) ,
	paperless_billing varchar(10) ,
	payment_method varchar(50) ,
	monthly_charges float ,
	total_charges varchar(10) , -- there are nulls 
	churn varchar(10) 
);

truncate table telco_customer_churn;

BULK INSERT dbo.telco_customer_churn 
from 'C:\sql\Customer Churn  SQL Power Bi Project\Telco-Customer-Churn.csv'
WITH (
    FIRSTROW = 2,         -- Skips the header row
    FIELDTERMINATOR = ',',-- Character that separates columns
	ROWTERMINATOR = '0x0a', -- This line is critical to separate the rows
	TABLOCK
);

 
