-- Databricks notebook source
-- MAGIC %run
-- MAGIC ./Includes/Copy-Datasets

-- COMMAND ----------

SELECT * FROM orders LIMIT 6;

-- COMMAND ----------

SELECT
  order_id,
  books,
  filter(books, i -> i.quantity >= 2) AS multiple_copies
FROM orders;

-- COMMAND ----------

SELECT order_id, multiple_copies
FROM (
  SELECT
    order_id,
    filter(books, i -> i.quantity >= 2) AS multiple_copies
  FROM orders)
WHERE size(multiple_copies) > 0;

-- COMMAND ----------

SELECT
  order_id,
  books,
  transform(
    books,
    b -> CAST(b.subtotal * 0.8 AS INT)
  ) AS subtotal_after_discount
FROM orders;

-- COMMAND ----------

CREATE OR REPLACE FUNCTION get_url(email STRING)
RETURNS STRING

RETURN concat("https://www.", split(email, "@")[1])

-- COMMAND ----------

SELECT email, get_url(email) domain
FROM customers;

-- COMMAND ----------

DESCRIBE FUNCTION get_url

-- COMMAND ----------

DESCRIBE FUNCTION EXTENDED get_url

-- COMMAND ----------

CREATE OR REPLACE FUNCTION site_type(email STRING)
RETURNS STRING
RETURN CASE
          WHEN email like "%.com" THEN "Commercial business"
          WHEN email like "%.org" THEN "Non profit"
          WHEN email like "%.edu" THEN "Edu inst"
          ELSE concat("Unknown extension for domain ", split(email, "@")[1])
      END;


-- COMMAND ----------

SELECT email, site_type(email) AS domain_category
FROM customers;

-- COMMAND ----------

DROP FUNCTION get_url

-- COMMAND ----------


