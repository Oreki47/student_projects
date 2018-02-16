library(igraph)

# (a) 
g_forest <- forest.fire.game(1000, fw.prob=0.37, bw.factor=0.32/0.37, directed=FALSE)
a <- degree_distribution(g_forest, mode='in')
b <- degree_distribution(g_forest, mode='out')
setEPS()
postscript("hw1P4a1.eps")
plot(a, xlab="Degree", ylab="Density_in")
setEPS()
postscript("hw1P4a2.eps")
plot(b, xlab="Degree", ylab="Density_out")
dia_forest <- diameter(g_forest, unconnected=TRUE, weights=NULL)
mod_forest <- cluster_fast_greedy(g_forest, merges=TRUE, modularity=TRUE, membership=TRUE)
modularity(mod_forest)

# (b)
d <- 0
for (j in 1:100)
{
  g_forest <- forest.fire.game(1000, fw.prob=0.37, bw.factor=0.32/0.37, directed=FALSE)
  d <- d + diameter(g_forest, unconnected=TRUE)
}
d <- d/100

# (c)
m <- 0
l <- 0
for (j in 1:100)
{
  g_forest <- forest.fire.game(1000, fw.prob=0.27, bw.factor=0.32/0.37, directed=FALSE)
  mod_forest <- cluster_fast_greedy(g_forest, merges=TRUE, modularity=TRUE, membership=TRUE)
  m <- m + modularity(mod_forest)
  l <- l + length(mod_forest)
}
m <- m/100
l <- l/100