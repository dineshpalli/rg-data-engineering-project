*Thanks to [Luke J Byrne](https://github.com/lukejbyrne) for the Repository! This is my fork of the [original repository](https://github.com/lukebyrne/azure-data-engineering-e2e-project) for my own learning and reference.*
*Please check out his [YouTube video](https://www.youtube.com/watch?v=ygJ11fzq_ik&t=4868s) for a detailed walkthrough of the project.*

# Azure End-to-End Data Engineering Real-Time Project

This project is a data engineering pipeline solution to a made-up business problem, created to aid in my learning and understanding of data pipelining.

## Problem Statement / Business Request

In this project, your company has recognized a gap in understanding its customer demographics—specifically, the gender distribution within the customer base and how it might influence product purchases. With a significant amount of customer data stored in an on-premises SQL database, key stakeholders have requested a comprehensive KPI dashboard. This dashboard should provide insights into sales by gender and product category, showing total products sold, total sales revenue, and a clear gender split among customers. Additionally, they need the ability to filter this data by product category and gender, with a user-friendly interface for date-based queries.

## Project Overview

This project addresses a critical business need by building a comprehensive data pipeline on Azure. The goal is to extract customer and sales data from an on-premises SQL database, transform it in the cloud, and generate actionable insights through a Power BI dashboard. The dashboard will highlight key performance indicators (KPIs) related to gender distribution and product category sales, allowing stakeholders to filter and analyze data by date, product category, and gender.

## Business Requirements

The business has identified a gap in understanding customer demographics—specifically gender distribution—and how it influences product purchases. The key requirements include:

1. **Sales by Gender and Product Category**: A dashboard showing the total products sold, total sales revenue, and a gender split among customers.
2. **Data Filtering**: Ability to filter the data by product category, gender, and date.
3. **User-Friendly Interface**: Stakeholders should have access to an easy-to-use interface for making queries.

## Solution Overview

To address this request, we'll build a robust data pipeline that extracts the on-premises data, loads it into Azure, and performs the necessary transformations to make the data more query-friendly. The transformed data will then feed into a custom-built report that meets all the specified requirements. This pipeline will be scheduled to run automatically every day, ensuring that stakeholders always have access to up-to-date and accurate data.

![Diagram illustrating an end-to-end Azure data engineering pipeline. Data originates from an On-Premises SQL Server, is ingested via Azure Data Factory, transformed through Bronze, Silver, and Gold layers in Azure Data Lake Storage Gen2 using Azure Databricks, and then loaded into Azure Synapse Analytics for visualization in Power BI. Supporting services like Azure Key Vault and Azure AD are also shown.](https://raw.githubusercontent.com/dineshpalli/rg-data-engineering-project/refs/heads/main/graphics/project_plan.png)

To meet these requirements, the solution is broken down into the following components:

1. **Data Ingestion**:
    - Extract customer and sales data from an on-premises SQL database.
    - Load the data into Azure Data Lake Storage (ADLS) using Azure Data Factory (ADF).

2. **Data Transformation**:
    - Use Azure Databricks to clean and transform the data.
    - Organize the data into Bronze, Silver, and Gold layers for raw, cleansed, and aggregated data respectively.

3. **Data Loading and Reporting**:
    - Load the transformed data into Azure Synapse Analytics.
    - Build a Power BI dashboard to visualize the data, allowing stakeholders to explore sales and demographic insights.

4. **Automation**:
    - Schedule the pipeline to run daily, ensuring that the data and reports are always up-to-date.

## Technology Stack

- **Azure Data Factory (ADF)**: For orchestrating data movement and transformation.
- **Azure Data Lake Storage (ADLS)**: For storing raw and processed data.
- **Azure Databricks**: For data transformation and processing.
- **Azure Synapse Analytics**: For data warehousing and SQL-based analytics.
- **Power BI**: For data visualization and reporting.
- **Azure Key Vault**: For securely managing credentials and secrets.
- **SQL Server (On-Premises)**: Source of customer and sales data.

## Setup Instructions

### Prerequisites

- An Azure account with sufficient credits.
- Access to an on-premises SQL Server database.

### Step 1: Azure Environment Setup

1. **Create Resource Group**: Set up a new resource group in Azure.
2. **Provision Services**:
   - Create an Azure Data Factory instance.
   - Set up Azure Data Lake Storage with `bronze`, `silver`, and `gold` containers.
   - Set up an Azure Databricks workspace and Synapse Analytics workspace.
   - Configure Azure Key Vault for secret management.

### Step 2: Data Ingestion

1. **Set up SQL Server**: Install SQL Server and SQL Server Management Studio (SSMS). Restore the AdventureWorks database.
2. **Ingest Data with ADF**: Create pipelines in ADF to copy data from SQL Server to the `bronze` layer in ADLS.

### Step 3: Data Transformation

1. **Mount Data Lake in Databricks**: Configure Databricks to access ADLS.
2. **Transform Data**: Use Databricks notebooks to clean and aggregate the data, moving it from `bronze` to `silver` and then to `gold`.

### Step 4: Data Loading and Reporting

1. **Load Data into Synapse**: Set up a Synapse SQL pool and load the `gold` data for analysis.
2. **Create Power BI Dashboard**: Connect Power BI to Synapse and create visualizations based on business requirements.

### Step 5: Automation and Monitoring

1. **Schedule Pipelines**: Use ADF to schedule the data pipelines to run daily.
2. **Monitor Pipeline Runs**: Use the monitoring tools in ADF and Synapse to ensure successful pipeline execution.

### Step 6: Security and Governance

1. **Manage Access**: Set up role-based access control (RBAC) using Azure Entra ID (formerly Active Directory).

### Step 7: End-to-End Testing

1. **Trigger and Test Pipelines**: Insert new records into the SQL database and verify that the entire pipeline runs successfully, updating the Power BI dashboard.

## Conclusion

This project provides a robust end-to-end solution for understanding customer demographics and their impact on sales. The automated data pipeline ensures that stakeholders always have access to the most current and actionable insights.

## Additional Resources
*I added a file called 'steps.md' to the repository, which contains a detailed step-by-step guide from the YouTube video for setting up the project. This guide is designed to help me replicate the project on my own Azure environment.*