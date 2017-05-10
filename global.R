mensaje_aviso <- NULL
mensaje_error <- NULL

genes_id_aceptados <- c("Ensembl" = "ensembl_gene_id", "NCBI gene ID" = "entrezgene", "UniGene" = "unigene")   # Tipos de gen ID permitidos listFilters(mart)

algoritmo_id <- c("Algoritmo de usuario 1" = "Algoritmo de usuario 1") # Algoritmos de usuario

## INSERCIÓN DE DOCUMENTOS
msg_error_insercion_bd <- "Error: no se ha podido insertar el registro en la base de datos"

###POSTGRESQL
## CONEXIÓN CON BD 
DATABASE_BD_TEST <- "mirnaplatform_bd_test"
DATABASE_BD_REAL <- "mirnaplatform_bd" 
HOST_BD <- "127.0.0.1"
USUARIO_BD <- "postgres"
CLAVE_BD <- "mirna"
PORT_BD <- 5432

## ESQUEMA
ESQUEMA_BD <- "mirnaplatform"

## TABLAS
TABLA_MIRNA <- "mirna"
TABLA_UTR <- "utr_gen"
TABLA_GEN <- "gen"
TABLA_INPUT_USER <- "input_user"
TABLA_OUTPUT_USER <- "output_user"
TABLA_BINDINGSITES <- "binding_sites"
TABLA_FEATURES <- "features"
TABLA_TARGETS <- "targets"
TABLA_TEXTMINING <- "text_mining"
TABLA_MIRNATARGETS <- "mirnatargets_release_targetscan"
TABLA_DATASETS_ENSEMBL <- "datasets_ensembl"

# ARCHIVOS RELEASE
ARCHIVO_ZIP_RELEASE_TARGETSCAN <- "www/Predicted_Targets_Info.default_predictions.txt.zip"
ARCHIVO_TXT_RELEASE_TARGETSCAN <- "www/Predicted_Targets_Info.default_predictions.txt"


# CONSULTAS SQL 
SQL_INSERT_INPUT_USER <- paste("INSERT INTO", paste(ESQUEMA_BD, paste(TABLA_INPUT_USER, "(input_id, input_datetime, input_mirna_id, input_gen_id, input_utr_id, input_alg) VALUES (%s'), '%s', '{%s}', '{%s}', '{%s}', '%s');"), sep = "."))
SQL_SELECT_INPUT_USER_ID <- paste("SELECT input_id FROM ", paste(ESQUEMA_BD, paste(TABLA_INPUT_USER, "WHERE input_datetime = '%s';"), sep = "."))

SQL_INSERT_OUTPUT_USER <- paste("INSERT INTO", paste(ESQUEMA_BD, paste(TABLA_OUTPUT_USER, "(output_id, output_datetime, input_id, output_target) VALUES (%s'), '%s', '{%s}', '{%s}', '{%s}', '%s');"), sep = "."))

SQL_SELECT_COUNT_MIRNA <- paste("SELECT COUNT(mirna_id) FROM", paste(ESQUEMA_BD, paste(TABLA_MIRNA, "WHERE mirna_id = '%s';"), sep = "."))
SQL_SELECT_MIRNA <- paste("SELECT mirna_id, mirna_seq, mirna_ref FROM", paste(ESQUEMA_BD, paste(TABLA_MIRNA, "WHERE mirna_id IN ('%s') ORDER BY mirna_id;"), sep = "."))
SQL_INSERT_MIRNA <- paste("INSERT INTO", paste(ESQUEMA_BD, paste(TABLA_MIRNA, "(mirna_id, mirna_ref, mirna_precomp, mirna_seq) VALUES ('%s', %s, %s, '%s');"), sep = "."))
SQL_UPDATE_MIRNA <- paste("UPDATE", paste(ESQUEMA_BD, paste(TABLA_MIRNA, "SET mirna_ref = %s, mirna_precomp = %s, mirna_seq = '%s' WHERE mirna_id = '%s';"), sep = "."))

