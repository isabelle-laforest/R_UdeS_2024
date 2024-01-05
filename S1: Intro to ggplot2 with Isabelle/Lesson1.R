#### Start ####
# Distribute Cheat Sheets
# Discuss online resources
# https://ggplot2.tidyverse.org/index.html
# https://r-graph-gallery.com
# https://uc-r.github.io/ggplot_intro
# https://ggplot2-book.org/introduction
# https://bookdown.org/ozancanozdemir/introduction-to-ggplot2/
# https://www.rforecology.com/post/a-simple-introduction-to-ggplot2/
# https://towardsdatascience.com/a-quick-introduction-to-ggplot2-d406f83bb9c9
# http://r-statistics.co/Complete-Ggplot2-Tutorial-Part1-With-R-Code.html

#### Install packages ####
# Post-it down, put post-it up when done with installing
install.packages("ggplot2")
install.packages("patchwork")
install.packages("ggsignif")
install.packages("tidyverse")
install.packages("ggmap")
install.packages("RColorBrewer")
install.packages("ggthemes")
install.packages("")
library(ggplot2)
library(patchwork)
library(ggsignif)
library(tidyverse)
library(ggmap)
library(RColorBrewer)
library(ggthemes)
# post-it down

#### Load data ####
tree<-read.csv("Desktop/tree.csv",row.names=1)
summary(tree)
head(tree)
plot(biomass~Nmass, data=tree)

#### Get started with ggplot2 ####
# create canvas
ggplot(tree)

# variables of interest mapped
ggplot(tree, aes(x = Nmass, y = biomass))

# data plotted
ggplot(tree, aes(x = Nmass, y = biomass)) +
  geom_point()
ggplot(tree, aes(Nmass,biomass)) +
  geom_point()

# add color to the points
ggplot(tree, aes(x = Nmass, y = biomass)) +
  geom_point(color="blue")

# add color by factor
ggplot(tree, aes(x = Nmass, y = biomass, color=species)) +
  geom_point()

# create object that will contain graph
f1<-ggplot(tree, aes(x = Nmass, y = biomass, color=species)) +
  geom_point()
f1
f1<-ggplot(tree, aes(x = Nmass, y = biomass, color=species)) +
  geom_point();f1

#### Exercise 1 (max 10 min) ####
# Create a scatterplot with the variables LMA (x) and Amass (y) and color it by genus
# Put post-it up when done
ggplot(tree, aes(x = LMA, y = Amass, color=genus)) +
  geom_point()
#put post-it down

#### Themes ####
# assignment arrow shortcut option - and alt -
# https://ggplot2.tidyverse.org/reference/ggtheme.html
f1 <- ggplot(tree, aes(x = Nmass, y = biomass, color=species)) +
  geom_point();f1
f1 + theme_bw()
f1 + theme_linedraw()
f1 + theme_light()
f1 + theme_dark()
f1 + theme_classic()
f1 + theme_minimal()
f1 + theme_void()

# More themes with ggthemes
f1 + theme_economist_white()
f1 + theme_tufte()

#### Patchwork ####
# Meant to be a quick initiation (more later)
f1 <- ggplot(tree, aes(x = Nmass, y = biomass, color=species)) +
  geom_point()+guides(color = guide_legend(ncol = 3));f1
f2 <- f1 + theme_bw() + guides(color="none")
f3 <- f1 + theme_linedraw() + guides(color="none")
f4 <- f1 + theme_light() + guides(color="none")
f5 <- f1 + theme_dark() + guides(color="none")
f6 <- f1 + theme_classic() + guides(color="none")
f7 <- f1 + theme_minimal() + guides(color="none")
f8 <- f1 + theme_void() + guides(color="none")

design <- "
  123
  456
  789"

f1 + f2 + f3 + f4 + f5 + f6 + f7 + f8 + guide_area() +
  plot_layout(design = design, guides = "collect")+
  plot_annotation(tag_levels = 'A')
(f1 | f2 | f3) / (f4 | f5 | f6) / (f7 | f8 | plot_spacer())

design <- "
  123
  466
  566"

