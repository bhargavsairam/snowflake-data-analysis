CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.test(
id INT,
first_name STRING,
last_name STRING,
email STRING,
gender STRING,
job STRING,
phone string
);

CREATE OR REPLACE file format MANAGE_DB.file_formats.csv_file
type = csv
field_delimiter = ','
skip_header = 1;

CREATE OR REPLACE STAGE MANAGE_DB.external_stages.time_travel_stage
URL = 's3://data-snowflake-fundamentals/time-travel/'
FILE_FORMAT = MANAGE_DB.file_formats.csv_file

LIST @manage_db.external_stages.time_travel_stage

COPY INTO OUR_FIRST_DB.PUBLIC.test
FROM @manage_db.external_stages.time_travel_stage
files = ('customers.csv')


SELECT * FROM OUR_FIRST_DB.PUBLIC.test;

//adding the first name wrong without any filter conditions. Now we need to get back our original DB.
UPDATE OUR_FIRST_DB.public.test
SET FIRST_NAME = 'joyen'

// one way is to select the offset based on when we might have saved the correct data. In this case, I have selected in last 2 minutes with time stamp.
SELECT * FROM OUR_FIRST_DB.public.test at (OFFSET => -60*2)

ALTER SESSION SET TIMEZONE = 'UTC';
SELECT DATEADD(DAY,1,CURRENT_TIMESTAMP);

//2023-11-17 21:45:13.897 +0000
//second way is using timestamp.
SELECT * FROM OUR_FIRST_DB.PUBLIC.test before(timestamp =>'2023-11-16 21:45:13.897 +0000'::timestamp)

//3rd way -> using query ID to get queries before specified query that was run.
SELECT * FROM OUR_FIRST_DB.public.test before(statement => '01b0603c-0404-d46a-0001-eceb0002416e')


//Restoring data from time travel
//Bad Method
CREATE OR REPLACE TABLE OUR_FIRST_DB.public.test AS
SELECT * FROM OUR_FIRST_DB.public.test before(statement => '01b0603c-0404-d46a-0001-eceb0002416e')

//Now we cannot go back beyond the above id because when we ran the above query, the table was dropped and created newly effectively erasing previous history.

//Good method
CREATE OR REPLACE TABLE OUR_FIRST_DB.public.test1 AS
SELECT * FROM OUR_FIRST_DB.public.test before(statement => '01b0603c-0404-d46a-0001-eceb0002416e')


TRUNCATE TABLE our_first_db.public.test

INSERT INTO OUR_FIRST_DB.public.test
SELECT * FROM OUR_FIRST_DB.public.test1