SQL_SELECT_COUNT_UTR <- paste("SELECT COUNT(utr_id) FROM", paste(ESQUEMA_BD, paste(TABLA_UTR, "WHERE utr_id = '%s';"), sep = "."))
SQL_INSERT_UTR <- paste("INSERT INTO", paste(ESQUEMA_BD, paste(TABLA_UTR, "(utr_id, utr_ref, utr_precomp, utr_seq, utr_gen_id) VALUES ('%s', %s, %s, '%s', '%s');"), sep = "."))
SQL_UPDATE_UTR <- paste("UPDATE", paste(ESQUEMA_BD, paste(TABLA_UTR, "SET utr_ref = %s, utr_precomp = %s, utr_seq = '%s', utr_gen_id = '%s' WHERE utr_id = '%s';"), sep = "."))
SQL_SELECT_UTR1 <- paste("SELECT utr_gen_id, utr_id, utr_seq, utr_ref FROM", paste(ESQUEMA_BD, paste(TABLA_UTR, "WHERE utr_gen_id IN ('%s') ORDER BY utr_gen;"), sep = "."))
SQL_SELECT_UTR2 <- paste("SELECT utr_gen_id, utr_id, utr_seq, utr_ref FROM", paste(ESQUEMA_BD, paste(TABLA_UTR, "WHERE utr_id IN ('%s') ORDER BY utr_gen;"), sep = "."))

SQL_SELECT_COUNT_GEN <- paste("SELECT COUNT(gen_id) FROM", paste(ESQUEMA_BD, paste(TABLA_GEN, " WHERE gen_id = '%s';"), sep = "."))
SQL_INSERT_GEN <- paste("INSERT INTO", paste(ESQUEMA_BD, paste(TABLA_GEN, "(gen_id, gen_attrib) VALUES ('%s', '{%s}');"), sep = "."))
SQL_UPDATE_GEN <- paste("UPDATE", paste(ESQUEMA_BD, paste(TABLA_GEN, "SET gen_id = '%s', gen_attrib = '{%s}' WHERE gen_id = '%s';"), sep = "."))

SQL_SELECT_BINDINGSITES_MIRNA_ID_PRECOMP <- paste("SELECT mirna_id FROM", paste(ESQUEMA_BD, paste(TABLA_BINDINGSITES, "WHERE mirna_id IN ('%s') ORDER BY mirna_id;"), sep = "."))

SQL_SELECT_BINDINGSITES_UTR_ID_PRECOMP<- paste("SELECT utr_id FROM", paste(ESQUEMA_BD, paste(TABLA_BINDINGSITES, "WHERE utr_id IN ('%s') ORDER BY mirna_id;"), sep = "."))

SQL_SELECT_MIRNATARGETS <- paste("SELECT mir_family AS \"miR Family\", gene_id AS \"Gene ID\", gene_symbol AS \"Gene Symbol\", transcript_id AS \"Transcript ID\", species_id AS \"Species ID\", utr_start AS \"UTR start\", utr_end AS \"UTR end\", msa_start AS \"MSA start\", msa_end AS \"MSA end\", Seed_match AS \"Seed match\", pct AS \"PCT\" FROM", paste(ESQUEMA_BD, paste(TABLA_MIRNATARGETS, "ORDER BY mir_family,gene_id"), sep = "."))

SQL_DROP_MIRNATARGETS <- paste("DROP TABLE IF EXISTS", paste(ESQUEMA_BD, TABLA_MIRNATARGETS, sep = "."))

SQL_SELECT_BINDINGSITES_PAR_MIRNAUTR_PRECOMP <- paste("SELECT bs_id, mirna_id, utr_id, feat_id, bs_mirna_seq_start, bs_mirna_seq_end, bs_utr_seq_start, bs_utr_seq_end, bs_seq_seed, bs_seq_seed_start, bs_seq_seed_end, bs_seq_region_3, bs_seq_region_3_start, bs_seq_region_3_end, bs_seq_region_total, bs_seq_region_total_start, bs_seq_region_total_end, bs_score, bs_scoring_matrix, bs_other::text, bs_type FROM", paste(ESQUEMA_BD, paste(TABLA_BINDINGSITES, "WHERE mirna_id = '%s' AND utr_id = '%s' ORDER BY mirna_id, utr_id;"), sep = "."))

