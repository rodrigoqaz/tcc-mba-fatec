# index:


library(tidyverse)
library(xtable)
library(stargazer)
source('R/GetData.R')


data <- GetData()

dataset <- data %>% 
  mutate(day = lubridate::date(datetime)) %>% 
  filter(day < '2020-04-01') %>% 
  group_by(day) %>% 
  summarise(
    AIL     = min(AIL),
    AQ1     = min(AQ1),
    AMD     = median(AMD),
    AQ3     = max(AQ3),
    ASL     = max(ASL),
    BIL     = min(BIL),
    BQ1     = min(BQ1),
    BMD     = median(BMD),
    BQ3     = max(BQ3),
    BSL     = max(BSL),
    BAMOUNT = sum(BAMOUNT),
    AAMOUNT = sum(AAMOUNT),
    Bid     = last(Bid),
    Ask     = last(Ask),
    Open    = min(Last),
    Last    = last(Last),
    Low     = min(Low),
    High    = max(High),
    Volume  = sum(Volume)
  )

save(dataset, file = 'data/dataset.RData')

# Tabela 1 ----

data %>% 
  ungroup() %>% 
  select(-Currency, -Timestamp) %>% 
  summary() %>% 
  as.data.frame() %>% 
  separate(
    col  = Freq,
    into = c('key', 'value'), 
    sep  = ":"
  ) %>% 
  drop_na() %>% 
  pivot_wider(
    names_from  = key,
    values_from = value
  ) %>%
  column_to_rownames('Var2') %>% 
  select(-Var1) %>% 
  stargazer(
    type = "latex", 
    summary = FALSE, 
    out = "template-artigo/tabela1.tex",
    title = "Sumarização dos dados", 
    font.size = "scriptsize",
    notes = "Fonte: Dados do estudo",
    label = 'summary'
  )



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

png(file="template-artigo/img/data-hist.png",width=500,height=350)
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

png(file="template-artigo/img/dataset.png",width=500,height=350)
p2
dev.off()