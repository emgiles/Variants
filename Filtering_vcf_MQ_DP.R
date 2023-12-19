#Filtering of vcf based on MQ and DP
install.packages("dplyr")
install.packages("ggplot2")

library("dplyr")
library("ggplot2")

setwd("/Users/emily/Dropbox/School/Thesis/Variants-Ch2/filtering_data")
data <- read.table("scurra_viridula_zebrina_pileup_24oct2023_called_variants.MQ.DP.txt",header=F) #text file with MQ and DP for all variants- derived from BCFtools query
data <- read.table("viridula_pileup_29may2023_called_variants.MQ.DP.txt",header=F) #text file with MQ and DP for all variants- derived from BCFtools query
data <- read.table("zebrina_pileup_29may2023_called_variants.MQ.DP.txt",header=F) #text file with MQ and DP for all variants- derived from BCFtools query


data2 <- read.table("scurra_viridula_zebrina_pileup_19may2023_called_variants.QUAL.txt",header=F) #text file with MQ and DP for all variants- derived from BCFtools query


head(data) #V1 is MQ and V2 is DP
colnames(data)<- c("MQ","DP")
head(data)

head(data2)
colnames(data2) <- c("QUAL")
head(data2)

meanMQ<-mean(data$MQ) #54.123 #for 24oct data = 54.03
quantMQ<-quantile(data$MQ) #25% = 50, 50%=58, 75%=59 #for 24oct data= 0%=30, 25%=51, 50%=57, 75%=59, 100%=60

meanDP<-mean(data$DP) #936 #for 24oct data = 826.79
quantDP<-quantile(data$DP) #24oct: 0%= 1, 25% = 170, 50%=647, 75%=1284, 100%=33439

meanQUAL<-mean(data2$QUAL) #450.85
quantQUAL<- quantile(data2$QUAL) #25% = 69, 50%=208, 75%=999


##Plotting but file might be too large to plot data
a <- ggplot(data, aes(x=MQ))
a + geom_histogram(binwidth=0.5, color ="black", fill="gray") +
  geom_vline(aes(xintercept=meanMQ),
             linetype="dashed", linewidth=0.6) +
  theme(legend.title=element_blank(), 
      panel.background=element_blank(),
      axis.line=element_line(colour="black"),
      axis.text=element_text(size=10),
      axis.title=element_text(size=10),
      axis.text.x=element_text(angle = 0, vjust = 0.5, hjust=1),
      #axis.text.x=element_blank(),
      legend.key.size = unit(0.5, 'cm'),
      legend.position="bottom")

a <- ggplot(data, aes(x=DP))
a + geom_histogram(binwidth=0.5, color ="black", fill="gray") +
  scale_x_log10(breaks=c(1,2,3,4,5,100,1000, 10000))+
  geom_vline(aes(xintercept=meanDP),
             linetype="dashed", linewidth=0.6) +
  theme(legend.title=element_blank(), 
        panel.background=element_blank(),
        axis.line=element_line(colour="black"),
        axis.text=element_text(size=10),
        axis.title=element_text(size=10),
        axis.text.x=element_text(angle = 0, vjust = 0.5, hjust=1),
        #axis.text.x=element_blank(),
        legend.key.size = unit(0.5, 'cm'),
        legend.position="bottom")

ggplot(data, aes(x = factor(1), y = MQ)) +
  geom_boxplot(width = 0.4, fill = "white") +
  geom_jitter(aes(), 
              width = 0.1, size = 1) + 
  labs(x = NULL)   # Remove x axis label
