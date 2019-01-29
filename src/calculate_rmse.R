# model validation based on all exploratories

library(Metrics)
library(reshape2)
library(ggplot2)
source("/home/marvin/repositories/envimaR/R/getEnvi.R")

p <- getEnvi("/home/marvin/be_hyperspectral/data/")


res <- readRDS(paste0(p$results$here, "trait_prediction.RDS"))

# include which exploratory it is
res$EP <- substr(res$EPID, 1,1)
res <- na.omit(res)


# statements
traits <- as.character(unique(res$target))
ep <- c("A", "H", "S")

statements <- expand.grid(traits, ep)
i <- 1
rmse_all <- lapply(seq(nrow(statements)), function(i){
  t <- res$target == statements[i,1]
  e <- res$EP == statements[i,2]
  
  all_folds <- lapply(seq(3,9), function(j){
    data.frame(EP = statements[i,2],
               fold = colnames(res)[j],
               trait = statements[i,1],
               RMSE = rmse(actual = res[t & e,]$observation, predicted = res[t & e,j]))
   
  })
  do.call(rbind, all_folds)
})

rmse_df <- do.call(rbind, rmse_all)

saveRDS(rmse_df, paste0(p$results$here, "ep_rmse.RDS"))







