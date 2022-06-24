FROM rocker/r-bspm:20.04
RUN R -e "install.packages(c('tikzDevice','ggplot2','data.table','RColorBrewer','stringr','plyr'))"
RUN R -e "install.packages(c('tidytext','cowplot','ggbeeswarm','tidyverse','ggrepel','ggforce','scales'))"
RUN echo "bspm::disable()" | tee -a /etc/R/Rprofile.site
RUN R -e "install.packages('ggbeeswarm', repos='http://cran.us.r-project.org')"
RUN echo "bspm::enable()" | tee -a /etc/R/Rprofile.site

COPY scripts/plots /plot-scripts
COPY results /results
VOLUME "/output"