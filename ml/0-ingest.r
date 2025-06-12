# Databricks notebook source
# MAGIC %sh
# MAGIC which python > /tmp/python_path.txt

# COMMAND ----------

python_path <- readLines("/tmp/python_path.txt")
Sys.setenv(RETICULATE_PYTHON = python_path)
python_path

# COMMAND ----------

# MAGIC %python
# MAGIC %pip install setuptools py4j pandas arrow
# MAGIC %restart_python

# COMMAND ----------

install.packages("reticulate")
install.packages("sparklyr")
install.packages("pysparklyr")

library(tidyverse)
library(sparklyr)
library(pysparklyr)
library(reticulate)

# COMMAND ----------

os <- import("os")
# use_python("/usr/local/lib/python3.12")
print(python_path)
use_python(python_path)

# COMMAND ----------

# conexao
sc <- spark_connect(method = "databricks")

# COMMAND ----------

# exemplo de escrita de delta table
mtcars_id <- mtcars %>% rownames_to_column("car_id")
mtcars_tbl <- copy_to(sc, mtcars_id, "mtcars_id", overwrite = TRUE)
spark_write_table(mtcars_tbl, "mtcars_id", mode = "overwrite")

# COMMAND ----------

mtcars_db <- tbl(sc, "mtcars_id")

# COMMAND ----------

# Import the necessary modules
fs <- import("databricks.feature_engineering")
fe <- fs$FeatureEngineeringClient()

# COMMAND ----------

# MAGIC %python
# MAGIC from databricks.feature_store import FeatureStoreClient
# MAGIC
# MAGIC # Initialize the Feature Store client
# MAGIC fs = FeatureStoreClient()
# MAGIC
# MAGIC # Load data into a DataFrame
# MAGIC data = spark.read.table("mtcars_id")
# MAGIC
# MAGIC # Define the feature table name
# MAGIC feature_table_name = "databricks_asn.default.mtcars_fs"
# MAGIC
# MAGIC # Write the DataFrame to the feature store
# MAGIC fs.create_table(
# MAGIC     name=feature_table_name,
# MAGIC     primary_keys=["car_id"],
# MAGIC     df=data,
# MAGIC     schema=data.schema,
# MAGIC     description="mtcars do R"
# MAGIC )

# COMMAND ----------


