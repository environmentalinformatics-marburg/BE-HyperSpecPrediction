# load input data
library(caret)

# split the 26 plots into 7 parts based on location
folds <- list(Fold1 = c(1,8,9,16),
              Fold2 = c(18,22,6),
              Fold3 = c(21,3,17,19),
              Fold4 = c(20,25,4,5),
              Fold5 = c(13,11,24,26),
              Fold6 = c(23,2,10),
              Fold7 = c(15,7,14,12))


ffs_preparations <- lapply(seq(length(folds)), function(f){
  # keep one fold out from training
  indep_valid <- folds[[f]]
  # keep six folds for the cv and ffs
  model_folds <- folds
  model_folds[[f]] <- NULL
  
  # create train control with the remaining six folds
  control <- caret::trainControl("cv", indexOut = model_folds, indexFinal = NULL,
                                 returnResamp = "all", savePredictions = TRUE)
  return(list(train_control = control,
              indep_valid = indep_valid))
  
})

