LoadLibraries()

# Practice
fix(Hitters)
attach(Hitters)

sum(is.na(Hitters$Salary))

Hitters = na.omit(Hitters)

library(leaps)
regfit.full = regsubsets(Salary~., Hitters)
summary(regfit.full)

regfit.full = regsubsets(Salary~., data=Hitters, nvmax=19)
reg.summary = summary(regfit.full)
names(reg.summary)

par(mfrow =c(2,2))
plot(reg.summary$rss ,xlab=" Number of Variables ",ylab=" RSS", type="l")


plot(reg.summary$adjr2 ,xlab =" Number of Variables ", ylab=" Adjusted RSq",type="l")
which.max(reg.summary$adjr2)
points(11, reg.summary$adjr2[11], col="red", cex=2, pch=20)

plot(reg.summary$cp ,xlab =" Number of Variables ",ylab="Cp",type="l")
which.min(reg.summary$cp)
points(10, reg.summary$cp[10], col ="red", cex =2, pch =20)

plot(reg.summary$bic ,xlab=" Number of Variables ",ylab=" BIC", type="l")
which.min(reg.summary$bic)
points(6, reg.summary$bic[6], col =" red", cex =2, pch =20)

plot(regfit.full ,scale ="r2")
plot(regfit.full ,scale ="adjr2")
plot(regfit.full, scale ="Cp")
plot(regfit.full, scale ="bic")


regfit.fwd = regsubsets(Salary~., data=Hitters, nvmax =19, method ="forward")
summary(regfit.fwd)

regfit.fwd = regsubsets(Salary~., data=Hitters, nvmax =19, method ="backward")
summary(regfit.fwd)

# 6.5.3
set.seed(1)
train = sample(c(TRUE, FALSE), nrow(Hitters), rep=TRUE)
test = (!train)

regfit.best = regsubsets(Salary~., data=Hitters[train,], nvmax=19)
test.mat = model.matrix(Salary~., data=Hitters[test,])


val.erroes = rep(NA, 19)
for(i in 1:19){
  coefi = coef(regfit.best, id=i)
  pred = test.mat[, names(coefi)] %*% coefi
  val.errors[i] = mean((Hitters$Salary[test] - pred)^2)
}
# pass due to loose memory

# Ridge and Lasso
Hitters =na.omit(Hitters)
x = model.matrix(Salary~., Hitters)[, -1]
y = Hitters$Salary

library(glmnet)
grid = 10^seq(10, -2, length = 100)
rigde.mod = glmnet(x, y, alpha=0, lambda=grid)

set.seed(1)
train = sample(1:nrow(x), nrow(x)/2)
test = (-train)
y.test = y[test]

ridge.mod =glmnet(x[train, ], y[train], alpha =0, lambda=grid, thresh =1e-12)
ridge.pred = predict(ridge.mod, s=4, newx=x[test, ])
mean((ridge.pred - y.test)^2)

set.seed(1)
cv.out = cv.glmnet(x[train, ], y[train], alpha=0)
plot(cv.out)

cv.out$lambda.min

out = glmnet(x, y, alpha=0)
predict(out ,type="coefficients", s=cv.out$lambda.min)[1:20, ]

lasso.mod = glmnet(x, y, alpha=1, lambda=grid)
cv.out = cv.glmnet(x[train, ], y[train], alpha=0)
plot(cv.out)

out = glmnet(x, y, alpha=1, lambda=grid)
predict(out ,type="coefficients", s=cv.out$lambda.min)[1:20, ]

# pcr and pls
library(pls)
