# Obtém os dados do banco:

library(DBI)
source('R/ConnectDatabase.R')

GetData <- function(source = "local", persist=FALSE) {
  
  file <- "data/data.RData"
  switch (source,
    "local" = {
      if (file.exists(file)) get(load(file)) else stop("File not found")
    },
    "database" = {
      con <- ConnectDatabase()
      query <- "SELECT * 
                FROM
                dbo.tbTicker"
      data <- dbGetQuery(con, query)
      
      data <- data %>% 
        mutate(
          datetime = as.POSIXct(
            x = as.numeric(Timestamp),
            origin="1970-01-01"
          )
        )
      
      if (persist) save(data, file = file)
      return(data)
    }
  )
  
}

### Carrega os dados do Banco de dados e salva:
#data <- get_data(source = "database", persist = TRUE)

### Carrega os dados locais:
#data <- get_data()

