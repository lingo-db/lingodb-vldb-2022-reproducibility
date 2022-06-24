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
print(data_ours)
data_hyper <- as.data.table(read.csv('/results/hyper-tpch-1.log', sep=""))
data_hyper$qname <- paste("Q",data_hyper$query,sep="")
data_hyper <- aggregate(data_hyper[, 2:3], list(data_hyper$qname), min)
data_hyper$qname <- data_hyper$Group.1
data_hyper$type <- "hyper"

data_duckdb <- as.data.table(read.csv('/results/duckdb-tpch-1.log', sep=""))
data_duckdb$qname <- data_duckdb$name
print(data_duckdb)
data_duckdb <- aggregate(data_duckdb[, 2:3], list(data_duckdb$qname), min)
data_duckdb$qname <- data_duckdb$Group.1
data_duckdb$type <- "duckdb"
data_duckdb$time <- data_duckdb$timing*1000


print(data_duckdb)
data <- rbind.fill(data_ours, data_hyper,data_duckdb)
data$qname <- factor(data$qname,levels = c("Q1","Q2","Q3","Q4","Q5","Q6","Q7","Q8","Q9","Q10","Q11","Q12","Q13","Q14","Q15","Q16","Q17","Q18","Q19","Q20","Q21","Q22"))
data$time <- 1000/data$time

data$max_val <- 100
data$real_time <- data$time

data <- transform(data, time = pmin(time, max_val))

print(data)
pd = position_dodge(1)

pdf(file="/output/runtime.pdf", width=7, height=1.1)
ggplot(data, aes(x=qname, y=time,fill=type)) +
geom_bar(stat="identity", position=position_dodge(),width=0.8)+
 ylab('queries/s') + xlab("")+
   theme_classic() +
   theme(text = element_text(size=10), axis.text.x = element_text(hjust=0.5),axis.ticks.x = element_blank(),
          panel.grid.major.y = element_line( size=.1, color="darkgray"),
         strip.background = element_blank()) +
             coord_cartesian(ylim=c(0, 105))+
         theme(legend.title = element_blank(),legend.position="right",legend.key.size = unit(0.3, 'cm'))+
    scale_fill_manual(labels = c('ours' = 'LingoDB', 'hyper' = 'Hyper', 'duckdb' = 'DuckDB'),name="Systems", values=c("#888888","#e37222","#0065BD"))+
 geom_text(position=pd, aes(label=ifelse((type=="hyper"), ifelse((qname=="Q6"), round(real_time),""),ifelse((type=="ours"), ifelse((qname=="Q2" | qname=="Q11"), round(real_time),""),"")),y=105),size=2)


# scale_fill_discrete(labels = c('lkm_setup' = 'lkm', 'mmap_setup' = 'mmap'),name="Implementation", breaks=c('lkm_setup', 'mmap_setup'))+
# geom_text(position=position_dodge(), aes(label=ifelse(variable=="lkm_setup", speedup_setup,"")),vjust=-0.25,size=2.5)
dev.off()

#barplot(data, main="Car Distribution",  xlab="Number of Gears")
