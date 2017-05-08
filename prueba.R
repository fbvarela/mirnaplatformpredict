library(RJSONIO)
getTargetingMirna <- function(sym, evidence_count) {
  browser()
  giUrl <- "http://app1.bioinformatics.mdanderson.org/genesmash/_design/basic/_view/by_symbol"
  glink <- paste(giUrl, "?key=\"", sym, "\"", sep='')
  gene_data <- fromJSON(paste(readLines(glink), collapse=''))
  Target_Info <- NA
  if(length(gene_data[["rows"]]) != 0) {
    GeneID <- as.character(gene_data$rows[[1]]["id"])
    #Extracting mirna-target interactions for the Gene from targetHub
    diUrl <- 'http://app1.bioinformatics.mdanderson.org/tarhub/_design/basic/_view/by_geneIDcount'
    link <- paste(diUrl, '?key=["', GeneID, '",', evidence_count, ']', sep='')
    JSON_data <- paste(readLines(link), collapse='')
    target_data <- fromJSON(JSON_data)
    if(is.list(target_data) & (length(target_data$rows) > 0)) {
      target_data <- target_data$rows
      target_Info <- matrix(nrow = length(target_data), ncol = 2)
      colnames(target_Info) <- c("miRNA-gene_interaction", "corresponding_mature_miR") 
      for(i in 1:length(target_data)) {
        target_Info[i,1] = unlist(target_data[[i]]$id)
        target_Info[i,2] = unlist(target_data[[i]]$value)
      }	
    } 
  }
  target_Info
}
getTargetingMirna("TP53",2)


killDbConnections <- function () {
  
  all_cons <- dbListConnections(MySQL())
  
  print(all_cons)
  
  for(con in all_cons)
    +  dbDisconnect(con)
  
  print(paste(length(all_cons), " connections killed."))
  
}