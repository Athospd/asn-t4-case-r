# Databricks notebook source
install.packages(c("plotly"))

# COMMAND ----------

library(tidyverse)
library(tidymodels)
library(mlflow)
library(sparklyr)
library(plotly)

f <- glue::glue
options(repr.plot.width=1000, repr.plot.height=500)

source("scripts/parametros.R")

spark <- spark_connect(method = "databricks")

# COMMAND ----------

FEATURES

# COMMAND ----------

# MAGIC %md
# MAGIC # Dados

# COMMAND ----------

base <- tbl(spark, "ingestao")

display(base)

# COMMAND ----------

FEATURES = c(
  "qtdIdadeDias", "QtdDiasUltTransacao", 
  "qtdTransacoes", "qtdTransacoesDia", "pctDia01", "pctDia02", 
  "pctDia03", "pctDia04", "pctDia05", "pctDia06", "pctDia07", "pctManha", 
  "pctTarde", "pctNoite", "pctMadrugada", "pctChatMessage", "pctListaPresenca", 
  "pctResgatarPonei", "pctPresencaStreak", "pctTrocaPontosStreamElements", 
  "qtdTransacaoDiaD7", "qtdTransacaoDiaD14", "qtdTransacaoDiaD28", 
  "qtdTransacaoDiaD56", "qtPontos", "qtPontosAbs", "vlPontosPos", 
  "vlPontosNeg", "vlPontosPosD7", "vlPontosNegD7", "vlPontosPosD14", 
  "vlPontosNegD14", "vlPontosPosD28", "vlPontosNegD28", "vlPontosPosD56", 
  "vlPontosNegD56", "qtdPontosDia", "qtdPontosDiaD7", "qtdPontosDiaD14", 
  "qtdPontosDiaD28", "qtdPontosDiaD56", "qtMinutosAssistidos", 
  "vlIFRBruto", "vlIFRPlus1", "vlIFRPlus1Case", "vlGanhoLiquido", 
  "avgIntervalDays", "medianIntervalDays", "maxIntervalDays", "stdIntervalDays", 
  "qtdInterval28days"
)

id = as.symbol("idCliente")
vr = as.symbol("flagAtividade")
data = as.symbol("dtRef")

# Enriquecimento usando Feature Store (ou usando um left join)
base_enriquecida = base |>
  select(data, id, vr, all_of(FEATURES))

display(base_enriquecida)

# COMMAND ----------

# missing
base_enriquecida |> 
  mutate(across(everything(), ~ na_if(.x, "null"))) |>
  mutate(across(everything(), is.na)) |>
  summarise(across(everything(),  ~mean(as.numeric(.x), na.rm = TRUE))) |>
  pivot_longer(everything()) |>
  arrange(desc(value)) |>
  display()

# COMMAND ----------

# VR vs tempo
base_enriquecida |>
  group_by(data, vr) |>
  count() |>
  mutate(
    !!vr := as.character(!!vr)
  ) |>
  ggplot(aes(x = !!data, y = n, fill = !!vr)) +
  geom_col() 

# COMMAND ----------

# Retira safras censuradas e cria plano de separacao de bases
set.seed(1)
base_enriquecida_com_publico <- base_enriquecida |>
  mutate(
    publico = case_when(
      !!data >= "2025-01-01" ~ "remover",
      !!data >= "2024-10-01" ~ "OOT",
      TRUE ~ "TREINO"
    )
  )

# COMMAND ----------

# Publico vs tempo
base_enriquecida_com_publico |>
  group_by(data, publico) |>
  count() |>
  ggplot(aes(x = !!data, y = n, fill = publico)) +
  geom_col()

# COMMAND ----------

# Publico vs tempo
base_enriquecida_com_publico |>
  ggplot(aes(x = !!data, y = !!vr, colour = publico)) +
  stat_summary(geom = "line") +
  stat_summary(geom = "point") +
  labs(title = f("% de {vr}"))


# COMMAND ----------

base_enriquecida_com_publico |>
  filter(publico != "remover") |>
  group_by(publico) |>
  summarise(
    qtd = n(),
    p_vr = round(mean(!!vr), 2)
  ) |>
  ungroup() |>
  mutate(
    p = round(qtd/sum(qtd), 2)
  ) |>
  display()

# COMMAND ----------

# MAGIC %md
# MAGIC ### Filtra e arruma a base

# COMMAND ----------

# Filter the training set
training_set <- base_enriquecida_com_publico |> 
  filter(publico != "remover")


training_set_path = "databricks_asn.default.live_do_teo_trianing_set"
spark_write_table(training_set, training_set_path, mode = "overwrite")

# COMMAND ----------

# OPCIONAL salva metadados
metadados <- list(
  training_set_path = training_set_path,  
  features = features,
  id = id,
  vr = vr,
  data = data
)

saveRDS(metadados, "metadados_1_analyse.rds")
