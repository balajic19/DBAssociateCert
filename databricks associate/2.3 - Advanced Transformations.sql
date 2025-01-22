-- Databricks notebook source
-- MAGIC %run
-- MAGIC ./Includes/Copy-Datasets

-- COMMAND ----------

-- MAGIC  %python
-- MAGIC dbutils.fs.rm('dbfs:/user/hive/warehouse/customers', True)

-- COMMAND ----------

CREATE TABLE customers AS
SELECT * FROM JSON.`${dataset.bookstore}/customers-json`;

-- COMMAND ----------

SELECT * FROM customers

-- COMMAND ----------

DESCRIBE customers;

-- COMMAND ----------

 SELECT customer_id, profile:first_name, profile:address:country FROM customers;

-- COMMAND ----------

SELECT profile FROM customers LIMIT 1;

-- COMMAND ----------

CREATE OR REPLACE TEMP VIEW parsed_customers AS
SELECT customer_id, from_json(profile, schema_of_json('{"first_name":"Dniren","last_name":"Abby","gender":"Female","address":{"street":"768 Mesta Terrace","city":"Annecy","country":"France"}}')) AS profile_struct FROM customers

-- COMMAND ----------

SELECT * FROM parsed_customers;

-- COMMAND ----------

DESCRIBE parsed_customers

-- COMMAND ----------

SELECT customer_id, profile_struct.first_name, profile_struct.address.country FROM parsed_customers

-- COMMAND ----------

CREATE OR REPLACE TEMP VIEW customers_final AS
SELECT customer_id, profile_struct.*
FROM parsed_customers;

SELECT * FROM customers_final;

-- COMMAND ----------

-- MAGIC %python
-- MAGIC dbutils.fs.rm('dbfs:/user/hive/warehouse/orders', True)

-- COMMAND ----------

CREATE TABLE orders AS
SELECT * FROM PARQUET.`${dataset.bookstore}/orders`

-- COMMAND ----------

SELECT order_id, customer_id, books
FROM orders

-- COMMAND ----------

SELECT order_id, customer_id, explode(books) AS book FROM orders;

-- COMMAND ----------

SELECT customer_id,
  collect_set(order_id) AS order_set,
  collect_set(books.book_id) AS book_set
FROM orders
GROUP BY customer_id;

-- COMMAND ----------

SELECT customer_id,
  collect_set(books.book_id) AS before_flatten,
  array_distinct(flatten(collect_set(books.book_id))) AS after_flatten
FROM orders
GROUP BY customer_id;

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

MERGE INTO books b
USING books_update u
ON b.book_id = u.book_id AND b.title = u.title
WHEN NOT MATCHED AND u.catergory = 'Computer Science' THEN
INSERT *


-- COMMAND ----------

SELECT * FROM books;

-- COMMAND ----------

CREATE OR REPLACE TEMP VIEW orders_enriched AS
SELECT * 
FROM (
  SELECT *, explode(books) AS book
  FROM orders) o 
INNER JOIN books b
ON o.book.book_id = b.book_id;

SELECT * FROM orders_enriched

-- COMMAND ----------

CREATE OR REPLACE TEMP VIEW orders_updates
AS SELECT * FROM PARQUET.`${dataset.bookstore}/orders-new`;

SELECT * FROM orders
UNION
SELECT * FROM orders_updates

-- COMMAND ----------

SELECT * FROM orders
INTERSECT
SELECT * FROM orders_updates

-- COMMAND ----------

SELECT * FROM orders
MINUS
SELECT * FROM orders_updates

-- COMMAND ----------

CREATE OR REPLACE TABLE transactions AS

SELECT * FROM (
  SELECT 
    customer_id,
    book.book_id AS book_id,
    book.quantity AS quantity
  FROM orders_enriched
) PIVOT (
  sum(quantity) FOR book_id in (
    'B01', 'B02', 'B03', 'B04', 'B05', 'B06',
    'B07', 'B8', 'B09', 'B010', 'B11', 'B12'
  )
);

SELECT * FROM transactions;

-- COMMAND ----------


