# nested ffs
# order: nri, single, vegind

# load model functions
source("~/ma/BE-HyperSpecPrediction/src/09a_independent_fold_training.R")
source("~/ma/BE-HyperSpecPrediction/src/08_model_preparations.R")

targets <- readRDS("~/ma/data/finished_df/targets.RDS")


# choose target
t <- "nr_sp"

# # # # # # # # #
# load selected variables
sv <- lapply(list.files(paste0("~/ma/data/results/", t), pattern = "selvar", full.names = TRUE), readRDS)
sv[[1]] <- sv[[1]][[1]]

all_sel <- do.call(rbind, sv)
uni_sel <- as.character(na.omit(unique(as.vector(as.matrix(all_sel[,1:7])))))

# list of all predictors
all_pred <- list(readRDS("~/ma/data/finished_df/narrow_bands.RDS"),
                 readRDS("~/ma/data/finished_df/single_bands.RDS"),
                 readRDS("~/ma/data/finished_df/vegindices.RDS"))


# create new predictor data frame
sel_pred <- lapply(all_pred, function(x){
  return(x[,which(colnames(x) %in% uni_sel)])
})
sel_pred <- do.call(cbind, sel_pred)



# train with all variables
mod_train <- indep_fold_train(model_folds, pred = sel_pred, target = targets[,which(colnames(targets) == t)])
saveRDS(mod_train, "~/ma/data/models/nr_sp_nested_train.RDS")

mod_ffs <- indep_fold_ffs(model_folds, pred = sel_pred, target = targets[,which(colnames(targets) == t)])
saveRDS(mod_ffs, "~/ma/data/models/leaf_area/leaf_area_nested_ffs.RDS")
mod_ffs$errors/mean(targets$leaf_area)

mod_train$errors / mod_ffs$errors


