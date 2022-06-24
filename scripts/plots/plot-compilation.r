#!/bin/env Rscript
library(tikzDevice)
library(ggplot2)
library(data.table)
library(RColorBrewer)
library(stringr)
library(plyr)

data_ours <- as.data.table(read.csv('/results/tpch-times.csv', sep=""))
data_ours$qname <- str_replace(data_ours$query,"tpch","Q")
data_ours$type <- "ours"
data_ours$compilation <- data_ours$db + data_ours$std+data_ours$llvm+data_ours$opt+ data_ours$compile+data_ours$conversion
print(data_ours)
data_hyper <- as.data.table(read.csv('/results/hyper-tpch-1.log', sep=""))
data_hyper$qname <- paste("Q",data_hyper$query,sep="")
data_hyper$type <- "hyper"
data_hyper$compilation <- data_hyper$hypercompile
print(data_hyper)
data_hyper=data_hyper[data_hyper$run == 1,]

data_hyper_sf10 <- as.data.table(read.csv('/results/hyper-tpch-10.log', sep=""))
data_hyper_sf10$qname <- paste("Q",data_hyper_sf10$query,sep="")
data_hyper_sf10$type <- "hyper10"
data_hyper_sf10$compilation <- data_hyper_sf10$hypercompile
data_hyper_sf10=data_hyper_sf10[data_hyper_sf10$run == 1,]

data <- rbind.fill(data_ours, data_hyper,data_hyper_sf10)
print(data)
data$qname <- factor(data$qname,levels = c("Q1","Q2","Q3","Q4","Q5","Q6","Q7","Q8","Q9","Q10","Q11","Q12","Q13","Q14","Q15","Q16","Q17","Q18","Q19","Q20","Q21","Q22"))

print(data)
pd = position_dodge(1)
#png(filename = "test.png",
#    width = 2000, height = 300, units = "px", pointsize = 12,
#     bg = "white",   type = c("cairo", "cairo-png", "Xlib", "quartz"))
pdf(file="/output/compilation.pdf",  width=7, height=1.1)
ggplot(data, aes(x=qname, y=compilation,fill=type)) +
geom_bar(stat="identity", position=position_dodge(),width=0.8)+
 ylab('time (ms)') + xlab("")+
   theme_classic() +
   theme(text = element_text(size=10), axis.text.x = element_text(angle=0, hjust=0.7,vjust=0),axis.ticks.x = element_blank(),
          panel.grid.major.y = element_line( size=.1, color="darkgray"),
         strip.background = element_blank()) +
         theme(legend.title = element_blank(),legend.position="right",legend.margin=margin(0,0,0,0),legend.key.size = unit(0.3, 'cm'))+
    scale_fill_manual(labels = c('ours' = 'LingoDB', 'hyper' = 'Hyper (SF=1)', 'hyper10' = 'Hyper (SF=10)'),name="Systems", values=c("#e37222","#e32233","#0065BD"))
