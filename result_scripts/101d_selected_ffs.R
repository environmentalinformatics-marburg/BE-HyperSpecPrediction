# nested forward feature selection, predictor group distribution
library(dplyr)
library(plyr)
library(reshape2)
library(ggplot2)
library(ggmosaic)

sv <- lapply(list.files("~/ma/data/results/", pattern = "selvar_ffs", recursive = TRUE, full.names = TRUE), readRDS)
sv <- do.call(rbind, sv)

# simplifly the predictor name to its group:
for(i in seq(7)){
  sv[,i] <- as.character(sv[,i])
  sv[grepl("wl", sv[,i]),i] <- "nri"
  sv[grepl("^(mean|sd)", sv[,i]),i] <- "single"
  sv[grepl("(mean|sd)$", sv[,i]),i] <- "vegind"
}
sv$pred_group <- NULL

sv <- reshape2::melt(sv, value = "target", measure.vars = seq(7)) %>%
  na.omit()
sv_cont <- table(sv$value, sv$target)
plot(table(sv$value, sv$target))

ggplot(sv)+
  geom_mosaic(aes(x = product(value, target), fill = value))


