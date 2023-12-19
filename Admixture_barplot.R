setwd("/Users/emily/Dropbox/School/Thesis/Variants-Ch2/admixture/admixture_6dec2023/")


tbl=read.table("all_samples_filtrado_final.recode.renamed_27nov2023.16.Q")
tbl=read.table("all_samples_filtrado_final.recode.renamed_27nov2023.6.Q")
indTable = read.table("all_samples_filtrado_final.recode.renamed_27nov2023.ind",
                      col.names = c("Sample", "Sex", "Pop"))

barplot(t(as.matrix(tbl)), col=rainbow(6),
          xlab="Individual #", ylab="Ancestry", border=NA)

mergedAdmixtureTable = cbind(tbl, indTable)
mergedAdmixtureTable$Species = ifelse(grepl('^Sscu', mergedAdmixtureTable$Sample), 'scurra',
                                      ifelse(grepl('^scur', mergedAdmixtureTable$Sample), 'scurra',
                                             ifelse(grepl('^viri', mergedAdmixtureTable$Sample), 'viridula',
                                                    ifelse(grepl('^zebr', mergedAdmixtureTable$Sample), 'zebrina', 'other'))))

mergedAdmixtureTable$Site = ifelse(grepl('CN', mergedAdmixtureTable$Sample), 'CN',
                            ifelse(grepl('HU', mergedAdmixtureTable$Sample), 'HU',
                            ifelse(grepl('PA', mergedAdmixtureTable$Sample), 'PA',
                            ifelse(grepl('R1', mergedAdmixtureTable$Sample), 'NI', 
                            ifelse(grepl('NI', mergedAdmixtureTable$Sample), 'NI',
                            ifelse(grepl('PL', mergedAdmixtureTable$Sample), 'PL',
                            ifelse(grepl('PU', mergedAdmixtureTable$Sample), 'PU',
                            ifelse(grepl('ZA', mergedAdmixtureTable$Sample), 'ZA',
                            ifelse(grepl('CH', mergedAdmixtureTable$Sample), 'CH',
                            ifelse(grepl('viridula_dnb', mergedAdmixtureTable$Sample), 'EC',
                            ifelse(grepl('zebrina_dnb', mergedAdmixtureTable$Sample), 'NI',
                            ifelse(grepl('EC', mergedAdmixtureTable$Sample), 'EC',
                            ifelse(grepl('100', mergedAdmixtureTable$Sample), 'TO',
                            ifelse(grepl('102', mergedAdmixtureTable$Sample), 'PA',
                            ifelse(grepl('103', mergedAdmixtureTable$Sample), 'PA',
                            ifelse(grepl('104', mergedAdmixtureTable$Sample), 'PA',
                            ifelse(grepl('105', mergedAdmixtureTable$Sample), 'PA',
                            ifelse(grepl('106', mergedAdmixtureTable$Sample), 'PA',
                            ifelse(grepl('107', mergedAdmixtureTable$Sample), 'PA',
                            ifelse(grepl('108', mergedAdmixtureTable$Sample), 'PA',
                            ifelse(grepl('109', mergedAdmixtureTable$Sample), 'PA',
                            ifelse(grepl('110', mergedAdmixtureTable$Sample), 'PA',
                            ifelse(grepl('viridula_9', mergedAdmixtureTable$Sample), 'TO',
                                                           'other')))))))))))))))))))))))

mergedAdmixtureTable$Sp_Site= paste(mergedAdmixtureTable$Species,"_", mergedAdmixtureTable$Site)

par(mar=c(10,4,4,4))

#Plot using original sample names
barplot(t(as.matrix(subset(mergedAdmixtureTable, select=V1:V6))), 
        col=rainbow(6), border=NA, names.arg = mergedAdmixtureTable$Sample, 
        las=2, cex.axis=1, cex.names = 0.3)

#Plot using species distinction
barplot(t(as.matrix(subset(mergedAdmixtureTable, select=V1:V6))), 
        col=rainbow(6), border=NA, names.arg = mergedAdmixtureTable$Species, 
        las=2, cex.axis=1, cex.names = 0.3)

#Plot using site distinction
barplot(t(as.matrix(subset(mergedAdmixtureTable, select=V1:V6))), 
        col=rainbow(6), border=NA, names.arg = mergedAdmixtureTable$Site, 
        las=2, cex.axis=1, cex.names = 0.3)

#Plot using species and site distinction
barplot(t(as.matrix(subset(mergedAdmixtureTable, select=V1:V6))), 
        col=c("#00B6EB","#A58AFF","#0088b0","#c4f2ff","#e4dbff", "#FB61D7"), border="black", names.arg = mergedAdmixtureTable$Sp_Site, 
        las=2, cex.axis=1, cex.names = 0.3)


