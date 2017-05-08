source("global.R")

##API Ensemble Biomart
if(!require(biomaRt)){
  source("https://bioconductor.org/biocLite.R")
  biocLite("biomaRt")
  library(biomaRt)
}

if(!require(Biostrings)){
  source("https://bioconductor.org/biocLite.R")
  biocLite("Biostrings")
  library(Biostrings)
}

if(!require(mirbase.db)){
  source("https://bioconductor.org/biocLite.R")
  biocLite("mirbase.db")
  library("mirbase.db")
}

if(!require(seqinr)){
  install.packages("seqinr")
  library(seqinr)
}

if(!require(dplyr)){
  install.packages("dplyr")
  library(dplyr)
}

if(!require(jsonlite)){
  install.packages("jsonlite")
  library(jsonlite)
}



#' Función RecuperarDatasetsEnsembl(): conexión a Ensembl para recuperar el nombre de los datasets
#'
#' @return df_dat_ensembl: character vector - Nombre de datasets encontrados | FALSE (error)
#'
#' @examples RecuperarDatasetsEnsembl()

  RecuperarDatasetsEnsembl <- function()
    {
      print("Entrando en RecuperarDatasetsEnsembl")
      mensaje_error <<- NULL
      dat_ensembl <- NULL
      ##browser()
      tryCatch(
        dat_ensembl <- useEnsembl(biomart = BIOMART_ENSEMBL_RELEASE, host = HOST_ENSEMBL),
        
        warning = function(w) { print(paste("WARNING: ", w)); mensaje_aviso <<- msg_aviso_dataset_ensembl; debug(logger, w); return(FALSE) },
        error = function(e)   { print(paste("ERROR: ", e));   mensaje_error <<- msg_error_dataset_ensembl; error(logger, e); return(FALSE) }
      )
      if (is.null(dat_ensembl) == FALSE)
        {
        dat_ensembl <- sort(listDatasets(dat_ensembl)$dataset)
      }
      print("Saliendo de RecuperarDatasetsEnsembl")
      return (dat_ensembl)
  }


#' Función LeerArchivoFasta(archivo_fasta)
#' Lectura de archivos fasta con la función read.fasta de la librería seqinr
#' 
#' @return objeto read.fasta con el contenido del archivo | FALSE (error)
#' @param archivo_fasta character - nombre del archivo
#' 
#' @examples LeerArchivoFasta("ejemplo1.fasta")

  LeerArchivoFasta <- function(archivo_fasta)
    {
      ##browser()
      print("Entrando en LeerArchivoFasta")
      mensaje_error <<- NULL
      
      tryCatch(
        archivo <- read.fasta(archivo_fasta, forceDNAtolower = FALSE),
          
          warning = function(w) { print(paste("WARNING: ", w)); return(mensaje_aviso <<- paste(msg_aviso_lectura_fasta, archivo_fasta)); debug(logger, w); return(FALSE) },
          error = function(e)   { print(paste("ERROR: ", e));   return(mensaje_error <<- paste(msg_error_lectura_fasta, archivo_fasta)); error(logger, e); return(FALSE) }
        )
      
      print("Saliendo de LeerArchivoFasta")
      return(archivo)
  }

  
#' Función: LeerArchivoFastaBiostrings(archivo_fasta, tipo = "DNA"): 
#' Lectura de archivos fasta con las funcines readRNAStringSet y readDNAStringSet de la librería Biostrings
#' 
#' @param archivo_fasta character - nombre de archivo fasta
#' @param tipo character - "DNA" o "RNA" (valor por defecto: "RNA") 
#' 
#' @return objeto readRNAStringSet o readDNAStringSet con el contenido del archivo
#' 
#' @examples LeerArchivoFastaBiostrings("ejemplo1.fasta", "DNA")
  
  LeerArchivoFastaBiostrings <- function(archivo_fasta, tipo = "RNA")
    {
      print("Entrando en LeerArchivoFasta biostrings")
      ##browser()
      if (tipo == "RNA")
        {
          object_seq_fasta <- readRNAStringSet(archivo_fasta, "fasta")  # Fasta file upload mirRNA
      }
      else{
          object_seq_fasta <- readDNAStringSet(archivo_fasta, "fasta") # Fasta file upload mirDNA
      }
    
    print("Saliendo de LeerArchivoFasta biostrings")
    return(object_seq_fasta) 
  }


