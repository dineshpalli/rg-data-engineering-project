# Dinesh Palli's Notes - Collected from various sources

## [What is a schema?](https://www.datacamp.com/tutorial/database-schema)
In database management, a schema defines the structure of a database, outlining how data is organized, stored, and related. It's essentially a blueprint that specifies the tables, fields (columns), data types, relationships, and constraints within a database. Schemas help maintain data integrity, security, and organization.

## What are the components of a schema?
Let’s see what its key components are and how they contribute to the overall database schema: 

* Table is a collection of related data organized in rows and columns.
* Field is a column that contains information within a table.
* Data type specifies the kind of data a field can contain (e.g., integer, varchar, date).

A well-designed database schema ensures that the data is correct, the query performance is optimized, and your database can support business growth. But what does a well-designed database schema look like? Here’s what you need to know:

A good schema has certain constraints. Constraints are the rules for organizing data in a DBMS to maintain integrity.
A well-organized schema optimizes data storage and indexing to speed up searches. 
A well-defined schema automates everything, from routine updates to scaling up as the business grows. 
A good schema is flexible enough to adapt to changing business requirements without requiring a complete redesign.

## What are the database schema types?
Database schemas can be categorized into several types based on their structure and purpose. Here are some common types:
* **Physical Schema**: Defines how data is physically stored in the database, including file structures and storage allocation.
* **Logical Schema**: Represents the logical structure of the database, including tables, fields, and relationships, without considering how data is physically stored.
* **View Schema**: A virtual schema that provides a specific view of the data, often used to simplify complex queries or restrict access to certain data.
* **External Schema**: Represents how data is viewed by different users or applications, allowing for different perspectives on the same underlying data.
* **Conceptual Schema**: A high-level representation of the database structure, focusing on the overall organization and relationships between data without going into physical details.
* **Data Model Schema**: Defines the data model used in the database, such as relational, object-oriented, or document-based models.

## What are the types of database warehouse modelling schemas?
In data warehousing, schemas are used to organize and structure data for efficient querying and analysis. The most common types of database warehouse modeling schemas include:
* **Flat Schema**: A flat model schema is a 2-D array in which every column contains the same type of data/information and the elements with rows are related to each other. It is just like a table or a spreadsheet. This schema is better for small applications that do not contain complex data. A simple schema where all data is stored in a single table. It is easy to implement but not suitable for complex queries or large datasets. This schema is rarely used in practice due to its limitations in handling complex relationships and large volumes of data.

* **Star Schema**: A simple schema with a central fact table connected to multiple dimension tables. It is easy to understand and query, making it suitable for analytical queries. A denormalized data warehouse schema where a central fact table is connected to multiple dimension tables, each of which describes a single aspect of the fact data.

    Characteristics:

        • Simple and intuitive
        • Denormalized structure (fewer joins, faster queries)
        • Best suited for OLAP[ˆ1] operations and BI tools

    Components:

        • Fact Table: Contains measurable data (e.g., sales, revenue)
        • Dimension Tables: Contain descriptive attributes (e.g., customer, time, product)
    
    Diagram:

                +--------------+
                |  Time Dim    |
                +--------------+
                    |
        +-------------+-------------+-------------+-------------+
        |           Fact Table (Sales)           |
        +-------------+-------------+-------------+-------------+
        | Time_Key | Product_Key | Store_Key | Revenue | Units |
        +----------+-------------+-----------+---------+--------+
            |            |             |
            ↓            ↓             ↓
        +--------+   +-------------+   +------------+
        |Product |   |  Store      |   |  Customer  |
        | Dim    |   |  Dim        |   |  Dim       |
        +--------+   +-------------+   +------------+

* **Snowflake Schema**: An extension of the star schema where dimension tables are normalized into multiple related tables. This reduces data redundancy but can complicate queries. A snowflake schema is a normalized version of the star schema where dimension tables are split into additional tables (sub-dimensions).

    Characteristics:

        • Reduces data redundancy
        • More complex joins
        • Better space efficiency
        • Normalized structure (3NF or higher)

    Components:

        • Same core concept as Star Schema
        • Fact Table: Contains measurable data (e.g., sales, revenue)
        • Dimension Tables: Dimension tables are split into hierarchical sub-dimensions. Contain descriptive attributes, which may be further normalized into sub-dimensions
    
    Diagram:

                        +-------------+
                        |   Date Dim  |
                        +-------------+
                                |
                +---------------+-------------------+
                |                                   |
        +---------------+                  +----------------+
        |    Fact Table (Sales)           |
        +---------------+----------------+
        | Date_Key | Product_Key | Store_Key | Revenue |
        +----------+-------------+-----------+---------+
            |            |             |
            ↓            ↓             ↓
        +--------+     +------------+   +-------------+
        |Product |     | Store Dim |   | Customer Dim|
        | Dim    |     +------------+   +-------------+
        +--------+             |               |
                |        +-------------+      +--------------+
                |        | Region Dim  |      | City Dim     |
                |        +-------------+      +--------------+
                |                                     
        +------------+                          
        | Category   |
        | Dim        |
        +------------+


