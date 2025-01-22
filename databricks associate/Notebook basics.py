# Databricks notebook source
print("hello world")

# COMMAND ----------

# MAGIC %sql
# MAGIC SELECT "HELLO WORLD FROM SQL!"

# COMMAND ----------

# MAGIC %run ./Includes/Setup

# COMMAND ----------

# MAGIC %fs ls '/databricks-datasets'

# COMMAND ----------

dbutils.help()

# COMMAND ----------

dbutils.fs.help()

# COMMAND ----------

files = dbutils.fs.ls('/databricks-datasets')
print(files)

# COMMAND ----------

display(files)

# COMMAND ----------


