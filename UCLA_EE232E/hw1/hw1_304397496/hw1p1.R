library(igraph)
rm(list=ls(all=TRUE))

# (a) Basic
g1 <- erdos.renyi.game(1000, 1/100, type=c("gnp"))
con1 <- is.connected(g1)
diameter(g1, unconnected=TRUE)

g2 <- erdos.renyi.game(1000, 5/100, type=c("gnp"))
con2 <- is.connected(g2)
diameter(g2, unconnected=TRUE)

g3 <- erdos.renyi.game(1000, 1/10, type=c("gnp"))
con3 <- is.connected(g3)
diameter(g3, unconnected=TRUE)

# setEPS()
# postscript("hw1P1a1.eps")
plot(degree_distribution(g1), xlim=range(0, 150), 
     xlab = "Degree", ylab = "Density",
     ylim=range(0 ,0.15), col=2)
points(degree_distribution(g2), col=3)
points(degree_distribution(g3), col=4)
legend('topright', legend=c("p = 0.01", "p = 0.05", "p = 0.1"), col=c('red', 'blue', 'green'), pch = c(1,1), cex=0.8)

# (b) Average diag
d1 <- 0
d2 <- 0
d3 <- 0
for (j in 1:100)
{
  g1 <- erdos.renyi.game(1000, 1/100, type=c("gnp"))
  g2 <- erdos.renyi.game(1000, 5/100, type=c("gnp"))
  g3 <- erdos.renyi.game(1000, 1/10, type=c("gnp"))
  d1 <- d1 + diameter(g1, unconnected=TRUE)
  d2 <- d2 + diameter(g2, unconnected=TRUE)
  d3 <- d3 + diameter(g3, unconnected=TRUE)
}
d1 <- d1/100
d2 <- d2/100
d3 <- d3/100

# (c) Average threshold
i_0 = 0
for (j in 1:100)
{
  i=0.006;
  repeat{
    gtest <- erdos.renyi.game(1000, i, type = c("gnp"));
    if(is.connected(gtest)){break()}
    i <- i+0.0001
  }
  i_0 <- i_0 + i
}
i_0 <- i_0/100


