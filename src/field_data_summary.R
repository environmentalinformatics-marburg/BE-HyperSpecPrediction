# prepare target validation set
source("D:/ludwig/be/BE-HyperSpecPrediction/src/set_environment.R")

# load hyperspectral locations

hy <- readRDS(paste0(p$aerial_summary$here, "alb_model_variables.RDS"))


# load field data
traits15 <- readRDS(paste0(p$field_data$here, "traits_15.RDS"))
vegcover <- readRDS(paste0(p$field_data$here, "veg_cover.RDS"))

vegcover <- vegcover[vegcover$Year == 2015,c("EPID", "biomass_g", "nr_sp", "evenness", "shannon")]
vegcover$EPID <- as.character(vegcover$EPID)

targets <- join(traits15, vegcover, by = "EPID")
targets$Region <- NULL
targets$Year <- NULL
targets$speciesrichness <- NULL
targets <- targets[,c(9, 1:8,10:13)]



# filter the plots and clean up the factors
t <- targets[targets$EPID %in% hy$EPID,]
t <- t[order(t$EPID),]
t$EPID  <- as.factor(t$EPID)

saveRDS(t, paste0(p$field_data$here, "targets.RDS"))
