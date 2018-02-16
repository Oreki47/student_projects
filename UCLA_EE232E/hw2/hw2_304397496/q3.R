library(igraph)
library(matrixStats)

# (a) Measure the prob of RandomWalk visit
n <- 1000
p <- 1/100
g <- erdos.renyi.game(n, p, type=c("gnp"))

t <- 20
n_walkers <- 1000
sp <- matrix(0, nrow = t, ncol=n_walkers)

for (j in 1:n_walkers)
{
  node_next <- sample(n, 1)
  sp[1, j] <- node_next
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
    sp[i+1, j] <- node_next # Store node degree value
  }
}
prob <- table(sp)
plot(prob)
cor(cbind(prob)[1:100], cbind(degree(g))[1:100])

# png(filename="E:/OneDrive/Github/R/232E_All/hw2/hw2p3a1.png")
# plot(prob, xlab=expression(italic('n')), ylab = "Frequency")
# dev.off()


# (b) Directed graph with same task (walker redesign)
n <- 1000
p <- 1/100
g <- erdos.renyi.game(n, p, type=c("gnp"), directed=TRUE)

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
    sp[i+1, j] <- node_next # Store node degree value
  }
}
prob <- table(sp)
plot(prob)
cor(cbind(prob)[1:25], cbind(degree(g, mode="in"))[1:25])

# png(filename="E:/OneDrive/Github/R/232E_All/hw2/hw2p3b1.png")
# plot(prob, xlab=expression(italic('n')), ylab = "Frequency")
# dev.off()

# png(filename="E:/OneDrive/Github/R/232E_All/hw2/hw2p3b1.png")
# plot(cbind(prob)[1:25], cbind(degree(g, mode="in"))[1:25],
#      xlab=expression(italic('n')), ylab = "Degree")
# dev.off()

# (c) With a damping parameter d = 0.15
n <- 1000
p <- 1/100
g <- erdos.renyi.game(n, p, type=c("gnp"))

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
cor(cbind(prob)[1:100], cbind(degree(g))[1:100])

# png(filename="E:/OneDrive/Github/R/232E_All/hw2/hw2p3c1.png")
# plot(prob, xlab=expression(italic('n')), ylab = "Frequency")
# dev.off()