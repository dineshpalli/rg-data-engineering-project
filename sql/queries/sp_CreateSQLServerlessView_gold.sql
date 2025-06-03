-- Switch to the target database where the views should be created.
-- This assumes you've already created a database like 'gold_db' that will hold SQL views on Delta tables.
USE gold_db
GO

-- Create or modify a stored procedure named 'CreateSQLServerlessView_gold'.
-- This procedure dynamically creates or updates a SQL Serverless view that reads from Delta Lake files.
-- It takes a single input parameter: the name of the view (which also matches the folder name in ADLS).
CREATE OR ALTER PROC CreateSQLServerlessView_gold @ViewName nvarchar(100)
AS 
BEGIN
    -- Declare a variable to hold the dynamic SQL statement.
    DECLARE @statement VARCHAR(MAX)

    -- Build a dynamic CREATE OR ALTER VIEW statement that reads Delta format files
    -- from the gold layer in Azure Data Lake using OPENROWSET.
    -- Key notes:
    -- - 'BULK' points to the folder for the given table/view.
    -- - 'FORMAT = DELTA' tells SQL Serverless to interpret it as a Delta Lake table.
    -- - The view is named the same as the folder, assuming 1:1 mapping between view name and Delta folder name.
    SET @statement = N'CREATE OR ALTER VIEW ' + @ViewName + ' AS
        SELECT
            *
        FROM
            OPENROWSET(
                BULK ''https://datalakedeproj.dfs.core.windows.net/gold/SalesLT/' + @ViewName + '/'',
                FORMAT = ''DELTA''
            ) AS [result]'

    -- Execute the dynamic SQL statement to create or update the view.
    EXEC (@statement)
END
GO