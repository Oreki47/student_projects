source('E:/OneDrive/Github/R/Libs/plot_libs.R')
# 8
# (a)
college = read.csv('data/College.csv')
# (b)
fix(college)
rownames(college) = college[, 1]
fix(college)
college = college [,-1]
fix(college)
# (c)
# The larger the number from outstate,
# the better chance of elite, i.e.,
# outstate has a higher bar.
summary(college)
pairs(college[, 1:10])
elite = rep('No', nrow(college)) # rep for repeat
elite [college$Top10perc > 50] = TRUE
elite = as.factor(elite)
college = data.frame(college, elite)
plot(college$Outstate, elite)
fix(college)
par(mfrow=c(2,2)) # split the print window
hist(college$Enroll)
hist(college$Top10perc)
#...

# 9
# (a)
auto = read.csv('data/Auto.csv', header=T, na.strings="?")
auto = na.omit(auto)
summary(auto)
sapply(auto[, 1:7], range) # interesting

# (d)
newauto = auto[-(10:85), ]

#(e)
par(mfrow=c(1,1))
plot(auto$mpg, auto$year)
corr = cor(auto[, 1:7])

# 10
# (a)
library(MASS)
boston = Boston
dim(boston)
corr = cor(boston)

# (c)
plot_heatmap(corr)

# (d)
par(mfrow=c(1,3))
# most subs: low
# 18 of them > 20
hist(boston$crim[boston$crim>1], breaks=25)
length(boston$crim[boston$crim > 20])
# gap
hist(boston$tax, breaks=25)
# a skew towards high ratios
hist(boston$ptratio, breaks=25)

# (e)
length(boston$chas[boston$chas ==1])
# dim(subset(boston, chas == 1))

# (f)
median(boston$ptratio)

# (g)
subset(boston, medv == min(boston$medv))

# (f)
dim(subset(boston, boston$rm > 7))
summary(subset(boston, boston$rm > 8))