SQL_SELECT_BINDINGSITES_PAR_MIRNAUTR_INPUT <- paste("SELECT bs_id, mirna_id, utr_id, feat_id, bs_mirna_seq_start, bs_mirna_seq_end, bs_utr_seq_start, bs_utr_seq_end, bs_seq_seed, bs_seq_seed_start, bs_seq_seed_end, bs_seq_region_3, bs_seq_region_3_start, bs_seq_region_3_end, bs_seq_region_total, bs_seq_region_total_start, bs_seq_region_total_end, bs_score, bs_scoring_matrix, bs_type, bs_other::text FROM", paste(ESQUEMA_BD, paste(TABLA_BINDINGSITES, "WHERE mirna_id = '%s' AND utr_id = '%s' AND bs_id = %d"), sep = "."))

# CONSULTAS PARA LA EJECUCIÓN DEL ALGORITMO

#SQL_SELECT_COUNT_BS <- paste("SELECT COUNT(bs_id) FROM", paste(ESQUEMA_BD, paste(TABLA_BINDINGSITES, "WHERE bs_id = '%s';"), sep = "."))                                         

SQL_SELECT_BS_ID_POTENCIALES <- paste("SELECT bs_id, feat_id FROM", paste(ESQUEMA_BD, paste(TABLA_BINDINGSITES, "WHERE mirna_id = '%s' AND utr_id = '%s' AND bs_mirna_seq_start = %d AND bs_mirna_seq_end = %d AND bs_utr_seq_start = %d AND bs_utr_seq_end = %d AND bs_seq_seed = '%s' AND bs_seq_seed_start= %d AND bs_seq_seed_end = %d AND bs_seq_region_3 = '%s' AND bs_seq_region_3_start = %d AND bs_seq_region_3_end = %d AND bs_seq_region_total = '%s' AND bs_seq_region_total_start = %d AND bs_seq_region_total_end = %d AND bs_score = %f AND bs_scoring_matrix = '{%s}' AND bs_other = '%s' AND bs_type = %d;"), sep = "."))

SQL_INSERT_BINDING_SITES_POTENCIALES <- paste("INSERT INTO", paste(ESQUEMA_BD, paste(TABLA_BINDINGSITES, "(bs_id, mirna_id, utr_id, feat_id, bs_mirna_seq_start, bs_mirna_seq_end, bs_utr_seq_start, bs_utr_seq_end, bs_seq_seed, bs_seq_seed_start, bs_seq_seed_end, bs_seq_region_3, bs_seq_region_3_start, bs_seq_region_3_end, bs_seq_region_total, bs_seq_region_total_start, bs_seq_region_total_end, bs_score, bs_scoring_matrix, bs_other, bs_type) VALUES (DEFAULT, '%s', '%s', %s, %d, %d, %d, %d, '%s', %d, %d, '%s', %d, %d, '%s', %d, %d, %f, '{%s}', '%s', %d);"), sep = "."))  
SQL_UPDATE_BINDING_SITES_POTENCIALES <- paste("UPDATE", paste(ESQUEMA_BD, paste(TABLA_BINDINGSITES, "SET mirna_id = '%s', utr_id = '%s', bs_mirna_seq_start = %d, bs_mirna_seq_end = %d, bs_utr_seq_start = %d, bs_utr_seq_end = %d, bs_seq_seed = '%s', bs_seq_seed_start = %d, bs_seq_seed_end = %d, bs_seq_region_3 = '%s', bs_seq_region_3_start = %d, bs_seq_region_3_end = %d, bs_seq_region_total = '%s', bs_seq_region_total_start = %d, bs_seq_region_total_end = %d, bs_score = %f, bs_scoring_matrix = '{%s}', bs_other = '%s', bs_type = %d WHERE bs_id = %d;"), sep = "."))

