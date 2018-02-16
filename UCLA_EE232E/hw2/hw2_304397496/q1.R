library(igraph)
library(matrixStats)

# (a) Random graph by Erdos.Renyi
n <- 10000
p <- 1/100
g <- erdos.renyi.game(n, p, type=c("gnp"), undirected=TRUE)

# (b), (c), (d) Generate random walk and measure stats
t <- 20
n_walkers <- 100
sp <- matrix(0, nrow = t-1, ncol=n_walkers)
w <- matrix(0, nrow=t, ncol=1)
for (j in 1:n_walkers)
{
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

# png(filename="E:/OneDrive/Github/R/232E_All/hw2/hw2p1b9.png")
# plot(mean_row, xlab=expression(italic('t')), ylab = "Average Distance") 
# dev.off()
# png(filename="E:/OneDrive/Github/R/232E_All/hw2/hw2p1b10.png")
# plot(sds_row, xlab=expression(italic('t')), ylab = "Standard Diviation")
# dev.off()


# For n = 100 plotting
# cg <- clusters(g)
# Gcc <- induced_subgraph(g, which(cg$membership ==which.max(cg$csize)))
# community <- fastgreedy.community(Gcc, merges=TRUE, modularity=TRUE, membership=TRUE)
# plot(community, Gcc, edge.arrow.size=0.2, vertex.size=1.0)


# (e)
n <- 1000
p <- 1/100
g <- erdos.renyi.game(n, p, type=c("gnp"))
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
png(filename="E:/OneDrive/Github/R/232E_All/hw2/hw2p1bdeg.png")
plot(deg, xlab=expression(italic('t')), ylab = "Average degree") 
dev.off()



