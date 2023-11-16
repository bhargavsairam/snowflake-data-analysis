CREATE OR REPLACE storage integration  s3_init
TYPE = EXTERNAL_STAGE
STORAGE_PROVIDER = S3
ENABLED = TRUE
STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::*********'
STORAGE_ALLOWED_LOCATIONS = ('s3://bucket-for-snowflake-data')
COMMENT = 'Creating connection to S3'

DESC integration s3_init;


//We need to create an IAM role with access to S3 and then once we create the storage integration object with storage_aws_role_arn copied from IAM role, 
//We need to run the description of storage integration object. We need to copy the storage_aws_external_id property value and paste it in
//trust policy - sts:externalId value and then copy the storage_aws_iam_user_arn value and paste it in AWS key-value pair.



CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.ORDERS_S3_INT(
    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30)
);

CREATE OR REPLACE file format MANAGE_DB.file_formats.csv_fileformat
type = csv
field_delimiter = ','
skip_header = 1
null_if = ('NULL','null')
empty_field_as_null = TRUE;


CREATE OR REPLACE stage MANAGE_DB.external_stages.csv_folder
URL = 's3://bucket-for-snowflake-data'
STORAGE_INTEGRATION = s3_init
FILE_FORMAT = MANAGE_DB.file_formats.csv_fileformat


COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_S3_INT
FROM @manage_db.external_stages.aws_stage;