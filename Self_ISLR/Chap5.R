# Load all library needed (like python $load magic)
LoadLibraries=function (){
library (ISLR)
library (MASS)
library (boot)
library (class)
source('E:/OneDrive/Github/R/Libs/plot_libs.R')
print (" The libraries and functions have been loaded .")}

# Load library
LoadLibraries()

# Practice 
set.seed(1)
attach(Auto)
train = sample(392, 196)

# linear
lm.fit = lm(mpg~horsepower, data=Auto, subset=train)
mean((mpg-predict(lm.fit, Auto))[-train]^2)

# Poly
lm.fit = lm(mpg~poly(horsepower, 2), data=Auto, subset=train)
mean((mpg-predict(lm.fit, Auto))[-train]^2)

lm.fit = lm(mpg~poly(horsepower, 3), data=Auto, subset=train)
mean((mpg-predict(lm.fit, Auto))[-train]^2)

# LOOCV
glm.fit = glm(mpg~horsepower, data=Auto)
cv.err = cv.glm(Auto, glm.fit)
cv.err$delta

cv.error = rep(0, 5)
for (i in 1:5){
  glm.fit = glm(mpg~poly(horsepower, i), data=Auto)
  cv.error[i] = cv.glm(Auto, glm.fit)$delta[1]
}
cv.error

# K-Fold
set.seed(17)
cv.error.10 = rep(0, 10)
for (i in 1:10){
  glm.fit = glm(mpg~poly(horsepower, i), data=Auto)
  cv.error.10[i] = cv.glm(Auto, glm.fit, K=10)$delta[1]
}
cv.error.10

# The bootstrap
alpha.fn <- function(data, index) {
  X = data$X[index]
  Y = data$Y[index]
  return ((var(Y)-cov (X,Y))/(var(X)+var(Y) -2* cov(X,Y)))
}

alpha.fn(Portfolio ,1:100)
set.seed(1)
alpha.fn(Portfolio, sample(100, 100, replace=T))

# use boot
boot(Portfolio, alpha.fn, R=1000)

boot.fn <- function(data, index){
  return (coef(lm(mpg~horsepower ,data=data ,subset =index)))
}

boot(Auto, boot.fn, 1000)

# poly
boot.fn=function (data, index){
  coefficients(lm(mpg~horsepower +I(horsepower^2), data=data,
                  subset=index))
}
set.seed(1)
boot(Auto, boot.fn, 1000)

# Conceptual
# 2.
# (h)
store = rep(NA, 10000)
for(i in 1:10000){
  store [i] = sum(sample(1:100, rep=TRUE) == 4) > 0
}
mean(store)

# Applied
# 5.
# (a)
attach(Default)
set.seed(1)
glm.fit = glm(default~income+balance, data=Default, family=binomial)

# (b)
train = sample(10000, 5000)
glm.fit = glm(default~income+balance, data=Default, family=binomial, subset=train)
glm.pred = rep("No", 5000)
glm.probs = predict(glm.fit, Default[-train,], type="response")
glm.pred[glm.probs > .5] = "Yes"
mean(glm.pred != Default[-train,]$default)
 
# (c)
# It's random so just run it 3 times

# (d)
# Larger, not useful
glm.fit = glm(default~income+balance+student, data=Default, family=binomial, subset=train)
glm.pred = rep("No", 5000)
glm.probs = predict(glm.fit, Default[-train,], type="response")
glm.pred[glm.probs > .5] = "Yes"
mean(glm.pred != Default[-train,]$default)

# 6.
# (a)
set.seed(1)
glm.fit = glm(default~income+balance, data=Default, family=binomial)
summary(glm.fit)

# (b)
boot.fn = function(data, index){
  return(coef(glm(default~income+balance, data=data, family=binomial, subset=index)))  
}

# (c)
boot(Default, boot.fn, 50)

# (d)
# Very close.

# 7.
# (a)
attach(Weekly)
set.seed(1)
glm.fit = glm(Direction~Lag1+Lag2, data=Weekly, family=binomial)

# (b)
train = 2:1089
glm.fit = glm(Direction~Lag1+Lag2, data=Weekly[-1, ], family=binomial)

# (c)
# No
prob = predict(glm.fit, Weekly[1, ], type="response")
pred = "Up"
print(probs == Weekly$Direction[1])

# (d)
count = rep(0, dim(Weekly)[1])
for(i in 1:(dim(Weekly)[1])){
  glm.fit = glm(Direction~Lag1+Lag2, data=Weekly[-i, ], family=binomial)
  up = predict.glm(glm.fit, Weekly[i, ], type="response") > 0.5
  true_up = Weekly[i, ]$Direction == "Up"
  if (up != true_up) 
    count[i] = 1
}

sum(count)

# (e)
mean(count)

# 8
# (a)
# n = 100, p = 3
set.seed(2)
y=rnorm(100)
x=rnorm(100)
y=x-2 * x^2 + rnorm(100)

# (b)
# A quadratic shape 
plot(x, y)

# (c)
Data = data.frame(x, y)

# i
glm.fit = glm(y~x)
cv.glm(Data, glm.fit)$delta

# ii 
glm.fit = glm(y~poly(x, 2))
cv.glm(Data, glm.fit)$delta

# iii
glm.fit = glm(y~poly(x, 3))
cv.glm(Data, glm.fit)$delta

# iv
glm.fit = glm(y~poly(x, 4))
cv.glm(Data, glm.fit)$delta

# (d)
# set.seed(2)
# Nope.

# (e)
# Quadratic.

# (f)
# t-test shows that 3 and 4 order not necessary.
summary(glm.fit)

# 9
set.seed(1)
attach(Boston)

# (a)
mu = mean(medv)

# (b)
se.mu = sd(medv)/sqrt(length(medv))

# (c)
# Almost the same
boot.fn = function(data, index) return(mean(data[index]))
library(boot)
bstrap = boot(medv, boot.fn, 1000)
bstrap

# (d)
# pretty close
t.test(medv)
c(bstrap$t0 - 2 * 0.4119, bstrap$t0 + 2 * 0.4119)

# (e)
mu.med = median(medv)

# (f)
# Same as sample median
boot.fn = function(data, index) return(median(data[index]))
bstrap.med = boot(medv, boot.fn, 1000)
bstrap.med

# (g)
# Also pretty close
mu_0.1 = quantile(medv, c(0.1))
boot.fn = function(data, index) return(quantile(data[index], c(0.1)))
bstrap.0.1 = boot(medv, boot.fn, 1000)
bstrap.0.1
