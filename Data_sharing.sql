CREATE OR REPLACE DATABASE DATA_S;

CREATE OR REPLACE STAGE aws_stage
URL = 's3://bucketsnowflake3';


CREATE OR REPLACE TABLE ORDERS (
    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30)
);

COPY INTO ORDERS
FROM @manage_db.external_stages.aws_stage
file_format = (type = csv field_delimiter = ',',skip_header=1)
pattern = '.*OrderDetails.*';

SELECT * FROM ORDERS;

// Create or Share object
CREATE OR REPLACE SHARE ORDERS_SHARE;

//Grant usage on database
GRANT USAGE ON DATABASE DATA_S TO SHARE ORDERS_SHARE;

//GRANT USAGE ON SCHEMA
GRANT USAGE ON SCHEMA DATA_S.PUBLIC TO SHARE ORDERS_SHARE;

//GRANT USAGE ON TABLE
GRANT SELECT ON TABLE DATA_S.PUBLIC.ORDERS TO SHARE ORDERS_SHARE;

SHOW GRANTS TO SHARE ORDERS_SHARE;


// add customer account ID
ALTER SHARE ORDERS_SHARE AND ACCOUNT = <consumer-account-id>



--create reader account--
CREATE MANAGED ACCOUNT test_account
ADMIN_NAME = 'test_admin_name'
ADMIN_PASSWORD = 'set_pwd_test_admin'
TYPE = READER;


//Show Accounts
SHOW MANAGED ACCOUNTS;


--share data

ALTER SHARE ORDERS_SHARE
ADD ACCOUNT = <consumer-account-id>

//create the reader account from the url provided by above query
// Then check for shares using "Show Shares" and Describe Share <shareID>
// create ware house initally and create data base using shared data base.