## miRNA ID -> SECUENCIA

#' Función RecuperarSecuenciasMirna(mirna_id, objeto_fasta = NULL, updateProgress = NULL)  
#' Obtención de la secuencia de un miRNA a partir de su ID 
#'
#' @param mirna_id character vector - miRNAs seleccionado por el usuario
#' @param objeto_fasta objeto seqinr - Objeto de tipo fasta seqinr (valor por defecto: NULL)
#' @param updateProgress función - barra de espera  (valor por defecto: NULL)
#'
#' @return df_mirna_id_seq - data.frame - mirna_id y mirna_seq | FALSE (error)
#' 
#' @examples RecuperarSecuenciasMirna(c("cel-mir-2", "cel-let-7"), archivo_fasta)

  RecuperarSecuenciasMirna <- function(mirna_id, objeto_fasta = NULL, updateProgress = NULL)
    {
      print("Entrando en RecuperarSecuenciasMirna")
    
      if (is.function(updateProgress)) { text <- "miRNA ID -> seq miRNA"; updateProgress(detail = text) }
      mensaje_error <<- NULL
      df_mirna_id_seq <- data.frame(stringsAsFactors = FALSE)
      df_mirna_id_seq_bd <- data.frame(stringsAsFactors = FALSE)
      v_id <- NULL
      v_mirna_id <- NULL
      #browser()
      
      if(length(mirna_id) != 0)
        {
          df_mirna_id_seq_bd <- RecuperarMirnaBD(mirna_id = mirna_id)

      }else
        {
          df_mirna_id_seq_bd <- RecuperarMirnaBD(mirna_id = sub(pattern = "\\|.*", "", x = names(objeto_fasta)))
      }
      if (is.null(mensaje_error) == FALSE) return(FALSE)
      
      tryCatch( 
        if(is.null(objeto_fasta))
          {
            #browser()      
            v_mirna_id <- mirna_id
            # Se comprueba si las secuencias están en base de datos antes de consultar mirbase

            if (nrow(df_mirna_id_seq_bd) > 0)
              {
                data_mirna_id <- unique(sort(df_mirna_id_seq_bd$mirna_id))
                idx <- which(mirna_id %in% data_mirna_id)
                v_mirna_id <- v_mirna_id[-idx]
                if(is.null(v_mirna_id) == FALSE) v_mirna_id <- unique(sort(v_mirna_id))
            }
            
            v_mirna_id <- unique(sort(v_mirna_id))
            
            #browser()
            if (length(v_mirna_id) > 0)
              {
                seq_mirbase <- mirbaseSEQUENCE # ftp://mirbase.org/pub/mirbase/CURRENT RELEASE 21
                df_mirbase <- links(seq_mirbase)
                colnames(df_mirbase) <- c("mirna_id", "mirna_seq")
                # Solo devuelve los mirna ID que estén en la BD de mirBase 
                df_mirna_id_seq <- subset(df_mirbase, df_mirbase$mirna_id %in% v_mirna_id, select = c("mirna_id", "mirna_seq"))
                df_mirna_id_seq <- arrange(df_mirna_id_seq, mirna_id)
                df_mirna_id_seq$mirna_ref <- rep(1,nrow(df_mirna_id_seq))
                # Se comprueba que devuelva resultados
                if(nrow(df_mirna_id_seq) == 0 && nrow(df_mirna_id_seq_bd) == 0 ) mensaje_error <<- msg_aviso_obtencion_mirna_seq_no_result
            }
  
        }else
          {
            #browser()
            # Los nombres del archivo fasta pueden tener 2 tipos de formato (no se pueden mezclar): 
            # hsa-mir-1|MI0006324 o hsa-mir-1 MI0006324
            v_mirna_id <- names(objeto_fasta)
            
            if(grep('|', v_mirna_id[1]) == 0 )
              {
                v_id <- sub(pattern = " .*", "", x = v_mirna_id)  
                v_acc <- sub(pattern = ".* ", "", x = v_mirna_id)
                
            }else
              {
                v_id <- sub(pattern = "\\|.*", "", x = v_mirna_id)
                v_acc <- sub(pattern = ".*\\|", "", x = v_mirna_id)
            }
            #browser()
            v_seq <- NULL
            #browser()
            mirna_seq <- getSequence(objeto_fasta)
            
            for(i in 1 : length(mirna_seq))
              {
                v_seq <- c(v_seq, paste(mirna_seq[[i]], collapse = ""))
            }
            df_mirna_id_seq <- cbind.data.frame(v_id, v_seq)
            
            references <- c()  
            if(nrow(df_mirna_id_seq_bd) == 0) 
              {
                df_mirna_id_seq$utr_ref <- rep(0, nrow(df_mirna_id_seq))
            }else
              {
                for(i in 1 : nrow(df_mirna_id_seq))
                  {
                    #browser()
                    df_ref <- subset(df_mirna_id_seq_bd, mirna_id == df_mirna_id_seq[i,2], select = c("mirna_ref"))
                    references <- c(references, ifelse(nrow(df_ref) == 0, 0, 1))
                }
                
                df_mirna_id_seq$utr_ref <- references
            }
            browser()
            
            names(df_mirna_id_seq) <- c("mirna_id", "mirna_seq", "mirna_ref")
        },
        
        df_mirna_id_seq <- rbind.data.frame(df_mirna_id_seq, df_mirna_id_seq_bd, stringsAsFactors = FALSE),
        print("Saliendo de RecuperarSecuenciasMirna") ,
        
          warning = function(w) { print(paste("WARNING: ", w)); mensaje_aviso <<- msg_aviso_obtencion_mirna_seq; debug(logger, w); return(FALSE) },
          error = function(e)   { print(paste("ERROR: ", e));   mensaje_error <<- msg_error_obtencion_mirna_seq; debug(logger, w); return(FALSE) }
      )

      #browser()
      print("Saliendo de RecuperarSecuenciasMirna")
      return(df_mirna_id_seq)
  }
  
  
