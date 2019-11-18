p <- list()
p$A <- c(90,10)
p$B <- c(30,70)
p$C <- c(50,50)
p$D <- c(70,30)
p$E <- c(10,90)

p_norm <- lapply( p , function(q) q/sum(q))
H <- sapply( p_norm , function(q) -sum(ifelse(q==0,0,q*log(q))) ) 