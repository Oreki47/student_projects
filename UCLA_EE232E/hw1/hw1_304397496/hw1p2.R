library(igraph)
rm(list=ls(all=TRUE))

# (a) basic
g_bar <- barabasi.game(1000, directed=FALSE)
deg <- degree_distribution(g_bar)

# setEPS()
#　postscript("hw1P2a1.eps")
plot(seq(deg), deg, log="xy", xlab="Degree", ylab="Density")
x <- seq(deg)
y <- x^(-3)
lines(x, y, col='red')

is.connected(g_bar)

# (b) 

# (c)

# (d)
n <- 1000
deg_j <- vector()

for (i in 1:3000){
  g <- barabasi.game(n, directed = FALSE)
  deg_j <- c(deg_j, length(neighbors(g, sample(neighbors(g, sample(n, 1)), 1))))
}
# setEPS()
# postscript("hw1P2d1.eps")
h <- hist(deg_j, breaks=seq(-0.5, by=1, length.out=max(deg_j) + 2))
plt <- data.frame(x=h$mids, y=h$density)

# setEPS()
# postscript("hw1P2d2.eps")
plot(plt, log="xy", xlab="Degree", ylab="Density")
x <- seq(deg_j)
y <- x^(-2)
lines(x, y, col='red')

