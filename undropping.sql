CREATE OR REPLACE STAGE MANAGE_DB.external_stages.time_travel_stage
URL = 's3://data-snowflake-fundamentals/time-travel/'
FILE_FORMAT = MANAGE_DB.file_formats.csv_file;

CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.customers(
id INT,
first_name STRING,
last_name STRING,
email STRING,
gender STRING,
job STRING,
phone string
);

COPY INTO OUR_FIRST_DB.PUBLIC.customers
FROM @manage_db.external_stages.time_travel_stage
files = ('customers.csv')

SELECT * FROM OUR_FIRST_DB.public.customers;
// Dropping table
DROP TABLE OUR_FIRST_DB.public.customers;

UNDROP TABLE OUR_FIRST_DB.public.customers;

//Dropping Schema
DROP SCHEMA OUR_FIRST_DB.public;

UNDROP SCHEMA OUR_FIRST_DB.public;

// Dropping Database
DROP DATABASE OUR_FIRST_DB;

UNDROP DATABASE OUR_FIRST_DB;

