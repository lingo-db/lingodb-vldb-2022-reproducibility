#!/bin/env Rscript
library(ggplot2)
library(data.table)
library(cowplot)
library(tikzDevice)
library(tidytext)
library(RColorBrewer)
library(ggbeeswarm)
library(tidyverse)
library(ggrepel)
library(ggforce)


data_ours <- as.data.table(read.csv('/results/tpch-times.csv', sep=""))
data_ours$qname <- str_replace(data_ours$query,"tpch","")
data_ours$total <- data_ours$db+data_ours$std+data_ours$llvm+data_ours$opt+ data_ours$compile+data_ours$conversion
df=subset(data_ours,select=c("qname","opt","db","std","llvm","conversion","compile","total"))
# Calculate some statistics

df=melt(as.data.table(df), id.vars = c("qname"),
                measure.vars = c("opt","db","std","llvm","conversion","compile","total"))
df$optimization<-df$variable
df$time <- df$value
df$query <- df$qname
df$optimization=factor(df$optimization,levels = c("opt","db","std","llvm","conversion","compile","total"),labels=c("Query Opt.","$\\rightarrow$ imperative","$\\rightarrow$ std","$\\rightarrow$ llvm", "$\\rightarrow$ LLVM","LLVM","Total"))

print(df)
# Plot TPC-DS as beeplot with annotated outliers
tpcds <- df
is_outlier <- function(x) { return(x > (quantile(x, 0.5) + 60) & x > quantile(x, 0.75) + 2.5 * IQR(x)) }
pdf(file="/output/compilation-phases.pdf",  width=7, height=1.1)

tpcds %>% group_by(optimization) %>%
  mutate(outlier = if_else(is_outlier(time), paste('Q', query), NA_character_)) %>%
ggplot(aes(x = optimization, y = time, color = optimization)) +
  geom_quasirandom(size = .5) + #geom_boxplot() +
  facet_row(. ~ (optimization == 'Total'), scales = "free", space = "free") +
  scale_y_continuous(expand = expansion(mult = c(0, .015))) +
  expand_limits(y = 0) +
  scale_x_discrete(guide = guide_axis(n.dodge = 2)) +
  scale_color_manual(values=c('#23507A', '#FFD200', '#CD161C', '#FF7F00', '#67356F', '#3C893A', '#3BC4B5', '#666666')) +
  geom_text_repel(aes(label = outlier), size = 1.5, na.rm = TRUE, box.padding = .05, nudge_y = 5, nudge_x = .3)+#, direction = "x") +
  coord_cartesian(clip = 'off') +
  theme_minimal_hgrid() + #panel_border() +
  labs(x = "", y = "Time [ms]") +
  theme(legend.position="none", strip.text.x = element_blank(),
        plot.margin=unit(c(0, 0, 0, 0), "mm"), axis.title = element_text(size = 8),
        axis.title.y = element_text(margin = margin(t = 0, r = 0, b = 0, l = 0)),
        axis.text.y = element_text(size = 8), axis.text.x = element_text(size = 8),
        panel.spacing = unit(.5, 'mm'))
dev.off()
