# Obtém os spotligths para apresentar no gráfico:

#' @param data Data Frame;


library(tidyverse)
library(lubridate)


Spotlights <- function(data) {
  
  # Get maximum value from series
  max <- data %>% 
    filter(Last == max(Last)) %>% 
    head(1)
  
  # Get minumum value from series
  min <- data %>% 
    filter(Last == min(Last)) %>% 
    head(1)
  
  # Get maximum value of year 2019
  max_2019 <- data %>% 
    filter(lubridate::year(datetime) == 2019) %>% 
    filter(Last == max(Last)) %>%
    head(1)
  
  # Get last value
  last <- data %>% 
    filter(datetime == max(datetime)) %>% 
    head(1)
  
  return(mget(ls()[!grepl('data',ls())]) %>% purrr::map_df(I, .id = "origem"))
  
}