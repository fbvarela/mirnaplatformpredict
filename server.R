source('global.R')
source("bd_script.R")
source("api_script.R")
source("validaciones_script.R")
source("predicciontargets_script.R")
source("busquedatargets_script.R")
source("interfaz_script.R")

## Libreria log4 
if(!require(log4r)){
  install.packages("log4r")
  library(log4r)
}

server = function(input, output, session) 
  {
    logger <- create.logger(logfile = archivo_log, level = "ERROR")

    BusquedaTargets(input, output, session)
    PrediccionTargets(input, output, session)
} 

