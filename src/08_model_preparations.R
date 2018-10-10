# load input data
library(caret)

# split the 26 plots into 7 parts based on location
folds <- list(Fold1 = as.integer(c(1,8,9,16)),
              Fold2 = as.integer(c(18,22,6)),
              Fold3 = as.integer(c(21,3,17,19)),
              Fold4 = as.integer(c(20,25,4,5)),
              Fold5 = as.integer(c(13,11,24,26)),
              Fold6 = as.integer(c(23,2,10)),
              Fold7 = as.integer(c(15,7,14,12)))

#all_plots <- seq(26)



model_folds <- lapply(seq(length(folds)), function(f){
  # keep one fold out from training
  indep_valid <- folds[[f]]
  # keep six folds for the cv and ffs
  # create training indices out of the remaining folds
  model_folds <- folds
  model_folds[[f]] <- NULL
  
  train_folds <- lapply(model_folds, function(m){
    seq(26)[!seq(26) %in% c(indep_valid, m)]
  })
  
  # create train control with the remaining six folds
  control <- caret::trainControl("cv", index = train_folds, indexFinal = NULL, savePredictions = FALSE)
  return(list(train_control = control,
              indep_valid = indep_valid))
  
})

