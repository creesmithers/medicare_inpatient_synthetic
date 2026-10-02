--CREATE VIEW full_inpatient_data AS
WITH claims AS (
    SELECT
        BENE_ID,
        CLM_ID,
        CLM_PASS_THRU_PER_DIEM_AMT,
        CAST(CLM_FROM_DT AS date) AS Claim_Start,
        CAST(CLM_THRU_DT AS date) AS Claim_End,
        CAST(CAST(CLM_PMT_AMT AS decimal(18,2))+(CAST(CLM_PASS_THRU_PER_DIEM_AMT AS decimal(18,2)) *
                    CAST(CLM_UTLZTN_DAY_CNT AS decimal(18,2))
            ) AS decimal(18,2)) AS Total_Medicare_Payment,
        CAST(CLM_TOT_CHRG_AMT AS decimal(18,2)) AS Total_Charges,
        CLM_LINE_NUM
    FROM dbo.inpatient
    WHERE CLM_LINE_NUM = '1'
),

all_beneficiaries AS (
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
),

beneficiary_demographics AS (
    SELECT
        bene_year,
        BENE_ID,
        MAX(BENE_BIRTH_DT) AS BENE_BIRTH_DT,
        MAX(SEX_IDENT_CD) AS SEX_IDENT_CD,
        MAX(BENE_RACE_CD) AS BENE_RACE_CD
    FROM all_beneficiaries
    GROUP BY
        bene_year,
        BENE_ID
),

claims_analysis AS(
SELECT
    c.BENE_ID,
    c.CLM_ID,
    c.Claim_Start,
    c.Claim_End,
    YEAR(Claim_Start) AS Claim_Year,
    MONTH(Claim_Start) AS Start_Claim_Month,
    CAST(DATEDIFF(day, c.Claim_Start, c.Claim_End)+1 AS INT) Claim_Length_Days,
    c.Total_Medicare_Payment,
    c.Total_Charges,
    b.BENE_BIRTH_DT,
    DATEDIFF(YEAR, b.BENE_BIRTH_DT, c.Claim_Start)
        -
        CASE
            WHEN DATEADD(YEAR, DATEDIFF(YEAR, b.BENE_BIRTH_DT, c.Claim_Start), b.BENE_BIRTH_DT) > c.Claim_Start
            THEN 1
            ELSE 0
        END AS Age,
    CASE
        WHEN b.SEX_IDENT_CD = '1' THEN 'Male'
        WHEN b.SEX_IDENT_CD = '2' THEN 'Female'
        ELSE 'Unknown'
    END AS Sex,
    CASE
        WHEN b.BENE_RACE_CD = '1' THEN 'White'
        WHEN b.BENE_RACE_CD = '2' THEN 'Black'
        WHEN b.BENE_RACE_CD = '3' THEN 'Other'
        WHEN b.BENE_RACE_CD = '4' THEN 'Asian'
        WHEN b.BENE_RACE_CD = '5' THEN 'Hispanic'
        WHEN b.BENE_RACE_CD = '6' THEN 'North American Native'
        ELSE 'Unknown'
    END AS Race

FROM claims c
LEFT JOIN beneficiary_demographics b 
    ON c.BENE_ID = b.BENE_ID
    AND YEAR(c.Claim_Start) = b.bene_year
)

SELECT
    *,
    CASE
        WHEN Age < 65 THEN '<65'
        WHEN Age BETWEEN 65 AND 69 THEN '65-69'
        WHEN Age BETWEEN 70 AND 74 THEN '70-74'
        WHEN Age BETWEEN 75 AND 79 THEN '75-79'
        WHEN Age BETWEEN 80 AND 84 THEN '80-84'
        WHEN Age >= 85 THEN '85+'
        ELSE 'Unknown'
        END AS Age_Bucket
FROM claims_analysis
WHERE Claim_Year BETWEEN 2015 AND 2022;