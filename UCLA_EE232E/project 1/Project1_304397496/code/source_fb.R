library(igraph) 
library(hydroGOF)
# library(matrixStats)

#
# Problem 1 
#
### Build Graph based on vertice files
df <- read.table("facebook_combined.txt")
m  <- as.matrix(df)
m[, 1] <- m[ ,1] + 1
m[, 2] <- m[, 2] + 1
g <- graph.data.frame(m[, 1:2], directed=FALSE)

# is.connected(g)
# diameter(g)

plot(degree_distribution(g), log='xy', xlab='Degree', ylab="Frequency", main='Degree Distribution in log-scale')

# png(filename="E:/OneDrive/Github/R/232E_All/project1/q1a.png")
# plot(degree_distribution(g), xlab='Degree', ylab="Frequency", main='Degree Distribution')
# dev.off()

# Fit curve
c <- as.matrix(degree_distribution(g))
temp <- data.frame(y = c, x = seq(length(c)))
mod <- nls(y ~ exp(a + b * x), data = temp, start = list(a = 0, b = 0))

summary(mod)
mse_fit <- mse(degree_distribution(g), predict(mod, list(x = temp$x)))
# mean(degree(g))
# mean(predict(mod, list(x = temp$x))*vcount(g)*temp$x)

# png(filename="E:/OneDrive/Github/R/232E_All/project1/q1b.png")
# plot(degree_distribution(g), log='xy', xlab='Degree', ylab="Frequency", main='Degree Distribution in log-scale')
# lines(temp$x, predict(mod, list(x = temp$x)), col=10)

#
# Problem 2 
#
g_node1 <- induced.subgraph(g, c(1, neighbors(g,1)))

png(filename="E:/OneDrive/Github/R/232E_All/project1/q1c.png", height = 1080, width = 1080)
weight <- rep(2,vcount(g_node1))
weight[1] <- 5
color <- rep('green',vcount(g_node1))
color[1] <- 'red'
plot.igraph(g_node1,vertex.size=weight,vertex.label =NA,vertex.color=color)
dev.off()

#
# Problem 3 
#
core_degree <- degree(g)[which(degree(g)>200)]

# Communities 

# fg <- fastgreedy.community(g_node1)
# png(filename="E:/OneDrive/Github/R/232E_All/project1/q1d.png", height = 1080, width = 1080)
# colors <- rainbow(max(membership(fg)))
# palette(colors)
# plot(g_node1, vertex.size=weight,vertex.label =NA, vertex.color=colors[membership(fg)], 
#      layout=layout.fruchterman.reingold)
# dev.off()
# 
# eb <- edge.betweenness.community(g_node1)
# png(filename="E:/OneDrive/Github/R/232E_All/project1/q1e.png", height = 1080, width = 1080)
# colors <- rainbow(max(membership(eb)))
# palette(colors)
# plot(g_node1, vertex.size=weight,vertex.label =NA, vertex.color=colors[membership(eb)],
#      layout=layout.fruchterman.reingold)
# dev.off()
# 
# im <- infomap.community(g_node1)
# png(filename="E:/OneDrive/Github/R/232E_All/project1/q1f.png", height = 1080, width = 1080)
# colors <- rainbow(max(membership(im)))
# palette(colors)
# plot(g_node1, vertex.size=weight,vertex.label =NA, vertex.color=colors[membership(im)],
#      layout=layout.fruchterman.reingold)
# dev.off()

#
# Problem 4 
#
g_rm <- induced.subgraph(g, neighbors(g,1))
weight <- rep(2,vcount(g_rm))

# fg <- fastgreedy.community(g_rm)
# png(filename="E:/OneDrive/Github/R/232E_All/project1/q1g.png", height = 1080, width = 1080)
# colors <- rainbow(max(membership(fg)))
# palette(colors)
# plot(g_rm, vertex.size=weight,vertex.label =NA, vertex.color=colors[membership(fg)],
#      layout=layout.fruchterman.reingold)
# dev.off()
# 
# eb <- edge.betweenness.community(g_rm)
# png(filename="E:/OneDrive/Github/R/232E_All/project1/q1h.png", height = 1080, width = 1080)
# colors <- rainbow(max(membership(eb)))
# palette(colors)
# plot(g_rm, vertex.size=weight,vertex.label =NA, vertex.color=colors[membership(eb)],
#      layout=layout.fruchterman.reingold)
# dev.off()
# 
# im <- infomap.community(g_rm)
# png(filename="E:/OneDrive/Github/R/232E_All/project1/q1i.png", height = 1080, width = 1080)
# colors <- rainbow(max(membership(im)))
# palette(colors)
# plot(g_rm, vertex.size=weight,vertex.label =NA, vertex.color=colors[membership(im)],
#      layout=layout.fruchterman.reingold)
# dev.off()



#
# Problem 5
#
### Dispersion and Embeddedness
core_node <- degree(g)[which(degree(g)>200)]
### Data Structure
ebd <- numeric() # embeddedness
dsp <- numeric() # dispersion
### Compute Sum of Dispersion
sum_dsp <- function(g, mf)
{
  dsp <- distances(g, v=V(g)[mf], to=V(g)[[mf]])
  return (sum(dsp)/2)
}

