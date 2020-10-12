# index:


library(tidyverse)
library(xtable)
library(stargazer)
library(ggrepel)
source('R/MakeDataset.R')
source('R/PreProcessData.R')
source('R/LongTable.R')
source('R/Spotligths.R')

data <- GetData()

dataset <- MakeDataset(data)
train <- PreProcessData(dataset, '2020-01-01')$train
test <- PreProcessData(dataset, '2020-01-01')$test

save(dataset, file = 'data/dataset.RData')
save(list = c("train", "test"), file = 'data/train-test.RData')



