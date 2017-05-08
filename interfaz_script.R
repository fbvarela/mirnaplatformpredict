
#' Función IdentificarBindingSitesPotenciales(mirna_info, utr_info, mirna_utr_no_precomp = NULL)
#' Ejecuta el primer paso del algoritmo de predicción para identificar los binding-sites potenciales
#' Se pueden calcular todos los pares miRNA y 3'UTR o sólo aquellos no precomputados
#'
#' @param mirna_info data.frame - Datos de ID y secuencia de miRNA
#' mirna_id: character - ID de miRNA
#' mirna_seq: character - secuencia de nucleótidos de miRNA
#' 
#' @param utr_info data.frame - Datos de ID y secuencia de extremo 3'UTR
#' utr_id: character - ID de 3'UTR
#' utr_gen: character - ID de gen
#' utr_seq: character - secuencia de nucleótidos de extremos 3'UTR
#' 
#' @param mirna_utr_no_precomp data.frame - ID de pares miRNA y 3'UTR no precomputados
#' bs_id: integer
#' mirna_id: character
#' utr_id: character
#' precomp: integer
#' 
#' @param updateProgress función - barra de espera (valor por defecto: NULL)
#' 
#' @return df_binding_sites_potenciales: data.frame - info de binding-sites potenciales
#'
#' Estructura de df_binding_sites_potenciales
#' bs_id integer - PK NOT NULL (valor: 0)
#' mirna_id - character 
#' utr_id - character 
#' feat_id - integer (valor: 0)
#' bs_mirna_seq_start - integer
#' bs_mirna_seq_end - integer
#' bs_utr_seq_start - integer
#' bs_utr_seq_end - integer
#' bs_seq_seed - character 
#' bs_seq_seed_start - integer
#' bs_seq_seed_end - integer
#' bs_seq_region_3 - character 
#' bs_seq_region_3_start - integer
#' bs_seq_region_3_end - integer
#' bs_seq_region_total - character 
#' bs_seq_region_total_start - integer
#' bs_seq_region_total_end - integer
#' bs_score - character 
#' bs_scoring_matrix - array
#' bs_type - integer NOT NULL valor 0: potencial
#' bs_other - json (clave: valor)
#' 
#' @examples IdentificarBindingSitesPotenciales(c("hsa-mir-510", 1, 1, "GUGGUGUCCUACUCAGGAGAGUGGCAAUCACAUGUAAUUAGGUGUGAUUGAAACCUCUAAGAGUGGAGUAACAC"), 
#' c("ENST00000367029", 1, 1, "GAACTGTGGGAGACCAGCGGAGTGGGAGGGAGACGCAGTAGACAGAGACAGACCGAGAGAGGAATGGAGAGACAGAGGGGGCGCGCGCACAGGAGCCTGACTCCGCTGGGAGAGTGCAG
#' GAGCACGTGCTGTTTTTTATTTGGACTTAACTTCAGAGAAACCGCTGACATCTAGAACTGACCTACCACAAGCATCCACCAAAGGAGTTTGGGATTGAGTTTTGCTGCTGTGCAGCACTGCATTGTCATGACATTTCCAACACTGTGTGA
#' ATTATCTAAATGCGTCTACCATTTTGCACTAGGGAGGAAGGATAAATGCTTTTTATGTTATTATTATTAATTATTACAATGACCACCATTTTGCATTTTGAAATAAAAAAACTTTTTATACCA"), updateProgress)

  IdentificarBindingSitesPotenciales <- function(mirna_info, utr_info, mirna_utr_no_precomp = NULL, updateProgress = NULL)
    {
      tryCatch(
        df_binding_sites_potenciales <- data.frame(),
        
        ## Código de la función
        
        warning = function(w) { print(paste("WARNING: ", w)); mensaje_aviso <<- msg_aviso_calculo_bs_potenciales; return(FALSE) }, 
        error = function(e)   { print(paste("ERROR: ", e));   mensaje_error <<- msg_error_calculo_bs_potenciales; return(FALSE) }
      )
      
      return(df_binding_sites_potenciales)
  }
  
  