## gen ID -> SECUENCIA  3'UTR

#' Función RecuperarSecuenciasExtremo3utr(gen_id, data_sel, gen_id_ref, objeto_fasta = NULL, updateProgress = NULL) 
#' Recupera secuencias de 3'UTR en Ensembl o la base de datos a partir de gen ID
#' 
#' @param gen_id character - valor del campo "gen id" (valor por defecto: NULL)
#' @param data_sel character vector - dataset de "Ensembl" seleccionado por el usuario
#' @param gen_id_ref character vector - selección campo radio con la bd de referencia 
#' @param objeto_fasta objeto seqinr - objeto de archivo fasta (valor por defecto: NULL)
#' @param updateProgress función - barra de espera (valor por defecto: NULL)
#' 
#' @return df_gen_utr_id_seq - data.frame 3'UTR ID, gen ID, secuencia de extremo 3'UTR y 0 (no ref) | 1 (ref)
#' 
#' @examples RecuperarSecuenciasExtremo3utr("ENSG00000139618", "hsapiens_gene_ensembl", "ensembl" )
  
  RecuperarSecuenciasExtremo3utr <- function(gen_id = NULL, data_sel, gen_id_ref, objeto_fasta = NULL, updateProgress = NULL)
    {
      print("Entrando en RecuperarSecuenciasExtremo3utr")
      mensaje_error <<- NULL
      consulta_sql <- NULL
      objeto_fasta_utr <- NULL
      df_gen_utr_id_seq <- data.frame(stringsAsFactors = FALSE)
      df_gen_utr_id_seq_bd <- data.frame(stringsAsFactors = FALSE)
      v_gen_id <- NULL
      v_gen_id_no_precomp <- NULL
      
      #browser()
      if (data_sel[1] == "Todos") data_sel <- data_sel[-1] # Se elimina "Todos" del vector de datasets
      #browser()
      # Se comprueba si el extremo 3'UTR está en la base datos antes de consultar con Biomart 
      if(is.null(gen_id) == FALSE)
        {
          df_gen_utr_id_seq_bd <- RecuperarUtrBD(gen_id = paste(gen_id, collapse = "','"))
      }else
        {
          df_gen_utr_id_seq_bd <- RecuperarUtrBD(utr_id = sub(pattern = ".*\\|", "", x = names(objeto_fasta)))
        }

      if (is.null(mensaje_error) == FALSE) return(FALSE)
      #browser()
      if(is.null(objeto_fasta))
        {
          #browser()
          v_gen_id <- unique(sort(gen_id))
          if (nrow(df_gen_utr_id_seq_bd) > 0)
            {
              data_gen_id <- unique(sort(df_gen_utr_id_seq_bd$utr_gen_id))
            
              idx <- which(v_gen_id %in% data_gen_id)
              v_gen_id_no_precomp <- v_gen_id[-idx]
              if (is.null(v_gen_id_no_precomp) == FALSE) v_gen_id_no_precomp <- unique(sort(v_gen_id_no_precomp))
          }else
            {
              v_gen_id_no_precomp <- v_gen_id
          }
          
          #browser()
          if (length(v_gen_id_no_precomp) > 0)
            {
              for(i in 1 : length(data_sel))
                {
                  if (is.function(updateProgress)) { text <- "gen ID -> seq 3'UTR"; updateProgress(detail = text) }
      
                  ##browser()
                  atts_ensembl <- c()
                  for(j in 1 : length(attributes_ensembl))
                    {
                      atts_ensembl <- c(atts_ensembl, sprintf(uri_xml_utr_att, attributes_ensembl[j]))
                  }
                  
                  atts_ensembl <- paste0(atts_ensembl, collapse = "")
                  ##browser()
                  uri_req <- sprintf(uri_xml_utr_query_1, as.character(data_sel[i]), 
                                     gen_id_ref, 
                                     paste(as.character(v_gen_id_no_precomp), collapse = ","),
                                     atts_ensembl, 
                                     uri_xml_utr_query_2)
                  
                  uri_req <- (paste0(uri_end_point, uri_req))
                  ##browser()
                  
                  
                  # Petición y descarga de datos mediante API
                  tryCatch(
                    system(command = paste("wget -O ", paste(ruta_archivo_API_fasta, uri_req))),  # CONEXIÓN API: descarga de archivos
                    
                      warning = function(w) { print(paste("WARNING: ", w));  mensaje_aviso <<- msg_aviso_biomart_xml_utr_ensembl; debug(logger, w); return(FALSE) },
                      error = function(e)   { print(paste("ERROR: ", e));    mensaje_error <<- msg_error_biomart_xml_utr_ensembl; error(logger, e); return(FALSE) }
                    )
                  ##browser()
                  #if (is.null(mensaje_error) == FALSE) return(df_gen_utr_id_seq <- NULL)
                  ##browser()
                  
                  if (file.info(ruta_archivo_API_fasta)$size != 0)  # Se comprueba si el archivo contiene datos
                    {
                      tryCatch(
                        seq_validas <- EliminarSeqNoValidasFasta(archivo = ruta_archivo_API_fasta),
                        
                          warning = function(w) { print(paste("WARNING: ", w)); mensaje_error <<- msg_aviso_archivo_fasta_utr_ensembl; debug(logger, w); return(FALSE) },
                          error = function(e)   { print(paste("ERROR: ", e));   mensaje_error <<- msg_error_archivo_fasta_utr_ensembl; error(logger, e); return(FALSE) }
                        )
                  
                    if (is.null(mensaje_error) == FALSE) return(df_gen_utr_id_seq)
                    ##browser()
                    fileConn <- file(ruta_archivo_seq_validas_API_fasta)
                    
                    tryCatch(
                      write(x = seq_validas[,1], file = fileConn, append = TRUE),
                        warning = function(w) { print(paste("WARNING: ", w));  mensaje_aviso <<- msg_aviso_biomart_xml_archivo_utr_ensembl; debug(logger, w); return(FALSE) },
                        error = function(e)   { print(paste("ERROR: ", e));    mensaje_error <<- msg_error_biomart_xml_archivo_utr_ensembl; error(logger, e); return(FALSE) }
                    )
                    #browser()
                    close(con = fileConn)

                    if (file.info(ruta_archivo_validas_API_fasta)$size > 1)
                      {
                        objeto_fasta_utr <- LeerArchivoFasta(archivo = ruta_archivo_validas_API_fasta)
                    }
                    if (is.null(mensaje_error) == FALSE) return(FALSE)
                  }
              }
          }
            
      }else
         {
           objeto_fasta_utr <- objeto_fasta      
        }
      #tryCatch( 
        if(is.null(objeto_fasta_utr) == FALSE)
          {
            #browser()
            mapply(names(objeto_fasta_utr), getSequence(objeto_fasta_utr), 
                   FUN = function(x, y) {
                   df_gen_utr_id_seq <<- rbind(df_gen_utr_id_seq, c(sub(pattern = "\\|.*", "", x = x), # gen ID
                                                                        sub(pattern = ".*\\|", "", x = x), # 3'UTR ID
                                                                        paste(y, collapse = "")), stringsAsFactors = FALSE) })
            #browser()
            references <- c()  
            if(nrow(df_gen_utr_id_seq_bd) == 0) 
              {
                df_gen_utr_id_seq$utr_ref <- rep(0, nrow(df_gen_utr_id_seq))
            }else
              {
                for(i in 1 : nrow(df_gen_utr_id_seq))
                  {
                    #browser()
                    df_ref <- subset(df_gen_utr_id_seq_bd, utr_id == df_gen_utr_id_seq[i,2], select = c("utr_ref"))
                    references <- c(references, ifelse(nrow(df_ref) == 0, 0, 1))
                }
                df_gen_utr_id_seq$utr_ref <- references
                colnames(df_gen_utr_id_seq_bd) <- c("gen_id", "utr_id", "utr_seq", "utr_ref")
              }
          }
          #browser(),
          
          df_gen_utr_id_seq <- rbind.data.frame(df_gen_utr_id_seq, df_gen_utr_id_seq_bd, stringsAsFactors = FALSE)
          colnames(df_gen_utr_id_seq) <- c("gen_id", "utr_id", "utr_seq", "utr_ref")
          df_gen_utr_id_seq <- arrange(df_gen_utr_id_seq, gen_id)
        
       #     warning = function(w) { print(paste("WARNING: ", w));  mensaje_aviso <<- msg_aviso_recuperar_utr_bd; debug(logger, w); return(FALSE) },
       #      error = function(e)   { print(paste("ERROR: ", e));    mensaje_error <<- msg_error_recuperar_utr_bd; error(logger, e); return(FALSE) }
       #    )
      #browser()
      if (nrow(df_gen_utr_id_seq) == 0)  
        { 
          mensaje_error <<- msg_aviso_obtencion_utr_seq_no_result
          return (FALSE)
      }
      
      #browser()

      # Se borra el archivo
      file.remove(ruta_archivo_validas_API_fasta)
      print("Saliendo de buscar_extremo_3utr_seq")
      
      return (df_gen_utr_id_seq)
  }
  
  
