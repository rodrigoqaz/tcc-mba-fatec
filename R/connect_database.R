

# configuração do driver:
# https://eriqande.github.io/2014/12/19/setting-up-rodbc.html

# Conexão no banco de dados, conforme o sistema operacional: ----

config <- config::get(file = 'config.yml')

connect_database <- function() {
  
  os <- Sys.info()[1]
  
  switch(
    os,
    "Darwin"  = {
      con <- DBI::dbConnect(
        odbc::odbc(), 
        config$azure$connection,
        uid = config$azure$user,
        pwd = config$azure$password
      )
    },
    "Windows" = {
      con <- DBI::dbConnect(
        odbc::odbc(), 
        .connection_string = paste0(
          "Driver={ODBC Driver 17 for SQL Server};
          Server=",config$azure$host,";
          Uid=",config$azure$user,";
          Pwd=",config$azure$password,""
        )
      )
    }
  )
  
  return(con)
  
}

