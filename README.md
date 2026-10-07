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
