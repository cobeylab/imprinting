## ---- include = FALSE-------------------------------------
knitr::opts_chunk$set(
collapse = TRUE,
comment = "#>"
)
library(dplyr)
library(ggplot2)
library(tidyr)

## ----eval=FALSE-------------------------------------------
#  install.packages("devtools", repos='http://cran.us.r-project.org')

## ---------------------------------------------------------
library(devtools) # Load the package

## ----eval=FALSE-------------------------------------------
#  devtools::install_github("cobeylab/imprinting")

## ---------------------------------------------------------
library(imprinting) 

## ----include=FALSE----------------------------------------
library(dplyr)
library(ggplot2)

## ---------------------------------------------------------
get_imprinting_probabilities(observation_years = 2022, countries = "United States")

## ---------------------------------------------------------
get_imprinting_probabilities(observation_years = 2022, 
                             countries = "United States", 
                             df_format = 'wide')

