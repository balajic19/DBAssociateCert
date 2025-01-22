-- Databricks notebook source
-- MAGIC %run
-- MAGIC ./Includes/Copy-Datasets

-- COMMAND ----------

-- MAGIC %python
-- MAGIC dbutils.fs.rm('dbfs:/user/hive/warehouse/orders', True)

-- COMMAND ----------

CREATE TABLE orders AS
SELECT * FROM PARQUET.`${dataset.bookstore}/orders`

-- COMMAND ----------

SELECT * FROM orders;

-- COMMAND ----------

CREATE OR REPLACE TABLE orders AS
SELECT * FROM PARQUET.`${dataset.bookstore}/orders`;

-- COMMAND ----------

DESCRIBE HISTORY orders;

-- COMMAND ----------

INSERT OVERWRITE orders
SELECT * FROM PARQUET.`${dataset.bookstore}/orders`

-- COMMAND ----------

DESCRIBE HISTORY orders;

-- COMMAND ----------

INSERT OVERWRITE orders
SELECT *, current_timestamp() FROM PARQUET.`${dataset.bookstore}/orders`

-- COMMAND ----------

INSERT INTO orders
SELECT * FROM PARQUET.`${dataset.bookstore}/orders-new`

-- COMMAND ----------

SELECT count(*) FROM orders

-- COMMAND ----------

DESCRIBE HISTORY orders

-- COMMAND ----------

-- MAGIC %python
-- MAGIC dbutils.fs.rm('dbfs:/user/hive/warehouse/customers', True)

-- COMMAND ----------

CREATE TABLE customers AS
SELECT * FROM JSON.`${dataset.bookstore}/customers-json`;

-- COMMAND ----------

CREATE OR REPLACE TEMP VIEW customers_updates AS
SELECT * FROM JSON.`${dataset.bookstore}/customers-json-new`;

MERGE INTO customers c
USING customers_updates u
ON c.customer_id = u.customer_id
WHEN MATCHED AND c.email IS NULL AND u.email IS NOT NULL THEN
  UPDATE SET email = u.email, updated = u.updated
WHEN NOT MATCHED THEN INSERT *

-- COMMAND ----------

CREATE OR REPLACE TEMP VIEW books_update
    (book_id STRING, title STRING, author STRING, catergory STRING, price DOUBLE)
USING CSV
OPTIONS(
  path = '${dataset.bookstore}/books-csv-new',
  header = 'true',
  delimiter = ';'
);

SELECT * FROM books_update

-- COMMAND ----------

-- MAGIC %python
-- MAGIC dbutils.fs.rm('dbfs:/user/hive/warehouse/books', True)

-- COMMAND ----------

CREATE OR REPLACE TEMP VIEW books_tmp_vw
    (book_id STRING, title STRING, author STRING, catergory STRING, price DOUBLE)
USING CSV
OPTIONS(
  path = "${dataset.bookstore}/books-csv/export*.csv",
  header = "true",
  delimiter = ";"
);


CREATE TABLE books AS
SELECT * FROM books_tmp_vw;

SELECT * FROM books;

-- COMMAND ----------

SELECT * FROM books;

-- COMMAND ----------

MERGE INTO books b
USING books_update u
ON b.book_id = u.book_id AND b.title = u.title
WHEN NOT MATCHED AND u.catergory = 'Computer Science' THEN
INSERT *


-- COMMAND ----------

MERGE INTO books b
USING books_update u
ON b.book_id = u.book_id AND b.title = u.title
WHEN NOT MATCHED AND u.catergory = 'Computer Science' THEN
INSERT *


-- COMMAND ----------


