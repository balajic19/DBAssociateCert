-- Databricks notebook source
CREATE TABLE IF NOT EXISTS managed_default
  (width INT, length INT, height INT);

INSERT INTO managed_default
VALUES
  (3, 2, 1)

-- COMMAND ----------

DESCRIBE EXTENDED managed_default

-- COMMAND ----------

-- MAGIC %fs ls 'dbfs:/mnt/'

-- COMMAND ----------

CREATE TABLE IF NOT EXISTS external_default
  (width INT, length INT, height INT)
LOCATION 'dbfs:/mnt/demo/external_default';

INSERT INTO external_default
VALUES
  (3, 2, 1)

-- COMMAND ----------

-- MAGIC %fs ls 'dbfs:/mnt/demo/external_default'

-- COMMAND ----------

DESCRIBE EXTENDED external_default

-- COMMAND ----------

DROP TABLE managed_default;

-- COMMAND ----------

DROP TABLE external_default;

-- COMMAND ----------

-- MAGIC %fs ls 'dbfs:/mnt/demo/external_default'

-- COMMAND ----------

CREATE SCHEMA new_default

-- COMMAND ----------

DESCRIBE DATABASE EXTENDED new_default

-- COMMAND ----------

USE new_default;

CREATE TABLE IF NOT EXISTS managed_default
  (width INT, length INT, height INT);

INSERT INTO managed_default
VALUES
  (3, 2, 1);

-----------------------------------

CREATE TABLE IF NOT EXISTS external_default
  (width INT, length INT, height INT)
LOCATION 'dbfs:/mnt/demo/external_default';

INSERT INTO external_default
VALUES
  (3, 2, 1);

-- COMMAND ----------

DESCRIBE EXTENDED managed_default;

-- COMMAND ----------

DESCRIBE EXTENDED external_default;

-- COMMAND ----------

DROP TABLE managed_default;
DROP TABLE external_default;

-- COMMAND ----------

CREATE DATABASE custom
LOCATION 'dbfs:/Shared/schemas/custom.db'

-- COMMAND ----------

DESCRIBE DATABASE EXTENDED custom

-- COMMAND ----------

USE custom;

CREATE TABLE IF NOT EXISTS managed_custom
  (width INT, length INT, height INT);

INSERT INTO managed_custom
VALUES
  (3, 2, 1);

-----------------------------------

CREATE TABLE IF NOT EXISTS external_custom
  (width INT, length INT, height INT)
LOCATION 'dbfs:/mnt/demo/external_default';

INSERT INTO external_custom
VALUES
  (3, 2, 1);

-- COMMAND ----------

DESCRIBE EXTENDED managed_custom;

-- COMMAND ----------

DESCRIBE EXTENDED external_custom

-- COMMAND ----------

DROP TABLE managed_custom;
DROP TABLE external_custom;

-- COMMAND ----------


