#This is an R procedure example how to calculate MCF for different locations. 
library(weathermetrics) #convert C to K
setwd("C:/AAFC/Project 1_MCF/")

#Required input, which don't influence MCF
VS_Yr<-1200  #kg/yr
VS_LQD<-100  #100%
#constants, these inputs are fixed input in the 2019 IPCC Refinement
f_T1<-308.16 #K
f_Ea<-19347  #cal/mol
f_R<-1.987   #cal/K.mol
B0<-0.24     #dimensionless
#Optional inputs, which influence MCF
f_Tmin<-1.0  #degree C
f_T2d<-3.0   #T2 damping, degree C
E_eff<-95    #95%

#Read climate data and removal timing. 
T.avg.m<-read.csv("2_method/R/Github/example.csv",header=T)#PC:Pacific Canada,AC:Atlantic Canada
M.rm<-ifelse(T.avg.m$Removal.two=="Y",1,0)#convert it for calculation
#Calculate the MCF for the input locations
#Example 1: MCF results under different climate conditions
MCF.1<-data.frame(Pacific.Canada=double(),Atlantic.Canada=double())
for (k in 1:2){
  Manure.rm<-rep(M.rm,3) # for stabilization 3 yr
  T.sel<-T.avg.m[,k+1] #skip month
  print(paste("Station sequence",k))
  source("2_method/R/Github/MCF calculator_single.R",echo = F)
  MCF.1[1,k]<-MCF
}
print(MCF.1)#0.16 for Pacific Canada, 0.24 for Atlantic Canada

#Example 2: MCF results under different removal scenarios 
#change removal scenario to one (sep), two (Apr and Sep), three removal per year (Apr, Aug, Oct).
MCF.2<-c()
for (k in 1:3){
  M.rm<-ifelse(T.avg.m[,3+k]=="Y",1,0)#convert it for calculation
  Manure.rm<-rep(M.rm,3) # for stabilization 3 yr
  T.sel<-T.avg.m[,3] #Use Atlantic Canada for example
  print(paste("Station sequence",k))
  source("2_method/R/Github/MCF calculator_single.R",echo = F)
  MCF.2[k]<-MCF
}
print(MCF.2)#0.35 for one removal, 0.24 for two removal, 0.18 for three removal

#Example 3:MCF results under different emptying efficiencies
#four emptying efficiencies are used.
Emptying_eff<-c(50,85,95,100)
MCF.3<-c()
for (k in 1:4){
  M.rm<-ifelse(T.avg.m[,5]=="Y",1,0)#by using two removals
  Manure.rm<-rep(M.rm,3) # for stabilization 3 yr
  E_eff<-Emptying_eff[k]
  T.sel<-T.avg.m[,3] #Use Atlantic Canada for example
  print(paste("Station sequence",k))
  source("2_method/R/Github/MCF calculator_single.R",echo = F)
  MCF.3[k]<-MCF
}
print(MCF.3)#0.44 for 50%, 0.27 for 85%, 0.24 for 95%, 0.22 for 100%
E_eff<-95#reset the emptying efficiency

#Example 4:MCF results under different minimum temperatures
#four minimum temperatures are used.
min.T<-c(0,1,2,3)
MCF.4<-c()
for (k in 1:4){
  M.rm<-ifelse(T.avg.m[,5]=="Y",1,0)#by using two removals
  Manure.rm<-rep(M.rm,3) # for stabilization 3 yr
  f_Tmin<-min.T[k]
  T.sel<-T.avg.m[,3] #Use Atlantic Canada for example
  print(paste("Station sequence",k))
  source("2_method/R/Github/MCF calculator_single.R",echo = F)
  MCF.4[k]<-MCF
}
print(MCF.4)#0.23 for 0°C , 0.24 for 1°C , 0.24 for 2°C , 0.25 for 3°C
f_Tmin<-1#reset minimum temperature

#Example 5:MCF results under different damping factors
#five damping factors are used.
damping<-seq(0,5,1)
MCF.5<-c()
for (k in 1:6){
  M.rm<-ifelse(T.avg.m[,4]=="Y",1,0)#by using one removals in fall
  Manure.rm<-rep(M.rm,3) # for stabilization 3 yr
  f_T2d<-damping[k]
  T.sel<-T.avg.m[,3] #Use Atlantic Canada for example
  print(paste("Station sequence",k))
  source("2_method/R/Github/MCF calculator_single.R",echo = F)
  MCF.5[k]<-MCF
}
print(MCF.5)#0.45 for 0°C , 0.41 for 1°C , 0.38 for 2°C , 0.35 for 3°C
#, 0.32 for 4°C , 0.29 for 5°C




