source("global.R")


datasets <- NULL # Contiene todos los datasets Ensembl

PrediccionTargets <- function(input, output, session)
  {
    ##browser()
    mensaje_error <<- "inicio"
    
    
    shinyjs::disable("submit_pred_target")
    
    # Carga de datasets en la lista desplegable
    datasets <<-  RecuperarDatasetsEnsembl()
    
    # Si Ensembl no está disponible se cargan los datasets de la BD
    if (is.null(datasets))
      {
        con <- ConectarBD()
        if (is.null(mensaje_error) == FALSE)  { return(FALSE) } 
      
        datasets <<- ConsultarDatosBD(con_db = con, consulta_sql = SQL_SELECT_DATASETS_ENSEMBL)
        if (is.null(mensaje_error) == FALSE) { DesconectarBD(con_db = con);  return(FALSE) } 
      
        DesconectarBD(con_db = con)
      
    }else
      {
        datasets <<- c("Todos", datasets)    
    }
    
    output$html_dataset <- renderUI({
      selectInput(inputId = "select_dataset", label = "Dataset Ensembl", choices = datasets, multiple = TRUE, selected = DATASET_ENSEMBL_DEFECTO, width = "240px")
    })
    
    ##browser()
    if(is.null(mensaje_error) == FALSE && mensaje_error != "inicio")
      {
        output$msg_info <- renderPrint({
          return(mensaje_error)
        })
    }
    
    shinyjs::enable("submit_pred_target")
    
    # Botón de salir de la aplicación
    observeEvent(input$submit_salir, {
      shinyjs::js$closeWindow()
      stopApp()
    })
  
    # Botón para limpiar campo de archivos fasta (no lo hace bien)
    shinyjs::onclick("resetAll", shinyjs::reset("form_fasta"))
    
    # botón de submit: se tiene que enviar información sobre miRNA y 3'UTR en sus distintas combinaciones.
    observeEvent(input$submit_pred_target, 
      {
        ##browser()      
        shinyjs::disable("submit_pred_target")
        mensaje_error <<- NULL
        ##browser() 
        #output$msg_info <- renderPrint( { return(""); })
        ##browser()
        # Si se selecciona "Todos" se guardarn todos los datasets; en otro caso sólo los seleccionados.
        if (input$select_dataset == "Todos") datasets_sel <- datasets else datasets_sel <- input$select_dataset
        
        # Se quitan espacios en blanco de los campos mirna_id y gen_id
        text_mirna <- if(input$text_mirna != "") trimws(unlist(strsplit(input$text_mirna, ","))) else trimws(input$text_mirna)
        text_gen <- if(input$text_gen != "") trimws(unlist(strsplit(input$text_gen, ","))) else trimws(input$text_gen) 
        
        ##browser()
        # Barra de tiempo
        progress <- shiny::Progress$new()
        progress$set(message = "Ejecutando...", value = 0)
        on.exit(progress$close())
        
        updateProgress <- function(value = NULL, detail = NULL) {
          if (is.null(value)) {
            value <- progress$getValue()
            value <- value + (progress$getMax() - value) / 5
          }
          progress$set(value=value, detail=detail)
        }
      
      #browser()        
      # Se conprueba la selección de campos del usuario
      if ((text_mirna != "" && text_gen != "") && is.null(input$file_mirna) && is.null(input$file_utr)) # campos 1 y 2
        {  
          print("Selección de campos 1 y 2")
          df_input <- data.frame()
          #browser()
        ##browser()
          if (ValidarTextGenID(gen_id = text_gen, tipo_ref = input$radio_id_ref)) # Valida gen ID
            {
              # Recuperación de secuencias mirRNA partir del miRNA ID
              df_mirna_id_seq <- RecuperarSecuenciasMirna(mirna_id = text_mirna, 
                                                          updateProgress = updateProgress)   
              
              if (is.null(mensaje_error) == FALSE) { return(MostrarMensajeUsuario(mensaje_error)) } 
              
              ##browser()
              # Recuperación de secuencias 3'UTR a partir del gen ID
              df_gen_utr_id_seq <- RecuperarSecuenciasExtremo3utr(gen_id = text_gen,                
                                                                   data_sel = datasets_sel, 
                                                                   gen_id_ref = input$radio_id_ref, 
                                                                   updateProgress = updateProgress)
              ##browser()
              if (is.null(mensaje_error) == FALSE) { return(MostrarMensajeUsuario(mensaje_error)) } 
              
              # Añadir el campo secuencia mirna precomputada 0 | 1
              v_mirna_precomp <- ClasificarIDPrecomputado(tipo = "mirnaid",
                                                          df_id = df_mirna_id_seq)
              
              if (is.null(mensaje_error) == FALSE) { return(MostrarMensajeUsuario(mensaje_error)) } 
              
              # Añadir el campo secuencia gen/utr precomputada 0 | 1
              v_utr_precomp <- ClasificarIDPrecomputado(tipo = "genutr", 
                                                        df_id = df_gen_utr_id_seq)
              
              if (is.null(mensaje_error) == FALSE) { return(MostrarMensajeUsuario(mensaje_error)) } 
              
              ##browser()
              
              df_mirna_id_seq$mirna_precomp <- v_mirna_precomp
              df_gen_utr_id_seq$utr_precomp <- v_utr_precomp
              
              df_mirna_id_seq$mirna_ref <- rep(1, nrow(df_mirna_id_seq))
              df_gen_utr_id_seq$utr_ref <- rep(1, nrow(df_gen_utr_id_seq))
  
              ##browser()
          }
      }   
      
      else if ((text_mirna != "" && is.null(input$file_utr) == FALSE)  && text_gen == "" && is.null(input$file_mirna))  # campos 1 y 4
        {
          print("Selección de campos 1 y 4")
          
          df_archivos_fasta <- input$file_utr
          df_archivos_fasta$tipo <- rep("DNA", nrow(df_archivos_fasta)) # Se añade si es fasta "RNA" o "DNA"
          browser()
          
          if (ValidarArchivoFasta(df_archivos_fasta)) # Valida fasta
            {
              
              # Recuperación de secuencias mirRNA partir del archivo fasta 
              df_mirna_id_seq <- RecuperarSecuenciasMirna(mirna_id = text_mirna,
                                                          updateProgress = updateProgress)   
              browser()
              if (is.null(mensaje_error) == FALSE) { return(MostrarMensajeUsuario(mensaje_error)) } 
              
              # Añadir el campo secuencia mirna precomputada 0|1
              v_mirna_precomp <- ClasificarIDPrecomputado(tipo = "mirnaid",
                                                          df_id = df_mirna_id_seq)
              browser()
              if (is.null(mensaje_error) == FALSE) { return(MostrarMensajeUsuario(mensaje_error)) } 
              
              objeto_fasta_utr <- LeerArchivoFasta(df_archivos_fasta$datapath) # Leer fasta
              browser()
              
              if (is.null(mensaje_error) == FALSE) { return(MostrarMensajeUsuario(mensaje_error)) } 
              
              # Recuperación de secuencias 3'UTR a partir del gen ID
              df_gen_utr_id_seq <- RecuperarSecuenciasExtremo3utr(data_sel = datasets_sel, 
                                                                  gen_id_ref = input$radio_id_ref, 
                                                                  objeto_fasta = objeto_fasta_utr,
                                                                  updateProgress = updateProgress)
              browser()
              if (is.null(mensaje_error) == FALSE) { return(MostrarMensajeUsuario(mensaje_error)) } 
              
              # Añadir el campo secuencia gen/utr precomputada 0|1
              v_utr_precomp <- ClasificarIDPrecomputado(tipo = "genutr", 
                                                        df_id = df_gen_utr_id_seq)
              browser()
              if (is.null(mensaje_error) == FALSE) { return(MostrarMensajeUsuario(mensaje_error)) } 
              
              ##browser()
              
              df_mirna_id_seq$mirna_precomp <- v_mirna_precomp
              df_gen_utr_id_seq$utr_precomp <- v_utr_precomp
              
              browser()
          }
        }
        else if ((text_gen != "" && is.null(input$file_mirna) == FALSE)  && text_mirna == "" && is.null(input$file_utr))  # campos 2 y 3
          {
            print("Selección de campos 2 y 3")
            #browser()
            df_archivos_fasta <- input$file_mirna
            df_archivos_fasta$tipo <- rep("RNA", nrow(df_archivos_fasta)) # Se añade si es "RNA" o "DNA"
            
            if (ValidarTextGenID(gen_id = text_gen, tipo_ref = input$radio_id_ref)) # Valida gen ID
              {
                if (ValidarArchivoFasta(df_archivos_fasta)) # Valida fasta
                  {            
                    objeto_fasta_mirna <- LeerArchivoFasta(df_archivos_fasta$datapath) # Leer fasta
                    
                    if (is.null(mensaje_error) == FALSE) { return(MostrarMensajeUsuario(mensaje_error)) } 
                    
                    #Recuperación de secuencias mirRNA partir del archivo fasta
                    df_mirna_id_seq <- RecuperarSecuenciasMirna(mirna_id = text_mirna, 
                                                                objeto_fasta = objeto_fasta_mirna, 
                                                                updateProgress = updateProgress)  
                    browser()
                    if (is.null(mensaje_error) == FALSE) { return(MostrarMensajeUsuario(mensaje_error)) } 
                    
                    # Añadir el campo secuencia mirna precomputada 0 | 1
                    v_mirna_precomp <- ClasificarIDPrecomputado(tipo = "mirnaid",
                                                                df_id = df_mirna_id_seq)
                    
                    if (is.null(mensaje_error) == FALSE) { return(MostrarMensajeUsuario(mensaje_error)) } 
                    
                    # Recuperación de secuencias 3'UTR a partir del gen ID
                    df_gen_utr_id_seq <- RecuperarSecuenciasExtremo3utr(gen_id = text_gen,                
                                                                        data_sel = datasets_sel, 
                                                                        gen_id_ref = input$radio_id_ref,
                                                                        updateProgress = updateProgress)
                    ##browser()
                    if (is.null(mensaje_error) == FALSE) { return(MostrarMensajeUsuario(mensaje_error)) } 
                    
                    # Añadir el campo precomputada 0 | 1
                    v_utr_precomp <- ClasificarIDPrecomputado(tipo = "genutr", 
                                                              df_id = df_gen_utr_id_seq)
                    
                    if (is.null(mensaje_error) == FALSE) { return(MostrarMensajeUsuario(mensaje_error)) }
                    
                    df_mirna_id_seq$mirna_precomp <- v_mirna_precomp
                    df_gen_utr_id_seq$utr_precomp <- v_utr_precomp
                    browser()
                }
            }
        }
        
        else if ((text_mirna == "" && text_gen == "") && is.null(input$file_mirna) == FALSE && is.null(input$file_utr) == FALSE) # campos 3 y 4
          {
            ##browser()
            print("Selección de campos 3 y 4")
            df_archivo_fasta_mirna <- input$file_mirna
            df_archivo_fasta_mirna$tipo <- rep("RNA", nrow(df_archivo_fasta_mirna))
            df_archivo_fasta_utr <- input$file_utr
            df_archivo_fasta_utr$tipo <- rep("DNA", nrow(df_archivo_fasta_utr))
            df_archivos_fasta <- rbind(df_archivo_fasta_mirna, df_archivo_fasta_utr)
            ##browser()
            if(ValidarArchivoFasta(df_archivos_fasta)) # Valida fasta
              {
                print("Archivo fasta válido")
                for(i in 1:nrow(df_archivos_fasta))
                 {
                    objeto_fasta <- LeerArchivoFasta(df_archivos_fasta[i,4]) 
                    
                    if (is.null(mensaje_error) == FALSE) { return(MostrarMensajeUsuario(mensaje_error)) }  # Lectura fasta no válido
                    ##browser()
                  
                    if(df_archivos_fasta[i,5] == "RNA")
                      {
                        #Recuperación de secuencias mirRNA partir del archivo fasta
                        df_mirna_id_seq <- RecuperarSecuenciasMirna(mirna_id = names(objeto_fasta), 
                                                                    objeto_fasta = objeto_fasta, 
                                                                    updateProgress = updateProgress)  
                        
                        if (is.null(mensaje_error) == FALSE) { return(MostrarMensajeUsuario(mensaje_error)) } 
                        
                        # Añadir el campo secuencia mirna precomputada 0|1
                        v_mirna_precomp <- ClasificarIDPrecomputado(tipo = "mirnaid",
                                                                    df_id = df_mirna_id_seq)
                        
                        if (is.null(mensaje_error) == FALSE) { return(MostrarMensajeUsuario(mensaje_error)) } 
                      
                    }else
                      {
                        # Recuperación de secuencias 3'UTR a partir del gen ID
                        df_gen_utr_id_seq <- RecuperarSecuenciasExtremo3utr(gen_id = names(objeto_fasta),        
                                                                            data_sel = datasets_sel, 
                                                                            gen_id_ref = input$radio_id_ref,
                                                                            objeto_fasta = objeto_fasta,
                                                                            updateProgress = updateProgress)
                        ##browser()
                        if (is.null(mensaje_error) == FALSE) { return(MostrarMensajeUsuario(mensaje_error)) } 
                        
                        # Añadir el campo secuencia gen/utr precomputada 0|1
                        v_utr_precomp <- ClasificarIDPrecomputado(tipo = "genutr", 
                                                                  df_id = df_gen_utr_id_seq)
                        
                        if (is.null(mensaje_error) == FALSE) { return(MostrarMensajeUsuario(mensaje_error)) } 
                        
                        df_mirna_id_seq$mirna_precomp <- v_mirna_precomp
                        df_gen_utr_id_seq$utr_precomp <- v_utr_precomp
                    }
                  }
                }
            }else
              {
                # Falta algún campo
                #browser()
                shinyjs::enable("submit_pred_target")
                mensaje_error <<- msg_aviso_campos
                output$msg_info <- renderPrint({ return(mensaje_error) })
            }
      
      ##browser()
      if (is.null(mensaje_error) == FALSE) { return(MostrarMensajeUsuario(mensaje)) } 
      
      df_binding_sites_precomp_bd <- ClasificarMirnaUtrPrecomputado(mirna_id = df_mirna_id_seq$mirna_id, 
                                                             utr_id = df_gen_utr_id_seq$utr_id, 
                                                             updateProgress = updateProgress)
      browser()
      if (is.null(mensaje_error) == FALSE) { return(MostrarMensajeUsuario(mensaje)) } 
      browser()      
      #df_binding_sites_precomp_bd <- RecuperarMirnaUtrPrecomputados(mirna_utr_precomp = df_mirna_utr_precomp)
      
      #browser()      
      if (is.null(mensaje_error) == FALSE) { return(MostrarMensajeUsuario(mensaje)) } 
      browser()
      # input_user_id <- PrepararInputBD(mirna_input = df_mirna_id_seq, 
      #                                  utr_input = df_gen_utr_id_seq, 
      #                                  algoritmo = input$select_alg, 
      #                                  updateProgress = updateProgress)
      

      if (is.null(mensaje_error) == FALSE) { return(MostrarMensajeUsuario(mensaje)) } 
      browser()
       
      EjecutarAlgoritmoPrediccion(mirna_info = df_mirna_id_seq,
                                  utr_info = df_gen_utr_id_seq,
                                  input_user_id = input_user_id,
                                  tipo = input$radio_id_calc, 
                                  binding_sites_precomp_bd = df_binding_sites_precomp_bd, 
                                  updateProgress = updateProgress)
                                  
      browser()
      if (is.null(mensaje_error) == FALSE) 
        { 
          MostrarMensajeUsuario(mensaje_error)
          
      }else 
        { 
          output$msg_info <- renderPrint({
            shinyjs::enable("submit_pred_target"); 
            mensaje_error <<- NULL; 
            return("Ejecutando...") 
          }) 
      }
  })
    
  MostrarMensajeUsuario <- function(mensaje)
    {
      shinyjs::enable("submit_pred_target")
      output$msg_info <- renderPrint({ return(mensaje_error) })
  }
 
}

