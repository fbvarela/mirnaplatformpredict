source("global.R")

## Librerias PostgreSQL
if(!require(RPostgreSQL)){
  install.packages("RPostgreSQL")
  library(RPostgreSQL)
}

# Driver
if(!require(DBI)){
  install.packages("DBI")
  library(DBI)
}

#' Función ConectarBD(db = DATABASE_BD_TEST, host = HOST_BD, port = PORT_BD, user = USUARIO_BD, pass = CLAVE_BD) 
#' Conecta con una base de datos PostgreSQL remota
#' Los parámetros están en el archivo "global.R"
#' @param db character - Base de datos
#' @param host character - Dirección remota
#' @param port integer - Puerto de conexión
#' @param user character - Usuario
#' @param pass character - Clave
#'
#' @return Objeto de conexión PostgreSQL
#'
#' @examples ConectarBD("test", "localhost", "1234", "rlopez", "1234")

  ConectarBD <- function(db = DATABASE_BD_TEST, host = HOST_BD, port = PORT_BD, user = USUARIO_BD, pass = CLAVE_BD)
    {
      print("Entrando en ConectarBD")
      mensaje_error <<- NULL
      con_db <- NULL
      CerrarConexionesBD()
      drv <- dbDriver("PostgreSQL")
      
      tryCatch(
        con_db <- dbConnect(drv = drv, dbname = db,
                          host = host, port = port,
                          user = user, password = pass),
      
          warning = function(w) { print(paste("WARNING: ", w)); mensaje_error <<- msg_aviso_conexion_bd; debug(logger, w); return(FALSE) },
          error = function(e)   { print(paste("ERROR: ", e));   mensaje_error <<- msg_error_conexion_bd; error(logger, e); return(FALSE) }
      
      )
      print("Saliendo de ConectarBD")
      return(con_db)
  }
  

#' Función DesconectarBD(con_db): cierra una conexión de base de datos PostgreSQL
#'
#' @param con_db Objeto de conexión - Conexión abierta de PostgreSQL
#'
#' @return boolean - TRUE (éxito) | FALSE
#'
#' @examples DesconectarBD(con)
  
  DesconectarBD <- function(con_db)
    {
      RPostgreSQL::dbDisconnect(conn = con_db)
  }
  
#' Función CerrarConexionesBD(): cierra todas las conexiones de base de datos PostgreSQL abiertas
#'
#' @return
#'
#' @examples CerrarConexionesBD()

  CerrarConexionesBD <- function()
    {    
      # Se utiliza try para que si dbClearResult(dbListResults(con)[[1]] da error no se interrumpa la aplicación
      try(lapply(dbListConnections(dbDriver(drv = "PostgreSQL")), function(con) dbClearResult(dbListResults(con)[[1]])))
    
      drv <- dbDriver("PostgreSQL")
      all_cons <- dbListConnections(drv)
      
      for(con in all_cons)
        dbDisconnect(conn = con)
      
      print(paste(length(all_cons), " desconexiones"))
  }
  
  
#' Función ConsultarDatosBD(con_db, consulta_sql): ejecuta una consulta SQL de tipo "SELECT" en una base de datos PostgreSQL
#'
#' @param con_db Objeto conexión - Conexión abierta PostgreSQL
#' @param consulta_sql character - Consulta SQL de tipo "SELECT"
#'
#' @return data.frame con datos de la consulta | FALSE (error)
#'
#' @examples ConsultarDatosBD(con, "SELECT * FROM test")

  ConsultarDatosBD <- function(con_db, consulta_sql) 
    {
      #browser()
      print("Entrando en ConsultarDatosBD")
      print(consulta_sql)
      mensaje_error <<- NULL
      data <- NULL
      tryCatch(
        data <- dbGetQuery(conn = con_db, statement = consulta_sql),
  
          warning = function(w) { print(paste("WARNING: ", w)); mensaje_error <<- msg_aviso_consulta_bd; debug(logger, w); return(FALSE) },
          error = function(e)   { print(paste("ERROR: ", e));   mensaje_error <<- msg_error_consulta_bd; error(logger, e); return(FALSE) }
      )
      print("Saliendo de ConsultarDatosBD")
      return(data)
  }
  
  
#' Función EjecutarConsultaBD(con_db, consulta_sql): ejecuta una consulta SQL de cualquier tipo en una base de datos PostgreSQL
#'
#' @param con_db Objeto conexión - Conexión abierta PostgreSQL
#' @param consulta_sql character - Consulta SQL
#'
#' @return data: data.frame - Datos de la tabla | FALSE (error) 
#' 
#' @examples EjecutarConsultaBD(con, "INSERT INTO test VALUES('prueba')")
  
  EjecutarConsultaBD <- function(con_db, consulta_sql)
    {
      print("Entrando en EjecutarConsultaBD")
      print(consulta_sql)
      mensaje_error <<- NULL
      rs <- NULL

      tryCatch(
        rs <- dbSendQuery(conn = con_db, statement = consulta_sql),
          warning = function(w) { print(paste("WARNING: ", w)); mensaje_error <<- msg_aviso_insercion_bd; debug(logger, w); return(FALSE) },
          error = function(e)   { print(paste("ERROR: ", e));   mensaje_error <<- msg_error_insercion_bd; error(logger, e); return(FALSE) }
      )
      print("Saliendo de EjecutarConsultaBD")
      return (rs)
  }
  

#' Función InsertarDatosBDcon_db, esquema = ESQUEMA_BD, tabla_bd, df_datos)
#' Inserta datos en una tabla a partir de un data.frame
#'
#' @param con_db Objeto conexión - Conexión a una base da datos PostgreSQL
#' @param esquema character - Nombre del esquema (valor por defecto: variable ESQUEMA_BD de global.R)
#' @param tabla_bd character - Nombre de la tabla
#' @param df_datos data.frame - Datos a insertar 
#'
#' @return boolean - TRUE (éxito)| FALSE
#'
#' @examples InsertarDatosBD

  InsertarDatosBD <- function(con_db, esquema = ESQUEMA_BD, tabla_bd, df_datos)
    {
      print("Saliedo de EjecutarConsultaBD")
      mensaje_error <<- NULL
      data <- NULL
      
      tryCatch(
        data <- dbWriteTable(conn = con_db, name = c(esquema, tabla_bd), value = df_datos, append = TRUE, row.names = FALSE),
        
          warning = function(w) { print(paste("WARNING: ", w)); mensaje_error <<- msg_aviso_insercion_bd; debug(logger, w); return(FALSE) },
          error = function(e)   { print(paste("ERROR: ", e));   mensaje_error <<- msg_error_insercion_bd; error(logger, e); return(FALSE) }
      )
      print("Saliendo de InsertarDatosBD")
      return(TRUE)
  }
  
  