SQL_SELECT_COUNT_FEATURES <- paste("SELECT COUNT(feat_id) FROM", paste(ESQUEMA_BD, paste(TABLA_FEATURES, "WHERE feat_id = '%s';"), sep = "."))       
#SQL_SELECT_BS_FEAT_ID <- paste("SELECT feat_id FROM", paste(ESQUEMA_BD, paste(TABLA_BINDINGSITES, "WHERE bs_id = %d;"), sep = "."))       
SQL_SELECT_BS_FEAT_ID <- "SELECT bs.feat_id AS bs_feat_id, ft.feat_id  FROM mirnaplatform.binding_sites bs LEFT OUTER JOIN  mirnaplatform.features ft ON (bs.feat_id = ft.feat_id) WHERE bs_id = '%s';"

SQL_SELECT_FEATURES_ID <- paste("SELECT MAX(feat_id) FROM", paste(ESQUEMA_BD, paste(TABLA_FEATURES, ";"), sep = "."))                                         
                                      
SQL_SELECT_FEATURES_BS_ID <- "SELECT mirnaplatform.features.* from mirnaplatform.features, mirnaplatform.binding_sites WHERE mirnaplatform.features.feat_id = mirnaplatform.binding_sites.feat_id AND bs_id IN ('%s');"

SQL_INSERT_FEATURES <- paste("INSERT INTO", paste(ESQUEMA_BD, paste(TABLA_FEATURES, "(feat_id, feat_seed_type_id, feat_seed_score, feat_seed_pct, feat_seed_add, feat_cons_mf_id, feat_cons_ms_id, feat_cons_add, feat_free_energy, feat_free_energy_add, feat_insite_fe_region, feat_insite_match_region, feat_insite_mismatch_region, feat_insite_gc_match_region, feat_insite_gc_mismatch_region, feat_insite_au_match_region, feat_insite_au_mismatch_region, feat_insite_gu_match_region, feat_insite_gu_mismatch_region, feat_insite_bulges_mirna_region, feat_insite_bulged_nucl_region, feat_insite_add, feat_acc_energy, feat_ae_add) VALUES (%d, %d, %f, %f, '%s', %d, %d, '%s', %f, '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', %f, '%s');"), sep = "."))
SQL_UPDATE_FEATURES <- paste("UPDATE", paste(ESQUEMA_BD, paste(TABLA_FEATURES, "SET feat_seed_type_id = %d, feat_seed_score = %f, feat_seed_pct = %f, feat_seed_add = '%s', feat_cons_mf_id = %d, feat_cons_ms_id = %d, feat_cons_add = '%s', feat_free_energy = %f, feat_free_energy_add = '%s', feat_insite_fe_region = '%s', feat_insite_match_region = '%s', feat_insite_mismatch_region = '%s', feat_insite_gc_match_region = '%s', feat_insite_gc_mismatch_region = '%s', feat_insite_au_match_region = '%s', feat_insite_au_mismatch_region = '%s', feat_insite_gu_match_region = '%s', feat_insite_gu_mismatch_region = '%s', feat_insite_bulges_mirna_region = '%s', feat_insite_bulged_nucl_region = '%s', feat_insite_add = '%s', feat_acc_energy = %f, feat_ae_add = '%s' WHERE feat_id = %d;"), sep = "."))
                                                                                                        
SQL_UPDATE_BS_FEAT_ID <- paste("UPDATE", paste(ESQUEMA_BD, paste(TABLA_BINDINGSITES, "SET feat_id = %d WHERE bs_id = %d;"), sep = "."))