#' Función ClasificarIDReferencia(id, data_sel, tipo, updateProgress = NULL) 
#' Comprueba si un mirna id o gen id de un archivo fasta es de referencia o nuevo
#' consultando las bases de datos de Biomart Ensembl
#' 
#' @param id character vector - mirna ID o 3'UTR ID 
#' @param data_sel character vector - datasets de Emsembl seleccionados por el usuario
#' @param tipo character - "mirnaid" (miRNA ID) | otro (3'UTR ID)
#' @param updateProgress function - barra de ejecución (valor por defecto: NULL)
#'
#' @return df_es_ref data.frame - valores: IDs -> 1 (referencia) | 0 (nuevo) 
#'
#' @examples ClasificarIDReferencia(c("hsa-mir-217"), "mirnaid", NULL)
  
  ClasificarIDReferencia <- function(id, data_sel, tipo, updateProgress = NULL)
    {
      print("Entrando en ClasificarIDReferencia")
      mensaje_error <<- NULL
      df_es_ref <- NULL
      ##browser()
      tryCatch(
        ##browser(),
        if(tipo=="mirnaid")
          {
            if (is.function(updateProgress)) { text <- "Referencia miRNA | Nueva"; updateProgress(detail = text) }
          
            v_mirna_ids <- sub(pattern = "\\|.*", "", x = id)
            mirna_id <- mirbaseSEQUENCE
            mirna_id_keys <- mappedkeys(mirna_id)
            
            es_mirna_ref <- sapply(v_mirna_ids, function(x) { if(length(which(x %in% mirna_id_keys)) == 0) 0 else 1 })
            df_es_ref <- data.frame(mirna_id = names(es_mirna_ref), mirna_ref = c(es_mirna_ref))
  
        }else 
          { 
            ##browser()
            v_gen_ids <- sub(pattern="\\|.*", "", x = id)
            v_utr_ids <- sub(pattern=".*\\|", "", x = id)
    
            df_es_ref <- data.frame(gen_id = v_gen_ids, gen_ref = 1, utr_id = v_utr_ids, utr_ref = 0) 
            
            relacion_gen_total <- data.frame()
            relacion_utr_total <- data.frame()
            ##browser()          
            tryCatch(
              for(i in 1 : length(data_sel))
                {
                  if (is.function(updateProgress)) { text <- "Referencia gen UTR | Nueva"; updateProgress(detail = text) }
                  
                  ensembl <- useMart(biomart=BIOMART_ENSEMBL_RELEASE,
                                     host = HOST_ENSEMBL,
                                     path = PATH_ENSEMBL,
                                     port = PORT_ENSEMBL,
                                     dataset = as.character(data_sel[i]))
    
                  ##browser()
                  relacion_gen_ids <- getBM(attributes = "ensembl_gene_id",
                                            filters = "ensembl_gene_id", 
                                            values = df_es_ref$gen_id, 
                                            mart = ensembl)
                    
                  relacion_gen_total <- rbind(relacion_gen_total, relacion_gen_ids)
  
                  relacion_utr_ids <- getBM(attributes = "ensembl_transcript_id",
                                            filters = "ensembl_transcript_id", 
                                            values = df_es_ref$utr_id, 
                                            mart = ensembl)
                    
                  relacion_utr_total <- rbind(relacion_utr_total, relacion_utr_ids)
              },
              
                warning = function(w) { print(paste("WARNING: ", w)); mensaje_aviso <<- msg_aviso_biomart_utr_ensembl; debug(logger, w); return(FALSE) }, 
                error = function(e)   { print(paste("ERROR: ", e));   mensaje_error <<- msg_error_biomart_utr_ensembl; error(logger, e); return(FALSE) } 
            )
          
          if (is.null(mensaje_error) == FALSE) return(FALSE)
            
          es_gen_ref <- sapply(df_es_ref$gen_id, function(x) { if(length(which(x %in% relacion_gen_total[,1])) == 0) 0 else 1 })  
          df_es_ref$gen_ref <- es_gen_ref
  
          es_utr_ref <- sapply(df_es_ref$utr_id, function(x) { if(length(which(x %in% relacion_utr_total[,1])) == 0) 0 else 1 })  
          df_es_ref$utr_ref <- es_utr_ref
          
          df_es_ref <- df_es_ref[order(df_es_ref$gen_id),] 
        },
  
          warning = function(w) { print(paste("WARNING: ", w));  mensaje_aviso <<- msg_aviso_buscar_referencias; debug(logger, w); return(FALSE) },
          error = function(e)   { print(paste("ERROR: ", e));    mensaje_error <<- msg_error_buscar_referencias; error(logger, e); return(FALSE) } 
      )
      
      print("Saliendo de ClasificarIDReferencia") 
      
      ##browser()
      return(df_es_ref)
  }
  
  
