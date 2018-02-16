library(igraph) 
# library(eulerian)
# library(graph)
# construct network
df <- read.table("edgelist_day.csv", sep =",")
m  <- as.matrix(df)
rm(df)
g <- graph.data.frame(m[, 1:2], directed=FALSE)
E(g)$weight <- m[, 3]
rm(m)
gc()

# checks
is.connected(g)
is.weighted(g)
is.simple(g)
is.directed(g)

# MST and graph
g_mst <- mst(g, weights = E(g)$weight, algorithm = NULL)
# Assign color by section
color_idx <- read.table('colorlist.csv', sep=',')
color_palette = c('aliceblue', 'mediumpurple',
                  'gold', 'blue', 
                  'navy',
                  'blueviolet', 'brown',
                  'hotpink', 'chartreuse',
                  'cornsilk', 'beige',
                  'khaki')
palette(rainbow(12))
color <- c()
for (col in color_idx$V2){color <- c(color, palette()[col])}

# png(filename="03mst.png", height = 1080, width = 1080)
# plot(g_mst, vertex.label =NA, vertex.size = 2, vertex.color = color)
# dev.off()

# Evaluate sector clustering
p <- numeric()
for (idx in 1:505)
{
  neis <- neighbors(g_mst, toString(idx-1))
  count = 0
  for (nei in neis)
  {
    if (color_idx$V2[idx] == color_idx$V2[nei])
    {
      count = count + 1
    }
    p <- c(p, count/ length(neis))
  }
}
print (mean(p))

# Evaluate RANDOM clustering
# simply randomize V2
p_up <- numeric()
for (trail in 1:100)
{
  if (trail%%10 == 0)
  {
    print(trail)
  }
  rand_sec <- sample(color_idx$V2)
  p <- numeric(0)
  for (idx in 1:505)
  {
    neis <- neighbors(g_mst, toString(idx-1))
    count = 0
    for (nei in neis)
    {
      if (rand_sec[idx] == rand_sec[nei])
      {
        count = count + 1
      }
      p <- c(p, count/ length(neis))
    }
  }
  p_up <- c(p_up, mean(p))
}

print (mean(p_up))

# 5
g_mlt <- add.edges(g_mst, get.edgelist(g_mst, names=TRUE))
# write.csv(get.edgelist(g_mlt, names=TRUE), file = 'euler.csv')
g_nel <- igraph.to.graphNEL(g_mlt)
eul_walk <- eulerian(g_nel)
write.csv(eul_walk, file = 'euler.csv')


data <- read.table('adj.csv', sep = ',')
library(TSP)
atsp <- ATSP(as.matrix(data))
tour <- solve_TSP(atsp, method = "nn")
tour_length(tour)

# 6
# construct network
df <- read.table("edgelist_week.csv", sep =",")
m  <- as.matrix(df)
rm(df)
g <- graph.data.frame(m[, 1:2], directed=FALSE)
E(g)$weight <- m[, 3]
rm(m)
gc()

# MST and graph
g_mst <- mst(g, weights = E(g)$weight, algorithm = NULL)
# Assign color by section
color_idx <- read.table('colorlist.csv', sep=',')
color_palette = c('aliceblue', 'mediumpurple',
                  'gold', 'blue', 
                  'navy',
                  'blueviolet', 'brown',
                  'hotpink', 'chartreuse',
                  'cornsilk', 'beige',
                  'khaki')
palette(rainbow(12))
color <- c()
for (col in color_idx$V2){color <- c(color, palette()[col])}

png(filename="06mst.png", height = 1080, width = 1080)
plot(g_mst, vertex.label =NA, vertex.size = 2, vertex.color = color)
dev.off()

# Evaluate sector clustering
p <- numeric()
for (idx in 1:505)
{
  neis <- neighbors(g_mst, toString(idx-1))
  count = 0
  for (nei in neis)
  {
    if (color_idx$V2[idx] == color_idx$V2[nei])
    {
      count = count + 1
    }
    p <- c(p, count/ length(neis))
  }
}
print (mean(p))

# 7
# construct network
df <- read.table("edgelist_corr.csv", sep =",")
m  <- as.matrix(df)
rm(df)
g <- graph.data.frame(m[, 1:2], directed=FALSE)
E(g)$weight <- m[, 3]
rm(m)
gc()

# MST and graph
g_mst <- mst(g, weights = E(g)$weight, algorithm = NULL)
# Assign color by section
color_idx <- read.table('colorlist.csv', sep=',')
color_palette = c('aliceblue', 'mediumpurple',
                  'gold', 'blue', 
                  'navy',
                  'blueviolet', 'brown',
                  'hotpink', 'chartreuse',
                  'cornsilk', 'beige',
                  'khaki')
palette(rainbow(12))
color <- c()
for (col in color_idx$V2){color <- c(color, palette()[col])}

png(filename="07mst.png", height = 1080, width = 1080)
plot(g_mst, vertex.label =NA, vertex.size = 2, vertex.color = color)
dev.off()

# 8
n <- 1000
# initialize with 2 nodes
vc <- graph(c(1, 2), directed = FALSE)
# loop to construct the mst
p <- c(1, 1)
for (i in 3:n)
{
  j <- sample(1:(i-1), 1, prob = p/sum(p))
  vc <- add.vertices(vc, 1)
  vc <- add.edges(vc, c(i, j))
  p[j] <- 1/length(neighbors(vc, j))
  p <- c(p, 1)
}
png(filename="08vc4.png", height = 1080, width = 1080)
plot(vc, vertex.label =NA, vertex.size = 2)
dev.off()