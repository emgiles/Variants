
getwd()
setwd("/Path_to_files/")


eval <- read.table("species_date_called_filtered2_fmiss50_variant.pca.eval")
#eval <- read.table("species_date_called_filtered2_fmiss50_variant.pca.eval")
head(eval)
evec1.pc <- round(eval[1,1]/sum(eval)*100,digits=2)
evec2.pc <- round(eval[2,1]/sum(eval)*100,digits=2)
evec <- read.table("species_date_called_filtered2_fmiss50_variant.pca.evec")
#evec <- read.table("species_date_called_filtered2_fmiss50_variant.pca.evec")
head(evec)

###example plot
par(mar = c(6.1, 6.1, 2.1, 2.1))
plot(evec[,2], evec[,3], xlab=paste("eigenvector1\n",evec1.pc, "% of observed genetic variation", sep=""), ylab=paste("eigenvector2\n",evec2.pc, "% of observed genetic variation", sep=""), col=c(rep("dark blue",14),c(rep("gold",17))), pch=c(rep(15,14), rep(17,17)), cex=2.5, cex.axis=1.5,cex.lab=1.5)

###plot1
# SVG graphics device
svg("PCA_with_labels.svg")
par(mar = c(6.1, 6.1, 2.1, 2.1))
plot(evec[,2], evec[,3], xlab=paste("eigenvector1\n",evec1.pc, "% of observed genetic variation", sep=""), 
     ylab=paste("eigenvector2\n",evec2.pc, "% of observed genetic variation", sep=""), 
     col=alpha(ifelse(grepl('^Sscu', evec$V1), 'black',
                      ifelse(grepl('^viridula_dnb', evec$V1), 'black',
                             ifelse(grepl('^zebrina_dnb', evec$V1), 'black',
                                    ifelse(grepl('^viridula', evec$V1), '#A58AFF', 
                                           ifelse(grepl('^zebrina', evec$V1), '#00B6EB',
                                                  ifelse(grepl('^scurra', evec$V1), '#FB61D7', 'black')))))), 0.7), 
     pch=ifelse(grepl('^Sscu', evec$V1), 8,
                ifelse(grepl('^viridula_dnb', evec$V1), 8,
                       ifelse(grepl('^zebrina_dnb', evec$V1), 8,
                              ifelse(grepl('^viridula', evec$V1), 21, 
                                     ifelse(grepl('^zebrina', evec$V1), 21,
                                            ifelse(grepl('^scurra', evec$V1), 21, 5)))))), 
     lwd = 1:5,
     text(evec[,2], evec[,3], labels=evec$V1, cex=.5, pos=4),
     cex=2, cex.axis=1.5,cex.lab=1.5)
# Close the graphics device
dev.off()

#blue point near scurra is zebrina_ZA_6
#purple point near zebrina is viridula_HU_01
