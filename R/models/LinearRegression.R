# Linear Regression:
library(tidyverse)
library(tidymodels)

LinearRegression <- function(train, test) {
  
  set.seed(4242)
  # Cria a receita:
  recipe <- train %>% 
    recipe(Y~.) %>% 
    update_role(day, new_role = "id variable") %>% 
    step_corr(all_predictors()) %>%
    step_center(all_predictors(), -all_outcomes()) %>%
    step_scale(all_predictors(), -all_outcomes()) %>%
    prep()
  
  # Trata as bases de treino e teste:
  train <- recipe %>% bake(train)
  test <- recipe %>% bake(test)
  
  # Modelo de random forest
  lm <- linear_reg(penalty = 0.001, mixture = 0.5) %>% 
    set_engine("glmnet") %>% 
    fit(Y ~., data = train)
  
  # Gera as previsões
  predictions <- lm %>%
    predict(test) %>% 
    pull()
  
  return(predictions)
  
}

