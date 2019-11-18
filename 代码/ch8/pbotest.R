library(pbo)
library(lattice) # for plots
library(xts)
library(PerformanceAnalytics) # for Omega ratio
N <- 1000                 # studies, alternative configurations
T <- 2990               # sample returns
S <- 10                   # partition count

#function for SharpeRatio
# SharpeRatio<- function(retlist ){
#   return(mean(retlist)/sd(retlist))
# }

# load the matrix with samples for N alternatives
data1<-read.csv('M.csv',sep=',',header=FALSE)
M <- xts(data1[,-1],order.by=as.POSIXct(data1$V1),tz='Asia/Shanghai')

# compute and plot
my_pbo <- pbo(M,S,f=Omega,threshold=1)
summary(my_pbo)
histogram(my_pbo)
dotplot(my_pbo,pch=15,col=2,cex=1.5)
xyplot(my_pbo,plotType="cscv",cex=0.8,show_rug=FALSE,osr_threshold=100)
xyplot(my_pbo,plotType="degradation")
xyplot(my_pbo,plotType="dominance",lwd=2)
xyplot(my_pbo,plotType="pairs",cex=1.1,osr_threshold=75)
xyplot(my_pbo,plotType="ranks",pch=16,cex=1.2)
xyplot(my_pbo,plotType="selection",sel_threshold=100,cex=1.2)
