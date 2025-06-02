This notes of the Azure end-to-end data engineering project guides you through extracting data from an on-premises SQL database, processing it via an automated daily pipeline, and finally, updating a Power BI dashboard. Here's a breakdown of the process:

**Phase 1: Setup and Configuration**

***Note:** Since I don't have access to a Windows machine, I created a virtual machine with Windows on Azure and followed the steps in the video to set up the environment. Write me if you want to know how I did that.*

1. **Set up an On-Premises SQL Database**:
    * **Why**: This database acts as the data source. The project's goal is to migrate this data to the cloud for analysis.
    * **How**:
        * Download the [AdventureWorks sample dataset](https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver17&tabs=ssms) from Microsoft to use as sample data. \[[09:15](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=555)\]
        * Download and install [SQL Server Express](https://go.microsoft.com/fwlink/p/?linkid=2216019&clcid=0x409&culture=en-us&country=us), a free version of [SQL Server](https://www.microsoft.com/en-us/sql-server/sql-server-downloads), to host your database. \[[10:06](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=606)\]
        * Download and install [SQL Server Management Studio (SSMS)](https://learn.microsoft.com/en-us/ssms/install/install) for managing your SQL Server and databases. \[[10:39](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=639)\]
        * Move the AdventureWorks database file to the SQL Server backup folder. \[[12:02](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=722)\]
        * In SSMS, connect to your SQL Server Express engine. \[[11:32](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=692)\]
        * Restore the AdventureWorks database from the backup file to make the data accessible. \[[12:49](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=769)\]

2. **Set up Azure Resources**:
    * **Why**: Azure provides the necessary cloud services for building the data pipeline and for storing/processing data.
    * **How**:
        * Sign up for a Microsoft Azure account; new users, students often receive free credits. \[[14:50](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=890)\]
        * **Create a Resource Group**: This acts as a container for all project-related Azure resources for easier management (e.g., `intech-RG`). \[[15:50](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=950)\]
        * **Create Azure Data Factory (ADF)**:
            * **Why**: ADF orchestrates and automates data movement and transformation, extracting data from your on-premises SQL server.
            * **How**: Create a Data Factory resource (e.g., `intech-df`) in your resource group. \[[18:03](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=1083)\]
        * **Create Azure Data Lake Storage Gen2 (ADLS Gen2)**:
            * **Why**: ADLS Gen2 stores raw and transformed data, optimized for big data analytics.
            * **How**: Create a Storage Account (e.g., `intechsg`), ensuring to enable the "Hierarchical namespace" in advanced settings to turn it into a data lake. \[[19:31](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=1171)\], \[[21:15](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=1275)\] Create containers `bronze` (raw data \[[05:01](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=301)\]), `silver` (cleaned/minor transformations \[[05:10](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=310)\]), and `gold` (fully transformed, ready for analytics \[[05:10](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=310)\]).
        * **Create Azure Databricks**:
            * **Why**: Databricks, an Apache Spark-based platform, is used for data processing and transformation (bronze to silver, silver to gold).
            * **How**: Create an Azure Databricks workspace (e.g., `intech-databricks`). \[[22:14](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=1334)\]
        * **Create Azure Synapse Analytics**:
            * **Why**: Synapse Analytics integrates data warehousing and big data analytics, loading transformed gold-layer data for Power BI.
            * **How**: Create a Synapse workspace (e.g., `intech-synapse`), linking it to your ADLS Gen2 account and allowing it to create a new file system (e.g., `synapsefs`). \[[23:33](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=1413)\], \[[24:13](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=1453)\]
        * **Create Azure Key Vault**:
            * **Why**: Key Vault securely stores secrets like passwords and connection strings.
            * **How**: Create a Key Vault resource (e.g., `intech-kv`). \[[27:24](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=1644)\]

3. **Set up Power BI**:
    * **Why**: Power BI is used for creating interactive dashboards and reports.
    * **How**:
        * A work or school account is needed. A workaround involves signing up for a Microsoft 365 trial to get a work email for Power BI. \[[31:11](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=1871)\]
        * Download and install Power BI Desktop, preferably from the Microsoft Store for automatic updates. \[[32:27](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=1947)\]

**Phase 2: Data Ingestion (On-Prem SQL to Azure Data Lake - Bronze Layer)**

1. **Prepare SQL Server for Data Factory Access**:
    * **Why**: Data Factory needs credentials and permissions to access your on-premises SQL database.
    * **How**:
        * In SSMS, create a SQL login (e.g., `look2`) with a password. \[[34:56](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=2096)\]
        * Create a user in the AdventureWorks database mapped to this login and grant `SELECT` permissions (e.g., `GRANT SELECT ON SCHEMA::SalesLT TO look2`). \[[58:34](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=3514)\]
        * Ensure your SQL Server instance is running (SQL Server Configuration Manager). \[[34:16](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=2056)\]
        * In SSMS server properties, enable "SQL Server and Windows Authentication mode". \[[48:19](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=2899)\]

2. **Store SQL Credentials in Azure Key Vault**:
    * **Why**: For secure management of SQL username and password.
    * **How**: In Azure Key Vault, create secrets for the username and password. \[[35:51](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=2151)\] Grant your account necessary permissions on Key Vault if needed. \[[36:36](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=2196)\]

3. **Configure Azure Data Factory for Ingestion**:
    * **Why**: To build the data extraction pipeline.
    * **How**:
        * **Launch Data Factory Studio.** \[[33:47](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=2027)\]
        * **Create a Self-Hosted Integration Runtime (SHIR)**:
            * **Why**: SHIR connects Data Factory in the cloud to your on-premises SQL Server.
            * **How**: Create a self-hosted IR in Data Factory, then download and install SHIR software on your SQL Server machine or a machine on the same network. \[[42:48](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=2568)\]
        * **Create Linked Service for Azure Key Vault**:
            * **Why**: Allows Data Factory to retrieve secrets from Key Vault.
            * **How**: Create a Key Vault linked service in Data Factory. Grant Data Factory's Managed Identity "Key Vault Secrets User" role on your Key Vault. \[[45:30](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=2730)\], \[[46:13](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=2773)\]
        * **Create Linked Service for On-Prem SQL Server**:
            * **Why**: Defines the connection to your source database.
            * **How**: Create a SQL Server linked service using SHIR, SQL Authentication, and retrieve credentials from Key Vault. Test connection, possibly setting "Encrypt connection" to "Optional". \[[42:09](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=2529)\], \[[49:33](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=2973)\]
        * **Create Linked Service for Azure Data Lake Storage (Bronze)**:
            * **Why**: Defines the connection to the destination data lake.
            * **How**: Create an ADLS Gen2 linked service. \[[51:56](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=3116)\]
        * **Create Datasets**:
            * **SQL Server Source Dataset**: Represents data in on-prem SQL tables. \[[41:37](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=2497)\]
            * **ADLS Gen2 Sink Dataset (Parquet for Bronze)**: Represents data in the bronze layer, using Parquet format and parameterized file paths. \[[51:30](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=3090)\]
        * **Create Ingestion Pipeline (`CopyAllTables`)**:
            * **`Lookup` Activity**: Dynamically gets a list of tables from your SQL database (e.g., `SELECT TABLE_SCHEMA, TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'SalesLT'`). \[[56:16](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=3376)\]
            * **`ForEach` Activity**: Iterates over the table list from the `Lookup` activity. \[[59:31](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=3571)\], \[[01:04:41](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=3881)\]
                * **Inside `ForEach`, add `Copy Data` Activity**: Copies data for each table.
                    * **Source**: Uses SQL Server source dataset with a dynamic query (e.g., `@concat('SELECT * FROM ', item().TABLE_SCHEMA, '.', item().TABLE_NAME)`). \[[01:00:05](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=3605)\], \[[01:06:13](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=3973)\]
                    * **Sink**: Uses ADLS Gen2 (Parquet) sink dataset with parameterized file paths (e.g., `bronze/SalesLT/{tableName}/{tableName}.parquet`). \[[01:01:02](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=3662)\]
        * **Publish and Trigger**: Publish Data Factory changes and trigger the pipeline to test. \[[01:06:27](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=3987)\]

**Phase 3: Data Transformation (Bronze -> Silver -> Gold using Azure Databricks)**

1. **Set up Azure Databricks Cluster**:
    * **Why**: Provides compute for transformation notebooks.
    * **How**: Create a "Single Node" cluster for the free trial, enable "Credential passthrough", and set an inactivity termination time. \[[01:13:13](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=4393)\], \[[01:18:16](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=4696)\], \[[01:15:12](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=4512)\], \[[01:14:48](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=4488)\]

2. **Mount ADLS Gen2 to DBFS (Optional)**:
    * **Why**: Simplifies ADLS access from Databricks.
    * **How**: Use a notebook with `dbutils.fs.mount` to mount `bronze`, `silver`, `gold` containers. \[[01:16:30](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=4590)\], \[[01:19:42](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=4782)\]

3. **Create Transformation Notebooks**:
    * **Bronze to Silver (`BronzeToSilver` notebook)**:
        * **Why**: Initial cleaning and data type conversions (e.g., standardizing date formats).
        * **How (PySpark)**: Iterate through Parquet files in bronze, read into Spark DataFrame, convert date columns to `yyyy-MM-dd` format, and write to silver layer in Delta format. \[[01:23:06](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=4986)\], \[[01:23:37](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=5017)\], \[[01:24:21](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=5061)\], \[[01:27:46](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=5266)\], \[[01:28:01](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=5281)\]
    * **Silver to Gold (`SilverToGold` notebook)**:
        * **Why**: Prepares data for analytics (e.g., aggregations, joins, changing column names to snake_case).
        * **How (PySpark)**: Iterate through Delta tables in silver, read into Spark DataFrame, convert column names to snake_case, and write to gold layer in Delta format. \[[01:32:19](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=5539)\], \[[01:32:32](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=5552)\], \[[01:32:48](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=5568)\], \[[01:35:36](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=5736)\]

4. **Integrate Databricks Notebooks into Data Factory Pipeline**:
    * **Why**: Automates transformation steps after ingestion.
    * **How**:
        * **Generate Databricks Access Token**: Create and copy a new token from Databricks user settings. \[[01:38:21](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=5901)\]
        * **Store Token in Key Vault**: Create a Key Vault secret for the Databricks token. \[[01:39:02](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=5942)\]
        * **Create Databricks Linked Service in ADF**: Connect to Databricks workspace using the access token from Key Vault. \[[01:37:48](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=5868)\]
        * **Add Notebook Activities to ADF Pipeline**: Add `Notebook` activities for "Bronze to Silver" and "Silver to Gold" in your ADF pipeline, setting dependencies and notebook paths. \[[01:37:18](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=5838)\], \[[01:40:41](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=6041)\]
        * Publish and test.

**Phase 4: Loading Data into Azure Synapse Analytics (for Power BI)**

1. **Create a Serverless SQL Database in Synapse**:
    * **Why**: Creates a logical database for defining views over gold-layer data.
    * **How**: In Synapse Studio, create a "Serverless" SQL database (e.g., `GoldDB`). \[[01:44:45](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=6285)\], \[[01:46:00](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=6360)\]

2. **Create Views in Synapse over Gold Data**:
    * **Why**: Provides a SQL interface to Delta tables without moving data.
    * **How (Automated Method Recommended)**:
        * **Create a Stored Procedure in `GoldDB`**: Write a stored procedure (e.g., `usp_CreateViewForTable`) to dynamically create views for tables using `OPENROWSET` to read Delta data from the gold layer. \[[01:48:46](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=6526)\]
        * **Create a Synapse Pipeline**:
            * Create a linked service for the Serverless SQL Pool in Synapse. \[[01:49:45](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=6585)\]
            * Create a dataset for gold layer files. \[[01:51:42](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=6702)\]
            * Use `Get Metadata` activity to list table folders in the gold layer. \[[01:51:31](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=6691)\]
            * Use `ForEach` activity to iterate through tables.
                * Inside `ForEach`, add a `Stored Procedure` activity to call `usp_CreateViewForTable` for each table. \[[01:53:56](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=6836)\]
            * Publish and run this Synapse pipeline once. \[[01:57:21](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=7041)\]

**Phase 5: Data Visualization in Power BI**

1. **Connect Power BI to Synapse Analytics**:
    * **Why**: To pull data from Synapse views for reporting.
    * **How**: In Power BI Desktop, "Get Data" -> "Azure Synapse Analytics SQL". Enter Serverless SQL endpoint, `GoldDB`, and authenticate. Load the views. \[[01:58:51](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=7131)\], \[[01:59:11](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=7151)\], \[[02:00:04](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=7204)\]

2. **Model Data in Power BI**:
    * **Why**: To define relationships between tables for correct filtering.
    * **How**: In Power BI's "Model" view, create/modify relationships between tables (views) based on common keys (e.g., `CustomerID`). Define cardinality and cross-filter direction. It's suggested to delete auto-detected relationships and create them manually. \[[02:00:59](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=7259)\], \[[02:10:46](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=7846)\]

3. **Build the Dashboard**:
    * **Why**: To present insights according to business requirements.
    * **How**:
        * **Cards**: For "Total Products" and "Total Sales Revenue". \[[02:04:19](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=7459)\], \[[02:05:58](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=7558)\]
        * **Donut Chart**: For gender split (using "Title" as a proxy). \[[02:07:50](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=7670)\]
        * **Slicers**: For "Product Category" and "Gender". \[[02:08:45](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=7725)\]
        * Ensure visuals interact correctly. \[[02:10:00](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=7800)\]

**Phase 6: Automation and Security**

1. **Automate the ADF Pipeline**:
    * **Why**: For daily updates to the dashboard.
    * **How**: In Data Factory, add a daily schedule trigger to your main pipeline. \[[02:13:27](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=8007)\]

2. **Test End-to-End Automation**:
    * **Why**: To verify the entire process.
    * **How**: Add new data to your on-premises SQL database. \[[02:16:02](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=8162)\] Wait for the ADF pipeline (or trigger manually). Refresh Power BI Desktop to see updated visuals. \[[02:29:32](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=8972)\]

3. **Azure Active Directory (Entra ID) for Security (Conceptual)**:
    * **Why**: Manage access to Azure resources using groups for better scalability.
    * **How**: Create a Security Group in Entra ID (e.g., "Data Engineers"). \[[02:18:57](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=8337)\] Add users to the group. Assign roles/permissions to the *group* on Azure resources. \[[02:20:17](http://www.youtube.com/watch?v=ygJ11fzq_ik&t=8417)\]

*This comprehensive guide covers the main steps and their purposes as detailed in the [video](https://www.youtube.com/watch?v=ygJ11fzq_ik&t=4868s).*