SQL_SELECT_BINDING_SITES_DEFINITIVOS <- paste("SELECT bs_id, mirna_id, utr_id, feat_id, bs_mirna_seq_start, bs_mirna_seq_end, bs_utr_seq_start, bs_utr_seq_end, bs_seq_seed, bs_seq_seed_start, bs_seq_seed_end, bs_seq_region_3, bs_seq_region_3_start, bs_seq_region_3_end, bs_seq_region_total, bs_seq_region_total_start, bs_seq_region_total_end, bs_score, bs_scoring_matrix, bs_type, bs_other::text FROM", paste(ESQUEMA_BD, paste(TABLA_BINDINGSITES, "WHERE bs_id IN (%s) AND bs_type = 1 ORDER BY mirna_id, utr_id;"), sep = "."))

                                                                                                                                                                                                                                                                                                                                                                                                                              
#RESULTADOS
SQL_SELECT_TARGETS_TODOS <- "SELECT RANK() OVER (PARTITION BY tg.mirna_id, tg.gen_id ORDER BY tg_score DESC) AS \"Posición\", tg.mirna_id AS \"miRNA ID\", tg.gen_id AS \"Target (gen ID)\", tg_score AS \"Puntuación\", tm_mirna_info::text AS \"miRNA info\", tm_gen_info::text as \"gen info\" FROM mirnaplatform.targets AS tg, mirnaplatform.text_mining AS tm WHERE tg.tm_id = tm.tm_id ORDER BY tg.mirna_id, gen_id;"
SQL_SELECT_TARGETS <- "SELECT RANK() OVER (PARTITION BY tg.mirna_id, tg.gen_id ORDER BY tg_score DESC) AS \"Posición\", tg.mirna_id AS \"miRNA ID\", tg.gen_id AS \"Target (gen ID)\", tg_score AS \"Puntuación\", tm_mirna_info::text AS \"miRNA info\", tm_gen_info::text as \"gen info\" FROM mirnaplatform.targets AS tg, mirnaplatform.text_mining AS tm WHERE tg.tm_id = tm.tm_id AND tg_id IN (%s) ORDER BY tg.mirna_id, gen_id;"

SQL_SELECT_COUNT_TARGETS <- paste("SELECT COUNT(tg_id) FROM", paste(ESQUEMA_BD, paste(TABLA_TARGETS, "WHERE mirna_id = '%s' AND gen_id = (SELECT utr_gen_id FROM mirnaplatform.utr_gen WHERE utr_id = '%s') AND bs_id = %d;"), sep = "."))
SQL_SELECT_ID_TARGETS <- paste("SELECT tg_id FROM", paste(ESQUEMA_BD, paste(TABLA_TARGETS, "WHERE mirna_id = '%s' AND gen_id = (SELECT utr_gen_id FROM mirnaplatform.utr_gen WHERE utr_id = '%s') AND bs_id = %d;"), sep = "."))
SQL_INSERT_TARGETS <- paste("INSERT INTO", paste(ESQUEMA_BD, paste(TABLA_TARGETS, "(tg_id, mirna_id, gen_id, bs_id, tm_id, tg_score) VALUES (DEFAULT, '%s', (SELECT utr_gen_id FROM mirnaplatform.utr_gen WHERE utr_id = '%s'), %d, %d, %f) RETURNING tg_id;"), sep = "."))
SQL_UPDATE_TARGETS <- paste("UPDATE", paste(ESQUEMA_BD, paste(TABLA_TARGETS, "SET mirna_id = '%s', gen_id = (SELECT utr_gen_id FROM mirnaplatform.utr_gen WHERE utr_id = '%s'), bs_id = %d, tm_id = %d, tg_score = %f WHERE tg_id = %d RETURNING tg_id;"), sep = "."))

SQL_UPDATE_BINDING_SITES_ID <- paste("UPDATE", paste(ESQUEMA_BD, paste(TABLA_BINDINGSITES, "SET bs_type = %d WHERE bs_id = %d;"), sep = "."))

SQL_UPDATE_GEN <- paste("UPDATE", paste(ESQUEMA_BD, paste(TABLA_GEN, "SET gen_id = '%s', gen_attrib = '{%s}' WHERE gen_id = '%s';"), sep = "."))

SQL_INSERT_OUTPUT_USER <- paste("INSERT INTO", paste(ESQUEMA_BD, paste(TABLA_OUTPUT_USER, "(output_id, output_datetime, input_id, output_target) VALUES (DEFAULT, '%s', %d, '{%s}');"), sep = "."))
SQL_UPDATE_BINDING_SITES_TYPE <- paste("UPDATE", paste(ESQUEMA_BD, paste(TABLA_BINDINGSITES, "SET bs_type = 0"), sep = "."))

msg_aviso_conexion_bd <- "No se ha podido conectar con la base de datos PostgreSQL"
msg_error_conexion_bd <- "Error: no se ha podido conectar con la base de datos PostgreSQL"

msg_aviso_consulta_bd <- "No se ha podido realizar la consulta en la base de datos PostgreSQL"
msg_error_consulta_bd <- "Error: no se ha podido realizar la consulta en la base de datos PostgreSQL"