#' Función RecuperarMirnaBD(mirna_id)
#' Recupera información sobre miRNA de la base de datos (tabla mirna)
#'
#' @param mirna_id character vector - mirna ID
#'
#' @return data: data.frame - Datos de miRNA de la tabla mirna | FALSE (error)
#'
#' @examples RecuperarMirnaBD("hsa-mir-181a-2")

  RecuperarMirnaBD <- function(mirna_id)
    {
      print("Entrando en RecuperarMirnaBD") 
      
      con <- ConectarBD()
      if (is.null(mensaje_error) == FALSE) { return(FALSE) }
    
      v_mirna_id <- unique(sort(mirna_id))
      browser()
      consulta_sql <- sprintf(SQL_SELECT_MIRNA, mirna_id)
    
      data <- ConsultarDatosBD(con_db = con, consulta_sql = consulta_sql)
      if (is.null(mensaje_error) == FALSE) { DesconectarBD(con_db = con); return(FALSE) }
      
      DesconectarBD(con_db = con)
      
      print("Saliendo de RecuperarMirnaBD") 
      return(data)
  }
  
  
  #' Función RecuperarUtrBD(gen_id)
  #' Recupera información sobre extremos 3'UTR de la base de datos (tabla utr_gen)
  #'
  #' @param gen_id character vector - gen IDs (valor por defecto: NULL)
  #' @param utr_id character vector - 3'UTR IDs (valor por defecto: NULL)
  #'  
  #' @return data: data.frame - Datos de extremo 3'UTR de la tabla utr_gen | FALSE (error)
  #'
  #' @examples RecuperarUtrBD("ENSG00000139620")
  
  RecuperarUtrBD <- function(gen_id = NULL, utr_id = NULL)
    {
      #browser()
      print("Entrando en RecuperarUtrBD") 
    
      con <- ConectarBD()
      if (is.null(mensaje_error) == FALSE) { return(FALSE) }
      
      data <- NULL
      if (is.null(gen_id) == FALSE)
        {
          consulta_sql <- sprintf(SQL_SELECT_UTR1, gen_id)
      }else
        {
          consulta_sql <- sprintf(SQL_SELECT_UTR2, utr_id)
      }
      data <- ConsultarDatosBD(con_db = con, consulta_sql = consulta_sql)
      if (is.null(mensaje_error) == FALSE) { DesconectarBD(con_db = con); return(FALSE) }
      #browser()
      DesconectarBD(con_db = con)
      print("Saliendo de RecuperarUtrBD") 
      return(data)
  }  
  
  #' Title
  #'
  #' @param utr_id 
  #'
  #' @return
  #' @export
  #'
  #' @examples
  ObtenerUtrParalogos <- function(utr_id)  
    {
      atts_ensembl <- paste0(atts_ensembl, collapse = "")
      ##browser()
      
      uri_req <- sprintf(uri_xml_utr_query_1, as.character(data_sel[i]), 
                         gen_id_ref, 
                         paste(as.character(v_gen_id), collapse = ","),
                         atts_ensembl, 
                         uri_xml_utr_query_2)
    
      uri_req <- (paste0(uri_end_point, uri_req))
    
    
      # Petición y descarga de datos mediante API
      tryCatch(
        system(command = paste("wget -O ", paste(ruta_archivo_paralogos_API_fasta, uri_req))),  # CONEXIÓN API: descarga de archivos
        
        warning = function(w) { print(paste("WARNING: ", w));  mensaje_aviso <<- msg_aviso_biomart_xml_utr_ensembl; debug(logger, w); return(FALSE) },
        error = function(e)   { print(paste("ERROR: ", e));    mensaje_error <<- msg_error_biomart_xml_utr_ensembl; error(logger, e); return(FALSE) }
      )
  }