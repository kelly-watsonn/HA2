
## Thesis - visualization of results ## 


install.packages(c('tidyverse','devtools','gghalves'))

devtools::install_github('smin95/smplot2', force = TRUE)

library(rms)
library(readr)
library(ggplot2)
library(ggrepel)
library(smplot2)
library(tidyverse) 
library(cowplot)
library(smplot2)
library(ggpubr)
library(readxl)
library(haven)
library(reshape2)
library(stringr)

## Set WD 
setwd("insert your file path") 

## Import Dataset
HA2_data <- read_dta("meta_input_data_full.dta")


## Create new variable - trial name to label points
HA2_data$LAZ_MD <- HA2_data$lhaz1I - HA2_data$lhaz1C
HA2_data$HA_MD <- HA2_data$HA_days1I - HA2_data$HA_days1C
HA2_data <- separate(HA2_data, countrytrial, c("country", "trial"), sep = "; ")

HA2_data_noH <- HA2_data %>% filter(id != "I14")


####################### CORRELATION PLOT - LAZ VS HA ###########################

cor(HA2_data$LAZ_MD, HA2_data$HA_MD, method="pearson") ## 0.8148601
cor(HA2_data$LAZ_MD, HA2_data$HA_MD, method="spearman") ## 0.7425042
cor(HA2_data_noH$LAZ_MD, HA2_data_noH$HA_MD, method="pearson") ## 0.9576501
cor(HA2_data_noH$LAZ_MD, HA2_data_noH$HA_MD, method="spearman") ## 0.9367726

cor.test(HA2_data$LAZ_MD, HA2_data$HA_MD, method="pearson") # 0.8148601; 95%CI: 0.5616672 0.9284981; p-value 3.813e-05
cor.test(HA2_data$LAZ_MD, HA2_data$HA_MD, method="spearman",exact=FALSE) # 0.7425042 ; p-value 0.0004169
cor.test(HA2_data_noH$LAZ_MD, HA2_data_noH$HA_MD, method="pearson") # 0.9576501 ; 95%CI:0.8838170 0.9849382; p-value 1.631e-09
cor.test(HA2_data_noH$LAZ_MD, HA2_data_noH$HA_MD, method="spearman",exact=FALSE) # 0.9367726; p-value: 3.1e-08


H <- ggplot(data=HA2_data, aes(x=LAZ_MD, y=HA_MD))+
  geom_point(shape = 21, fill='black',color = 'white', size = 3)+
  sm_statCorr(show_text=FALSE, linetype = 'solid',color='dodgerblue4')+
  geom_smooth(method=lm , color="black", se=FALSE)+
  geom_label_repel(aes(label = trial),
                   box.padding   = 0.5, 
                   point.padding = 0.3,
                   segment.color = 'snow3',
                   colour='gray9',
                   size =3,
                   label.size = NA)+
  labs(tag = "a") +
  theme_classic()+
  theme(text = element_text(size = 14, family = "Arial"))+
  annotate("text",x = 0.25, y=0, label = ('R = 0.74 \n   p < 0.001'), colour="black",size=4)+
  xlab("LAZ MD at trial end-line")+
  ylab("Height-age MD at trial end-line (days)")+
  scale_x_continuous(breaks = seq(0, 0.3, by = 0.1)) +
  scale_y_continuous(breaks = seq(-5, 25, by = 5)) +
  coord_cartesian(ylim = c(-7, 25)) +
  theme(axis.title = element_text(size = 14)) +
  theme(plot.tag = element_text(face = "bold"))

  
NoH <- ggplot(data=HA2_data_noH, aes(x=LAZ_MD, y=HA_MD))+
  geom_point(shape = 21, fill='black',color = 'white', size = 3)+
  sm_statCorr(show_text=FALSE, linetype = 'solid',color='dodgerblue4')+
  geom_smooth(method=lm , color="black", se=FALSE)+
  geom_label_repel(aes(label = trial),
                   box.padding   = 0.5, 
                   point.padding = 0.3,
                   segment.color = 'snow3',
                   colour='gray9',
                   size =3,
                   label.size = NA)+
  coord_cartesian(ylim = c(-7, 25)) +
  labs(tag = "b") +
  theme_classic()+
  theme(text = element_text(size = 14, family = "Arial"))+
  annotate("text",x = 0.25, y=0, label = ('R = 0.94 \n   p < 0.0001'), colour="black",size=4)+
  xlab("LAZ MD at trial end-line")+
  ylab("")+
  scale_x_continuous(breaks = seq(0, 0.3, by = 0.1)) +
  scale_y_continuous(breaks = seq(-5, 25, by = 5)) +
  theme(axis.title = element_text(size = 14)) + 
  theme(plot.tag = element_text(face = "bold"))


Figure_2 <- ggarrange(H, NoH, ncol = 2, nrow = 1, align = "v")

ggsave(
  "HA2_Figure2.eps",
  plot = Figure_2,
  scale = 1,
  width = 30,
  height = 18,
  units = c("cm"),
  dpi = 300
)