#' Función ObtenerFeatures(binding_sites_potenciales, updateProgress = NULL)
#' Ejecuta el segundo paso del algoritmo de predicción para identificar los features
#'
#' @param binding_sites_potenciales data.frame - info sobre binding-sites
#' 
#' Estructura de binding_sites_potenciales
#' bs_id integer - PK NOT NULL 
#' mirna_id - character 
#' utr_id - character 
#' feat_id - integer,
#' bs_mirna_seq_start - integer
#' bs_mirna_seq_end - integer
#' bs_utr_seq_start - integer
#' bs_utr_seq_end - integer
#' bs_seq_seed - character 
#' bs_seq_seed_start - integer
#' bs_seq_seed_end - integer
#' bs_seq_region_3 - character 
#' bs_seq_region_3_start - integer
#' bs_seq_region_3_end - integer
#' bs_seq_region_total - character 
#' bs_seq_region_total_start - integer
#' bs_seq_region_total_end - integer
#' bs_score - character 
#' bs_scoring_matrix - array
#' bs_type - integer NOT NULL
#' bs_other - json (clave: valor)
#' 
#' @param updateProgress función - barra de espera (valor por defecto: NULL)
#' 
#' @return df_features: data.frame - Datos de los features. 
#' Importante: hay que incluir el ID de binding_sites (campo bs_id) pasado en el parámetro binding_sites_potenciales
#'
#' Estructura de df_features
#' bs_id integer (binding_sites ID)
#' feat_seed_type_id - integer
#' feat_seed_score- double(6, 2)
#' feat_seed_pct - double(6, 2)
#' feat_seed_add - json (clave: valor)
#' feat_cons_mf_id - integer
#' feat_cons_ms_id - integer
#' feat_cons_add - json (clave: valor)
#' feat_free_energy - double(6, 2)
#' feat_free_energy_add - json (clave: valor)
#' feat_insite_fe_region - json (clave: valor)
#' feat_insite_match_region - json (clave: valor)
#' feat_insite_mismatch_region - json (clave: valor)
#' feat_insite_gc_match_region - json (clave: valor)
#' feat_insite_gc_mismatch_region - json (clave: valor)
#' feat_insite_au_match_region - json (clave: valor)
#' feat_insite_au_mismatch_region - json (clave: valor)
#' feat_insite_gu_match_region - json (clave: valor)
#' feat_insite_gu_mismatch_region - json (clave: valor)
#' feat_insite_bulges_mirna_region - json (clave: valor)
#' feat_insite_bulged_nucl_region - json (clave: valor)
#' feat_insite_add - json (clave: valor)
#' feat_acc_energy - double(5, 2)
#' feat_ae_add - json (clave: valor)
#' feat_new -  string ("(name: string, description: string, attributes: jsonb resume: text)") Si no, cadena vacía ("")
#' 
#' @examples ObtenerFeatures(df_binding_sites, updateProgress)
#' df_binding_sites <- data.frame(26, 'hsa-mir-510', 'ENST00000367029', NULL, 9, 4, 54, 65, 'AGUAACAC', 2, 54, 
#' 'CUAAGAGUGG', 3, 32, 'CUAAGAGUGGAGUAACAC', 5, 23, 152.2, '{{1, 2, 3},{2, 3, 4}}', 0, '{}');)
#'
#' names(df_binding_sites) <- c("bs_id", "mirna_id", "utr_id", "bs_mirna_seq_start", "bs_mirna_seq_end",
#' "bs_utr_seq_start", "bs_utr_seq_end", "bs_seq_seed", "bs_seq_seed_start", "bs_seq_seed_end", "bs_seq_region_3",
#' "bs_seq_region_3_start", "bs_seq_region_3_end", "bs_seq_region_total", "bs_seq_region_total_start",
#' "bs_seq_region_total_end", "bs_score", "bs_scoring_matrix", "bs_type", "bs_other")

  ObtenerFeatures <- function(binding_sites_potenciales, updateProgress = NULL)
    {
      tryCatch(
        df_features <- data.frame(),
        ## Código de la función

        warning = function(w) { print(paste("WARNING: ", w)); mensaje_aviso <<- msg_aviso_calculo_features; return(FALSE) }, 
        error = function(e)   { print(paste("ERROR: ", e));   mensaje_error <<- msg_error_calculo_features; return(FALSE) }
    )
    
    return(df_features)
  }
  
  
