library(igraph)
library(matrixStats)

# (a) Random graph by barabasi.game
n <- 1000
g <- barabasi.game(n, directed=FALSE)

# (b), (c), (d) Generate random walk and measure stats
t <- 2000
n_walkers <- 10
sp <- matrix(0, nrow = t-1, ncol=n_walkers)
w <- matrix(0, nrow=t, ncol=1)
for (j in 1:n_walkers)
{
  if (j%%100 == 0)
  {
    print(j)
  }
  node_next <- sample(n, 1)
  w[1][1] <- node_next
  for (i in 1:t-1)
  {
    neig_next <- neighbors(g, node_next)
    if (length(neig_next) == 1) # if # of neighbor = 1, assign to next
    {
      node_next <- neig_next
    }
    else if(length(neig_next) == 0){} # if there is no neighbor do nothing
    else # if # of neighbor > 1
    {
      deg_neig <- degree(g, neig_next)
      node_next <-  sample(neig_next, 1, prob=deg_neig/sum(deg_neig), replace=TRUE)
    }
    w[i+1][1] <- node_next # Store node value
  }
  sp [, j] <-  distances(g, w, to = w[1])[2:t]
}

mean_row <- rowMeans(sp, na.rm = TRUE)
sds_row <- rowSds(sp, na.rm = TRUE)
plot(mean_row, xlab=expression(italic('t')), ylab = "Average Distance")
plot(sds_row, xlab=expression(italic('t')), ylab = "Standard Diviation")

# png(filename="E:/OneDrive/Github/R/232E_All/hw2/hw2p2b7.png")
# plot(mean_row, xlab=expression(italic('t')), ylab = "Average Distance")
# dev.off()
# png(filename="E:/OneDrive/Github/R/232E_All/hw2/hw2p2b8.png")
# plot(sds_row, xlab=expression(italic('t')), ylab = "Standard Diviation")
# dev.off()

# (e)
n <- 1000
g <- barabasi.game(n, directed=FALSE)
t <- 20
n_walkers <- 200
sp <- matrix(0, nrow = 1, ncol=n_walkers)

for (j in 1:n_walkers)
{
  node_next <- sample(n, 1)
  sp[1, j] <- degree(g, node_next)
  for (i in 1:t-1)
  {
    neig_next <- neighbors(g, node_next)
    if (length(neig_next) == 1) # if # of neighbor = 1, assign to next
    {
      node_next <- neig_next
    }
    else if(length(neig_next) == 0){} # if there is no neighbor do nothing
    else # if # of neighbor > 1
    {
      deg_neig <- degree(g, neig_next)
      node_next <-  sample(neig_next, 1, prob=deg_neig/sum(deg_neig), replace=TRUE)
    }
  }
  sp[1, j] <- node_next
}
deg <- table(degree(g, sp))
png(filename="E:/OneDrive/Github/R/232E_All/hw2/hw2p2edeg.png")
plot(deg, xlab=expression(italic('t')), ylab = "Average degree") 
dev.off()


