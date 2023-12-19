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

#-----------------------------Functions-----------------------------------------------
verify.na <- colwise(function(data=NULL) sum(is.na(data)))



#-----------------------------Functions-----------------------------------------------
FindTimeSeries <- function(SeriesName=NULL){
  
  data <- read.table(file = SeriesName, sep = ",", header = TRUE)
  
  if (length(data) < 2) {
    return('O arquivo deve possuir 2 s?ries de dados com a mesma quantidade de elementos.')
    }
  
  MinMeasure1<-length(data[,1])
  MinMeasure2<-length(data[,2])
  
  if (MinMeasure1 < 5){
    return('The data series must contain at least 5 elements.')
    } 
  
  if (MinMeasure2 < 5){
    return('The data series must contain at least 5 elements.')
  } 
  
  Test.na<- verify.na(data)
  
  if (Test.na[1]!=0){
    return('The series must contain the same amount of elements.')
  }
  
  if (Test.na[2]!=0){
    return('The series must contain the same amount of elements.')
    }
  
  return(data)
}

#------------------------------------------------------------------------------------
Def_Lag <- function(data=NULL, Measure= NULL, LagNumber=NULL, Iterance=NULL){
  
  colnames(data)[1]<-c("serie1")
  colnames(data)[2]<-c("serie2")
  
  SeriesList<- list()
  SeriesList[[1]] <- data 
  
  NewMeasure=Measure
  
 if(LagNumber>=Measure){
    return('The amount of lags must be smaller than the length of the series.')
    }else {
      j<- 1
      for (i in  1:Iterance+1){
      
          Begin<-LagNumber*j
          End_Serie1<-NewMeasure-LagNumber
          Begin_Serie2<-Begin+1
      
          serie1<-(data[1:End_Serie1,1])
          serie2<-(data[Begin_Serie2:Measure,2])
      
          LagSerie<-data.frame(serie1, serie2)
          SeriesList[[i]] <- LagSerie
          NewMeasure<-End_Serie1
          i<-i+1
          j<-j+1
      
       }
      return(SeriesList)
    }
}

#------------------------------------------------------------------------------------
CalcBoxesNumber<- function(Measure=NULL){
  
  MaxSize<- trunc(Measure/4)
  
  Boxes = c (4, 5, 7, 9, 11, 13, 16, 20, 24, 28, 33, 38, 45, 52 , 60, 69, 80, 
             91, 104, 119, 135, 154, 174, 198, 224, 252, 285, 321, 362, 407, 
             457, 513, 576, 645, 723, 809, 905, 1011, 1130, 1261, 1408, 1570, 
             1750, 1950, 2172, 2418, 2690, 2993, 3328, 3699, 4109, 4564, 5068, 
             5625, 6242, 6925, 7680, 8514, 9437, 10457, 11585, 12831, 14207, 
             15728, 17408, 19262, 21310, 23571)
  
  length(Boxes)
  
  i<- 1
  repeat{
    BoxesNumber = Boxes[1:i]
    i<-i+1
    if (Boxes[i] > MaxSize) break()
  }
  gc()
  return(BoxesNumber)
}


#------------------------------------------------------------------------------------
CalcRhoDCCA<- function(data=NULL, Measure = NULL, LagNumber=NULL, Iterance=NULL){
  
 
  QtLags<-length(data)
  boxsize<-CalcBoxesNumber(Measure) #Function call to calculate the number of boxes from the series 
  rho.all<-data.frame(boxsize)
  
  i<-1
  
  for (i in 1: QtLags){
    x1<-data[[i]][1]
    y1<-deframe(x1)
    y1<-as.numeric(sub(",", ".",y1))
    
    x2<-data[[i]][2]
    y2<-deframe(x2)
    y2<-as.numeric(sub(",", ".",y2))
    
    rho.dccam=rhodcca(y1,y2,m=boxsize,nu=0,overlap=TRUE)
    rho.dccam<-round(data.frame(rho.dccam),3)
    colnames(rho.dccam)[4]<-i
    rho.all<-data.frame(rho.all,rho.dccam[4])
    i<-i+1
  }
  
  gc()
  ####### Functionality to make the confidence interval ###############
  LastValue = last(boxsize)
  SizeTab = length(boxsize)
  j<-1
  #pre-allocate memory space for vector
  tab<-numeric(SizeTab)
  tab <- data.frame(CI_0.95Negative = numeric(), CI_0.95Positive = numeric())
  #confidence interval calculation
  repeat {
    M <- boxsize[j]
    GMZ<-rhodcca.test(N = Measure, k = 5, m = M, nu = 1, rep = 105)
    tab[j,1]<-(-1*GMZ$CI_0.95)
    tab[j,2]<-GMZ$CI_0.95
    j<-j+1
    
    if (M == LastValue) break()
  }
  
  colnames(rho.dccam)[4]<-"-CI 0.95"
  rho.all<-round(data.frame(rho.all,tab$CI_0.95Negative),3)
  
  colnames(rho.dccam)[4]<-"CI 0.95"
  rho.all<-round(data.frame(rho.all,tab$CI_0.95Positive),3)
  
  # Calculates the number of columns generated in RhoDCCA Data table and makes 
  # function call renaming table columns to generate graphs
  QtColTab_RhoDCCA <- length(rho.all)
  RhoDCCA_Rename <- RenameRhoDCCAData(rho.all, QtColTab_RhoDCCA, LagNumber, Iterance)
  
 return(RhoDCCA_Rename)
}

