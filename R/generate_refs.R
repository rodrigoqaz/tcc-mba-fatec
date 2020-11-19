library(tidyverse)
library(xtable)
library(stargazer)
library(ggrepel)
source('R/MakeDataset.R')
source('R/PreProcessData.R')
source('R/LongTable.R')
source('R/Spotligths.R')

data <- GetData()
load('data/dataset.RData')
load('data/train-test.RData')

# Tabela 1 ----

# data %>% 
#   ungroup() %>% 
#   select(-Currency, -Timestamp) %>% 
#   summary() %>% 
#   as.data.frame() %>% 
#   separate(
#     col  = Freq,
#     into = c('key', 'value'), 
#     sep  = ":"
#   ) %>% 
#   drop_na() %>% 
#   pivot_wider(
#     names_from  = key,
#     values_from = value
#   ) %>%
#   column_to_rownames('Var2') %>% 
#   select(-Var1) %>% 
#   longtable.stargazer(.,
#     type = "latex", 
#     summary = FALSE, 
#     filename = "template-artigo/tabela1.tex",
#     title = "Sumarização dos dados", 
#     font.size = "scriptsize",
#     notes = "Fonte: Dados do estudo",
#     label = 'summary'
#   )



# Grafico histórico ----

spotlights <- Spotlights(data)

p <- data %>% 
  ggplot(aes(x=datetime, y = Last)) + 
  geom_line() +
  labs(
    x = "Tempo",
    y = "Preço em Dólar (USD)"
  ) + 
  geom_label_repel(
    data = spotlights,
    mapping = aes(
      x = datetime, 
      y = Last, 
      label = formatC(Last, 2, format = "f"),
      fill = origem), 
    colour = "white"
  ) +
  geom_tile(alpha = 0) +
  guides(
    fill = guide_legend(
      title = "",
      override.aes = aes(label = "")
    )
  )

pdf(file="template-artigo/img/data-hist.pdf",height=3.5)
p
dev.off()

# Lag ----

data %>% 
  arrange(datetime) %>% 
  mutate(
    last_record = lag(datetime),
    lag = hms::as.hms(difftime(datetime,last_record, units = "mins"))
  ) %>% 
  select(
    `Data Final`   = datetime,
    `Data Inicial` = last_record,
    `Diferença`    = lag
  ) %>% 
  drop_na() %>% 
  arrange(desc(`Diferença`)) %>% 
  head(10) %>% 
  stargazer(
    type            = "latex", 
    summary         = FALSE, 
    out             = "template-artigo/tabela2.tex",
    title           = " \\textit{Lag} entre os registros", 
    font.size       = "small",
    notes           = "Fonte: Dados do estudo",
    label           = 'lag',
    table.placement = "h"
  )

# Datset ----

p2 <- dataset %>%
  ggplot(aes(x = day, y = Last)) +
  geom_line() +
  labs(
    y     = "Preço de Fechamento", 
    x     = "Dia"
  ) 

pdf(file="template-artigo/img/dataset.pdf",height=3.5)
p2
dev.off()




# Tabela descritivo variáveis ----

data %>% 
  select(-Currency) %>% 
  names() %>% 
  tibble() %>% 
  rename(`Variável` = '.') %>% 
  mutate(
    `Descrição` = c(
      'Limite inferior dos preços de venda do livro de ofertas',
      '1º Quartil dos preços de venda do livro de ofertas',
      'Mediana Quartil dos preços de venda do livro de ofertas',
      '3º Quartil dos preços de venda do livro de ofertas',
      'Limite superior dos preços de venda do livro de ofertas',
      'Limite inferior dos preços de compra do livro de ofertas',
      '1º Quartil dos preços de compra do livro de ofertas',
      'Mediana Quartil dos preços de compra do livro de ofertas',
      '3º Quartil dos preços de compra do livro de ofertas',
      'Limite superior dos preços de compra do livro de ofertas',
      'Volume total das ofertas de compra',
      'Volume total das ofertas de venda',
      'Valor da última oferta de compra',
      'Valor da última oferta de venda',
      'Valor da última negociação realizada',
      'Menor negociação realizada no timeframe',
      'Maior negociação realizada no timeframe',
      'Volume total das negociações realizadas',
      'Momento da última negociação',
      'Data e hora da última negociação'
    )
  ) %>% 
  stargazer(
    type            = "latex", 
    summary         = FALSE, 
    out             = "template-artigo/tabela_vars.tex",
    title           = "Variáveis coletadas através da API", 
    font.size       = "small",
    notes           = "Fonte: Dados do estudo",
    label           = 'vars',
    table.placement = "h",
    rownames        = FALSE
  )






# Tabela com descritivo das variáveis;
# Explicação das variáveis 



