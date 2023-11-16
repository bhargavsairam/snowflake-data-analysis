CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.employees(
id INT,
first_name STRING,
last_name STRING,
email STRING,
location STRING,
department STRING
)

CREATE OR REPLACE file format MANAGE_DB.file_formats.csv_fileformat
type = csv
field_delimiter = ','
skip_header = 1
null_if = ('NULL','null')
empty_field_as_null = TRUE;


CREATE OR REPLACE STAGE MANAGE_DB.external_stages.csv_folder
URL = 's3://bucket-for-snowflake-data/snowpipe/'
STORAGE_INTEGRATION = s3_init
FILE_FORMAT = MANAGE_DB.file_formats.csv_fileformat

LIST @MANAGE_DB.external_stages.csv_folder;


CREATE OR REPLACE SCHEMA MANAGE_DB.pipes


CREATE OR REPLACE PIPE MANAGE_DB.pipes.employee_pipe
auto_ingest = TRUE
AS
COPY INTO OUR_FIRST_DB.PUBLIC.employees
FROM @manage_db.external_stages.csv_folder;


DESC pipe MANAGE_DB.pipes.employee_pipe
//copy notification_channel value to s3 bucket's -> properties -> event notification -> create event -> copy arn path


SELECT * FROM our_first_db.public.employees;

SHOW pipes;