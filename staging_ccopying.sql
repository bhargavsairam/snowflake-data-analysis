// creating a database 
CREATE OR REPLACE DATABASE MANAGE_DB;
//creating a schema inside a database
CREATE OR REPLACE SCHEMA external_stages;

//creating my staging area which serves as a stage with my AWS s3 bucket credentials
CREATE STAGE my_stage
URL = "s3://bucket-for-snowflake-data/stage-and-copy/"
CREDENTIALS = (AWS_KEY_ID = 'AKIAZXN344AARXZWZY4W' AWS_SECRET_KEY = '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');

//describing my staging area
DESC STAGE MANAGE_DB.external_stages.my_stage

//creating a staging area with aws public bucket
CREATE OR REPLACE STAGE MANAGE_DB.external_stages.aws_stage
url = 's3://bucketsnowflakes3'

//listing contents of public aws bucket
LIST @aws_stage

//creating a table in database
CREATE OR REPLACE TABLE MANAGE_DB.PUBLIC.ORDERS(
    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30)
);

SELECT * FROM MANAGE_DB.public.orders;

//copying contents of staging area csv file to data warehouse
COPY INTO MANAGE_DB.PUBLIC.ORDERS
FROM @aws_stage
file_format = (type = CSV field_delimiter = ',',skip_header = 1)
files = ('OrderDetails.csv')

SELECT * FROM MANAGE_DB.public.orders;

CREATE OR REPLACE TABLE manage_db.public.orders_ex1(
    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT INT,
    CATEGORY_SUBSTRING VARCHAR(255)
);

COPY INTO MANAGE_DB.PUBLIC.orders_ex1
FROM(SELECT
        s.$1,
        s.$2,
        s.$3,
        CASE WHEN CAST(s.$3 as INT) <0 THEN 'NOT PROFITABLE' ELSE 'PROFITABLE' END
        FROM @MANAGE_DB.external_stages.aws_stage s)
        file_format = (type = csv field_delimiter = ',' skip_header = 1)
        files = ('OrderDetails.csv')


SELECT * FROM MANAGE_DB.PUBLIC.ORDERS_EX1;
