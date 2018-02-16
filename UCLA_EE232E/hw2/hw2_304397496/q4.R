library(igraph)
library(matrixStats)

# (a) Directed graph n PageRank Simulation with a damping parameter d = 0.15
n <- 1000
p <- 1/100
g <- erdos.renyi.game(n, p, type=c("gnp"), directed=TRUE)

d <- c(0.85, 0.15)
jump <- c(0, 1)
t <- 20
n_walkers <- 1000
sp <- matrix(0, nrow = t, ncol=n_walkers)
for (j in 1:n_walkers)
{
  if (j%%20 == 0)
  {
    print(j)
  }
  node_next <- sample(n, 1)
  sp[1, j] <- node_next
  for (i in 1:t-1)
  {
    jump_param <- sample(jump, 1, prob=d)
    if (jump_param==0)
    {
      neig_next <- neighbors(g, node_next, mode='out')
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
    else
    {
      # Question: random jump also /deg? Probably not
      node_next <- sample(n, 1)
    }
    sp[i+1, j] <- node_next # Store node degree value
  }
}
prob <- table(sp)
plot(prob)
cor(cbind(prob)[1:100], cbind(degree(g, mode='in'))[1:100])

# png(filename="E:/OneDrive/Github/R/232E_All/hw2/hw2p4a1.png")
# plot(prob, xlab=expression(italic('n')), ylab = "Frequency")
# dev.off()

# (b) Jump according to their degree

n <- 1000
p <- 1/100
g <- erdos.renyi.game(n, p, type=c("gnp"), directed=TRUE)
dis <- degree(g)/sum(degree(g))

d <- c(0.85, 0.15)
jump <- c(0, 1)
t <- 20
n_walkers <- 1000
sp <- matrix(0, nrow = t, ncol=n_walkers)
for (j in 1:n_walkers)
{
  if (j%%20 == 0)
  {
    print(j)
  }
  node_next <- sample(n, 1)
  sp[1, j] <- node_next
  for (i in 1:t-1)
  {
    jump_param <- sample(jump, 1, prob=d)
    if (jump_param==0)
    {
      neig_next <- neighbors(g, node_next, mode='out')
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
    else
    {
      # Jump according to distribution
      node_next <- sample(n, 1, prob=dis)
    }
    sp[i+1, j] <- node_next # Store node degree value
  }
}
prob <- table(sp)
plot(prob)
cor(cbind(prob)[1:100], cbind(degree(g, mode='in'))[1:100])

# png(filename="E:/OneDrive/Github/R/232E_All/hw2/hw2p4b1.png")
# plot(prob, xlab=expression(italic('n')), ylab = "Frequency")
# dev.off()
# (c) 