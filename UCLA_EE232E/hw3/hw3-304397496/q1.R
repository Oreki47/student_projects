library(igraph) 
# library(matrixStats)

# Build Graph based on vertice files
df <- read.table("sorted_directed_net.txt")
m  <- as.matrix(df)
m[, 1] <- m[ ,1] + 1
m[, 2] <- m[, 2] + 1
g <- graph.data.frame(m[, 1:2], directed=TRUE)
E(g)$weight <- m[, 3]

# 1 Connection
# con_bol <- is.connected(g)
# dir_bol <- is.directed(g)
# wei_bol <- is.weighted(g)

# cg  <- clusters(g, mode="strong")
# Gcc <- induced_subgraph(g, which(cg$membership ==which.max(cg$csize)))

# 2 Degree Distribution
# plot(degree_distribution(g, mode='in'), log="xy", xlab="In degree", ylab="Density")
# plot(degree_distribution(g, mode='out'), log="xy", xlab="Out degree", ylab="Density")

# png(filename="E:/OneDrive/Github/R/232E_All/hw3/hw3p1a3.png")
# plot(degree_distribution(g, mode='in'), log="xy", xlab="In degree", ylab="Density")
# x <- seq(degree_distribution(g, mode='in'))
# y <- x^(-1.5)
# lines(x,y,col='red')
# dev.off()
# png(filename="E:/OneDrive/Github/R/232E_All/hw3/hw3p1a4.png")
# plot(degree_distribution(g, mode='out'), log="xy", xlab="Out degree", ylab="Density")
# x <- seq(degree_distribution(g, mode='in'))
# y <- x^(-1.5)
# lines(x,y,col='red')
# dev.off()

# 3 Community Structure
# Option 1
g_un1 <- as.undirected(g, mode='each')

# con_bol_un1 <- is.connected(g_un1)
# dir_bol_un1 <- is.directed(g_un1)
# wei_bol_un1 <- is.weighted(g_un1)

c_un1 <- label.propagation.community (g_un1)

# Option 2
g_un2 <- as.undirected(g, mode="collapse", edge.attr.comb=list(weight="prod"))
E(g_un2)$weight <-sqrt(E(g_un2)$weight)

# con_bol_un2 <- is.connected(g_un2)
# dir_bol_un2 <- is.directed(g_un2)
# wei_bol_un2 <- is.weighted(g_un2)

c_un2 <- label.propagation.community (g_un2)
c_un3 <- fastgreedy.community(g_un2)
# table(c_un3$membership)

# 4 GCC from Option 2
# It's not GCC tho, some naming issue.
Gcc <- induced_subgraph(g_un2, which(c_un3$membership == which.max(sizes(c_un3))))
c_gcc <- fastgreedy.community(Gcc)
plot(c_gcc, Gcc, vertex.label=NA, edge.arrow.size=0.1, vertex.size=1.0)

# 5 Sub with size > 100
idx <- which(table(c_un3$membership) > 100, arr.ind=TRUE)
for (i in idx)
{
  sub <- induced.subgraph(g_un2, which(membership(c_un3) == i))
  c_sub <- fastgreedy.community(sub)
  mod[i] <- max(c_sub$modularity)
  png(paste(filename="E:/OneDrive/Github/R/232E_All/hw3/hw3p5a",i,".png", sep=""))
  hist(c_sub$membership, xlab="Cluster Index of Sub-Community", ylab="Size", main=paste("Community Structure of Subgraph",i))
  dev.off()
}

# 6 personal PageRank
# Using Algorithm in hw2-q4
# Initialize
n <- length(V(g))
t <- 2000
n_walkers <- 1
threshold <- 0.2
node_list <- c()
l <- length(table(c_un2$membership))
M <- matrix(0, nrow=l, ncol=150)
d <- c(0.85, 0.15)
jump <- c(0, 1)
dis <- degree(g)/sum(degree(g))
sp <- vector(mode='integer', t)
M <- matrix(0, nrow=l, ncol=n_walkers)
# Main Loop
for (j in 1:n_walkers)
{
  if (j%%2 == 0)
  {
    print(j)
  }
  # Initializing node i
  node_init <- sample(n, 1)
  node_next <- node_init
  dis <- vector(mode='integer', length(V(g)))
  dis[node_next] <- 1
  sp[1] <- node_next
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
    sp[i+1] <- node_next # Store node number
  }
  # freqency of visit to each node
  freq <- table(sp)
  # Index of 30 nodes with largerst prob
  a <- order(-freq)[0:30]
  temp <- vector(mode='integer', l)
  
  prob <- unname(freq[a]/sum(freq[a]))
  for (k in 1:30)
  {
    m <- vector(mode='integer', l)
    m[c_un2$membership[as.numeric(names(freq[a[k]]))]] <- 1
    temp <- temp + unname(prob[k])*m
  }
  if(length(which(temp > threshold)) > 1)
  {
    node_list <- append(node_list, node_init)
    M[, j] <- temp
  }
}




