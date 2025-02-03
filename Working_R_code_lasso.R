library(tidyverse)
library(magrittr)
library(glmnet)
library(pROC)

#I do not know why the no of rows in X does not match no of observations in y
#decided to delete the first one just to make it work
x_cont <- as.matrix(x)[-1,]
y_cont <- as.matrix(y)


x_cont <- as.matrix(x_cont)
y_cont <- as.matrix(y_cont)

## Perform ridge regression
ridge1 <- glmnet(x = x_cont, y = y_cont,
                 ## ‘alpha = 1’ is the lasso penalty, and ‘alpha = 0’ the ridge penalty.
                 alpha = 0)
plot(ridge1, xvar = "lambda")

## Perform ridge regression with 10-fold CV
ridge1_cv <- cv.glmnet(x = x, y = y_cont,
                       ## type.measure: loss to use for cross-validation.
                       type.measure = "mse",
                       ## K = 10 is the default.
                       nfold = 10,
                       ## ‘alpha = 1’ is the lasso penalty, and ‘alpha = 0’ the ridge penalty.
                       alpha = 0)
## Penalty vs CV MSE plot
plot(ridge1_cv)

#Lasso
lasso<- glmnet(x = x_cont,y = y_cont,alpha = 1)
plot(lasso, xvar = "lambda")
cvres_lasso<-cv.glmnet(x = x_cont,y = y_cont,alpha = 1)
coefficients(cvres_lasso)
plot(cvres_lasso, xvar = "lambda")



#Alasso
ridge1_cv <- cv.glmnet(x = x_cont, y = y_cont,
                       ## type.measure: loss to use for cross-validation.
                       type.measure = "mse",
                       ## K = 10 is the default.
                       nfold = 10,
                       ## ‘alpha = 1’ is the lasso penalty, and ‘alpha = 0’ the ridge penalty.
                       alpha = 0)
best_ridge <- abs(as.numeric(coef(ridge1_cv, s = ridge1_cv$lambda.min)))

alasso <- glmnet(x = x_cont, y = y_cont, alpha=1,
                  penalty.factor=1/best_ridge[-1])
plot(alasso, xvar = "lambda")


alasso_cv <- cv.glmnet(x = x_cont, y = y_cont, alpha=1,
                 penalty.factor=1/best_ridge[-1])
plot(alasso_cv)
#Coefficients of A lasso look strange!!!!
coef(alasso_cv)
