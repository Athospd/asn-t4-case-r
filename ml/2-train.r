# Databricks notebook source
library(tidyverse)
library(tidymodels)
library(mlflow)
library(sparklyr)
library(shapviz)
library(kernelshap)

f <- glue::glue
options(repr.plot.width=1000, repr.plot.height=500)

source("scripts/parametros.R")

spark <- spark_connect(method = "databricks")

# COMMAND ----------

# MAGIC %md
# MAGIC # Dados

# COMMAND ----------

# O data.frame tem que estar na memoria do R, nao pode ser uma tabela do spark
livedoteo_df = tbl(spark, training_set_path) |> 
  collect() |>
  mutate(
    !!vr := as.character(!!vr),
    aleatorio1 = runif(n()),
    aleatorio2 = runif(n()),
    aleatorio3 = runif(n())
  )

display(livedoteo_df)

# COMMAND ----------

# Splits train test e cv
set.seed(4)

# Splits
livedoteo_split <- livedoteo_df |> group_initial_split(publico)

livedoteo_train <- training(livedoteo_split)
livedoteo_oot <- testing(livedoteo_split)
livedoteo_cv_folds <- vfold_cv(livedoteo_train, v = 5)

# COMMAND ----------

# MAGIC %md
# MAGIC # Dataprep/Pipeline

# COMMAND ----------

features = c(FEATURES, "aleatorio1", "aleatorio2", "aleatorio3")
features_numericas = features
features_nominais = c()

livedoteo_pipeline <- recipe(livedoteo_train) |>
  update_role(everything(), new_role = "support") |> 
  update_role(vr, new_role = "outcome") |>
  update_role(features, new_role = "predictor") |>
  step_mutate(
    across(features_numericas, as.numeric)
  ) |>
  step_impute_median(features_numericas) |>
  step_discretize(all_numeric_predictors(), options = list(num_breaks = 10)) |>
  step_integer(all_predictors())

# os passos da pipe
livedoteo_pipeline

# COMMAND ----------

# Olhar como q ficaram as transformacoes
livedoteo_pipeline |>
  prep() |> 
  bake(livedoteo_train |> head(10)) |> 
  display()

# COMMAND ----------

# MAGIC %md
# MAGIC # Modelo

# COMMAND ----------

# modelo
livedoteo_rf_model <- rand_forest(
    trees = tune(), 
    mtry = tune()
  ) %>%
  set_engine("ranger", importance = "impurity") %>%
  set_mode("classification")

# workflow: modelo + pipeline juntos
livedoteo_rf_wf <- workflow() %>%
  add_recipe(livedoteo_pipeline) %>%
  add_model(livedoteo_rf_model)

# COMMAND ----------

# MAGIC %md
# MAGIC # Experimento MLFlow

# COMMAND ----------

# Create or load an existing MLflow experiment
experiment_name <- f("/Users/{username}/experiments/livedoteo")
experiment_id = mlflow_set_experiment(experiment_name)

f("Experiment ID: {experiment_id}")

# COMMAND ----------

# MAGIC %md
# MAGIC # Tunagem de hiperparam

# COMMAND ----------

livedoteo_rf_param_set <- livedoteo_rf_wf |>
  extract_parameter_set_dials() |> 
  update(
    mtry = finalize(mtry(), mtcars)
  )

livedoteo_rf_param_set

# COMMAND ----------

# roda a tunagem
livedoteo_rf_tune <- tune_bayes(
    livedoteo_rf_wf,
    resamples = livedoteo_cv_folds,
    param_info = livedoteo_rf_param_set,
    initial = 5,
    iter = 3,
    metrics = metric_set(roc_auc),
    control = control_bayes(no_improve = 3, verbose = TRUE)
  )

# tabela com resultados
livedoteo_rf_tune_metrics = collect_metrics(livedoteo_rf_tune, type = "wide")


# COMMAND ----------

show_best(livedoteo_rf_tune, metric = "roc_auc") |> display()

# COMMAND ----------

display(livedoteo_rf_tune_metrics)

# COMMAND ----------

# Update do workflow com os melhores params
# Melhor conjunto de hiperparams
# livedoteo_rf_best_params <- select_best(livedoteo_rf_tune, metric = "roc_auc")

livedoteo_rf_best_params <- tibble(mtry = 11, trees = 500)
livedoteo_rf_wf_final <- finalize_workflow(livedoteo_rf_wf, livedoteo_rf_best_params)

# Ajusta modelo na base de treino inteira
livedoteo_rf_last_fit <- livedoteo_rf_wf_final |> last_fit(livedoteo_split)

# COMMAND ----------

# base com valores preditos 
livedoteo_rf_preds <- collect_predictions(livedoteo_rf_last_fit) 

livedoteo_rf_preds |> head() |> display()

# COMMAND ----------

# Log no MLFlow
# run <- mlflow_start_run()

livedoteo_rf_last_fit_roc_auc_oos <- livedoteo_rf_last_fit |> collect_metrics(type = "wide") |> pull(roc_auc)

mlflow_log_param("mtry", livedoteo_rf_best_params$mtry)
mlflow_log_param("trees", livedoteo_rf_best_params$trees)
mlflow_log_metric("roc_auc_oos", livedoteo_rf_last_fit_roc_auc_oos)

# COMMAND ----------

#### Curva ROC 
roc_plot <- livedoteo_rf_preds |>
  roc_curve(!!vr, .pred_0) |>
  autoplot() +
  annotate("text", x = 0.7, y = 0.3, label = f("ROC AUC: {round(livedoteo_rf_last_fit_roc_auc_oos, 2)}"))

ggsave(roc_plot, filename = "roc_plot.png")
mlflow_log_artifact("roc_plot.png")

roc_plot

# COMMAND ----------

library(vip)

fitted_model <- extract_fit_parsnip(livedoteo_rf_last_fit)
vip(fitted_model)

# COMMAND ----------

# Prepare the test data
test_data_prep <- bake(
  prep(livedoteo_pipeline), 
  new_data = livedoteo_oot
) |>
  select(all_of(features))

# Extract the fitted model engine
fitted_model <- extract_fit_parsnip(livedoteo_rf_last_fit)

# Generate SHAP values
shap_rf <- fitted_model |> 
  kernelshap(
    X = test_data_prep |> head(1000), 
    bg_X = test_data_prep |> head(5), 
    type = "prob"
  ) |> 
  shapviz()

# Plot SHAP importance
sv_importance(shap_rf, kind = "both", show_numbers = TRUE)

# COMMAND ----------

fitted_model |> predict(livedoteo_df, type = "prob")
livedoteo_rf_last_fit |> extract_workflow() |> predict(livedoteo_df, type = "prob")
# AUC no tempo
# Shap Values
# Estabilidade features

# log images and artifacts

# COMMAND ----------

crated_model <- carrier::crate(
  function(x) workflows:::predict.workflow(livedoteo_rf_model, x),
  livedoteo_rf_model = extract_workflow(livedoteo_rf_last_fit)
)

mlflow_log_model(
  crated_model,
  artifact_path = "model"
)

# COMMAND ----------

mlflow_end_run()