#------------------------------------------------------------------------------------
RenameRhoDCCAData <- function(data=NULL, QtColumns=NULL, LagNumber=NULL, Iterance= NULL){
  
  # The first, second, last and penultimate column have fixed names
  colnames(data)[1]<- "Boxsize"
  colnames(data)[2]<- "Lag_0"
  colnames(data)[QtColumns]<- "- 0.95%"
  colnames(data)[QtColumns-1]<- "+ 0.95%"
  
  j<-1 
  i<-3
  repeat{
    LagValue<-LagNumber*j
    Name<- paste0("Lag_",LagValue)
    colnames(data)[i]<- Name
    LagValue <-0  
    j<-j+1
    i<-i+1
    
    if (Iterance == 1) break()  
    
    Iterance<-Iterance-1
  }
  return(data)
}


#------------------------------------------------------------------------------------
GenerateGraphLines<- function(RhoDCCA_Graph=NULL, Interance= NULL, QtCol= NULL){   
  
  fig <- plot_ly(RhoDCCA_Graph, x = ~Boxsize, y = ~`+ 0.95%`, name = '+ 0.95%', 
                 type = 'scatter', mode = 'lines' ) 
  fig <- fig %>% add_trace(y = ~`- 0.95%`, name = '- 0.95%', mode = 'lines') 
  fig <- fig %>% layout(title = "rhoDCCA with lags", 
                       xaxis = list(title = "Boxsize", linecolor='lightgray', 
                                    showgrid=TRUE, ticks="outside", type= "log", 
                                     showticklabels = TRUE),
                        yaxis = list (title = "rhoDCCA", linecolor='lightgray', 
                                      showgrid=TRUE, ticks="outside"))
  
  if (QtCol > 3){
    i<-2
    repeat{
      fig <- fig %>% add_trace(y = RhoDCCA_Graph[,i], name = names(RhoDCCA_Graph[i]),
                               mode = 'lines+markers')
                           
      if (Interance == 0) break()  
      Interance<-Interance-1
      i<-i+1
    }
  }
  
  return (fig)
}



#------------------------------------------------------------------------------------
GenerateGraphContour<- function(RhoDCCA_Graph=NULL, QtCol= NULL){
  
  Contour <- RhoDCCA_Graph
  
  LtColumn<- names(Contour[QtCol-2])
  
  Contour <- Contour %>% 
    pivot_longer(
      cols = Lag_0:LtColumn, # the columns of this range
      names_to = "Lag", # will have their names stored in this new column
      names_prefix = "Lag_", # copy only the names that come after 'Lag'
      values_to = "rhoDCCA") # and their values stored in that new column
  
  
  Contour <- Contour %>% 
    arrange((Lag))
  
  
  fig1<- plot_ly(Contour, x = ~Boxsize, y = ~Lag, z = ~rhoDCCA, type = "contour",
                 colorscale= 'Portland',
                 autocontour = FALSE, 
                 contours = list(showlabels = TRUE,size = 0.1),
                 line = list(smoothing = 0.95)
  ) %>% layout(
    title = "Countor plot",
    xaxis = list(title = "Boxsize"),
    yaxis = list(title = "Lag")
  ) %>% colorbar(title = "DCCA \n Coefficient")
  
  return(fig1)
  
}

#--------------------End functions-----------------------------------

