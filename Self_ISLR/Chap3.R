# Load all library needed (like python $load magic)
LoadLibraries=function (){
library (ISLR)
library (MASS)
source('E:/OneDrive/Github/R/Libs/plot_libs.R')
print (" The libraries and functions have been loaded .")}

# Load library
LoadLibraries()

# 8 
# (a)
# (1) - There is a relationship from F score and t-test.
lm.fit = lm(mpg~horsepower, data=Auto)
summary(lm.fit)
# (2) - 60% is explained. 
summary(lm.fit)$r.sq 
# (3) - Negative.
# (4) - 
predict(lm.fit, data.frame(horsepower=c(98)), interval="confidence")
predict(lm.fit, data.frame(horsepower=c(98)), interval="prediction")

# (b)
attach(Auto)
plot(horsepower, mpg)
abline(lm.fit)

# (c) - Nonlinear
par(mfrow=c(2,2))
plot(lm.fit)

# 9
# (a) - (b)
summary(Auto)
plot_heatmap(cor(subset(Auto, select=-name)))

# (c)
lm.fit = lm(mpg~.-name, data=Auto)
summary(lm.fit)
# (1) - Yes
# (2) - displacement, weight, year, origin.
# (3) - The newer the higher mpg.

# (d) - There are outliers as well as high leverage points.
# (1, 1) shows a bit of U-shape which suggests some Nonliearity in the data;
# (1, 2) shows the same as the previous;
# (2, 1) shows several outliers that inlcudes 3230 and 320 (value over 1.732);
# (2, 2) shows point 14 has higher leveage than others.
par(mfrow=c(2,2))
plot(lm.fit)

# (e)
# displacement:weight
lm.fit = lm(mpg~cylinders*displacement+displacement*weight, data=Auto)
summary(lm.fit)

# (f)
# weight^2 + cylinders are nice.
lm.fit = lm(mpg~I(weight^2)+I(displacement^2)+log(cylinders), data=Auto)
summary(lm.fit)

# 10
# (a)
lm.fit = lm(Sales~Price+Urban+US)
summary(lm.fit)

# (b)
# Price and US is a good predictor while Urban is Not

# (c)
# Sales = 13.04 - 0.054 * Price - 0.022 * Urban + 1.2 * US

# (d)
# Price and US

# (e)
lm.fit = lm(Sales~Price+US)
summary(lm.fit)

# (f)
# R^2 score increased and RSE decreased for (e) and therefore is better.

# (g)
confint(lm.fit)

# (h)
# NO.
plot(predict(lm.fit), rstudent(lm.fit))
par(mfrow=c(2,2))
plot(lm.fit)


# 11
# (a)
# The null hypothesis is rejected.
set.seed(1)
x = rNorm(100)
y = 2*x + rNorm(100)
lm.fit = lm(y ~ x + 0)
summary(lm.fit)

# (b)
# Same.
lm.fit=lm(x ~ y + 0)
summary(lm.fit)

# (c)
# Theoritically the coefficients should have a product of 1.

# (d)
# See Notes

# (e)
# Obviously ...

# (f)
lm.fit = lm(y~x)
summary(lm.fit)
lm.fit = lm(x~y) 
summary(lm.fit)

# 12
# (a)
# When \sum_{i=1}^{n} x_i = \sum_{i=1}^{n} y_i

# (b)
set.seed(1)
x = rNorm(100)
y = 2 * x 
lm.fit = lm(y ~ x + 0)
lm.fit = lm(x ~ y + 0)
summary(lm.fit)
summary(lm.fit)

# (c)
y = x # This is just a trivial case.

# 13
# (a)
set.seed(1)
x = rNorm(100)

# (b)
eps = rNorm(100, 0, 0.25)

# (c)
y = rep(-1, 100) + 0.5 * x  + eps # 100; -1; 0.5.

# (d)
plot(x, y) # A linear relation with some Noise

# (e)
lm.fit1 = lm(y ~ x)
summary(lm.fit) # Pretty good

# (f)
plot(x, y)
abline(lm.fit, col=2)
abline(-1, 0.5, col=3)
legend(-1, legend = c("model fit", "pop. regression"), col=2:3, lwd=3)

# (g)
lm.fit2 = lm(y ~ x+I(x^2))
summary(lm.fit) # Yes. However from the t-value we argue that x^2 term is redundant.

# (h)
set.seed(1)
eps = rNorm(100, 0, 0.125)
x = rNorm(100)
y = -1 + 0.5*x + eps
plot(x, y)
lm.fit3 = lm(y~x)
summary(lm.fit) # RSE is lower.
abline(lm.fit1, lwd=3, col=2)
abline(-1, 0.5, lwd=3, col=3)
legend(-1, legend = c("model fit", "pop. regression"), col=2:3, lwd=3)

# (j)
# 3 < 1 < 2
confint(lm.fit1)
confint(lm.fit2)
confint(lm.fit3)