msg_aviso_insercion_bd <- "No se ha podido insertar el registro en la base de datos"
msg_error_insercion_bd <- "Error: no se ha podido insertar el registro en la base de datos"


## CONSULTA BIOMART ENSEMBL R
HOST_ENSEMBL <- "www.ensembl.org"
BIOMART_ENSEMBL_RELEASE <- "ensembl" # Ensembl gene 88
PATH_ENSEMBL <- "/biomart/martservice"
PORT_ENSEMBL <- 80

## CONSULTA BIOMART ENSEMBL XML
uri_end_point <- "http://www.ensembl.org/biomart/martservice?query=" 
uri_xml_utr_query_1 <-  '\'<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE Query><Query virtualSchemaName="default" formatter="FASTA" header="0" uniqueRows="0" count="" datasetConfigVersion="0.6"><Dataset name="%s" interface="default"><Filter name="%s" value="%s"/> %s %s'

# Atributos recuperados de la consulta de Biomart ensembl
attributes_ensembl <- c("ensembl_gene_id", "ensembl_transcript_id", "3utr")
# "3_utr_start", "5_utr_end"
# "chromosome_name", "start_position", "end_position", 
#                        "gene_biotype", "transcript_start", "transcript_end", "transcription_start_site", "5_utr_start", "5_utr_end", "3_utr_start", 
#                        "3_utr_end", "cdna_coding_start", "cdna_coding_end")

uri_xml_utr_att <- '<Attribute name="%s"/>'
uri_xml_utr_query_2 <- '</Dataset></Query>\''

ruta_archivo_API_fasta <- "www/result_utr_API.fasta"
ruta_archivo_seq_validas_API_fasta <- "www/result_utr_validas_API.fasta"
ruta_archivo_paralogos_API_fasta <- "www/result_utr_paralogos_API.fasta"

msg_aviso_biomart_xml_archivo_utr_ensembl <- paste0("No se ha podido guardar el archivo con las secuencias:", ruta_archivo_API_fasta)
msg_error_biomart_xml_archivo_utr_ensembl <- paste0("Error: No se ha podido guardar el archivo con las secuencias:", ruta_archivo_API_fasta)

msg_aviso_biomart_utr_ensembl <- "No se ha podido conectar con Ensembl para recuperar secuencias 3'UTR (paquete R)"
msg_error_biomart_utr_ensembl <- "Error: no se ha podido conectar con Ensembl para recuperar secuencias 3'UTR (paquete R)"

msg_aviso_biomart_xml_utr_ensembl <- "No se ha podido conectar con Ensembl para recuperar secuencias 3'UTR (wget XML)"
msg_error_biomart_xml_utr_ensembl <- "Error: no se ha podido conectar con Ensembl para recuperar secuencias 3'UTR (wget XML)"

msg_error_biomart_ensembl <- "Error: no se ha podido conectar con Ensembl"
  
## DATASET ENSEMBL
DATASET_ENSEMBL_DEFECTO <- "hsapiens_gene_ensembl"
BIOMART_ENSEMBL_DB <- "ensembl"
SQL_SELECT_DATASETS_ENSEMBL <- paste("SELECT ds_name FROM",  paste(ESQUEMA_BD, paste(TABLA_DATASETS_ENSEMBL, "ORDER BY ds_name"), sep = "."))
msg_aviso_dataset_ensembl <- "No se ha podido conectar con Ensembl para mostrar los datasets"
msg_error_dataset_ensembl <- "Error: no se ha podido conectar con Ensembl para mostrar los datasets"

ensembl_mirror1 <- "uswest"
ensembl_mirror2 <- "useast"
ensembl_mirror3 <- "asia"

## URL targetscan mirBase
uri_end_mirbase <- "http://app1.bioinformatics.mdanderson.org/tarhub/_design/basic/_view/"

## MENSAJES 

msg_aviso_validacion_fasta <- "Archivo fasta no válido" 
msg_error_validacion_fasta <- "Error: archivo fasta no válido" 
msg_aviso_fasta_vacio <- "Archivo fasta no válido: vacío o incompleto"