#' Función ClasificarIDPrecomputado(df_id, tipo): clasifica ID mirna o 3'UTR en precomputado si | no
#'
#' @param df_id data.frame - miRNA ID o 3'UTR ID
#' @param tipo character - valores: "mirnaid" (miRNA ID) | otro (3'UTR ID)
#'
#' @return vector - valores: ID -> 1 (precomputado) | 0 (no precomputado) 
#'
#' @examples ClasificarIDPrecomputado(data.frame("hsa-mir-217"), "mirnaid")

  ClasificarIDPrecomputado <- function(df_id, tipo)
    {
      print("Entrando en ClasificarIDPrecomputado")
      mensaje_error <<- NULL
      con <- NULL
      tryCatch(
        con <- ConectarBD(),
        
        warning = function(w) { print(paste("WARNING: ", w)); mensaje_error <<- msg_aviso_conexion_bd; debug(logger, w); return(FALSE) }, 
        error = function(e)   { print(paste("ERROR: ", e));   mensaje_error <<- msg_error_conexion_bd; error(logger, e); return(FALSE) } 
      )
      
      es_precomp <- NULL
      consulta_sql <- NULL
      
      tryCatch(
        # mirna ID
        if(tipo == "mirnaid")
          {
            ##browser()
            df_mirna_input_precomp <- NULL
            id <- df_id$mirna_id
            v_id <- sub(pattern="\\|.*", "", x = id)
            id_in <- sapply(v_id, function(x) { paste("\'", paste(x, "\'", sep = ""), sep = "")})
            id_in <- paste(as.character(id_in), collapse = ", ")
            ##browser()
            consulta_sql <- gsub("\\?", id_in, SQL_SELECT_BINDINGSITES_MIRNA_ID_PRECOMP)
            ##browser()
            
            df_mirna_input_precomp <- ConsultarDatosBD(con_db = con, consulta = consulta_sql)
            DesconectarBD(con_db = con)
            
            if (is.null(mensaje_error) == FALSE) return(EnCasoDeError("e", e))
            
            ##browser()
            if(nrow(df_mirna_input_precomp) > 0)
              {
                es_precomp <- sapply(v_id, function(x) { if(length(which(x %in% df_mirna_input_precomp$mirna_id)) == 0) 0 else 1 })
            }else
              {
                es_precomp <- sapply(v_id, function(x) { 0 })
            }
            
            df_id$mirna_precomp <- es_precomp
            
          }else # 3'UTR ID
            {
              ##browser()
              df_utr_precomp <- NULL
              id <- df_id$utr_id
              v_id <- sub(pattern = "\\|.*", "", x = id)
              id_in <- sapply(v_id, function(x) { paste("\'", paste(x, "\'", sep = ""), sep = "")})
              id_in <- paste(as.character(id_in), collapse = ", ")
              ##browser()
              consulta_sql <- gsub("\\?", id_in, SQL_SELECT_BINDINGSITES_MIRNA_ID_PRECOMP)
              ##browser()
              
              df_utr_precomp <- ConsultarDatosBD(con_db = con, consulta = consulta_sql)
              if (is.null(mensaje_error) == FALSE) return(EnCasoDeError("e", e))
              ##browser()
              
              if(nrow(df_utr_precomp) > 0)
                {
                  es_precomp <- sapply(v_id, function(x) { if(length(which(x %in% df_utr_precomp$utr_id)) == 0) 0 else 1 })
              }else
                {
                  es_precomp <- sapply(v_id, function(x) { 0 })
              }
              
              df_id$utr_precomp <- es_precomp
            },
            
            warning = function(w) { print(paste("WARNING: ", w)); mensaje_aviso <<- msg_aviso_buscar_precomputadas; debug(logger, w); return(FALSE) } ,
            error = function(e)   { print(paste("ERROR: ", e));   mensaje_error <<- msg_error_buscar_precomputadas; error(logger, e); return(FALSE) } 
          )
          ##browser()
          print("Saliendo de ClasificarIDPrecomputado")
          return(es_precomp) 
  }


