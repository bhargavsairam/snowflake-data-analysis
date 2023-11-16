CREATE OR REPLACE STAGE MANAGE_DB.EXTERNAL_STAGES.JSONSTAGE
url = 's3://bucketsnowflake-jsondemo';

CREATE OR REPLACE file format MANAGE_DB.FILE_FORMATS.JSONFORMAT
TYPE = JSON;

CREATE DATABASE OUR_FIRST_DB;

CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.JSON_RAW(
    raw_file variant
);


COPY INTO OUR_FIRST_DB.PUBLIC.JSON_RAW
FROM @MANAGE_DB.EXTERNAL_STAGES.JSONSTAGE
file_format = MANAGE_DB.FILE_FORMATS.JSONFORMAT
files = ('HR_data.json')

SELECT * FROM OUR_FIRST_DB.PUBLIC.JSON_RAW

// extracting individual columns from json table
SELECT 
RAW_FILE:id::int as id,
$1:first_name::string AS FIRSTNAME, 
RAW_FILE:last_name::string AS last_name,
RAW_FILE:gender::string AS gender,
RAW_FILE:city::string AS CITY
FROM OUR_FIRST_DB.PUBLIC.JSON_RAW;

//Handling nested data

SELECT RAW_FILE:job.salary::INT as salary, RAW_FILE:job.title::STRING AS title FROM OUR_FIRST_DB.PUBLIC.JSON_RAW; 

//Handling array values
SELECT RAW_FILE:prev_company[0]::string as prev_company FROM OUR_FIRST_DB.PUBLIC.JSON_RAW // gets one previous company

// Here we have an array of languages spoken by people and their levels in language. we want to flatten it to store it in data warehouse
SELECT RAW_FILE:spoken_languages as spoken_languages FROM OUR_FIRST_DB.PUBLIC.JSON_RAW;

//creating a table language from our raw_file table and table with flatten on spoken languages.
CREATE OR REPLACE TABLE LANGUAGES AS 
SELECT 
RAW_FILE:first_name::STRING AS first_name,
f.value:language::STRING AS language,
f.value:level::STRING AS level
from OUR_FIRST_DB.PUBLIC.JSON_RAW, table(flatten(RAW_FILE:spoken_languages)) f

SELECT * FROM languages;

