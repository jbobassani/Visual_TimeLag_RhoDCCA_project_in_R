
TITLE PROJECT:     LagRhoDCCA Project

-------------------------------------------------------------------------------------------------------
DESCRIPTION:
-------------------------------------------------------------------------------------------------------
     This program calculates the rhoDCCA with lag periods from two time series 
 (of equal sizes) informed by the user. 

     After calculating the rhoDCCA with its lags, the program writes in the 
 program directory an .xlsx file containing the rhoDCCA calculations with lags, 
 in addition to the confidence interval.

     Two graphs are generated: the first is a line graph containing the x-axis 
  in logarithmic scale. The second is a contour plot, containing in another 
  perspective the effect of rhoDCCA and lags.CCA and lags.

---------------------------------------------------------------------------------------------------------
MINIMUM REQUIREMENTS:
---------------------------------------------------------------------------------------------------------

The user must install R at least the R version 4.0.1 (2020-06-06)

List of libraries used in code execution.
These libraries must be pre-installed by the user before running this cod:.
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

-----------------------------------------------------------------------------------------------------
EXECUTION:
-----------------------------------------------------------------------------------------------------
Open the rhoDCCAcomLag.R file.

You will need to inform the path where the file rhoDCCAcomLag.R 
is located in the command line where it is 'dir<-'

Then you will need to inform the path where the folder with the functionsR.R 
functions is located in the command line where it is located 'dirFunctions<-'


In the command line containing the information 'Data <-', the user must 
inform the name of the file.

Note: It is preferable that the file with the time series are inside the 
project directory.

In the line where the 'Lag<-' command is found, the user must inform 
the value of the lag that he wants to be calculated in rhoDCCA.

In the command line 'Iterations<-' the user must inform the number 
of repetitions of the lag.

Keep running the commands. At the end, rhoDCCAcomLag.R will generate a
 file named rhoDCCA_Completed_Lag.xlsx. It will also generate a confidence interval 
line graph with the rhoDCCA and Lags result (command line 'LineGraph'). At the end, 
a contour graph will be generated (command line 'ContourGraph).


EXAMPLE:
In the project folder 'rhoDCCAcomLag' there is an example time series that is declared 
in the above commands. Just change the path of the directories in 'dir<-' and 
'dirFunctions<-' to the path where it is located on your computer.


ATTENTION
The process of calculating the rhoDCCA and calculating the confidence interval 
varies according to the size of the time series. The software takes about 8 minutes 
to perform the rhoDCCA calculations on series with more than 2500 elements.