* **Galaxy Schema**: A galaxy schema consists of multiple fact tables that share dimension tables, making it more complex but powerful for handling multiple business processes. Also known as a fact constellation schema, it consists of multiple fact tables that share dimension tables. It is useful for complex data warehouses with multiple subject areas. 

    Characteristics:

        Used when multiple fact tables are required (e.g., orders, shipments, payments)
        • Shared dimension tables
        • Supports complex queries
        • Also called a fact constellation
    
    Components:
    
        • Multiple Fact Tables: Each representing a different business process (e.g., sales, inventory)
        • Shared Dimension Tables: Common dimensions used across multiple fact tables

    Diagram:

                        +-------------+
                        |  Date Dim   |
                        +-------------+
                            |
            +----------------+----------------+
            |                                 |
        +--------------+                +---------------+
        |  Fact Table  |                | Fact Table    |
        |  Sales       |                | Inventory     |
        +--------------+                +---------------+
        | Date_Key     |                | Date_Key      |
        | Product_Key  |                | Product_Key   |
        | Store_Key    |                | Store_Key     |
        | Revenue      |                | Stock_Level   |
        +--------------+                +---------------+
            |   |   |                       |   |
            ↓   ↓   ↓                       ↓   ↓
        +--------+ +----------+         +--------+ +---------+
        |Product | | Store    |         |Product | | Store   |
        | Dim    | | Dim      |         | Dim    | | Dim     |
        +--------+ +----------+         +--------+ +---------+


* **Relational Schema**: This schema is best suited for object-oriented programming languages that consider data about objects more valuable than logic and functions. In a relational database schema, each object is assigned its table, and these tables all connect to each other. For example, an e-commerce database has tables with products, customers, orders, and reviews—all related. Unlike the star or snowflake schema, it doesn’t have a central fact table. Instead, it has a flexible relationship between objects to increase efficiency in managing and retrieving data.

* **Hierarchical Schema**: This schema organizes data in a tree-like structure, where each record has a single parent and can have multiple children. It is less common in modern databases but can be useful for representing hierarchical relationships, such as organizational structures or file systems. In this schema, one root table connects to multiple child tables where each child has exactly one parent. For example, in a university system, a root table could include departments, with each department connecting to child tables for professors and courses. Professors can belong to only one department, but courses are assigned to a specific professor. The structure makes it easier to access frequently used data, such as course schedules and professor details.

* **Network Schema**: This schema is similar to the hierarchical schema but allows for more complex relationships, where records can have multiple parents and children. It is less common in modern databases but can be useful for representing many-to-many relationships, such as social networks or transportation systems. In this schema, each record can have multiple parent and child records, allowing for more complex relationships. For example, in a transportation system, a bus route can connect to multiple stops, and each stop can be part of multiple routes.

    *(From [Geeks for Geeks](https://www.geeksforgeeks.org/database-schemas/): The network model is similar to the hierarchical model in that it represents data using nodes (entities) and edges (relationships). However, unlike the hierarchical model, which enforces a strict parent-child relationship, the network model allows for more flexible many-to-many relationships. This flexibility means that a node can have multiple parent nodes and child nodes, making the structure more dynamic.*
    *The network model can contain cycles which is a situation where a path exists that allows you to start and end at the same node. These cycles enable more complex relationships and allow for greater data interconnectivity.)*

## Normalize the database
Normalization optimizes the data within your database by reducing redundant data and improving its integrity. There are several normal forms (1NF, 2NF, 3NF, BCNF, and more), but you should normalize up to the third normal form (3NF).

Look at the three normalization forms and their purpose here:

* 1NF: It removes all the redundant values.
* 2NF: It ensures all non-key attributes depend entirely on the primary key.
* 3NF: It ensures all non-key attributes are wholly dependent on the primary key and non-transitively dependent.


## Footnotes:

*[ˆ1]: **Online Analytical Processing (OLAP)**, is a technology that allows users to analyze large datasets quickly and efficiently, often using multidimensional databases. It's a key part of business intelligence (BI) and decision support, enabling users to explore data from different perspectives. OLAP is primarily used for business intelligence, decision support, and forecasting. It helps organizations analyze data to identify trends, make informed decisions, and predict future outcomes.*