msg_aviso_lectura_fasta <- "El archivo fasta no se puede leer" 
msg_error_lectura_fasta <- "Error: no se ha podido leer el archivo fasta" 

msg_aviso_campos <- "Selección incorrecta de campos"

msg_aviso_text_mirna <- "miRNA ID incorrecto"
msg_aviso_text_utr <- "Gen ID incorrecto"
msg_aviso_text_utr_ensemble  <- "Gen ID de Ensembl incorrecto"

msg_aviso_obtencion_mirna_seq <- "No se han podido recuperar las secuencias de miRNA"
msg_error_obtencion_mirna_seq <- "Error: no se ha podido recuperar las secuencias de miRNA"
msg_aviso_obtencion_mirna_seq_no_result <- "no hay correspondencias miRNA ID -> miRNA seq"

msg_aviso_obtencion_utr_seq <- "No se han podido recuperar las secuencias 3'UTR"
msg_error_obtencion_utr_seq <- "Error: no se han podido obtener las secuencias 3'UTR"
msg_aviso_obtencion_utr_seq_no_result <- "No hay correspondencias gen ID -> 3'UTR seq"

msg_aviso_transformar_fasta_a_lista <- "No se ha podido hacer la conversión de las secuencias"
msg_error_transformar_fasta_a_lista <- "Error: no se ha podido hacer la conversión de las secuencias"

msg_aviso_buscar_referencias <- "No se ha podido comprobar si la secuencia es de referencia"
msg_error_buscar_referencias <- "Error: no se ha podido comprobar si la secuencia es de referencia"

msg_aviso_buscar_precomputadas <- "No se ha podido comprobar si la secuencia está precomputada"
msg_error_buscar_precomputadas <- "Error: no se ha podido comprobar si la secuencia está precomputada"

msg_aviso_archivo_fasta_utr_ensembl <- "No se ha podido abrir el archvo fasta con secuencias recuperadas de Ensembl"
msg_error_archivo_fasta_utr_ensembl <- "Error: no se ha podido abrir el archvo fasta con secuencias descargadas de Ensembl"

msg_aviso_insertar_release_bd <- "No se ha podido actualizar la release de TargetScan"
msg_error_insertar_release_bd <- "Error: se ha podido actualizar la release de TargetScan"

msg_error_mirnautr_precomp <- "Error: no se han podido encontrar los pares miRNA-3'UTR precomputados"

msg_aviso_recuperar_utr_bd <- "No se han podido recuperar los extremos 3'UTR de la base de datos"
msg_error_recuperar_utr_bd <- "No se han podido recuperar los extremos 3'UTR de la base de datos"



## Mensajes para ventana modal

msg_modal_pares_precomp <- "Hay pares miRNA - 3' UTR precomputados: ¿quiere actualizarlos?"


## MENSAJES PARA EL CÁLCULO DEL ALGORITMO

# Calcular binding-sites

msg_aviso_calculo_bs_potenciales <- "No se han podido calcular los binding-sites potenciales"
msg_error_calculo_bs_potenciales <- "Error: no se han podido calcular los binding-sites potenciales"

msg_aviso_bs_potenciales_vacio <- "No se ha identificado ningún binding-site potencial"

# Calcular features

msg_aviso_calculo_features <- "No se han podido calcular los features"
msg_error_calculo_features <- "Error: no se han podido calcular los features"

msg_aviso_obtener_features <- "No se ha obtenido ningún feature"

msg_aviso_evaluar_binding_sites <- "No se han podido evaluar los binding-sites"
msg_error_evaluar_binding_sites <- "Error: no se han podido evaluar los binding-sites"

# Evaluar binding_sites
msg_aviso_evaluar_bs_potenciales <- "No se ha obtenido ningún binding-site potencial"

#Predicción final
msg_aviso_prediccion_final <- "No se ha obtenido ninguna predicción final"

# Consulta de resultados
msg_aviso_consulta_result <- "No se han encontrado resultados previos"

## LOG
archivo_log <- "log/mirnaplatform.log"
msg_aviso_log <- paste("No se ha podido escribir en el archivo de log:", archivo_log)
msg_error_log <- paste("Error: no se ha podido escribir en el archivo de log:", archivo_log)

