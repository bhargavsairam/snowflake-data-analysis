LIST @manage_db.external_stages.aws_stage;


CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.ORDERS (
    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30)
);

COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS
FROM @manage_db.external_stages.aws_stage
file_format = (type = csv field_delimiter = ',',skip_header=1)
pattern = '.*OrderDetails.*';



CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.ORDERS_CACHING (
    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30),
    DATE DATE
);

INSERT INTO ORDERS_CACHING
SELECT 
t1.ORDER_ID,
t1.AMOUNT,
t1.PROFIT,
t1.QUANTITY,
t1.CATEGORY,
t1.SUBCATEGORY,
DATE(UNIFORM(1500000000,1700000000,(RANDOM())))
FROM ORDERS t1
CROSS JOIN(SELECT * FROM ORDERS) t2
CROSS JOIN(SELECT TOP 100 * FROM ORDERS) t3;

// for first time run, it takes longer than second time run as the result will be stored into cache
SELECT * FROM ORDERS_CACHING WHERE DATE = '2020-06-09';
//since we are clustering it on date, when we try to filter the table using date, our query will run faster.
ALTER TABLE ORDERS_CACHING CLUSTER BY (DATE);

SELECT * FROM ORDERS_CACHING WHERE DATE = '2020-01-05';


DROP TABLE ORDERS_CACHING;