# 14
# (a)
set.seed(1)
x1 = runif(100) # uniform
x2 = 0.5 * x1 + rNorm(100)/10
y = 2 + 2*x1 + 0.3*x2 + rNorm(100) # 2, 2, 0.3.

# (b)
# Linear
plot(x1, x2)

# (c)
# Does Not seems to be a good fit.
# \beta_0 retains, \beta_1 retains, \beta_2 rejects.
lm.fit1 = lm(y ~ x1 + x2)
summary(lm.fit1) 

# (d)
lm.fit2 = lm(y ~ x1)
summary(lm.fit2) # No.

# (e)
lm.fit3 = lm(y ~ x2)
summary(lm.fit3) # No.

# (f)
# This is about colinearity. Although in this case it does increase RSE and 
# R^2 by a litter bit, this is generally Not a good thing.

# (g)
# Interestingly, the two points added reduce significance of x1 and increase
# that of x2. Also Notice that y = 6 which means it is an outlier especially 
# for the case where x1 serves as the sole predictor (which is shown by the
# drastic change of stats). For the reset two models it is definitely a
# high leverage point but does Not affect the model that seriously. The 
# fact that only lm.fit2(with x1) shows 101 on every graph also illustrates 
# this point.
x1=c(x1 , 0.1)
x2=c(x2 , 0.8)
y=c(y,6)


lm.fit1 = lm(y ~ x1 + x2)
summary(lm.fit1) 


lm.fit2 = lm(y ~ x1)
summary(lm.fit2) 


lm.fit3 = lm(y ~ x2)
summary(lm.fit3) 

par(mfrow=c(2,2))
plot(lm.fit1)

# 15
# (a)
Boston$chas <- factor(Boston$chas, labels = c("N","Y"))
summary(Boston)
attach(Boston)
lm.zn = lm(crim~zn)
summary(lm.zn) # Yes
lm.indus = lm(crim~indus)
summary(lm.indus) # Yes
lm.chas = lm(crim~chas) 
summary(lm.chas) # No
lm.Nox = lm(crim~Nox)
summary(lm.Nox) # Yes
lm.rm = lm(crim~rm)
summary(lm.rm) # Yes
lm.age = lm(crim~age)
summary(lm.age) # Yes
lm.dis = lm(crim~dis)
summary(lm.dis) # Yes
lm.rad = lm(crim~rad)
summary(lm.rad) # Yes
lm.tax = lm(crim~tax)
summary(lm.tax) # Yes
lm.ptratio = lm(crim~ptratio)
summary(lm.ptratio) # Yes
lm.black = lm(crim~black)
summary(lm.black) # Yes
lm.lstat = lm(crim~lstat)
summary(lm.lstat) # Yes
lm.medv = lm(crim~medv)
summary(lm.medv) # Yes

# (b)
# A lot of values seems redundant.
# Rejects zn, dis, rad, black, medv
# The overall RSE is reduced and R^2
# score improved as expected.
lm.all = lm(crim~., data=Boston)
summary(lm.all)

# (c)
# the nox predictor is off.
x = c(coefficients(lm.zn)[2],
      coefficients(lm.indus)[2],
      coefficients(lm.chas)[2],
      coefficients(lm.nox)[2],
      coefficients(lm.rm)[2],
      coefficients(lm.age)[2],
      coefficients(lm.dis)[2],
      coefficients(lm.rad)[2],
      coefficients(lm.tax)[2],
      coefficients(lm.ptratio)[2],
      coefficients(lm.black)[2],
      coefficients(lm.lstat)[2],
      coefficients(lm.medv)[2])
y = coefficients(lm.all)[2:14]
plot(x, y)

# (d)
lm.zn = lm(crim~poly(zn,3))
summary(lm.zn) # 1, 2
lm.indus = lm(crim~poly(indus,3))
summary(lm.indus) # 1, 2, 3
# lm.chas = lm(crim~poly(chas,3)) : qualitative predictor
lm.nox = lm(crim~poly(nox,3))
summary(lm.nox) # 1, 2, 3
lm.rm = lm(crim~poly(rm,3))
summary(lm.rm) # 1, 2
lm.age = lm(crim~poly(age,3))
summary(lm.age) # 1, 2, 3
lm.dis = lm(crim~poly(dis,3))
summary(lm.dis) # 1, 2, 3
lm.rad = lm(crim~poly(rad,3))
summary(lm.rad) # 1, 2
lm.tax = lm(crim~poly(tax,3))
summary(lm.tax) # 1, 2
lm.ptratio = lm(crim~poly(ptratio,3))
summary(lm.ptratio) # 1, 2, 3
lm.black = lm(crim~poly(black,3))
summary(lm.black) # 1
lm.lstat = lm(crim~poly(lstat,3))
summary(lm.lstat) # 1, 2
lm.medv = lm(crim~poly(medv,3))
summary(lm.medv) # 1, 2, 3

