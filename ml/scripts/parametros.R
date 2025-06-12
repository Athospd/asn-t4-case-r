username = "athos.damiani@gmail.com"
training_set_path = "databricks_asn.default.live_do_teo_trianing_set"

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
publico = as.symbol("publico")
