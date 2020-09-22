# Obtém os dados do banco:

library(DBI)
source('R/connect_database.R')

get_data <- function(source = "local", persist=FALSE) {
  
  file <- "data/data.RData"
  switch (source,
    "local" = {
      if (file.exists(file)) get(load(file)) else stop("File not found")
    },
    "database" = {
      con <- connect_database()
      query <- "SELECT * 
                FROM
                dbo.tbTicker"
      data <- dbGetQuery(con, query)
      if (persist) save(data, file = file)
      return(data)
    }
  )
  
}

### Carrega os dados do Banco de dados e salva:
#data <- get_data(source = "database", persist = TRUE)

### Carrega os dados locais:
#data <- get_data()

