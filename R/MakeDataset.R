## MakeDataset
library(tidyverse)
library(lubridate)
source('R/GetData.R')

MakeDataset <- function(data) {
  
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
  
  return(dataset)
  
}


# dataset <- MakeDataset(GetData())
# save(dataset, file = 'data/dataset.RData')