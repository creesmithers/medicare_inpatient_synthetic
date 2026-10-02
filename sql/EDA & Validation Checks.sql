-- Date Validation
SELECT TOP 50
    BENE_ID,
    CLM_ID,
    CLM_FROM_DT,
    CLM_THRU_DT
FROM dbo.inpatient
WHERE TRY_CONVERT(date, CLM_THRU_DT, 106)
    < TRY_CONVERT(date, CLM_FROM_DT, 106);
SELECT COUNT(*) AS Missing_Dates
FROM dbo.inpatient
WHERE CLM_FROM_DT IS NULL
   OR CLM_THRU_DT IS NULL;

-- Claim Lengths
SELECT TOP 10
        BENE_ID,
        CLM_ID,
        CAST(DATEDIFF(day, CLM_FROM_DT, CLM_THRU_DT) AS INT) Claim_Length_Days
FROM dbo.inpatient
ORDER BY Claim_Length_Days DESC;

-- benefit amount exploration
WITH claim_checks AS(
SELECT
    BENE_ID,
    CLM_ID,
    CAST(CLM_PMT_AMT AS decimal(18,2))+(CAST(CLM_PASS_THRU_PER_DIEM_AMT AS decimal(18,2)) *
                    CAST(CLM_UTLZTN_DAY_CNT AS decimal(18,2))
            ) AS Total_Medicare_Payment,
    CLM_TOT_CHRG_AMT,
    ROW_NUMBER() OVER (
        PARTITION BY CLM_ID 
        ORDER BY CLM_LINE_NUM DESC) as rn
FROM dbo.inpatient
)
SELECT TOP 50 *
FROM claim_checks
WHERE rn = 1
ORDER BY Total_Medicare_Payment DESC;

-- Check for oldest patients
WITH all_beneficiaries AS (
    SELECT 2015 AS bene_year, * FROM dbo.beneficiary_2015
    UNION ALL
    SELECT 2016, * FROM dbo.beneficiary_2016
    UNION ALL
    SELECT 2017, * FROM dbo.beneficiary_2017
    UNION ALL
    SELECT 2018, * FROM dbo.beneficiary_2018
    UNION ALL
    SELECT 2019, * FROM dbo.beneficiary_2019
    UNION ALL
    SELECT 2020, * FROM dbo.beneficiary_2020
    UNION ALL
    SELECT 2021, * FROM dbo.beneficiary_2021
    UNION ALL
    SELECT 2022, * FROM dbo.beneficiary_2022
    UNION ALL
    SELECT 2023, * FROM dbo.beneficiary_2023
    UNION ALL
    SELECT 2024, * FROM dbo.beneficiary_2024
    UNION ALL
    SELECT 2025, * FROM dbo.beneficiary_2025
)
SELECT DISTINCT TOP 10
    BENE_ID,
    CAST(BENE_BIRTH_DT AS DATE) as Birth_Date
FROM all_beneficiaries
ORDER BY Birth_Date;


-- check yearly claims
SELECT 
    YEAR(CAST(CLM_FROM_DT AS DATE)) AS claim_year,
    MIN(CAST(CLM_FROM_DT AS DATE)) AS earliest_claim,
    MAX(CAST(CLM_FROM_DT AS DATE)) AS latest_claim,
    COUNT(*) AS row_count
FROM inpatient
GROUP BY YEAR(CAST(CLM_FROM_DT AS DATE))
ORDER BY claim_year;



