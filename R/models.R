library(tidyverse)
library(tidymodels)
source('R/models/LinearRegression.R')
source('R/models/RandomForest.R')
source('R/models/NeuralNetwork.R')

load('data/train-test.RData')



# Aplica os modelos ----
lr <- LinearRegression(train, test)
rf <- RandomForest(train, test)
nn <- NeuralNetwork(train, test, 16, 32, 100)

# Gera dataset de validação ----
validation <- test %>% 
  select(day, real = Y) %>% 
  bind_cols(lr = lr, rf = rf, nn = nn)


# Gráfico comparativo modelos (scatter) ----
p_scatter <- validation %>% 
  pivot_longer(
    cols = c(lr, rf, nn), 
    names_to = "model", 
    values_to = "prediction"
  ) %>% 
  ggplot(aes(x = prediction, y = real)) + 
  geom_abline(col = "red", lty = 2) + 
  geom_point(alpha = .4) + 
  facet_wrap(~model) + 
  labs(
    x = "Preço Previsto (BTC/USD)",
    y = "Preço Real (BTC/USD)"
  )

# Gráfico comparativo modelos (Linear)----
p_line <- validation %>% 
  pivot_longer(
    cols = c(lr, rf, nn), 
    names_to = "model", 
    values_to = "prediction"
  ) %>% 
  pivot_longer(
    cols = c(real, prediction), 
    names_to = "tipo", 
    values_to = "value"
  ) %>% 
  ggplot(aes(x = day, y = value, color = tipo)) + 
    scale_color_manual(
      labels = c("Previsto", "Real"),
      values = c("red", "blue")
    ) +
    geom_line() +
    facet_wrap(~model) + 
    theme(legend.position="bottom", legend.title = element_blank()) + 
    labs(
      x = "Preço Previsto (BTC/USD)",
      y = "Preço Real (BTC/USD)"
    )

# Métricas dos modelos ----
metrics <- validation %>% 
  pivot_longer(
    cols = c(lr, rf, nn), 
    names_to = "model", 
    values_to = "prediction"
  ) %>% 
  group_by(model) %>% 
  metrics(truth = real, estimate = prediction) %>% 
  pivot_wider(names_from = model, values_from = .estimate)



pdf(file="template-artigo/img/results_scatter.pdf", height = 3)
p_scatter
dev.off()

pdf(file="template-artigo/img/results_line.pdf",height=3.5)
p_line
dev.off()


metrics %>% 
  select(-.estimator) %>% 
  column_to_rownames('.metric') %>% 
  stargazer(
    type = "latex", 
    summary = FALSE, 
    out = "template-artigo/tabela3.tex",
    title = "Métricas dos modelos", 
    font.size = "small",
    notes = "Fonte: Dados do estudo",
    label = 'results'
  )
