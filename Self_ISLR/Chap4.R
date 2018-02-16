# Load all library needed (like python $load magic)
LoadLibraries=function (){
library (ISLR)
library (MASS)
library (class)
source('E:/OneDrive/Github/R/Libs/plot_libs.R')
print (" The libraries and functions have been loaded .")}

# Load library
LoadLibraries()

# Practice 
names(Smarket)
pairs(Smarket) # not clear 
plot_heatmap(cor(Smarket[, -9])) # Better

attach(Smarket)
plot(Volume)
glm.fit=glm(Direction~Lag1+Lag2+Lag3+Lag4+Lag5+Volume, 
            data=Smarket ,family =binomial)
summary(glm.fit) # All values are large


glm.probs = predict(glm.fit, type="response")
contrasts(Direction)
glm.pred = rep("Down ", 1250)
glm.pred[glm.probs > .5]=" Up"

table(glm.pred, Direction)

# Add hold out
train = (Year < 2005)
Smarket.2005 = Smarket[!train, ]
Direction.2005 = Direction[!train]

glm.fit = glm(Direction ~ Lag1 + Lag2 + Lag3 + Lag4 + Lag5 + Volume,
              data=Smarket, family=binomial, subset=train)
glm.probs = predict(glm.fit, Smarket.2005, type='response')

glm.pred = rep('Down', 252)
glm.pred[glm.probs > 0.5] = "Up"
table(glm.pred, Direction.2005)
mean(glm.pred!=Direction.2005)

# Use less predictors
glm.fit=glm(Direction ~ Lag1 + Lag2,
            data=Smarket,
            family =binomial,
            subset =train)
# LDA Part
lda.fit = lda(Direction~Lag1+Lag2, data=Smarket, subset=train)

# QDA
qda.fit = qda(Direction~Lag1+Lag2, data=Smarket, subset=train)

# KNN
library(class)
train.X = cbind(Lag1 ,Lag2)[train ,]
test.X = cbind (Lag1 ,Lag2)[!train ,]
train.Direction = Direction [train]

set.seed(1)
knn.pred = knn(train.X, test.X, train.Direction, k=3)

# On Caravan
attach(Caravan)

standardized.X = scale(Caravan[, -86])
test = 1:1000
train.X = standardized.X[-test, ]
test.X = standardized.X[test, ]
train.Y = Purchase[-test]
test.Y = Purchase[test]
set.seed(1)
knn.pred = knn(train.X, test.X, train.Y, k=5)
mean(test.Y != knn.pred)
table(knn.pred, test.Y)

glm.fit = glm(Purchase~., data= Caravan, family=binomial, subset=-test)
glm.probs = predict(glm.fit ,Caravan[test ,], type="response")
glm.pred = rep("No", 1000)
glm.pred[glm.probs > 0.5] = "Yes"
table(glm.pred, test.Y)
glm.pred[glm.probs > 0.25] = "Yes"
table(glm.pred, test.Y)

# Exercise (Applied)
# 10
# (a)
# Only year and volume have some relationship.
attach(Weekly)
summary(Weekly)
plot_heatmap(cor(Weekly[, -9]))


# (b)
# Only Lag2
glm.fit = glm(Direction~Lag1+Lag2+Lag3+Lag4+Lag5+Volume, data=Weekly, family=binomial)
summary(glm.fit)

# (c)
# generate an overwhelming number of ups
glm.probs = predict(glm.fit, type="response")
glm.pred = rep("Down", length(glm.probs))
glm.pred[glm.probs > 0.5] = "Up"
table(glm.pred, Direction)

# (d)
mask = (Year < 2009)
Weekly.test = Weekly[!mask, ]
glm.fit = glm(Direction~Lag2, data=Weekly, family=binomial, subset=mask)
glm.probs = predict(glm.fit, Weekly.test, type="response")
glm.pred = rep("Down", length(glm.probs))
glm.pred[glm.probs > 0.5] = "Up"
Direction.test = Direction[!mask]
table(glm.pred, Direction.test)

# (e)
lda.fit = lda(Direction~Lag2, data=Weekly, family=binomial, subset=mask)
lda.pred = predict(lda.fit, Weekly.test)
table(lda.pred$class, Direction.test)

# (f) 
qda.fit = qda(Direction~Lag2, data=Weekly, subset=mask)
qda.class = predict(qda.fit, Weekly.test)$class
table(qda.class, Direction.test)

# (g)
train.X = as.matrix(Lag2[mask])
test.X = as.matrix(Lag2[!mask])
train.Direction = Direction[mask]
set.seed(1)
knn.pred = knn(train.X, test.X, train.Direction, k = 1)
table(knn.pred, Direction.test)

# (h)
# Logistic and LDA.

# (i)
# Nah.

# 11.
# (a)
attach(Auto)
mpg01 = rep(0, length(mpg))
mpg01[mpg > median(mpg)] = 1
auto = data.frame(Auto, mpg01)

# (b)
# all of them
cormat = cor(auto[, -9])
plot_heatmap(cormat)

# (c)
train = (year %% 2 == 0)
test = !train
auto.train = auto[train,]
auto.test = auto[test,]
mpg01.test = mpg01[test]

# (d)
# 12.64%
lda.fit = lda(mpg01~cylinders+weight+displacement+horsepower,
              data=Auto, subset=train)
lda.pred = predict(lda.fit, auto.test)
table(lda.pred$class, mpg01.test)
mean(lda.pred$class != mpg01.test)

# (e)
# 13.19%
qda.fit = qda(mpg01~cylinders+weight+displacement+horsepower,
              data=Auto, subset=train)
qda.pred = predict(qda.fit, auto.test)
mean(qda.pred$class != mpg01.test)

# (f)
# 12.09%
glm.fit = glm(mpg01~cylinders+weight+displacement+horsepower,
              data=Auto,
              family=binomial,
              subset=train)
glm.probs = predict(glm.fit, auto.test, type="response")
glm.pred = rep(0, length(glm.probs))
glm.pred[glm.probs > 0.5] = 1
mean(glm.pred != mpg01.test)

# (g)
library(class)
train.X = cbind(cylinders, weight, displacement, horsepower)[train,]
test.X = cbind(cylinders, weight, displacement, horsepower)[test,]
train.mpg01 = mpg01[train]
set.seed(1)
# KNN(k=1)
# 15.38%
knn.pred = knn(train.X, test.X, train.mpg01, k=1)
mean(knn.pred != mpg01.test)
# KNN(k=3)
# 13.74%
knn.pred = knn(train.X, test.X, train.mpg01, k=3)
mean(knn.pred != mpg01.test)
# KNN(k=10)
# 16.48%
knn.pred = knn(train.X, test.X, train.mpg01, k=10)
mean(knn.pred != mpg01.test)

# 12.
# (a)
power <- function(){
  print(2^3)
}

# (b)
power2 <- function(x, a){
  print(x^a)
}

# (c)
# 1000, 2.25e15, 2248091

# (d)
power3 <- function(x, a){
  return(x^a)
}

# (e)
x = 1:10
plot(x, power3(x, 2), log = "xy", ylab = "Log of y = x^2", xlab = "Log of x", 
     main = "Log of x^2 versus Log of x")

# (f)
plotpower <- function(x, a) {
  plot(x, power3(x, a))
}

# 13.
# Repetitive.