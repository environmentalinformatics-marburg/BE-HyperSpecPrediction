library(caret)
library(CAST)
library(pls)
library(doParallel)


dat <- join(predictors, targets[,c(1,20)], by = "EPID")
dat$EPID <- NULL

set.seed(100)
folds <- caret::createDataPartition(y = dat$SLA, times = 5, p = 0.8, list = TRUE)
folds <- createFolds(y = dat$SLA, k = 7, list = TRUE)
?trainControl

control <- trainControl("cv", index = folds, indexFinal = NULL, returnResamp = "all", savePredictions = TRUE)

cl <- 
ffs1 <- ffs(predictors = dat[,1:10], response = dat$SLA,
    method = "pls",
    metric = "RMSE",
    tuneLength = 10,
    trControl = control,
    preProc = c("center", "scale"),
    allowParallel = FALSE)

plot_ffs(ffs1)

# model without ffs


set.seed(100)
folds <- caret::createDataPartition(y = dat$SLA, times = 5, p = 0.8, list = TRUE)
control <- trainControl("repeatedcv", index = folds, indexFinal = NULL)

mod1 <- caret::train(SLA ~ ., data = dat,
              method = "pls",
              metric = "RMSE",
              tuneLength = 5,
              trControl = control,
              preProc = c("center", "scale"))
plot(mod1)

predict(mod1, newdata = dat[,1:116])
summary(mod1)