### Main loop
for (i in names(core_node)) # loop of core node i
# for (i in names(core_node)[1]) # single run
{
  print(i)
  pg <- induced.subgraph(g,  c(V(g)[i], neighbors(g, i))) # define personal network;
  # notice here when binding, we cannot directly bind i to neighbors as they are
  # different objects.
  core_dia <- diameter(pg) # diameter, used to replace Inf in dispersion calculation
  for (j in neighbors(pg, i)) # loop of neighbors of core node i
  {
    dsp_pg <- delete.vertices(pg, j)
    g_mutual <- intersect(neighbors(pg, i), neighbors(pg, j))
    # Again g_mutual returns a list object, not a vertices list.
    ebd <- c(ebd, length(g_mutual))
    dsp <- c(dsp, sum_dsp(pg, g_mutual))
  }
  
  ### Plot personal network with special setups
  # fg <- fastgreedy.community(pg)
  # png(paste(filename="E:/OneDrive/Github/R/232E_All/project1/personal/",i,".png", sep=""),
  #     height = 1080, width = 1080)
  # weight <- rep(2,vcount(pg))
  # 
  # colors <- rainbow(max(membership(fg)))
  # colors <- colors[membership(fg)]
  # 
  # colors[neighbors(pg, i)[which.max(dsp)]] <- 'gray'
  # weight[neighbors(pg, i)[which.max(dsp)]] <- 5
  # colors[neighbors(pg, i)[which.max(ebd)]] <- 'deeppink'
  # weight[neighbors(pg, i)[which.max(ebd)]] <- 5
  # colors[neighbors(pg, i)[which.max(dsp/ebd)]] <- 'gold'
  # weight[neighbors(pg, i)[which.max(dsp/ebd)]] <- 5
  # colors[V(pg)[i]] <- 'darkslateblue'
  # weight[V(pg)[i]] <- 5
  # palette(colors)
  # plot(pg, vertex.size=weight,vertex.label =NA, vertex.color= colors,
  #      layout=layout.fruchterman.reingold)
  # legend(x="topleft",
  #        legend=c("ebd", "dsp", "dis/emb", "core"),
  #        col=c('deeppink', 'gray', 'gold','darkslateblue'),
  #        cex = 1.75, pch =20)
  # dev.off()
  # 
  # ebd <- numeric() # embeddedness reset
  # dsp <- numeric() # dispersion reset
}


### Distribution
# png(filename="E:/OneDrive/Github/R/232E_All/project1/q1j.png")
# hist(ebd, breaks=50, main="Embeddedness Distribution",
#      xlab ="Embeddedness", ylab='Frequency')
# dev.off()
# 
# png(filename="E:/OneDrive/Github/R/232E_All/project1/q1k.png")
# hist(dsp, breaks=50, main="Dispersion Distribution",
#      xlab ="Dispersion", ylab='Frequency', ylim=range(0: 4000))
# dev.off()

#
# Problem 6
#
core_node <- degree(g)[which(degree(g)>200)]
  


### Main loop
# for (i in names(core_node)) # loop of core node i
for (i in names(core_node)[21]) # single run
{
  print(i)
  pg <- induced.subgraph(g,  c(V(g)[i], neighbors(g, i))) 
  fg <- label.propagation.community(pg)
  
  # Initialize Data Structure
  mod <- numeric()
  den <- numeric()
  deg_ave <- numeric()
  clu_eff <- numeric()
  com_len <- numeric()
  
  for (j in 1:length(fg))
  {
    if (sizes(fg)[j] > 10)
    {
      cg <- induced.subgraph(pg,V(pg)[which(fg$membership==j)])
      # mg <- walktrap.community(cg)
      
      # Store all values
      # mod <- c(mod, modularity(cg, mg$membership))
      den <- c(den, graph.density(cg))
      deg_ave <- c(deg_ave, mean(degree(cg)))
      clu_eff <- c(clu_eff, transitivity(cg, type='Global'))
      com_len <- c(com_len, vcount(cg))
    }
  } 

  # ### Plot data out
  # png(paste(filename="E:/OneDrive/Github/R/232E_All/project1/lp_type/",i,"lpr.png", sep=""),  height = 360, width = 720)
  # plot(den,      type = "b", lty = 1, pch = 0, col = 2, ylim = c(0, 1), xlab="Community Index", axes=FALSE)
  # lines(clu_eff, type = "b", lty = 3, pch = 2, col = 4)
  # axis(side=1, at=c(0:length(den)))
  # axis(side=2, at=seq(0, 1, by=0.2))
  # legend("topleft", c("Density", "Transitivity"), cex = 1.25,
  #        lty = c(1, 3), pch = c(0, 2), col=c(2, 4), merge = TRUE)
  # dev.off()
  # 
  # png(paste(filename="E:/OneDrive/Github/R/232E_All/project1/lp_type/",i,"lps.png", sep=""),  height = 360, width = 720)
  # plot(com_len, type = "b", lty = 1, pch = 0, col = 2, axes=FALSE)
  # legend("topright", c("Community_size"),
  #        cex = 1.25, lty = c(1), pch = c(0), col=c(2), merge = TRUE)
  # axis(side=1, at=c(0:length(den)))
  # axis(side=2, at=seq(0, max(com_len)+20, by=20))
  # dev.off()
  # 
  # png(paste(filename="E:/OneDrive/Github/R/232E_All/project1/lp_type/",i,"lpt.png", sep=""),  height = 360, width = 720)
  # plot(deg_ave, type = "b", lty = 2, pch = 1, col = 4, axes=FALSE)
  # legend("topright", c("Average_degree"),
  #        cex = 1.25, lty = c(2), pch = c(1), col=c(4), merge = TRUE)
  # axis(side=1, at=c(0:length(den)))
  # axis(side=2, at=seq(0, max(deg_ave)+20, by=10))
  # dev.off()
}
















