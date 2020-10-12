#### Rede neural mlp

library(keras)
library(tidyverse)
library(tensorflow)
library(DMwR)


NeuralNetwork <- function(train, test, n_hidden_layers = 1, 
                          hidden_dim = 32, n_epochs = 10) {
  
  set.seed(4242)
  
  # Gera base de treinamento (features) normalizada:
  train_scaled_x <- scale(
    train %>% 
      select(-day) %>% 
      select(-Y)
  )
  
  # Gera base de treinamento (target) normalizada:
  train_scaled_y <- scale(
    train %>% 
      select(-day) %>% 
      select(Y)
  )
  
  # Gera base de teste (features) normalizada:
  test_scaled_x <- scale(
    x = test %>% 
      select(-day, -Y), 
    center = attr(train_scaled_x, "scaled:center"),
    scale = attr(train_scaled_x, "scaled:scale")
  )
  
  # Gera base de teste (target) normalizada:
  test_scaled_y <- scale(
    x = test %>% 
      select(Y), 
    center = attr(train_scaled_y, "scaled:center"),
    scale = attr(train_scaled_y, "scaled:scale")
  )
  
  
  
  ## Estrutura da rede neural:
  
  model <- keras_model_sequential()
  
  model <- model %>% 
    layer_dense(units = 1, input_shape = (dim(train_scaled_x)[2]))
  
  # Camadas ocultas
  for (i in 1:n_hidden_layers){
    model <- model %>% 
      layer_dense(units = hidden_dim, activation = "relu")
  }
  
  # Camada de saída
  model %>% 
    layer_dense(units = 1, activation = "linear")
  
  
  model %>% compile(
    loss = loss_mean_squared_error, 
    optimizer = "adam"
  )
  
  
  model %>% 
    fit(
      x = train_scaled_x,
      y = train_scaled_y, 
      epochs = n_epochs, 
      validation_split = 0.2
    )
  
  pred <- predict(model, test_scaled_x)
  predicted <- unscale(pred[,1],test_scaled_y)[,1]
  
  return(predicted)
  
}

