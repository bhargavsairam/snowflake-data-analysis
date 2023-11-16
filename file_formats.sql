// Creating a new schema to maintain everything in an organized manner
CREATE OR REPLACE SCHEMA MANAGE_DB.file_formats;

// Creating a file format object
CREATE OR REPLACE FILE FORMAT MANAGE_DB.FILE_FORMATS.my_file_format;

//Check properties of file format object
DESC file format manage_db.file_formats.my_file_format;

//Altering file format object
ALTER FILE FORMAT MANAGE_DB.FILE_FORMATS.MY_FILE_FORMAT
SET SKIP_HEADER = 1

// We can only create or replace a file format type but cannot Alter an existing file format as different file formats have different properties
CREATE OR REPLACE FILE FORMAT MANAGE_DB.file_formats.my_file_format
    TYPE = JSON,
    TIME_FORMAT = AUTO;

//Altering the type of file format is not possible
ALTER file format MANAGE_DB.file_formats.my_file_format
SET TYPE = CSV


CREATE OR REPLACE FILE FORMAT MANAGE_DB.file_formats.csv_file_format
    TYPE = CSV,
    FIELD_DELIMITER = ','
    SKIP_HEADER = 1;

DESC file format manage_db.file_formats.csv_file_format;

TRUNCATE MANAGE_DB.PUBLIC.ORDERS

COPY INTO MANAGE_DB.PUBLIC.ORDERS
FROM @MANAGE_DB.external_stages.aws_stage
file_format = (FORMAT_NAME = MANAGE_DB.file_formats.csv_file_format)
files = ('OrderDetails.csv')
