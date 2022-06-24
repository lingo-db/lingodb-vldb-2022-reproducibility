#!/bin/env Rscript
library(tikzDevice)
library(ggplot2)
library(data.table)
library(RColorBrewer)
library(stringr)
library(plyr)
library(scales)


data <- as.data.table(read.csv('/results/qopt-codestats.csv', sep=""))

print(data)
pd = position_dodge(1)

pdf(file="/output/qopt-codestats.pdf",  width=2.3, height=1)
#png(filename = "test.png",
#    width = 2000, height = 300, units = "px", pointsize = 12,
#     bg = "white",   type = c("cairo", "cairo-png", "Xlib", "quartz"))
ggplot(data, aes(x=System,y=LoC,fill=System)) +
geom_bar(stat="identity", position=position_dodge(),width=0.6)+
 ylab('Lines of Code') + xlab("")+
   theme_classic() +
   	scale_y_continuous(labels = label_number(suffix = " K", scale = 1e-3))+

   theme(text = element_text(size=8), axis.text.x = element_text(hjust=0.5),axis.ticks.x = element_blank(),
          panel.grid.major.y = element_line( size=.1, color="darkgray"),
         strip.background = element_blank()) +
         theme(legend.title = element_blank(),legend.position="none",legend.key.size = unit(0.3, 'cm'),legend.margin=margin(0,0,0,0),axis.title.y = element_text(margin = margin(t = 0, r = 0, b = 0, l = 0)),
        legend.box.margin=margin(-20,0,0,0))+
    scale_fill_manual(labels = c('ours' = 'LingoDB', 'hyper' = 'Hyper', 'duckdb' = 'DuckDB'),name="Systems", values=c("#888888","#e37222","#0065BD"))

# scale_fill_discrete(labels = c('lkm_setup' = 'lkm', 'mmap_setup' = 'mmap'),name="Implementation", breaks=c('lkm_setup', 'mmap_setup'))+
# geom_text(position=position_dodge(), aes(label=ifelse(variable=="lkm_setup", speedup_setup,"")),vjust=-0.25,size=2.5)
dev.off()

#barplot(data, main="Car Distribution",  xlab="Number of Gears")