#' Función ClasificarMirnaUtrPrecomputado(mirna_id, utr_id, updateProgress: NULL) 
#' Comprueba si pares miRNA-3UTR tiene binding-sites precomputados (tabla binding_sites)
#'
#' @param mirna_id character vector - miRNA ID introducidos por el usuario
#' @param utr_id character vector - 3' UTR ID introducidos por el usuario
#' @param updateProgress función - barra de espera (valor por defecto: NULL)
#' 
#' @return data.frame - mirna_id, utr_id y precomp: 0 (no) | 1 (sí))
#'
#' @examples ComprobarMirnaUtrPrecomputado("hsa-mir-520b", "ENST00000352993")

  ClasificarMirnaUtrPrecomputado <- function(mirna_id, utr_id, updateProgress = NULL)
    {
      print("Entrando en ClasificarMirnaUtrPrecomputado")
      #browser()
      df_pares_precomputados <- data.frame(stringsAsFactors = FALSE)
      df_pares_mirna_utr <- expand.grid(mirna_id, utr_id, stringsAsFactors = FALSE)
      names(df_pares_mirna_utr) <- c("mirna_id", "utr_id")
      
      tryCatch(
        con <- ConectarBD(),
        
        warning = function(w) { print(paste("WARNING: ", w)); mensaje_error <<- msg_error_mirnautr_pre_computado; debug(logger, w); return(FALSE) }, 
        error = function(e)   { print(paste("ERROR: ", e));   mensaje_error <<- msg_error_mirnautr_pre_computado; error(logger, e); return(FALSE) }
      )
      
      for (i in 1 : nrow(df_pares_mirna_utr))
        {
          ##browser()
          if (is.function(updateProgress)) { text <- "Pares miRNA ID - 3'UTR precomputados"; updateProgress(detail = text) }
          v_pares <- c()
          
          consulta_sql <- sprintf(SQL_SELECT_BINDINGSITES_PAR_MIRNAUTR_PRECOMP, df_pares_mirna_utr$mirna_id[i], df_pares_mirna_utr$utr_id[i])
          datos <- ConsultarDatosBD(con_db = con, consulta_sql = consulta_sql)
          browser()
          if (is.null(mensaje_error) == FALSE) { DesconectarBD(con_db = con); return(FALSE) } 
          
          ##browser()
          # Puede haber un par con más de un binding-site. Se guarda tb el bs_id de la tabla para diferenciarlos
          if (nrow(datos) > 0)
            {
              browser()
              for (j in 1 : nrow(datos))
                {
                  v_pares <- c(datos$bs_id[j], df_pares_mirna_utr$mirna_id[i], df_pares_mirna_utr$utr_id[i], 1, 
                               ifelse(is.null(datos$feat_id[j]), NA, datos$feat_id[j]), datos$bs_mirna_seq_start[j], 
                               datos$bs_seq_seed_end[j], datos$bs_seq_region_3[j], datos$bs_seq_region_3_start[j], 
                               datos$bs_seq_region_3_end[j], datos$bs_seq_region_total[j], datos$bs_seq_region_total_start[j], 
                               datos$bs_seq_region_total_end[j], datos$bs_score[j], datos$bs_scoring_matrix[j], datos$bs_other[j], 
                               datos$bs_type[j])
                               
                               
                  df_pares_precomputados <- rbind.data.frame(df_pares_precomputados, v_pares, stringsAsFactors = FALSE)
              }  
          }
      }
      
      DesconectarBD(con_db = con)
      browser()
      #names(df_pares_precomputados) <- c("bs_id", "mirna_id", "utr_id", "precomp", "feat_id")
      
      print("Saliendo de ClasificarMirnaUtrPrecomputado")
      return(df_pares_precomputados)
  }  

#' Función RecuperarMirnaUtrPrecomputados(mirna_utr_precomp): 
#' Recupera información sobre binding-sites de pares miRNA-3'UTR de la base datos
#'
#' @param mirna_utr_precomp data.frame - miRNA, 3'UTR ID y precomp (0 | 1)
#'
#' @return df_binding_sites_bd - data.frame - ver tabla binding_sites en el esquema de base d edatos
#'
#' @examples RecuperarMirnaUtrPrecomputados(data.frame(mirna_id = "hsa-mir-200", utr_id = "ENST00000352993", precomp = 1"))

RecuperarMirnaUtrPrecomputados <- function(mirna_utr_precomp)
    {
      print("Entrando en RecuperarMirnaUtrPrecomputados")
      mensaje_error <<- NULL
      browser()
      df_binding_sites_bd <- NULL
      # Comprobar que hay pares precomputados
      if (1 %in% mirna_utr_precomp$precomp) # Si hay pares precomputados
        {
          # Preparar datos para enviar al algoritmo con información de la BD si está precomputado
           mirna_utr_precomp <- subset(mirna_utr_precomp, precomp == 1)
          ##browser() 
  
          for (i in 1 : nrow(mirna_utr_precomp))
            {
              tryCatch(
                con <- ConectarBD(), # Dentro del bucle porque sólo admite 16 conexiones abiertas
                
                warning = function(w) { print(paste("WARNING: ", w)); mensaje_error <<- msg_error_mirnautr_precomp; debug(logger, w); return(FALSE) }, 
                error = function(e)   { print(paste("ERROR: ", e));   mensaje_error <<- msg_error_mirnautr_precomp; error(logger, e); return(FALSE) }
              )
            
              # Se consulta si el par miRNA-3'UTR está en binding_sites
              consulta_sql <- sprintf(SQL_SELECT_BINDINGSITES_PAR_MIRNAUTR_INPUT, mirna_utr_precomp$mirna_id[i], mirna_utr_precomp$utr_id[i], as.numeric(mirna_utr_precomp$bs_id[i]))
              data <- ConsultarDatosBD (con_db = con, consulta_sql = consulta_sql)
              ##browser()
              
              if (is.null(mensaje_error) == FALSE) {DesconectarBD(con_db = con); error(logger, e); return(FALSE) }
              
              ##browser()
              df_binding_sites_bd <- rbind.data.frame(df_binding_sites_bd, data, stringsAsFactors = FALSE)
              ##browser()
              DesconectarBD(con_db = con)
          }
          ##browser()
          if (is.null(mensaje_error) == FALSE) { DesconectarBD(con_db = con); error(logger, e); return(FALSE) }
          #showModal(AbrirVentanaModal(mensaje = msg_modal_pares_precomp))      
      }
      return (df_binding_sites_bd)
      print("Saliendo de RecuperarMirnaUtrPrecomputados")
  }

#' Función: preparar_bd_input(mirna_input, utr_input, algoritmo, updateProgress = NULL) 
#' Hace las inserciones y actualizaciones necesarias en la base de datos con el input de usuario
#'
#' @param mirna_input data.frame - input miRNA con miRNA ID, secuencia, referencia (sí | no) y precomputado (sí | no).
#' @param utr_input data.frame - input 3'UTR con UTR ID, gen ID, secuencia, referencia (sí | no) y precomputado (sí | no).
#' @param algoritmo character - nombre del algoritmo de predicción utilizado 
#' @param updateProgress función - barra de espera (valor por defecto: NULL)
#' 
#' @return input_user_id: integer - ID del input 
#'
#' @examples preparar_bd_input(data.frame("hsa-mir-217", "AUGU", 1, 1), data.frame("ENSG00000139618", "ENST00000380152", 1, 1), "algoritmo 1")
#
  PrepararInputBD <- function(mirna_input, utr_input, algoritmo, updateProgress = NULL)
    {
      print("Entrando en PrepararInputBD")
      ## INSERCIÓN TABLAS
      #  -> INPUT_USER
      #  -> MIRNA
      #  -> UTR
      #  -> GEN
      
      # Se hace la conexión y desconexión aquí para los rollback
      ##browser()
      mensaje_error <<- NULL
      consulta_sql <- NULL
      # data.frame con el input de usuario
      df_input <- data.frame(input_datetime = NA, input_mirna_id = NA, 
                             input_gen_id = NA, input_utr_id = NA,
                             input_id = NA, input_alg = NA,
                             stringsAsFactors = FALSE)
      
      df_input$input_id <- 0
      input_fechahora <- format(x = Sys.time(), format = "%Y-%m-%d %H:%M:%S")
      df_input$input_datetime <- input_fechahora
      
      df_input$input_mirna_id <- paste0(mirna_input$mirna_id, collapse = ",")
      df_input$input_gen_id <- paste0(unique(utr_input$gen_id), collapse = ",")
      df_input$input_utr_id <-  paste0(utr_input$utr_id, collapse = ",")
      
      df_input$input_alg <- algoritmo
      
      ##browser()
      con <- ConectarBD()
      if (is.null(mensaje_error) == FALSE) { dbRollback(conn = con); return(FALSE) }
      ##browser()
      
      # Se agrupan todas las consultas en una transacción para poder hacer rollback si falla alguna.
      consulta_sql <- "BEGIN TRANSACTION"
      EjecutarConsultaBD (con_db = con, consulta_sql = consulta_sql)
      if (is.null(mensaje_error) == FALSE) { dbRollback(conn = con); DesconectarBD(con_db = con); return(FALSE) }
      
      # TABLA input_user
      consulta_sql <- sprintf(SQL_INSERT_INPUT_USER, 
                              paste0("NEXTVAL('", SEQ_INPUT_USER_MIRNA_ID), 
                              df_input$input_datetime, df_input$input_mirna_id, 
                              df_input$input_gen_id, df_input$input_utr_id,
                              df_input$input_alg)
      EjecutarConsultaBD(con_db = con, consulta_sql = consulta_sql)
      if (is.null(mensaje_error) == FALSE) { dbRollback(con); DesconectarBD(con_db = con); return(FALSE) }
      
      ##browser()
      # TABLA mirna
      for (i in 1 : nrow(mirna_input))
        {
          if (is.function(updateProgress)) { text <- "input_bd -> seq miRNA"; updateProgress(detail=text) }
          ##browser()
          
          # Si existe, actualiza; si no, inserta
          consulta_sql <- sprintf(SQL_SELECT_COUNT_MIRNA, mirna_input$mirna_id[i])
          #browser()
          data <- ConsultarDatosBD(con_db = con, consulta_sql = consulta_sql)  
          if (is.null(mensaje_error) == FALSE) { dbRollback(conn = con); DesconectarBD(con_db = con); return(FALSE) }
          ##browser()
          if(data$count == 0)
            {
              consulta_sql <- sprintf(SQL_INSERT_MIRNA, mirna_input$mirna_id[i], 1, mirna_input$mirna_precomp[i], mirna_input$mirna_seq[i]) 
          }else
            {
              consulta_sql <- sprintf(SQL_UPDATE_MIRNA, 1, mirna_input$mirna_precomp[i], mirna_input$mirna_seq[i], mirna_input$mirna_id[i]) 
          }
          
          
          EjecutarConsultaBD(con_db = con, consulta_sql = consulta_sql)  
          if (is.null(mensaje_error) == FALSE) { dbRollback(conn = con); DesconectarBD(con_db = con); return(FALSE) }
      }
      
      if (is.null(mensaje_error) == FALSE) { dbRollback(conn = con); DesconectarBD(con_db = con); return(FALSE) }
      
      # TABLA gen
      browser()
      v_gen_unicos <- unique(utr_input$gen_id)
      for (i in 1 : length(v_gen_unicos))
        {
          if (is.function(updateProgress)) { text <- "input_bd -> gen"; updateProgress(detail = text) }
          consulta_sql <- sprintf(SQL_SELECT_COUNT_GEN, v_gen_unicos[i])
          data <- ConsultarDatosBD(con_db = con, consulta_sql = consulta_sql)
          
          if(data$count == 0)
            {
              consulta_sql <- sprintf(SQL_INSERT_GEN, v_gen_unicos[i], "") 
          }else
            {
              consulta_sql <- sprintf(SQL_UPDATE_GEN, v_gen_unicos[i], "", v_gen_unicos[i]) 
          }
          
          
          EjecutarConsultaBD(con_db = con, consulta_sql = consulta_sql)  
          if (is.null(mensaje_error) == FALSE) { dbRollback(conn = con); DesconectarBD(con_db = con); return(FALSE) }
      }
      
      if (is.null(mensaje_error) == FALSE) { dbRollback(conn = con); DesconectarBD(con_db = con); return(FALSE) }
      
      browser()
      
      # TABLA utr_gen
      for (i in 1 : nrow(utr_input))
        {
          if (is.function(updateProgress)) { text <- "input_bd -> seq 3'UTR"; updateProgress(detail = text) }
        
          consulta_sql <- sprintf(SQL_SELECT_COUNT_UTR, utr_input$utr_id[i])
          data <- ConsultarDatosBD(con_db = con, consulta_sql = consulta_sql)  
          if (is.null(mensaje_error) == FALSE) { DesconectarBD(con_db = con); return(FALSE) }
          if(data$count == 0)
            {
              consulta_sql <- sprintf(SQL_INSERT_UTR, utr_input$utr_id[i], 1, utr_input$utr_precomp[i], utr_input$utr_seq[i], utr_input$gen_id[i]) 
          }else
            {
              consulta_sql <- sprintf(SQL_UPDATE_UTR, 1, utr_input$utr_precomp[i], utr_input$utr_seq[i], utr_input$gen_id[i], utr_input$utr_id[i]) 
          }
          
          
          EjecutarConsultaBD(con_db = con, consulta_sql = consulta_sql)  
          if (is.null(mensaje_error) == FALSE) { dbRollback(conn = con); DesconectarBD(con_db = con); return(FALSE) }
      }
      ##browser()
      
      if (is.null(mensaje_error) == FALSE) { dbRollback(conn = con); DesconectarBD(con_db = con); return(FALSE) }
      
      # Se hace commit a todos los insert y update
      dbCommit(conn = con)
      
      # Se cierra la conexión
      DesconectarBD(con_db = con)
      
      con <- ConectarBD()
      if (is.null(mensaje_error) == FALSE) { return(FALSE) }
      
      consulta_sql <- sprintf(SQL_SELECT_INPUT_USER_ID, df_input$input_datetime)
      #browser()
      rs <- ConsultarDatosBD(con_db = con, consulta_sql = consulta_sql)  
      if (is.null(mensaje_error) == FALSE) { return(FALSE) }
      
      input_user_id <- rs$input_id
      #browser()
      
      # Se cierra la conexión
      DesconectarBD(con_db = con)
      print("Saliendo de PrepararInputBD")
      return(input_user_id)
    }


#' Función EjecutarAlgoritmoPrediccion(mirna_info, utr_info, input_id , binding_sites_precomp_bd = NULL, mirna_utr_id_precomp = NULL, tipo = "calc_todo")
#' Contiene las llamadas a las funciones que ejecutan el algoritmo de predicción
#' 
#' @param mirna_info data.frame - Info de mirna
#' @param utr_info data.frame - Info de 3'UTR
#' @param input_id integer - valor de ID de input_user (ver esquema de base de datos)
#' @param binding_sites_precomp_bd data.frame - info de pares miRNA-3'UTR precomputados
#' @param mirna_utr_id_precomp data.frame - ID de pares miRNA-3'UTR precomputados
#' @param tipo character - indica si se calcula todo de nuevo o se utilice info de la base de datos - valores ("calc_todo" | "calc_parte")(valor por defecto: "calc_todo")
#' @param updateProgress función - barra de espera (valor por defecto: NULL)
#' 
#' @return
#'
#' @examples EjecutarAlgoritmoPrediccion

  EjecutarAlgoritmoPrediccion <- function(mirna_info, utr_info, input_user_id, binding_sites_precomp_bd, mirna_utr_id_precomp = NULL, 
                                          tipo = "calc_todo", updateProgress = NULL)
  #EjecutarAlgoritmoPrediccion <- function(mirna_info, utr_info, tipo = "calc_todo", updateProgress = NULL)
    {
      #browser()
      consulta_sql <- NULL
      
      #### 1. Identificación de binding-sites potenciales
      df_binding_sites_potenciales <- data.frame(stringsAsFactors = FALSE)
      
      browser()
      if (tipo == "calc_todo")   # Se recalcula todo
        {
          df_binding_sites_potenciales <- IdentificarBindingSitesPotenciales(mirna_info = mirna_info, 
                                                                             utr_info = utr_info) 

      }else # Se recalculan solo los pares que no hayan sido precomputados
        {
          df_id_no_precomp <- subset(df_binding_sites_precomp_bd, precomp == 0, select = c("mirna_id", "utr_id"))

          df_binding_sites_potenciales <- IdentificarBindingSitesPotenciales(mirna_info = mirna_info, 
                                                                             utr_info = utr_info,
                                                                             mirna_utr_no_precomp = df_id_no_precomp)
          
      }
      
      df_binding_sites_potenciales <- data.frame("hsa-mir-510", "ENST00000470094", 25, 4, 54, 65, "AGTCTTGT", 1, 8, "GATGACTTCA", 
                                                 9, 19, "AGTCTTGTGATGACTTCA", 1, 19, 60, "{1, 2, 3},{2, 3, 4}", "{}", 0, stringsAsFactors = FALSE)
      
      df_binding_sites_potenciales <- rbind.data.frame(df_binding_sites_potenciales, c("hsa-mir-510", "ENST00000380152", 25, 4, 54, 65, "AAAAAATT", 1, 8, "TAAATCTTTT", 
                                                        9, 19,  "AAAAAATTTAAATCTTTT", 1, 19, 41.1, "{5, 6, 7},{8, 9, 10}", "{}", 0), stringsAsFactors = FALSE)
      df_binding_sites_potenciales <- rbind.data.frame(df_binding_sites_potenciales, c("hsa-mir-510", "ENST00000528762", 25, 4, 54, 65, "AGCTATTC", 1, 8, "GCGTATTGTA", 
                                                       3, 32,  "AGCTATTCGCGTATTGTA", 1, 19, 54, "{3, 4, 5},{6, 7, 8}", "{}", 0), stringsAsFactors = FALSE)
                                                 
      df_binding_sites_potenciales <- rbind.data.frame(df_binding_sites_potenciales, c("hsa-mir-510", "ENST00000544455", 25, 4, 54, 65, "TTGGCACT", 1, 8, "TTGCTTTCAA", 
                                                       3, 32,  "TTGGCACTTTGCTTTCAA", 1, 19, 152.2, "{1, 3, 5},{7, 9, 11}", "{}", 0), stringsAsFactors = FALSE) 
       
       
       names(df_binding_sites_potenciales) <- c("mirna_id", "utr_id", "bs_mirna_seq_start", "bs_mirna_seq_end", "bs_utr_seq_start", 
                                                "bs_utr_seq_end", "bs_seq_seed", "bs_seq_seed_start", "bs_seq_seed_end", "bs_seq_region_3", 
                                                "bs_seq_region_3_start", "bs_seq_region_3_end", "bs_seq_region_total", "bs_seq_region_total_start", 
                                                "bs_seq_region_total_end", "bs_score", "bs_scoring_matrix", "bs_other", "bs_type")
       
       
      if (is.null(mensaje_error) == FALSE) { return(FALSE) }
      
      # Se guardan los binding-sites potenciales identificados (si existen) con el campo bs_tipo = 0 (potenciales)
      if (nrow(df_binding_sites_potenciales) == 0)
        {
            mensaje_error <<- msg_aviso_bs_potenciales_vacio
            return (FALSE)
      }else
        {
          con <- ConectarBD()
          if (is.null(mensaje_error) == FALSE) { return(FALSE) }              
          
          # Se guarda en la base de datos
          # Se agrupan todas las consultas en una transacción para poder hacer rollback si falla alguna.
          consulta_sql <- "BEGIN TRANSACTION"
          EjecutarConsultaBD(con_db = con, consulta_sql = consulta_sql)
    
          if (is.null(mensaje_error) == FALSE) { dbRollback(conn = con); DesconectarBD(con_db = con); return(FALSE) }
  
          # Se guardan los binding-sites  
          for(i in 1 : nrow(df_binding_sites_potenciales))
            {
              if (is.function(updateProgress)) { text <- "Identificando binding-sites potenciales"; updateProgress(detail = text) }
              browser()
            c("mirna_id", "utr_id", "bs_mirna_seq_start", "bs_mirna_seq_end", "bs_utr_seq_start", 
              "bs_utr_seq_end", "bs_seq_seed", "bs_seq_seed_start", "bs_seq_seed_end", "bs_seq_region_3", 
              "bs_seq_region_3_start", "bs_seq_region_3_end", "bs_seq_region_total", "bs_seq_region_total_start", 
              "bs_seq_region_total_end", "bs_score", "bs_scoring_matrix", "bs_other", "bs_type")
              consulta_sql <- sprintf(SQL_SELECT_BS_ID_POTENCIALES, 
                                      df_binding_sites_potenciales$mirna_id[i], 
                                      df_binding_sites_potenciales$utr_id[i], 
                                      as.integer(df_binding_sites_potenciales$bs_mirna_seq_start[i]), 
                                      as.integer(df_binding_sites_potenciales$bs_mirna_seq_end[i]),
                                      as.integer(df_binding_sites_potenciales$bs_utr_seq_start[i]),  
                                      as.integer(df_binding_sites_potenciales$bs_utr_seq_end[i]),
                                      df_binding_sites_potenciales$bs_seq_seed[i], 
                                      as.integer(df_binding_sites_potenciales$bs_seq_seed_start[i]),
                                      as.integer(df_binding_sites_potenciales$bs_seq_seed_end[i]), 
                                      df_binding_sites_potenciales$bs_seq_region_3[i],
                                      as.integer(df_binding_sites_potenciales$bs_seq_region_3_start[i]), 
                                      as.integer(df_binding_sites_potenciales$bs_seq_region_3_end[i]),
                                      df_binding_sites_potenciales$bs_seq_region_total[i],  
                                      as.integer(df_binding_sites_potenciales$bs_seq_region_total_start[i]),
                                      as.integer(df_binding_sites_potenciales$bs_seq_region_total_end[i]), 
                                      as.numeric(df_binding_sites_potenciales$bs_score[i]),
                                      df_binding_sites_potenciales$bs_scoring_matrix[i], 
                                      df_binding_sites_potenciales$bs_other[i],
                                      as.integer(df_binding_sites_potenciales$bs_type[i]))
              
              data <- ConsultarDatosBD(con_db = con, consulta_sql = consulta_sql)
              if (is.null(mensaje_error) == FALSE) { dbRollback(conn = con); DesconectarBD(con_db = con); return(FALSE) }
              
              if(nrow(data) == 0) # Si es nuevo se inserta
                {
                  browser()
                  consulta_sql <- sprintf(SQL_INSERT_BINDING_SITES_POTENCIALES,
                                          df_binding_sites_potenciales$mirna_id[i], 
                                          df_binding_sites_potenciales$utr_id[i],
                                          "nextval('mirnaplatform.feat_id_seq'::regclass)", 
                                          as.integer(df_binding_sites_potenciales$bs_mirna_seq_start[i]), 
                                          as.integer(df_binding_sites_potenciales$bs_mirna_seq_end[i]), 
                                          as.integer(df_binding_sites_potenciales$bs_utr_seq_start[i]), 
                                          as.integer(df_binding_sites_potenciales$bs_utr_seq_end[i]), 
                                          df_binding_sites_potenciales$bs_seq_seed[i], 
                                          as.integer(df_binding_sites_potenciales$bs_seq_seed_start[i]), 
                                          as.integer(df_binding_sites_potenciales$bs_seq_seed_end[i]), 
                                          df_binding_sites_potenciales$bs_seq_region_3[i], 
                                          as.integer(df_binding_sites_potenciales$bs_seq_region_3_start[i]), 
                                          as.integer(df_binding_sites_potenciales$bs_seq_region_3_end[i]), 
                                          df_binding_sites_potenciales$bs_seq_region_total[i], 
                                          as.integer(df_binding_sites_potenciales$bs_seq_region_total_start[i]),
                                          as.integer(df_binding_sites_potenciales$bs_seq_region_total_end[i]), 
                                          as.numeric(df_binding_sites_potenciales$bs_score[i]),
                                          df_binding_sites_potenciales$bs_scoring_matrix[i],
                                          df_binding_sites_potenciales$bs_other[i],
                                          as.integer(df_binding_sites_potenciales$bs_type[i]))
              }else    
                {
                  #browser()
                  consulta_sql <- sprintf(SQL_UPDATE_BINDING_SITES_POTENCIALES, 
                                          df_binding_sites_potenciales$mirna_id[i], 
                                          df_binding_sites_potenciales$utr_id[i], 
                                          as.integer(df_binding_sites_potenciales$bs_mirna_seq_start[i]), 
                                          as.integer(df_binding_sites_potenciales$bs_mirna_seq_end[i]), 
                                          as.integer(df_binding_sites_potenciales$bs_utr_seq_start[i]), 
                                          as.integer(df_binding_sites_potenciales$bs_utr_seq_end[i]), 
                                          df_binding_sites_potenciales$bs_seq_seed[i], 
                                          as.integer(df_binding_sites_potenciales$bs_seq_seed_start[i]), 
                                          as.integer(df_binding_sites_potenciales$bs_seq_seed_end[i]), 
                                          df_binding_sites_potenciales$bs_seq_region_3[i], 
                                          as.integer(df_binding_sites_potenciales$bs_seq_region_3_start[i]), 
                                          as.integer(df_binding_sites_potenciales$bs_seq_region_3_end[i]), 
                                          df_binding_sites_potenciales$bs_seq_region_total[i], 
                                          as.integer(df_binding_sites_potenciales$bs_seq_region_total_start[i]), 
                                          as.integer(df_binding_sites_potenciales$bs_seq_region_total_end[i]), 
                                          as.numeric(df_binding_sites_potenciales$bs_score[i]), 
                                          df_binding_sites_potenciales$bs_scoring_matrix[i], 
                                          df_binding_sites_potenciales$bs_other[i],
                                          as.integer(df_binding_sites_potenciales$bs_type[i]),
                                          as.integer(data$bs_id))
              }
              #browser()
              EjecutarConsultaBD(con_db = con, consulta_sql = consulta_sql)
              if (is.null(mensaje_error) == FALSE) { dbRollback(conn = con); DesconectarBD(con_db = con); return(FALSE) }
          }
          
            dbCommit(conn = con)  # Se hace el commit            
            DesconectarBD(con_db = con) # Se cierra la conexión
            
            # if (tipo == "calc_todo")
            #   {
            #     # Se añaden los binding-sites precomputados
            #     df_binding_sites_potenciales <- rbind.data.frame(df_binding_sites_potenciales, binding_sites_precomp_bd, stringsAsFactors = FALSE)
            # }
  
        }
      
      if (is.null(mensaje_error) == FALSE) { return(FALSE) } 
       
      browser()  
      #### 2. Obtención de features
      
      df_features <- ObtenerFeatures(binding_sites_potenciales = df_binding_sites_potenciales)
      if (is.null(mensaje_error) == FALSE) { return(FALSE) }
      
      df_features <- data.frame(27, 15, 128.3, 5.1, '{"seed_k": 23}', 4, 1, '{"cons_x": "conservationx"}', 58.3, '{"free_energy_x": 332.3}', 
                                '{"r3": 332.3, "r2": 34, "rt": 21.3}', '{"r3": 23.3, "r2": 43, "rt": 5.3}', '{"r3": 43.3, "r2": 34, "rt": 4.3}', 
                                '{"r3": 65.3, "r2": 1, "rt": 2.3}','{"r3": 3.3, "r2": 32, "rt": 0.3}', '{"r3": 67.3, "r2": 6, "rt": 7.3}', 
                                '{"r3": 4.3, "r2": 5, "rt": 5.3}', '{"r3": 5.3, "r2": 34, "rt": 21.3}', '{"r3": 78.3, "r2": 34, "rt": 2.3}', 
                                '{"r3": 98.3, "r2": 7.8, "rt": 21.3}', '{"r3": 332.3, "r2": 34.8, "rt": 6.3}', '{}', 2, '{}', 
                                 "", stringsAsFactors = FALSE);

      df_features <- rbind.data.frame(df_features, c(28, 15, 128.3, 54.2, '{"seed_k": 23}', 4, 1, '{"cons_x": "conservationx"}', 35.2, '{"free_energy_x": 332.3}', 
                                        '{"r3": 332.3, "r2": 34, "rt": 21.3}', '{"r3": 23.3, "r2": 43, "rt": 5.3}', '{"r3": 43.3, "r2": 34, "rt": 4.3}', 
                                        '{"r3": 65.3, "r2": 1, "rt": 2.3}', '{"r3": 3.3, "r2": 32, "rt": 0.3}', '{"r3": 67.3, "r2": 6, "rt": 7.3}', 
                                        '{"r3": 4.3, "r2": 5, "rt": 5.3}', '{"r3": 5.3, "r2": 34, "rt": 21.3}', '{"r3": 78.3, "r2": 34, "rt": 2.3}', 
                                        '{"r3": 98.3, "r2": 7.8, "rt": 21.3}', '{"r3": 332.3, "r2": 34.8, "rt": 6.3}', '{}', 4, '{}', 
                                         ""), stringsAsFactors = FALSE)
      
      df_features <- rbind.data.frame(df_features, c(29, 15, 58, 8, '{"seed_k": 23}', 4, 1, '{"cons_x": "conservationx"}', 658.45, '{"free_energy_x": 332.3}', 
                                        '{"r3": 332.3, "r2": 34, "rt": 21.3}', '{"r3": 23.3, "r2": 43, "rt": 5.3}', '{"r3": 43.3, "r2": 34, "rt": 4.3}', 
                                        '{"r3": 65.3, "r2": 1, "rt": 2.3}', '{"r3": 3.3, "r2": 32, "rt": 0.3}', '{"r3": 67.3, "r2": 6, "rt": 7.3}', 
                                        '{"r3": 4.3, "r2": 5, "rt": 5.3}', '{"r3": 5.3, "r2": 34, "rt": 21.3}', '{"r3": 78.3, "r2": 34, "rt": 2.3}', 
                                        '{"r3": 98.3, "r2": 7.8, "rt": 21.3}', '{"r3": 332.3, "r2": 34.8, "rt": 6.3}', '{}', 3, '{}', 
                                         ""), stringsAsFactors = FALSE)
      
      df_features <- rbind.data.frame(df_features, c(30, 15, 3, 1.32, '{"seed_k": 23}', 4.3, 1, '{"cons_x": "conservationx"}', 123.3, '{"free_energy_x": 332.3}', 
                                        '{"r3": 332.3, "r2": 34, "rt": 21.3}', '{"r3": 23.3, "r2": 43, "rt": 5.3}', '{"r3": 43.3, "r2": 34, "rt": 4.3}', 
                                        '{"r3": 65.3, "r2": 1, "rt": 2.3}', '{"r3": 3.3, "r2": 32, "rt": 0.3}', '{"r3": 67.3, "r2": 6, "rt": 7.3}', 
                                        '{"r3": 4.3, "r2": 5, "rt": 5.3}', '{"r3": 5.3, "r2": 34, "rt": 21.3}', '{"r3": 78.3, "r2": 34, "rt": 2.3}', 
                                        '{"r3": 98.3, "r2": 7.8, "rt": 21.3}', '{"r3": 332.3, "r2": 34.8, "rt": 6.3}', '{}', 232, '{}', 
                                         ""), stringsAsFactors = FALSE)
      
      
      names(df_features) <- c("bs_id", "feat_seed_type_id", "feat_seed_score", "feat_seed_pct", "feat_seed_add", 
      "feat_cons_mf_id", "feat_cons_ms_id", "feat_cons_add", "feat_free_energy", "feat_free_energy_add", "feat_insite_fe_region", 
      "feat_insite_match_region", "feat_insite_mismatch_region", "feat_insite_gc_match_region", "feat_insite_gc_mismatch_region", 
      "feat_insite_au_match_region", "feat_insite_au_mismatch_region", "feat_insite_gu_match_region", "feat_insite_gu_mismatch_region", 
      "feat_insite_bulges_mirna_region", "feat_insite_bulged_nucl_region", "feat_insite_add", "feat_acc_energy", "feat_ae_add", "feat_new")

      if (nrow(df_features) == 0)
        {
          mensaje_error <<- msg_aviso_obtener_features
          return (FALSE)
      }else
        {
          con <- ConectarBD()
          if (is.null(mensaje_error) == FALSE) { return(FALSE) }
      
          consulta_sql <- "BEGIN TRANSACTION"
          EjecutarConsultaBD(con_db = con, consulta_sql = consulta_sql)
          if (is.null(mensaje_error) == FALSE) { dbRollback(conn = con); DesconectarBD(con_db = con); return(FALSE) }
          
          # Se insertan los features
          for(i in 1 : nrow(df_features))
            {
              if (is.function(updateProgress)) { text <- "Calculando features"; updateProgress(detail = text) }
              
              # Hay que comprobar si hay features nuevos (no se implementa por falta de tiempo)
              # if (df_features$feat_new != "")
              #   {
              #     consulta_sql <- sprintf(SQL_SELECT_COUNT_FEATURES, df_features$feat_id[i])            
              # }
              
              browser()
              consulta_sql <- sprintf(SQL_SELECT_BS_FEAT_ID, as.integer(df_features$bs_id[i]))
              data <- ConsultarDatosBD(con_db = con, consulta_sql = consulta_sql)
              if (is.null(mensaje_error) == FALSE) { dbRollback(conn = con); DesconectarBD(con_db = con); return(FALSE) }
              
              if (nrow(data) == 0) # Si es nuevo se inserta
                {
                  consulta_sql <- sprintf(SQL_INSERT_FEATURES,
                                          #df_features$feat_id[i], 
                                          as.integer(df_features$feat_seed_type_id[i]), 
                                          as.numeric(df_features$feat_seed_score[i]), 
                                          as.numeric(df_features$feat_seed_pct[i]), 
                                          df_features$feat_seed_add[i], 
                                          as.integer(df_features$feat_cons_mf_id[i]), 
                                          as.integer(df_features$feat_cons_ms_id[i]), 
                                          df_features$feat_cons_add[i], 
                                          as.numeric(df_features$feat_free_energy[i]), 
                                          df_features$feat_free_energy_add[i], 
                                          df_features$feat_insite_fe_region[i], 
                                          df_features$feat_insite_match_region[i], 
                                          df_features$feat_insite_mismatch_region[i], 
                                          df_features$feat_insite_gc_match_region[i], 
                                          df_features$feat_insite_gc_mismatch_region[i], 
                                          df_features$feat_insite_au_match_region[i], 
                                          df_features$feat_insite_au_mismatch_region[i], 
                                          df_features$feat_insite_gu_match_region[i], 
                                          df_features$feat_insite_gu_mismatch_region[i], 
                                          df_features$feat_insite_bulges_mirna_region[i], 
                                          df_features$feat_insite_bulged_nucl_region[i], 
                                          df_features$feat_insite_add[i], 
                                          as.numeric(df_features$feat_acc_energy[i]), 
                                          df_features$feat_ae_add[i],
                                          "nextval('mirnaplatform.new_feature_id_seq'::regclass)")
                  browser()                        
                  EjecutarConsultaBD(con_db = con, consulta_sql = consulta_sql)
                  if (is.null(mensaje_error) == FALSE) { dbRollback(conn = con); DesconectarBD(con_db = con); return(FALSE) }
                  
                  # Se consulta el feat_id recién guardado en features
                  consulta_sql = sprintf(SQL_SELECT_FEATURES_ID)
                  data <- ConsultarDatosBD(con_db = con, consulta_sql = consulta_sql)
                  
                  if (is.null(mensaje_error) == FALSE) { dbRollback(conn = con); DesconectarBD(con_db = con); return(FALSE) }
                  
                  
                  # Se actualiza el feat_id correspondiente en binding-sites
                  consulta_sql = sprintf(SQL_UPDATE_BS_FEAT_ID, data$feat_id, df_features$bs_id[i])
                                          
                  EjecutarConsultaBD(con_db = con, consulta_sql = consulta_sql)
                  if (is.null(mensaje_error) == FALSE) { dbRollback(conn = con); DesconectarBD(con_db = con); return(FALSE) }
              
              }else    # Si existe se actualiza
                {
                  consulta_sql <- sprintf(SQL_UPDATE_FEATURES,
                                          as.integer(df_features$feat_seed_type_id[i]), 
                                          as.numeric(df_features$feat_seed_score[i]), 
                                          as.numeric(df_features$feat_seed_pct[i]), 
                                          df_features$feat_seed_add[i], 
                                          as.integer(df_features$feat_cons_mf_id[i]), 
                                          as.integer(df_features$feat_cons_ms_id[i]), 
                                          df_features$feat_cons_add[i], 
                                          as.numeric(df_features$feat_free_energy[i]), 
                                          df_features$feat_free_energy_add[i], 
                                          df_features$feat_insite_fe_region[i], 
                                          df_features$feat_insite_match_region[i], 
                                          df_features$feat_insite_mismatch_region[i], 
                                          df_features$feat_insite_gc_match_region[i], 
                                          df_features$feat_insite_gc_mismatch_region[i], 
                                          df_features$feat_insite_au_match_region[i], 
                                          df_features$feat_insite_au_mismatch_region[i], 
                                          df_features$feat_insite_gu_match_region[i], 
                                          df_features$feat_insite_gu_mismatch_region[i], 
                                          df_features$feat_insite_bulges_mirna_region[i], 
                                          df_features$feat_insite_bulged_nucl_region[i], 
                                          df_features$feat_insite_add[i], 
                                          as.numeric(df_features$feat_acc_energy[i]), 
                                          df_features$feat_ae_add[i],
                                          #data$new_id,
                                          data$feat_id)
                  browser()                      
                  EjecutarConsultaBD(con_db = con, consulta_sql = consulta_sql)
                  if (is.null(mensaje_error) == FALSE) { dbRollback(conn = con); DesconectarBD(con_db = con); return(FALSE) }
                  
                  # Se consulta el feat_id recién guardado en features
                  consulta_sql = sprintf(SQL_SELECT_BS_ID_FEATURES)
                  data <- ConsultarDatosBD(con_db = con, consulta_sql = consulta_sql)
                  
                  if (is.null(mensaje_error) == FALSE) { dbRollback(conn = con); DesconectarBD(con_db = con); return(FALSE) }
                  # Se actualiza el feat_id correspondiente en binding-sites
                  browser() 
                  consulta_sql = sprintf(SQL_UPDATE_BS_FEAT, data$feat_id, df_features$bs_id[i])
                  EjecutarConsultaBD(con_db = con, consulta_sql = consulta_sql)
              }
  
              if (is.null(mensaje_error) == FALSE) { dbRollback(conn = con); DesconectarBD(con_db = con);  error(logger, e); return }
          }
        }
        
      dbCommit(conn = con)            
      DesconectarBD(con_db = con) # Se cierra la conexión
      
      # if (tipo == "calc_parte")
      #   {
      #     con <- ConectarBD()
      #     if (is.null(mensaje_error) == FALSE) { return(FALSE) }
      #     
      #     consulta_sql = sprintf(SQL_SELECT_FEATURES_BS_ID, df_binding_sites_potenciales$bs_id)
      #     data <- EjecutarConsultaBD(con_db = con, consulta_sql = consulta_sql)
      #     if (is.null(mensaje_error) == FALSE) { return(FALSE) }
      #     
      #     # Se añaden los features precomputados
      #     df_features <- rbind.data.frame(df_features, data, stringsAsFactors = FALSE)
      #     DesconectarBD(con_db = con) # Se cierra la conexión
      # }
      
      if (is.null(mensaje_error) == FALSE) { return(FALSE) } 
      
    ##### 3. Evaluación de binding-sites potenciales
      
      df_binding_sites_definitivos <- EvaluarBindingSitesPotenciales(bs_potenciales = df_binding_sites_potenciales, 
                                                                     features = df_features, 
                                                                     updateProgress = updateProgress)
      
      if (is.null(mensaje_error) == FALSE) { return(FALSE) }  
      
      if (nrow(df_binding_sites) == 0)
        {
          mensaje_error <<- msg_aviso_evaluar_bs_potenciales
          return (FALSE)
      }else
        {
          con <- ConectarBD()
          if (is.null(mensaje_error) == FALSE) { return(FALSE) }  
        
          for(i in 1 : nrow(df_binding_sites))
            {
              if (is.function(updateProgress)) { text <- "Evaluando binding-sites"; updateProgress(detail = text) }
            
              # Se actualizan los binding-sites a definitivos (valor: 1)
              consulta_sql <- sprintf(SQL_UPDATE_BINDING_SITES_ID, 1, df_binding_sites_definitivos$bs_id[i])
              
              EjecutarConsultaBD(con_db = con, consulta_sql = consulta_sql)
              if (is.null(mensaje_error) == FALSE) { DesconectarBD(con_db = con); return(FALSE) }  
          }
        
          DesconectarBD(con_db = con)
      }
  
      ##### 4. Predicción final
      # Se recuperan todos los binding-sites definitivos
      
      
      consulta_sql <- sprintf(SQL_BINDING_SITES_DEFINITIVOS, df_binding_sites_definitivos$bs_id)
      con <- ConectarBD()
      if (is.null(mensaje_error) == FALSE) { return(FALSE) }
      
      EjecutarConsultaBD(con_db = con, consulta_sql = consulta_sql)
      if (is.null(mensaje_error) == FALSE) { DesconectarBD(con_db = con); return(FALSE) }  
      
      df_prediccion_final <- PrediccionFinalTargets(binding_sites_definitivos = df_binding_sites_definitivos, 
                                                    updateProgress = updateProgress)
      
      # Se guardan los datos del output en la tabla output_user
      df_output_user <- data.frame(stringsAsFactors = FALSE)
      output_fechahora <- format(x = Sys.time(), format = "%Y-%m-%d %H:%M:%S")
      df_output_user$ouput_datetime <- output_fechahora
      
      if (nrow(df_prediccion_final) == 0)
        {
          mensaje_error <<- msg_aviso_prediccion_final
          df_output_user$output_target <- ""

      }else
        {
          con <- ConectarBD()
          if (is.null(mensaje_error) == FALSE) { return(FALSE) }

          target_mirna <- c()
          mirna_unicos <- unique(df_prediccion_final$mirna_id)
          
          for(i in 1 : length(mirna_unicos))
            {
              target_mirna_aux <- subset(x = df_prediccion_final, mirna_id == mirna_unicos[i], select = c(mirna_id, target_mirna))
            
              targets_aux <- c(paste0("\"mirna_id\": \"", paste0(mirna_unicos[i], "\", \"target\": [\"", paste0(target_mirna_aux$target_mirna, collapse = "\", \""), paste0("\"]"))))
              target_mirna <<- c(paste(targets_aux, collapse = ",", targets_aux))
          }
          
          df_output_user$output_target <- target_mirna
          df_output_user$input_id <- input_user_id
        }
      
      InsertarDatosBD(con_db = con, tabla_bd = TABLA_OUTPUT_USER, df_datos = df_output_user)
      if (is.null(mensaje_error) == FALSE) { DesconectarBD(con_db = con); return(FALSE) }
      
      DesconectarBD(con_db)
    }





  
  
  