library(igraph)

# (a)
g_aging <- aging.prefatt.game(1000, pa.exp=1, aging.exp=-1, aging.bin=1000, directed=FALSE)
# setEPS()
# postscript("hw1P3a.eps")
plot(degree_distribution(g_aging), xlab="Degree", ylab="Degree_Distribution")

# (b)
m <- 0
l <- 0
for (j in 1:100)
{
  g_aging <- aging.prefatt.game(1000, pa.exp=1, aging.exp=-1, aging.bin=1000, directed=FALSE)
  mod_forest <- cluster_fast_greedy(g_aging, merges=TRUE, modularity=TRUE, membership=TRUE)
  m <- m + modularity(mod_forest)
  l <- l + length(mod_forest)
}
m <- m/100
l <- l/100

# (c)
# setEPS()
# postscript("hw1P3c.eps")
plot(mod_forest, g_aging)

# Sup


g <- aging.prefatt.game(1000, 1, -1, directed = FALSE)
cg <- clusters(g)
Gcc <- induced_subgraph(g, which(cg$membership ==which.max(cg$csize)))
community <- fastgreedy.community(Gcc, merges=TRUE, modularity=TRUE, membership=TRUE)
plot(community, Gcc, vertex.label=NA, edge.arrow.size=0.02, vertex.size=1.0)
