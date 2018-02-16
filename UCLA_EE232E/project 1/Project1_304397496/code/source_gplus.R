library(igraph) 
# library(hydroGOF)
# library(matrixStats)
options(digits = 20)
#
# Part 1 Loop through all files and find nodes with +2 circles
#
node_id <- as.matrix(read.table('index.csv', sep=',', numerals = 'no.loss'))


for (i in 3:nrow(node_id))
# for (i in 1)
{
  ### Read graph from edges.
  print(i)
  g <- read.graph(paste('gplus/',node_id[i, 2],".edges", sep=""),
                  format='ncol', directed=TRUE)
  
  ### Load circles file
  cir_pre <- read.table(paste('gplus_circles/',node_id[i, 2],".csv", sep=""),
                        sep=',', numerals = 'no.loss')
  
  ### Construct edgelist to be added
  from <- rep(as.numeric(length(V(g))+1), length(V(g)))
  to   <- 1:length(V(g))
  edge_add <- as.vector(t(cbind(from, to)))
  ### Add ego node/edges to graph
  g_full <- add.vertices(g, 1, name=toString(node_id[i, 1]))
  g_full <- add.edges(g_full, edge_add)
    
  ### Extract Community
  wk <- walktrap.community(g_full)
  im <- infomap.community(g_full)

  ### Plot Community Structure from Walktrap
  # plot_community(wk, g_full, as.numeric(node_id[i, 1]))
  
  ### Compare communities to circle
  post_analysis(wk, g_full, as.numeric(node_id[i, 1]))
  post_analysis(im, g_full, as.numeric(node_id[i, 1]))
}


post_analysis <- function(com_type, graph_full, idx)
{
  ### Load circles file
  cir_pre <- read.table(paste('gplus_circles/',node_id[i, 2],".csv", sep=""),
                        sep=',', numerals = 'no.loss')
  prob_cir <- matrix(0, nrow=length(com_type), ncol=length(cir_pre))
  prob_com <- matrix(0, ncol=length(com_type), nrow=length(cir_pre))
  for (i in 1:length(com_type))
  {
    cir_pos <- V(graph_full)[which(com_type$membership==i)]
    for (j in 1:length(cir_pre))
    {
      circle <- as.numeric(as.matrix(cir_pre)[, j])
      d<-intersect(circle, as.numeric(names(cir_pos)))
      size_circle <- length(circle[!is.na(circle)])
      prob_cir[i, j] <- length(d)/size_circle
      prob_com[j, i] <- length(d)/length(cir_pos)

    }
  }

  png(paste(filename="E:/OneDrive/Github/R/232E_All/project1/gplus_overlap/",idx,"cir",com_type$algorithm,".png", sep=""))
  barplot(prob_cir, main='Percentage Match over Prefixed Circles', xlab='Circles', ylab='Percentage',
          names.arg=c(1:length(cir_pre)))
  dev.off()
  
  png(paste(filename="E:/OneDrive/Github/R/232E_All/project1/gplus_overlap/",idx,"com",com_type$algorithm,".png", sep=""),  height = 360, width = 720)
  barplot(prob_com, main='Percentage Match Over Detected Communities', xlab='Communities',
          ylab='Percentage', names.arg=c(1:length(com_type)))
  dev.off()
}

plot_community <- function(com_type, graph_full, i)
{
  # Initialize values
  den <- numeric()
  deg_ave <- numeric()
  clu_eff <- numeric()
  com_len <- numeric()
  
  for (j in 1:length(com_type))
  {
    if (sizes(com_type)[j] > 10)
    {
      cg <- induced.subgraph(graph_full,V(graph_full)[which(com_type$membership==j)])
      
      # Store all values
      den <- c(den, graph.density(cg))
      deg_ave <- c(deg_ave, mean(degree(cg)))
      clu_eff <- c(clu_eff, transitivity(cg, type='Global'))
      com_len <- c(com_len, vcount(cg))
    }
  } 
  
  ### Plot data out
  png(paste(filename="E:/OneDrive/Github/R/232E_All/project1/gplus_wk/",i,"ga.png", sep=""),  height = 360, width = 720)
  plot(den,      type = "b", lty = 1, pch = 0, col = 2, ylim = c(0, 1), xlab="Community Index", axes=FALSE)
  lines(clu_eff, type = "b", lty = 3, pch = 2, col = 4)
  axis(side=1, at=c(0:length(den)))
  axis(side=2, at=seq(0, 1, by=0.2))
  legend("topleft", c("Density", "Transitivity"), cex = 1.25,
         lty = c(1, 3), pch = c(0, 2), col=c(2, 4), merge = TRUE)
  dev.off()

  png(paste(filename="E:/OneDrive/Github/R/232E_All/project1/gplus_wk/",i,"gb.png", sep=""),  height = 360, width = 720)
  plot(com_len, type = "b", lty = 1, pch = 0, col = 2, axes=FALSE)
  legend("topright", c("Community_size"),
         cex = 1.25, lty = c(1), pch = c(0), col=c(2), merge = TRUE)
  axis(side=1, at=c(0:length(den)))
  axis(side=2, at=seq(0, max(com_len)+20, by=20))
  dev.off()

  png(paste(filename="E:/OneDrive/Github/R/232E_All/project1/gplus_wk/",i,"gc.png", sep=""),  height = 360, width = 720)
  plot(deg_ave, type = "b", lty = 2, pch = 1, col = 4, axes=FALSE)
  legend("topright", c("Average_degree"),
         cex = 1.25, lty = c(2), pch = c(1), col=c(4), merge = TRUE)
  axis(side=1, at=c(0:length(den)))
  axis(side=2, at=seq(0, max(deg_ave)+20, by=10))
  dev.off()
}
