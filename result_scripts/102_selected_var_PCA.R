# pca of vegetation indices
library(dplyr)
library(plyr)
library(reshape2)
library(ggplot2)
library(ggmosaic)
library(vegan)
library(ggbiplot)

sv <- lapply(list.files("~/ma/data/results/", pattern = "selvar_vegind", recursive = TRUE, full.names = TRUE), readRDS)
sv <- do.call(rbind, sv)
for(i in seq(7)){sv[,i] <- as.character(sv[,i])}

sv_trait <- reshape2::melt(sv, value = "target", measure.vars = seq(7))

# get rid of mean and sd
sv_trait$value <- unlist(lapply(strsplit(sv_trait$value, "_"), "[[", 1))
sv_trait <- na.omit(sv_trait)

# filter single vegetation indices
rare <- names(table(sv_trait$value)[table(sv_trait$value) < 2])
sv_trait <- subset(sv_trait, !value %in% rare)

# filter for leaf area, specific leaf area, leaf drymass and biomass 
#sv_trait <- subset(sv_trait, target %in% c("leaf_area", "SLA", "leaf_drymass", "biomass_g"))
#sv <- subset(sv, target %in% c("leaf_area", "SLA", "leaf_drymass", "biomass_g"))
# contingancy table of vegetation index and trait
sv_cont <- t(table(sv_trait$target, sv_trait$value))

pca_sv <- prcomp(sv_cont, scale = TRUE, center = TRUE)
pca_var <- as.data.frame(pca_sv$rotation)
pca_obs <- as.data.frame(pca_sv$x)

ggplot(pca_var, aes(PC1, PC2))+
  geom_point()+
  geom_point(data = pca_obs, aes(PC1, PC2), color = "red")


ggbiplot(pca_sv, labels = rownames(pca_sv$x), choices = 2:3)
ggbiplot


# FFS PCA
#---------------
sv <- lapply(list.files("~/ma/data/results/", pattern = "selvar_ffs", recursive = TRUE, full.names = TRUE), readRDS)
sv <- do.call(rbind, sv)
for(i in seq(7)){sv[,i] <- as.character(sv[,i])}

sv_trait <- reshape2::melt(sv, value = "target", measure.vars = seq(7))
sv_trait <- na.omit(sv_trait)
# categorize features
sv_trait$cat <- ""
sv_trait$cat[grep(pattern = "^mean", x = sv_trait$value)] <- "single"
sv_trait$cat[grep(pattern = "^sd", x = sv_trait$value)] <- "single"
sv_trait$cat[grep(pattern = "^mean_", x = sv_trait$value)] <- "nri"

sv_trait$cat[sv_trait$cat == ""] <- "vegind"

# filter single vegetation indices
rare <- names(table(sv_trait$value)[table(sv_trait$value) < 2])
sv_trait <- subset(sv_trait, !value %in% rare)

# contingancy table of vegetation index and trait
sv_cont <- t(table(sv_trait$target, sv_trait$value))

pca_sv <- prcomp(sv_cont, center = TRUE, scale = TRUE)
ggbiplot(pca_sv, labels = rownames(pca_sv$x), groups = pca_obs$cat)

pca_var <- as.data.frame(pca_sv$rotation)
pca_obs <- as.data.frame(pca_sv$x)

# categorize observations
pca_obs$cat <- ""
pca_obs$cat[grep(pattern = "^mean", x = rownames(pca_obs))] <- "single"
pca_obs$cat[grep(pattern = "^sd", x = rownames(pca_obs))] <- "single"
pca_obs$cat[grep(pattern = "^mean_", x = rownames(pca_obs))] <- "nri"

pca_obs$cat[pca_obs$cat == ""] <- "vegind"

# define nudge
pca_var$nudge <- 0
pca_var$nudge[pca_var$PC1 < 0] <- -0.25
pca_var$nudge[pca_var$PC1 > 0] <- 0.25

pca_var$nudge_y <- c(0,0,0.2,0,0,0,0,0,0,0,-0.2,0)

pdf("~/ma/data/visualization/pca_predictors.pdf", width = 8, height = 8)
ggplot(pca_var, aes(PC1, PC2))+
  geom_hline(yintercept = 0, alpha = 0.6)+
  geom_vline(xintercept = 0, alpha = 0.6)+
  geom_point(data = pca_obs, aes(PC1, PC2, color = cat), alpha = 0.9)+
  scale_color_discrete(name = "Predictor group")+
  geom_segment(data=pca_var, aes(x=0, y=0, xend=PC1*7, yend=PC2*7), alpha = 0.5, arrow = arrow(length = unit(.3,"cm")))+
  geom_text(data = pca_var, aes(PC1*7.2, PC2*7.2), label = rownames(pca_var),
            size = 3.5, nudge_x = pca_var$nudge, nudge_y = pca_var$nudge_y, fontface = "bold")+
  xlab(paste0("PC1 (", round(100 * pca_sv$sdev[1]^2/sum(pca_sv$sdev^2), digits = 1), "%)"))+
  ylab(paste0("PC2 (", round(100 * pca_sv$sdev[2]^2/sum(pca_sv$sdev^2), digits = 1), "%)"))+
  theme(panel.background = element_blank())+
  coord_cartesian(xlim = c(-4.5, 2.6), ylim = c(-2, 4))
dev.off()
  #coord_cartesian(xlim = c(-5,2.5), ylim = c(-2.5,2.5))







# single PCA
#---------------
sv <- lapply(list.files("~/ma/data/results/", pattern = "selvar_single", recursive = TRUE, full.names = TRUE), readRDS)
sv <- do.call(rbind, sv)
for(i in seq(7)){sv[,i] <- as.character(sv[,i])}

sv_trait <- reshape2::melt(sv, value = "target", measure.vars = seq(7))

# get rid of mean and sd

sv_trait$value <- gsub("[^0-9\\.]", "", sv_trait$value) 
sv_trait <- na.omit(sv_trait)

# filter single vegetation indices
rare <- names(table(sv_trait$value)[table(sv_trait$value) < 2])
sv_trait <- subset(sv_trait, !value %in% rare)
# aggregate the wavelengths to 20 nm ranges
sv_trait$value <- as.numeric(sv_trait$value)
sv_trait$value_round <- 25*round(sv_trait$value/25)


# filter for leaf area, specific leaf area, leaf drymass and biomass 
#sv_trait <- subset(sv_trait, target %in% c("leaf_area", "SLA", "leaf_drymass", "biomass_g"))
#sv <- subset(sv, target %in% c("leaf_area", "SLA", "leaf_drymass", "biomass_g"))
# contingancy table of vegetation index and trait
sv_cont <- (table(sv_trait$target, sv_trait$value_round))

pca_sv <- prcomp(sv_cont, scale = TRUE)
ggbiplot(pca_sv, labels = rownames(pca_sv$x), choices = 1:2, labels.size = 4)



pca_var <- as.data.frame(pca_sv$rotation)
pca_obs <- as.data.frame(pca_sv$x)

ggplot(pca_var, aes(PC1, PC2))+
  geom_point()+
  geom_point(data = pca_obs, aes(PC1, PC2), color = "red")



ggbiplot




