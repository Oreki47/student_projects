library(igraph) 

#
# Problem 5 
#
df <- read.table("movie_network_trimmed.csv", sep =",")
m  <- as.matrix(df)
rm(df)
g <- graph.data.frame(m[, 1:2], directed=FALSE)
E(g)$weight <- m[, 3]
rm(m)
gc()

# checks
is.connected(g)
is.weighted(g)
is.directed(g)
# truncate half of the edges
# since edgelist is doubled
g <- simplify(g, remove.multiple = TRUE, remove.loops = TRUE,
         edge.attr.comb = igraph_opt("edge.attr.comb"))
save.image("E:/OneDrive/Github/R/232E_All/project2/movie_trimmed_1.RData")
is.simple(g)
fg <- fastgreedy.community(g, weights = E(g)$weight)
save.image("E:/OneDrive/Github/R/232E_All/project2/movie_trimmed_2.RData")

write.table(fg$membership, file = 'membership.txt', sep=',')
write.table(fg$names, file = 'movie_index.txt', sep= ',')

# neighbors
core_nodes = c(30255, 46820, 32740)
for (i in 1:3)
{
  edge_list <- numeric(0)
  core_neighbors <- neighbors(g, core_nodes[i])
  neighbor <- c()
  for (j in core_neighbors)
  {
    neighbor<- c(neighbor, names(V(g)[j]))
    # edge_list <- c(edge_list, V(g)[core_nodes[i]],V(g)[j])
  }
  weight_list  <- E(g)$weight[get.edge.ids(g, edge_list)]
  write.table(neighbor, paste(filename="core",i,".txt", sep=""), col.names = FALSE,row.names = FALSE)
  # write.table(weight_list, paste(filename="weight",i,".txt",sep=""), col.names = FALSE,row.names = FALSE)
}

