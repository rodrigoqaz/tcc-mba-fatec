# PreProcessData
library(tidyverse)


PreProcessData <- function(dataset, split_date = '2020-01-01') {
  
  # Pega o dataset e cria o split para gerar as bases de treino e teste
  dataset_split <- dataset %>% 
    mutate(Y = lag(Last)) %>% 
    drop_na()
  
  #Cria datset de treino
  train <- dataset_split %>% 
    filter(day < split_date)
  
  #Cria dataset de teste
  test <- dataset_split %>% 
    filter(day >= split_date)
  
  return(list(train = train, test = test))
}

