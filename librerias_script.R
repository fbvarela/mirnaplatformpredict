# Se ejecuta en una instalación limpia de RStudio para que no se olvide ninguna librería y se produzcan errores

install.packages("shiny")
library(shiny)

install.packages("shinyjs")
library(shinyjs)

install.packages("DT")
library(DT)

# Base de datos PostgreSQL
install.packages("RPostgreSQL")
library(RPostgreSQL)

# Driver
install.packages("DBI")
library(DBI)

# Biomart
source("https://bioconductor.org/biocLite.R")
biocLite("biomaRt")
library(biomaRt)

# Fasta
source("https://bioconductor.org/biocLite.R")
biocLite("Biostrings")
library(Biostrings)

# miRNA
source("https://bioconductor.org/biocLite.R")
biocLite("mirbase.db")
library("mirbase.db")

# Fasta
install.packages("seqinr")
library(seqinr)

install.packages("dplyr")
library(dplyr)

# JSON
install.packages("jsonlite")
library(jsonlite)

# Log
install.packages("log4r")
library(log4r)
  