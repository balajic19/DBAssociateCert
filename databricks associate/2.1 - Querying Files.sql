-- Databricks notebook source
-- MAGIC %run ./Includes/Copy-Datasets

-- COMMAND ----------

-- MAGIC %python
-- MAGIC files = dbutils.fs.ls(f"{dataset_bookstore}/customers-json")
-- MAGIC display(files)

-- COMMAND ----------

SELECT * FROM JSON.`${dataset.bookstore}/customers-json/export_*.json`

-- COMMAND ----------

SELECT count(*) FROM JSON.`${dataset.bookstore}/customers-json`

-- COMMAND ----------

SELECT *,
  input_file_name() source_file
FROM JSON.`${dataset.bookstore}/customers-json`

-- COMMAND ----------

SELECT * FROM TEXT.`${dataset.bookstore}/customers-json`

-- COMMAND ----------

SELECT * FROM binaryFile.`${dataset.bookstore}/customers-json`

-- COMMAND ----------

SELECT * FROM CSV.`${dataset.bookstore}/books-csv`

-- COMMAND ----------



-- COMMAND ----------

CREATE TABLE books_csv
    (book_id STRING, title STRING, author STRING, catergory STRING, price DOUBLE)
USING CSV
OPTIONS (
  header = "true",
  delimiter = ";"
)
LOCATION "${dataset.bookstore}/books-csv"

-- COMMAND ----------

SELECT * FROM books_csv

-- COMMAND ----------

DESCRIBE EXTENDED books_csv

-- COMMAND ----------

SELECT count(*) FROM books_csv

-- COMMAND ----------

-- MAGIC %python
-- MAGIC files = dbutils.fs.ls(f"{dataset_bookstore}/books-csv")
-- MAGIC display(files)

-- COMMAND ----------

-- MAGIC %python
-- MAGIC (spark.read
-- MAGIC         .table("books_csv")
-- MAGIC     .write
-- MAGIC         .mode("append")
-- MAGIC         .format("csv")
-- MAGIC         .option("header", "true")
-- MAGIC         .option("delimiter", ";")
-- MAGIC         .save(f"{dataset_bookstore}/books-csv"))

-- COMMAND ----------

-- MAGIC %python
-- MAGIC files = dbutils.fs.ls(f"{dataset_bookstore}/books-csv")
-- MAGIC display(files)

-- COMMAND ----------

SELECT count(*) FROM books_csv

-- COMMAND ----------

REFRESH TABLE books_csv

-- COMMAND ----------

SELECT count(*) FROM books_csv

-- COMMAND ----------

CREATE TABLE customers AS
SELECT * FROM JSON.`${dataset.bookstore}/customers-json`;

DESCRIBE EXTENDED customers

-- COMMAND ----------

-- %python
-- dbutils.fs.rm('dbfs:/user/hive/warehouse/customers', True)

-- COMMAND ----------

DESCRIBE EXTENDED customers

-- COMMAND ----------

SELECT * FROM CSV.`${dataset_bookstore}/books-csv`;

-- COMMAND ----------

CREATE TABLE books_unparsed AS
SELECT * FROM CSV.`${dataset.bookstore}/books-csv`;

SELECT * FROM books_unparsed;

-- COMMAND ----------

-- %python
-- dbutils.fs.rm('dbfs:/user/hive/warehouse/books', True)

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

DESCRIBE EXTENDED books;

-- COMMAND ----------