#' Función EvaluarBindingSitesPotenciales(bs_potenciales, features)
#' Ejecuta el tercer paso del algoritmo de predicción: evaluación de los binding-sites potenciales
#'
#' @param bs_potenciales data.frame - info de binding-sites potenciales
#' 
#' Estructura de bs_potenciales
#' bs_id integer - PK NOT NULL 
#' mirna_id - character 
#' utr_id - character 
#' feat_id - integer,
#' bs_mirna_seq_start - integer
#' bs_mirna_seq_end - integer
#' bs_utr_seq_start - integer
#' bs_utr_seq_end - integer
#' bs_seq_seed - character 
#' bs_seq_seed_start - integer
#' bs_seq_seed_end - integer
#' bs_seq_region_3 - character 
#' bs_seq_region_3_start - integer
#' bs_seq_region_3_end - integer
#' bs_seq_region_total - character 
#' bs_seq_region_total_start - integer
#' bs_seq_region_total_end - integer
#' bs_score - character 
#' bs_scoring_matrix - array
#' bs_type - integer NOT NULL
#' bs_other - json (clave: valor)
#' 
#' @param features data.frame - info de features asociados a los binding-sites
#'
#' Estructura de features
#' bs_id - integer (binding_sites ID)
#' feat_seed_type_id - integer
#' feat_seed_score - double(6, 2)
#' feat_seed_pct - double(6, 2)
#' feat_seed_add - json (clave: valor)
#' feat_cons_mf_id - integer
#' feat_cons_ms_id - integer
#' feat_cons_add - json (clave: valor)
#' feat_free_energy - double(6, 2)
#' feat_free_energy_add - json (clave: valor)
#' feat_insite_fe_region - json (clave: valor)
#' feat_insite_match_region - json (clave: valor)
#' feat_insite_mismatch_region - json (clave: valor)
#' feat_insite_gc_match_region - json (clave: valor)
#' feat_insite_gc_mismatch_region - json (clave: valor)
#' feat_insite_au_match_region - json (clave: valor)
#' feat_insite_au_mismatch_region - json (clave: valor)
#' feat_insite_gu_match_region - json (clave: valor)
#' feat_insite_gu_mismatch_region - json (clave: valor)
#' feat_insite_bulges_mirna_region - json (clave: valor)
#' feat_insite_bulged_nucl_region - json (clave: valor)
#' feat_insite_add - json (clave: valor)
#' feat_acc_energy - double(5, 2)
#' feat_ae_add - json (clave: valor)
#' feat_new_id - integer
#' 
#' @param updateProgress función - barra de espera (valor por defecto: NULL)
#' 
#' @return data.frame - ID de binding-sites definitivos
#'
#' @examples EvaluarBindingSitesPotenciales (df_binding_sites, df_features, updateProgress)
#' df_binding_sites <- data.frame(2, 13, "hsa-mir-181a-2", "ENST00000354071", "", 25, 4, 54, 65, "AAACACAACAAAACCAT", 2, 
#' 54, "AAACACA", 3, 32, "AAACACAACAAAAAACACAACAAA", 5, 23, 152.2,"{1, 2, 3},{2, 3, 4}", 1, "{}", stringsAsFactors = FALSE)
#' 
#' names(df_binding_sites) <- c("bs_id", "mirna_id", "utr_id", "feat_id", "bs_mirna_seq_start", "bs_mirna_seq_end",
#' "bs_utr_seq_start", "bs_utr_seq_end", "bs_seq_seed", "bs_seq_seed_start", "bs_seq_seed_end", "bs_seq_region_3",
#' "bs_seq_region_3_start", "bs_seq_region_3_end", "bs_seq_region_total", "bs_seq_region_total_start", 
#' "bs_seq_region_total_end","bs_score","bs_scoring_matrix","bs_type","bs_other")
#' 
#' df_features <- data.frame(8, 15, 128.30, 54.20, "{'seed_k': 23}", 4, 1, "{'cons_x': 'conservationx'}", 123.30,
#' "{free_energy_x': 332.3}", "{rt': 21.3, r2': 34, r3': 332.3}","{'rt': 5.3, 'r2': 43, 'r3': 23.3}",
#' "{'rt': 4.3, 'r2': 34, 'r3': 43.3}", "{'rt': 2.3, 'r2': 1, 'r3': 65.3}", "{'rt': 0.3, 'r2': 32, 'r3': 3.3}",
#' "{'rt': 7.3, 'r2': 6, 'r3': 67.3}", "{'rt': 5.3, 'r2': 5, 'r3': 4.3}", "{'rt': 21.3, 'r2': 34, 'r3': 5.3}",
#' "{'rt': 2.3, 'r2': 34, 'r3': 78.3}", "{'rt': 21.3, 'r2': 7.8, 'r3': 98.3}", "{'rt': 6.3, 'r2': 34.8, 'r3': 332.3}",
#' "{}", 232.00, "", 1, stringsAsFactors = FALSE)
#' 
#' names(df_features) <- c("feat_id", "feat_seed_type_id", "feat_seed_score", "feat_seed_pct", "feat_seed_add", "feat_cons_mf_id", 
#' "feat_cons_ms_id", "feat_cons_add", "feat_free_energy", "feat_free_energy_add", "feat_insite_fe_region", "feat_insite_match_region", 
#' "feat_insite_mismatch_region", "feat_insite_gc_match_region", "feat_insite_gc_mismatch_region", "feat_insite_au_match_region", 
#' "feat_insite_au_mismatch_region", "feat_insite_gu_match_region", "feat_insite_gu_mismatch_region", "feat_insite_bulges_mirna_region", 
#' "feat_insite_bulged_nucl_region", "feat_insite_add", "feat_acc_energy", "feat_ae_add", "feat_new_id")

  EvaluarBindingSitesPotenciales <- function(bs_potenciales, features, updateProgress = NULL)
    {
      tryCatch(  
        df_binding_sites_evaluados <- data.frame(),
        ## Código de la función
        
        warning = function(w) { print(paste("WARNING: ", w)); mensaje_aviso <<- msg_aviso_evaluar_binding_sites; return(FALSE) }, 
        error = function(e)   { print(paste("ERROR: ", e));   mensaje_error <<- msg_error_evaluar_binding_sites; return(FALSE) }
    )
    return(df_binding_sites_evaluados)
  }
  
  
