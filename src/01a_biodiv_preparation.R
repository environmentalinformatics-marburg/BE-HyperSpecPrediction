# Set path ---------------------------------------------------------------------
source("~/ma/BE-HyperSpecPrediction/src/00_set_environment.R")

# vegetation species records 2008 - 2016
vegrel0816 <- readBExpVegReleves(paste0(path$releves, "19686_releves_08_16.txt"))
vegrel0816_div <- compSpecRichBExpVegReleves(vegrel0816)

vegrel0816$Useful_EP_PlotID <- NULL

# cover data for 2014 and 2015
vegrel09 <- data.table::fread(paste0(path$releves, "6340_releves_2009.txt"))
vegrel09$EPID <- as.character(vegrel09$EP_PlotID)
vegrel09$EPID[nchar(vegrel09$EPID) == 4] <- paste0(substr(vegrel09$EPID[nchar(vegrel09$EPID) == 4], 1, 3), "0",
                                                   substr(vegrel09$EPID[nchar(vegrel09$EPID) == 4], 4, 4))
vegrel09$year <- 2009
vegrel09$EP_PlotID <- NULL

vegrel14 <- readBExpVegReleves(paste0(path$releves, "19807_releves_2014.txt"))
vegrel15 <- readBExpVegReleves(paste0(path$releves, "19809_releves_2015.txt"))

vegrel0616 <- read.csv(paste0(path$releves, "Vegetation_Header_Data_2008-2016.csv"), sep = ";", dec = ",")
vegrel0616$EpPlotID <- NULL
names(vegrel0616)[1] <- "EPID"


# biomass
biomass <- data.table::fread(paste0(path$releves, "16786_biomass_2013.txt"))
biomass$EPID <- as.character(biomass$EpPlotID)
biomass$EPID[nchar(biomass$EPID) == 4] <- paste0(substr(biomass$EPID[nchar(biomass$EPID) == 4], 1, 3), "0",
                                                   substr(biomass$EPID[nchar(biomass$EPID) == 4], 4, 4))
biomass$EpPlotID <- NULL

# traits
traits <- read.csv(paste0(path$releves, "traits_14_15.csv"))
traits$EPID <- as.character(traits$EP_PlotID)
traits$EPID[nchar(traits$EPID) == 4] <- paste0(substr(traits$EPID[nchar(traits$EPID) == 4], 1, 3), "0",
                                                 substr(traits$EPID[nchar(traits$EPID) == 4], 4, 4))
traits$EP_PlotID <- NULL
traits$X <- NULL
traits14 <- traits[traits$Year == 2014,]
traits15 <- traits[traits$Year == 2015,]


# LUI
lui <- readBExpLUI(paste0(path$lui, "LUI_glob_sep_22.02.2018+224004.txt"))
lui$Std_procedure.exploratory. <- NULL


# save cleaned data
saveRDS(vegrel0816, paste0(path$rdata, "veg_species.RDS"))
saveRDS(vegrel0816_div, paste0(path$rdata, "veg_diversity.RDS"))
saveRDS(vegrel0616, paste0(path$rdata, "veg_cover.RDS"))
saveRDS(vegrel09, paste0(path$rdata, "veg_cover_09.RDS"))
saveRDS(vegrel14, paste0(path$rdata, "veg_cover_14.RDS"))
saveRDS(vegrel15, paste0(path$rdata, "veg_cover_15.RDS"))
saveRDS(biomass, paste0(path$rdata, "biomass_13.RDS"))
saveRDS(traits14, paste0(path$rdata , "traits_14.RDS"))
saveRDS(traits15, paste0(path$rdata , "traits_15.RDS"))
saveRDS(lui, paste0(path$rdata, "lui.RDS"))


# # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # #