library(shiny)

if(!require(shinyjs)){
  install.packages("shinyjs")
  library(shinyjs)
}

if(!require(DT)){
  install.packages("DT")
  library(DT)
}


jscode <- "shinyjs.closeWindow = function() { window.close(); }"

fluidPage(
  useShinyjs(),
  navbarPage("Predicciones miRNA",
             tabPanel("Inicio",
                      sidebarLayout(
                        sidebarPanel(width=5, position="right",
                                     tags$h3("Predicción de targets miRNA"),
                                     helpText("Plataforma web para la identificación de", tags$a('targets miRNA', href='https://en.wikipedia.org/wiki/MicroRNA', target='_blank')),
                                     helpText("El código fuente está disponible en", tags$a('GitHub.', href='https://github.com/anikies/mirnaPlatformPredict', target='_blank'))
                        ),
                        
                        mainPanel(width=8,
                                  DT::dataTableOutput("content_bvda"))
                      )
             ),
             
             tabPanel("Búsquedas",
                      sidebarLayout(
                        sidebarPanel(width=5, position="right",
                                     tags$h3("Búsquedas"),
                                     helpText("Consulta de información de la base de datos local"),
                                     actionButton("submit_release_mirna", "Datos release" ),
                                     helpText("Muestra datos de", tags$a('TargetScan', href='http://www.targetscan.org/cgi-bin/targetscan/data_download.vert71.cgi', target='_blank')),
                                     actionButton("submit_results", "Resultados anteriores" ),
                                     helpText("Muestra resultados precomputados")
                        ),
                        
                        mainPanel("", width = 10,
                                  tags$div(textOutput('msgb_info'), style="color:red"),
                                  br(),
                                  DT::dataTableOutput("content_busq")))),
                                  tags$b(helpText("Resultados")),
             
             tabPanel("Nuevas predicciones",
                      sidebarLayout(
                        sidebarPanel(width = 8, position="left",
                                     tags$div(id = "form_pred",
                                     tags$h3("Predicciones"),
                                     helpText("Formulario de entrada de datos para la predicción de targets miRNA"),
                                     fluidRow(
                                       column(3,
                                            br(),
                                            selectInput("select_alg", "Algoritmo", algoritmo_id, 
                                                        selected = NULL, multiple = FALSE,
                                                        selectize = TRUE, width = "240px"),
                                            helpText("Selección del algoritmo de predicción"),
                                            tags$div(id = "form_select",
                                                     htmlOutput("html_dataset")
                                            ),
                                            
                                            helpText("Selección de datasets de", tags$a('Ensembl', href='www.ensembl.org/biomart', target='_blank')),
                                            br(),
                                            br(),
                                            HTML('<script type="text/javascript">$(document).ready(function() { $("#submit_pred_target").click(function() { $("#wmsg_info").text("En proceso...");});});</script>'),
                                            
                                            actionButton("submit_pred_target", "Ejecutar"),
                                            
                                            extendShinyjs(text = jscode, functions = c("closeWindow")),
                                            actionButton("submit_salir", "Salir"),
                                            helpText("Ejecución del algoritmo de predicción")
                                            #helpText("Salida de la aplicación")
                                          ),
                                       
                                       column(3,
                                           br(),
                                           textAreaInput("text_mirna", "miRNA ID", "", width = "300px", height = "75px"),
                                           helpText("Introducción de miRNA ID de referencia"),
                                           br(),
                                           textAreaInput("text_gen", "Gen ID", "", width = "300px", height = "75px"),
                                           helpText("Introducción de gen ID de referencia")
                                            
                                       ),  
                                        column(2,
                                           br(),
                                           br(),
                                           radioButtons("radio_id_calc", label = "Cálculo miRNA-3'UTR",
                                                        choices = c("Todo" = "calc_todo", "Sólo nuevos" = "calc_parte"), selected = "calc_todo"),
                                           br(),
                                           br(),
                                           br(),
                                           br(),

                                           radioButtons("radio_id_ref", label = "Base de datos referencia gen",
                                                        choices = genes_id_aceptados, selected = "ensembl_gene_id")                                                 
                                            ),

                                       column(4,
                                          h3("Archivos fasta"),
                                          fileInput("file_mirna", "Secuencias miRNA ", width = 600, accept = c(".fa", ".fasta",".txt")),
                                          fileInput("file_utr", "Secuencias 3'UTR", width = 600, accept = c(".fa", ".fasta",".txt")),
                                          helpText("Selección de archivo con", tags$a('formato fasta', href = 'https://en.wikipedia.org/wiki/FASTA_format', target = '_blank'), "de secuencias con extensión .fa, .fasta y .txt")
                      
                                        )
                                       )
                                     )
                      ),
                      
                      mainPanel("", width = 12,
                                DT::dataTableOutput("content"))
             ),
             
             mainPanel("", width = 12,
                       tags$div(textOutput('msg_info'), style="color:red"),
                       br(),
                       tags$b(helpText("Resultados")),
                       DT::dataTableOutput("content_pred")))
                )
             )