#' Función PrediccionFinalTargets(binding_sites_definitivos, updateProgress):
#' Ejecuta el cuarto paso del algoritmo de predicción para hacer la predicción final
#'
#' @param binding_sites_definitivos data.frame - info de binding-sites definitivos evaluados en el paso anterior
#'
#' Estructura de binding_sites_evaluados
#' bs_id integer - PK NOT NULL 
#' mirna_id - character 
#' utr_id - character 
#' feat_id - integer,
#' bs_mirna_seq_start - integer
#' bs_mirna_seq_end - integer
#' bs_utr_seq_start - integer
#' bs_utr_seq_end - integer
#' bs_seq_seed - character 
#' bs_seq_seed_start - integer
#' bs_seq_seed_end - integer
#' bs_seq_region_3 - character 
#' bs_seq_region_3_start - integer
#' bs_seq_region_3_end - integer
#' bs_seq_region_total - character 
#' bs_seq_region_total_start - integer
#' bs_seq_region_total_end - integer
#' bs_score - character 
#' bs_scoring_matrix - array
#' bs_type - integer NOT NULL
#' bs_other - json - clave - valor
#' 
#' @param updateProgress función - barra de espera (valor por defecto - NULL)
#' 
#' @return df_target - dataframe - Info de las predicciones
#' Estructura de df_target
#' mirna_id - character - miRNA ID
#' utr_id - character - 3'UTR ID
#' bs_id - integet- ID de binding-site definitivo
#' score - numeric (6,2) - Puntuación
#' 
#' @examples PrediccionFinalTargets(binding_sites_definitivos, updateProgress)
#' 


  PrediccionFinalTargets <- function(binding_sites_definitivos, updateProgress = NULL)
    {
      tryCatch(    
        df_target <- data.frame(stringsAsFactors = FALSE),
        ## Código de la función
        
        warning = function(w) { print(paste("WARNING: ", w)); mensaje_aviso <<- msg_aviso_evaluar_binding_sites; return(FALSE) }, 
        error = function(e)   { print(paste("ERROR: ", e));   mensaje_error <<- msg_error_evaluar_binding_sites; return(FALSE) }
      )
        
      return(df_target)
  }