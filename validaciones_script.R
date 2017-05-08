
#### FUNCIONES DE VALIDACIÓN ####
# Validación de genes ID

#' Función ValidarTextGenID(gen_id, tipo_ref = "ensembl_gene_id"): 
#' Valida gen ID introducidos por el usuario según nomenclatura seleccionada
#' Implementado solamente para nomenclatura "Ensembl"
#' 
#' @param gen_id character - gen ID 
#' @param tipo_ref character - Nomenclatura: "ensembl_gene_id" (Ensembl) | "entrezgene" (Entrez gene) | "refseq" (RefSeq) - (Valor por defecto: "ensembl_gene_id")
#'
#' @return boolean - TRUE | FALSE
#'
#' @examples ValidarTextGenID("ENS000021", "ensembl_gene_id")

  ValidarTextGenID <- function(gen_id, tipo_ref = "ensembl_gene_id") 
    {
      #browser()    
      mensaje_error <<- NULL

      print("Entrando en ValidarTextGenID")

      tryCatch(
        if (tipo_ref == "ensembl_gene_id")   # Validación para gen ID ensembl (que empiece por ENS: sólo se valida si hay uno)
          {   
            for (i in 1 : length(gen_id))
              {
                if (gen_id[i] != "" && nchar(gen_id[i]) != 15 && regexpr('^ENSG([0-9])+', gen_id[i])[1] < 0)  # Si tiene 15 posiciones y empieza por ENSG
                  {
                    mensaje_error <<- msg_aviso_text_utr
                    return(FALSE)
                }
            }
            
        }else if (tipo_ref == "entrezgene") # Validación para gen ID NCBI gene ID (entrezgene)
          {
            for (i in 1 : length(gen_id))
              {
                browser()
                if (gen_id[i] != "" && suppressWarnings(!is.na(as.integer(gen_id[i]))) == FALSE) # Comprueba si es un número entero
                  {
                    mensaje_error <<- msg_aviso_text_utr
                    return(FALSE)
                }
            }
        }
        else if (tipo_ref == "unigene") # Validación para gen ID unigene
          {
            for (i in 1 : length(gen_id))
              {
                browser()
                if (gen_id[i] != "" && regexpr('^[a-zA-Z]{2}\\.[0-9]+$', gen_id[i])[1] == FALSE) # 2 letras, un punto y el resto números enteros
                {
                  mensaje_error <<- msg_aviso_text_utr
                  return(FALSE)
                }
              }
        },
        
          warning = function(w) { print(paste("WARNING: ", w)); debug(logger, w); mensaje_aviso <<- msg_aviso_obtencion_utr_seq; return(FALSE) },
          error = function(e)   { print(paste("ERROR: ", e));   error(logger, e); mensaje_error <<- msg_error_obtencion_utr_seq; return(FALSE) }
        )
      
      print("Saliendo de ValidarTextGenID")
      return(TRUE)
    }


#' Función ValidarArchivoFasta(archivo_fasta): valida archivos fasta (formato y tipo de secuencia)
#'
#' @param archivo_fasta_info data.frame - Datos de archivo fasta seleccionados por el usaurio
#'
#' @return boolean TRUE | FALSE
#'
#' @examples ValidarArchivoFasta(data.frame(nombre="archivo.fasta", size="23" ruta = "archivos fasta" ))

  ValidarArchivoFasta <- function(archivo_fasta_info)
    {
      print("entrada en ValidarArchivoFasta")
      mensaje_error <<- NULL
      #browser()
      tryCatch(
        for (i in 1:nrow(archivo_fasta_info)) 
          {
            if (archivo_fasta_info[i,2] > 5)  # Archivo vacío
              {
                #browser()
                if (archivo_fasta_info[i,5] == "RNA") # Tipo de secuencia correcta
                    {
                      LeerArchivoFastaBiostrings(archivo = archivo_fasta_info[i,4], tipo = "RNA")
                  }
                else
                    {
                      LeerArchivoFastaBiostrings(archivo = archivo_fasta_info[i,4], tipo = "DNA")
                  }

            }else
              {
                #browser()
                mensaje_error <<- msg_aviso_fasta_vacio 
                return(FALSE)              
            }
          
        },
          warning = function(w) { print(paste("WARNING: ", w)); mensaje_error <<- msg_aviso_validacion_fasta; return(FALSE) }, # En este caso el warning también es motivo para cancelar el proceso
          error = function(e)   { print(paste("ERROR: ", e));   mensaje_error <<- msg_error_validacion_fasta; return(FALSE) }
      )
      #browser()
      if (is.null(mensaje_error) == FALSE) return(FALSE) else return(TRUE)
      print("salida de ValidarArchivoFasta")
      
  }
  
  
#' Función EliminarSeqNoValidasFasta(archivo_fasta): 
#' Elimina secuencias de nucleótidos en formato fasta con la secuencia "no disponible": "Sequence unavailable"
#'
#' @param archivo_fasta objeto fasta - Archivo con formato fasta
#'
#' @return data.frame - Secuencias de nueclótidos completas
#'
#' @examples EliminarSeqNoValidasFasta("/archivos.fasta")

  EliminarSeqNoValidasFasta <- function (archivo_fasta)
    {
      print("Entrada en EliminarSeqNoValidasFasta")  
      mensaje_error <<- NULL
      df_seq <- NULL
      #browser()
     
      df_seq <- read.table(file = archivo_fasta, sep = "\n", stringsAsFactors = FALSE)
      
      for (i in (1:nrow(df_seq)))
        {
          if (df_seq[i,1] == "Sequence unavailable")
            {
            df_seq[i, 1] <- NA
            df_seq[i-1, 1] <- NA
            trimws(df_seq[i, 1])
          }
        }
      
      df_seq <- na.omit(df_seq)
        
      #browser()
      if (is.null(mensaje_error)) print("Salida de EliminarSeqNoValidasFasta...OK") else print("Salida de EliminarSeqNoValidasFasta...no OK")
      return(df_seq)
  }
 
