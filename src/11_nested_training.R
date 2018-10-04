# nested ffs
# order: nri, single, vegind

# load model functions
source("F:/ma/BE-HyperSpecPrediction/src/09a_independent_fold_training.R")
source("F:/ma/BE-HyperSpecPrediction/src/08_model_preparations.R")

targets <- readRDS("F:/ma/data/finished_df/targets.RDS")


# choose target
t <- "height"

# # # # # # # # #
# load selected variables
sv <- lapply(list.files(paste0("F:/ma/data/results/", t), pattern = "selvar", full.names = TRUE), readRDS)
#sv[[1]] <- sv[[1]][[1]]

all_sel <- do.call(rbind, sv)
uni_sel <- as.character(na.omit(unique(as.vector(as.matrix(all_sel[,1:7])))))

# list of all predictors
all_pred <- list(readRDS("F:/ma/data/finished_df/narrow_bands.RDS"),
                 readRDS("F:/ma/data/finished_df/single_bands.RDS"),
                 readRDS("F:/ma/data/finished_df/vegindices.RDS"))


# create new predictor data frame
sel_pred <- lapply(all_pred, function(x){
  return(x[,which(colnames(x) %in% uni_sel)])
})
sel_pred <- do.call(cbind, sel_pred)



# train with all variables
mod_train <- indep_fold_train(model_folds, pred = sel_pred, target = targets[,which(colnames(targets) == t)])
saveRDS(mod_train, "F:/ma/data/models/height_nested_train.RDS")

mod_ffs <- indep_fold_ffs(model_folds, pred = sel_pred, target = targets[,which(colnames(targets) == t)])
saveRDS(mod_ffs, "F:/ma/data/models/height_nested_ffs.RDS")
