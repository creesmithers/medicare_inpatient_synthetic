# Medicare Inpatient Analysis

An end-to-end healthcare analytics project using CMS Synthetic Medicare data. I built the data pipeline from raw CSV files through Azure Data Factory and Azure SQL, then used Power BI to explore inpatient claims, Medicare payments, utilization, and beneficiary demographics.

## Why I Built This

I wanted to build a project that was closer to the type of work I would expect to see in a business intelligence or healthcare analytics role.

Rather than starting with a clean analysis-ready dataset, I wanted to work through the process of getting raw data into a usable form: loading the files, checking the data, handling the claim-level structure, combining beneficiary data across years, and building an analytical dataset that could be used in Power BI.

The main questions I wanted to answer were:

- How did Medicare payments change over the same period?
  - Which led to the question: How did inpatient claim volume change from 2015–2022?
  - And: Did payments grow at the same rate as claim volume?
- What was the average payment per inpatient claim?
- How many Medicare utilization days were associated with inpatient claims?
- What did the age and sex distribution of the inpatient population look like?

## Project Architecture

The project follows this basic workflow:

```text
CMS Synthetic Medicare Data
            ↓
    Azure Blob Storage
            ↓
    Azure Data Factory
            ↓
       Azure SQL
            ↓
         Power BI
```
## SQL Analysis
I used SQL to turn the ingested talbes into an analysis-ready dataset. 

Some of the main transformations included: 
- Combining beneficiary files from multiple years using UNION ALL
- Joinng beneficiary information to inpatient claims
- Converting dates to appropriate data types
- Calculating claim-level payment and utilization measures
- Checking for potential duplicates, inconsistent values, outliers, and incorrect values (such as claims ending before they began.)

I used CTEs to keep the transformation steps organized and easier to validate.

## Data Source
The project uses the CMS Synthetic Medicare Enrollment, Fee-for-Service Claims, and Prescription Drug Event Data.

The data is synthetic and is used for portfolio and analytical practice purposes.

## Author
Cree Smithers
Data Analytics \\ SQL \\ Power BI \\ Azure Data Factory
