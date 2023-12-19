#script to determine amount of missing data in vcf files
#quality

install.packages(c("LEA","adegenet","ggplot2","devtools","OutFLANK","grur","radiator","ape","poppr","vcfR","stringr","reshape2","RColorBrewer","dartR","pals"))
install.packages("OutFLANK")

if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install("LEA")
BiocManager::install("OutFLANK")

##packages
library(LEA)
library(adegenet)
library(ggplot2)
library(devtools)
library(OutFLANK)
library(grur)
library(radiator)
library(ape)
library(poppr)
library(vcfR)
library(stringr)
library(reshape2)
library("ggpubr")
library(RColorBrewer)
library(dartR)
library(pals)

mara = read.vcfR("populations.snps.vcf")
pops = read.table("population_map_Sv_Sz_ref_2.txt",header =F)
gl.mara <- vcfR2genlight(mara)
gl.mara2 <- vcfR2genlight(mara)
pop(gl.mara) <- pops$V2
pop(gl.mara2) <- pops$V3

queryMETA(mara, "DP")
dp.mara <- extract.gt(mara, element = "DP", as.numeric=T)
sum(is.na(dp.mara[,1]))

myMiss <- apply(dp.mara, MARGIN = 2, function(x){ sum((is.na(x))) })
myMiss <- myMiss/nrow(mara)


palette(brewer.pal(n=12, name = 'Set3'))

par(mar = c(12,4,4,2))
barplot(myMiss,  las = 2, col = 1:2, cex.names = 0.5)
title(ylab = "Missingness (%)")

which(myMiss>0.2)

class(dp.mara)
dim(dp.mara)
dpf <- melt(dp.mara, varnames = c("Index", "Sample"),
            value.name = "Depth", na.rm = TRUE)
dpf <- dpf[ dpf$Depth > 0, ]
p <- ggplot(dpf, aes(x = Sample, y = Depth))
p <- p + geom_violin(fill = "#C0C0C0", adjust = 1.0,
                     scale = "count", trim = TRUE)
p <- p + theme_bw()
p <- p + theme(axis.title.x = element_blank(),
               axis.text.x = element_text(angle = 60, hjust = 1))
p <- p + scale_y_continuous(trans = scales::log2_trans(),
                            breaks = c(1, 10, 100, 800),
                            minor_breaks = c(1:10, 2:10 * 10, 2:8 * 100))
p <- p + theme(panel.grid.major.y = element_line(color = "#A9A9A9", size = 0.6))
p <- p + theme(panel.grid.minor.y = element_line(color = "#C0C0C0", size = 0.2))
p <- p + ylab("Depth (DP)")
p



gt.mara <- extract.gt(mara, element = "GT", as.numeric=F)
sum(is.na(gt.at[,1]))

#myMiss <- apply(gt.mara, MARGIN = 2, function(x){ sum((x=="0/1"), NA ,na.rm = T) }) #this one is to check for heterocigosity
myMiss <- apply(gt.am, MARGIN = 2, function(x){ sum((is.na(x))) })
myMiss <- myMiss/nrow(mara)

library(RColorBrewer)
palette(brewer.pal(n=12, name = 'Set3'))

par(mar = c(12,4,4,2))
barplot(myMiss,  las = 2, col = 1:2, cex.names = 0.5)