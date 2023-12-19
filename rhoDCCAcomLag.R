##################################################################################  
# Main code
#
#
# Authors: Jessica Bassani de Oliveira¹ Thiago B. Murari², Aloisio S. Nascimento Filho²,
#          Claudia Andrea L. Cardoso¹, Hugo Saba³, Marcelo A. Moretti²,³
#
#¹ Programa de Pos-graduacao em Recursos Naturais, Universidade Estadual de Mato Grosso do Sul
#² Centro Universitario SENAI CIMATEC, Salvador, Brazil
#³ Universidade do Estado da Bahia - UNEB, Salvador, Brazil

#--------------------------------------------------------------------------------------------- 

#     This program calculates the rhoDCCA with lag periods from two time series 
# (of equal sizes) informed by the user. 
#
#     After calculating the rhoDCCA with its lags, the program writes in the 
#  program directory an .xlsx file containing the rhoDCCA calculations with lags, 
#  in addition to the confidence interval.
#
#     Two graphs are generated: the first is a line graph containing the x-axis 
#  in logarithmic scale. The second is a contour plot, containing in another 
#  perspective the effect of rhoDCCA and lags.

#-----------------------------------------------------------------------------

#     Este programa faz o calculo do rhoDCCA com periodos de defasagens a partir 
# de duas series temporais (de tamanhos iguais) informadas pelo usuario.
# 
#     Depois de calculado o rhoDCCA com suas defasagens, o programa grava no 
#  diretorio do programa um arquivo .xlsx contendo os calculos do rhoDCCA com 
#  defasagens, alem do intervalo de confianca.
# 
#  Dois graficos sao gerados: o primeiro -e um grafico de linhas contendo o eixo x 
# em escala logaritimica. O segundo é um grafico de contorno,   contendo em outra 
# perspectiva o efeito  do rhoDCCA e defasagens.

################################################################################## 

# Command to clear all variables loaded in R memory
rm(list=ls())   


# List of libraries used in code execution
# These libraries must be pre-installed by the user before running this code.
library(utils)
library(DCCA)
library(GMZTests)
library(xlsx)
library(dplyr)
library(tibble)
library(plotly)
library(ggplot2)
library(tidyr)
library(plyr)



##################################################################################  
#  Main 
################################################################################## 

# Enter the path of the directory where the time series files are located:
# (file in .CSV format)


# Path of the directory where the time series for the rhoDCCA calculation will be stored
dir<-'C:/Users/vagner/Desktop/Lag_RhoDCCA_projetoR/'   


# Path of the directory where the functions for calculating the rhoDCCA will be stored
dirFunctions<-'C:/Users/vagner/Desktop/Lag_RhoDCCA_projetoR/functions/'


setwd(dir)
getwd()
source(paste0(dirFunctions,'functionsR.R')) #

#-----  load time series ---------------------------------------------------------------

# Inform the .CSV file containing the two time series
# Ex: FindTimeSeries(SeriesName ='MySeries.csv')

Data <- FindTimeSeries(SeriesName='Example.csv')


# Functionality to check the number of time series elements
DataNumber<-length(Data[,1])

#------------------- Calculation of rhoDCCA   ----------------------------------

# Enter the amount of lag of the second time series (second column) and the 
# number of times the lag repeats
# Example: 10 day lag, repeating 3 times


# The user will inform two lag variables and number of repetitions

#Lags
Lags <- 15
#Iteration
Iterations<- 4


#--------------------------------------------------------------------------------

#Function call to build the list with the lags informed by the user
LagData<- Def_Lag(Data,DataNumber,Lags,Iterations)


#------------  Function call for calculating rhoDCCA  ---------------------------
DataRhoDCCA <- CalcRhoDCCA(LagData, DataNumber, Lags, Iterations)

# Variable that stores the number of columns generated in the data frame after calculating rhoDCCA
QtColTab_RhoDCCA<- length(DataRhoDCCA)


#--------------- Creating .xls file and graphics --------------------------------

# Write in the directory a file in .xlsx format with the rhoDCCA calculation table 
write.xlsx(DataRhoDCCA, file="rhoDCCA_Completed_Lag.xlsx")


#Write in the directory a file in .xlsx format with the rhoDCCA calculation table
LineGraph <- GenerateGraphLines(DataRhoDCCA, Iterations, QtColTab_RhoDCCA)   
LineGraph


ContourGraph <- GenerateGraphContour(DataRhoDCCA, QtColTab_RhoDCCA)
ContourGraph

#########################   End of main code     ###############################