f2 + f3 + f4 + f6 + f7 + f5 +
  plot_layout(design = design)+
  plot_annotation(tag_levels = 'A')

#### Exercise 2 (max 10 min) ####
# Take the plot that you created in exercise 1
# Make 4 versions with different themes
# Produce a patchwork output with the 4 resulting graphs
# Put post-it up when done

t1 <- ggplot(tree, aes(x = LMA, y = Amass, color=genus)) +
  geom_point()+theme_classic();t1
t2 <- ggplot(tree, aes(x = LMA, y = Amass, color=genus)) +
  geom_point()+theme_minimal();t2
t3 <- ggplot(tree, aes(x = LMA, y = Amass, color=genus)) +
  geom_point()+theme_solarized();t3
t4 <- ggplot(tree, aes(x = LMA, y = Amass, color=genus)) +
  geom_point()+theme_few();t4

t1 + t2 + t3 + t4

(t1  + t2 + t3) / t4

#put post-it down

#### Point shape ####
ggplot(tree, aes(x = LMA, y = Amass, color=species, shape=group)) +
  geom_point()

# What happens when you have more levels than provided automatically
ggplot(tree, aes(x = LMA, y = Amass, color=species, shape=genus)) +
  geom_point()

# http://www.sthda.com/english/wiki/ggplot2-point-shapes

ggplot(tree, aes(x = LMA, y = Amass, color=species, shape=genus)) +
  geom_point()+
  scale_shape_manual(values=c(21:25, 3, 8, 10, 11))

#### Point filling ####
p1<-ggplot(tree, aes(x = Nmass, y = biomass, color=species)) +
  geom_point(shape=21);f1
p2<-ggplot(tree, aes(x = Nmass, y = biomass, fill=species)) +
  geom_point(shape=21);f2
p1 + p2

#### Exercise 3 (max 10 min) ####
# Take the plot that you created in exercise 1
# Create a scatterplot of the biomass (x) by volume (y)
# Shape the points according to group with 2 fillable shapes
# Fill the points by genus
# Put post-it up when done

ggplot(tree, aes(x = LMA, y = volume, shape=group, fill=genus)) +
  geom_point()+
  scale_shape_manual(values=c(21,22))
#put post-it down

#### Point size ####
s1<-ggplot(tree, aes(x = Nmass, y = biomass, fill=species)) +
  geom_point(color="black",shape=21, size=0.5)+
  theme_bw()+guides(fill="none");s1

s2<-ggplot(tree, aes(x = Nmass, y = biomass, fill=species)) +
  geom_point(color="black",shape=21, size=2)+
  theme_bw()+guides(fill="none");s2

s3<-ggplot(tree, aes(x = Nmass, y = biomass, fill=species)) +
  geom_point(color="black",shape=21, size=3)+
  theme_bw();s3

s4<-ggplot(tree, aes(x = Nmass, y = biomass, fill=species)) +
  geom_point(color="black",shape=21, size=10)+
  theme_bw()+guides(fill="none");s4

s1 + s2 + s3 + s4 + plot_layout(guides = "collect")

# Sizing points by a variable
s5<-ggplot(tree, aes(x = Nmass, y = biomass, fill=species, size=species_richness)) +
  geom_point(color="black",shape=21)+
  theme_bw()+guides(fill="none");s5

#### Exercise 4 (max 10 min) ####
# See what happens if your size variable is not numerical (ex: using a factor variable)
# Put post-it up when done
s6<-ggplot(tree, aes(x = Nmass, y = biomass, fill=species, size=group)) +
  geom_point(color="black",shape=21)+
  theme_bw()+guides(fill="none");s6
# Put post-it down

#### Plot area ####
# Focus on a specific zone of the plot and change the sizes of the dots
a1<-ggplot(tree, aes(x = Nmass, y = biomass, fill=species)) +
  geom_point(color="black",shape=21, size=3)+
  xlim(1,1.25)+ylim(0,100000)+theme_bw();a1

a1<-ggplot(tree, aes(x = Nmass, y = biomass, fill=species, size=species_richness)) +
  geom_point(color="black",shape=21)+
  xlim(1,1.25)+ylim(0,100000)+theme_bw();a1

#### END ####
