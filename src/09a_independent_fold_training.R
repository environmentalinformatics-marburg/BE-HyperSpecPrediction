# function for training the model for every fold left out

indep_fold_train <- function(model_runs, pred, target){
  indep_valid <- lapply(model_runs, function(p){
    model <- caret::train(x = pred, y = target,
                          method = "pls",
                          metric = "RMSE",
                          tuneLength = 5,
                          trControl = p[[1]],
                          preProc = c("center", "scale", "zv"))
    indep_pred <- predict(model, newdata = pred[p[[2]],])
    error <- RMSE(pred = indep_pred, obs = target[p[[2]]])
    
    return(list(model = model,
                indep_pred = indep_pred,
                error = error))
  })
  error <- lapply(indep_valid, "[[", 3)
  return(list(models = indep_valid,
              errors = do.call(c, error)))
  
}

indep_fold_ffs <- function(model_runs, pred, target){
  indep_valid <- lapply(model_runs, function(p){
    model <- CAST::ffs(predictors = pred, response = target,
                       method = "pls",
                       metric = "RMSE",
                       tuneLength = 5,
                       trControl = p[[1]],
                       preProc = c("center", "scale", "zv"),
                       withinSE = FALSE)
    indep_pred <- predict(model, newdata = pred[p[[2]],])
    error <- RMSE(pred = indep_pred, obs = target[p[[2]]])
    
    return(list(model = model,
                indep_pred = indep_pred,
                error = error))
  })
  error <- lapply(indep_valid, "[[", 3)
  return(list(models = indep_valid,
              errors = do.call(c, error)))
  
}

