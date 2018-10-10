# compare vegetation indices between targets
library(dplyr)
library(plyr)
library(reshape2)

sv <- lapply(list.files("~/ma/data/results/", pattern = "selvar_vegind", recursive = TRUE, full.names = TRUE), readRDS)
sv <- do.call(rbind, sv)
for(i in seq(7)){sv[,i] <- as.character(sv[,i])}

sv_trait <- reshape2::melt(sv, value = "target", measure.vars = seq(7))

# get rid of mean and sd
sv_trait$value <- unlist(lapply(strsplit(sv_trait$value, "_"), "[[", 1))

sv_con <- as.data.frame(table(sv_trait$value, sv_trait$target))
sv_con <- reshape2::dcast(data = sv_con, formula = Var1 ~ Var2, value.var = "Freq", fun.aggregate = sum)

sv_con$sum <- rowSums(sv_con[2:13])

sv_con <- sv_con[sv_con$sum > 1,]
sv_con <- sv_con[order(sv_con$sum, decreasing = TRUE),]
rownames(sv_con) <- NULL
# reorder

sv_con <- sv_con[c("Var1", "nr_sp", "shannon", "evenness", "height", "biomass_g",
                               "SSD", "leaf_area", "SLA", "leaf_drymass", "seedmass", "leaf_P", "leaf_N", "sum")]


xtable::xtable(sv_con)
