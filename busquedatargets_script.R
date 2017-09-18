source('global.R')

  BusquedaTargets <- function(input, output, session)
    {
      observeEvent(input$submit_release_mirna, {
        mensaje_error <<- NULL
        shinyjs::disable("submit_release_mirna")
        #browser()
        con <- ConectarBD()
        if (!is.null(mensaje_error)) { error(logger, e); return(FALSE) }
        #browser()
        
        datos <- ConsultarDatosBD(con_db = con, consulta_sql = SQL_SELECT_MIRNATARGETS)
        if (!is.null(mensaje_error)) { shinyjs::enable("submit_release_mirna"); DesconectarBD(con_db = con); return(FALSE) }
        
        DesconectarBD(con_db = con)
        #browser()
        shinyjs::enable("submit_release_mirna")
        
        output$content_busq <- DT::renderDataTable({
          #browser()
          return(datos)
        })
      })
    
    observeEvent(input$submit_results, {
      mensaje_error <<- NULL
      shinyjs::disable("submit_results")
      con <- ConectarBD()
      if (!is.null(mensaje_error)) { return(FALSE) }
      
      datos <- ConsultarDatosBD(con_db = con, consulta_sql = SQL_SELECT_TARGETS_TODOS)
      if (!is.null(mensaje_error)) { shinyjs::enable("submit_results"); DesconectarBD(con_db = con); return(FALSE) }
      shinyjs::enable("submit_results")
      
      if (nrow(datos) == 0) 
        {
            output$msgb_info <- renderPrint({
              mensaje_error <<- msg_aviso_consulta_result; 
              return(mensaje_error) 
            })
      }else
        {
          output$content_busq <- DT::renderDataTable({
            return(datos)  
          })
      }
  })
}
  
  
#' Función InsertarReleaseBD(archivo_zip = ARCHIVO_ZIP_RELEASE_TARGETSCAN, archivo_txt = ARCHIVO_TXT_RELEASE_TARGETSCAN) 
#' Inserta datos de una release de targetScan en la base de datos (tabla datasets_ensembl).
#' Primero borra la tabla, si existe, y luego hace la inserción.
#' 
#' @param archivo_zip character - Ruta del archivo con formato zip con los datos de la release 
#' (valor por defecto: ARCHIVO_ZIP_RELEASE_TARGETSCAN en archivo global.R)
#' @param archivo_txt character - Ruta del archivo resultado de la descompresión del anterior 
#' (valor por defecto: ARCHIVO_TXT_RELEASE_TARGETSCAN en archivo global.R)
#' 
#' @return TRUE (éxito) | FALSE
#'
#' @examples InsertarReleaseBD("archivo_release.zip", "archivo_release.txt")

  InsertarReleaseBD <- function(archivo_zip = ARCHIVO_ZIP_RELEASE_TARGETSCAN, archivo_txt = ARCHIVO_TXT_RELEASE_TARGETSCAN)
    {
      mensaje_error <<- NULL
      tryCatch(
        
        browser(),
        file_release_unzip <- unzip(zipfile = archivo_zip, exdir = "www"),
        
        df_release <- read.csv(archivo_txt, 
                               sep = "", header=FALSE, col.names = c("mir_family",	"gene_id", "gene_symbol",	"transcript_id",	
                                                                  "species_id",	"utr_start", "utr_end",	"msa_start", "msa_end",	
                                                                  "seed_match",	"pct"), stringsAsFactors=FALSE, skip=1),
        
        warning = function(w) { print(paste("WARNING: ", w)); mensaje_aviso <<- msg_aviso_InsertarReleaseBD; return(FALSE) },
        error = function(e)   { print(paste("ERROR: ", e));   mensaje_error <<- msg_error_InsertarReleaseBD; return(FALSE) }
      )
      
      con <- ConectarBD()
      if (is.null(mensaje_error)==FALSE) { return(FALSE) }
      
      consulta_sql <- "BEGIN TRANSACTION"
      EjecutarConsultaBD (con_db = con, consulta_sql = consulta_sql)
      if (is.null(mensaje_error) == FALSE) { dbRollback(con); DesconectarBD(con_db = con); return(FALSE) }
      
      EjecutarConsultaBD(con_db = con, consulta_sql = SQL_DROP_MIRNATARGETS)
      if (is.null(mensaje_error) == FALSE) { dbRollback(con); DesconectarBD(con_db = con); return(FALSE) }
      
      EjecutarConsultaBD(con_db=con, tipo = "dbwrite", tabla_bd = TABLA_MIRNATARGETS, df_datos = df_release)
      if (is.null(mensaje_error) == FALSE) { dbRollback(con); DesconectarBD(con_db = con); return(FALSE) }
      
      dbCommit(conn=con)
      DesconectarBD(con_db=con)
      return (TRUE)
  }
