#loading required packages
install.packages('Rcpp', dependencies = TRUE)
install.packages('ggplot2', dependencies = TRUE)
install.packages("colorspace")
install.packages("plotly")
install.packages("sqldf")

library(ggplot2)
library(plotly)
library(sqldf)

#reading data into dataframe
data <- read.csv("SE-R.csv",header=T)


#Renaming the column year for better understanding
names(data)[1]<-paste("year")

#Reformat the data(Removing '%' symbol from the data to show the bleaching correctly)
data$bleaching = as.numeric(sub("%", "", data$bleaching))

#dividing datasets for each coral to draw graphs easily
bluecorals = sqldf("select * from data where type = 'blue corals'")
seapens = sqldf("select * from data where type='sea pens'")
hardcorals = sqldf("select * from data where type='hard corals'")
softcorals = sqldf("select * from data where type='soft corals'")
seafans = sqldf("select * from data where type='sea fans'")




#visualising the trends using points and smoother
# Site wise Plot graph for bluecorals bleaching over the years 
# Sorting the sites according to the latitude
bluecorals$site_order = factor(bluecorals$site, levels=c('site06','site01','site05','site02','site08','site03','site07','site04'))
SP <- ggplot(bluecorals, aes(x=year, y=bleaching)) + geom_point() + geom_smooth(aes(group = 1),
                                                                              method = "lm",
                                                                              color = "blue",
                                                                              formula = y~ poly(x, 2),
                                                                              se = FALSE)
SP + facet_grid(site_order ~ .) 
ggplotly()
 
# Site wise Plot graph for seapens bleaching over the years 
seapens$site_order = factor(seapens$site, levels=c('site06','site01','site05','site02','site08','site03','site07','site04'))
SP <- ggplot(seapens, aes(x=year, y=bleaching)) + geom_point() + geom_smooth(aes(group = 1),
                                                                                 method = "lm",
                                                                                 color = "blue",
                                                                                 formula = y~ poly(x, 2),
                                                                                 se = FALSE)
SP + facet_grid(site_order ~ .) 
ggplotly()

# Site wise Plot graph for hard corals bleaching over the years 
hardcorals$site_order = factor(hardcorals$site, levels=c('site06','site01','site05','site02','site08','site03','site07','site04'))
HC <- ggplot(hardcorals, aes(x=year, y=bleaching)) + geom_point() + geom_smooth(aes(group = 1),
                                                                                 method = "lm",
                                                                                 color = "blue",
                                                                                 formula = y~ poly(x, 2),
                                                                                 se = FALSE)
HC + facet_grid(site_order ~ .) 
ggplotly()

# Site wise Plot graph for soft corals bleaching over the years 
softcorals$site_order = factor(softcorals$site, levels=c('site06','site01','site05','site02','site08','site03','site07','site04'))
SC <- ggplot(softcorals, aes(x=year, y=bleaching)) + geom_point() + geom_smooth(aes(group = 1),
                                                                                 method = "lm",
                                                                                 color = "blue",
                                                                                 formula = y~ poly(x, 2),
                                                                                 se = FALSE)
SC + facet_grid(site_order ~ .) 
ggplotly()

# Site wise Plot graph for sea fans bleaching over the years 
seafans$site_order = factor(seafans$site, levels=c('site06','site01','site05','site02','site08','site03','site07','site04'))
SF <- ggplot(seafans, aes(x=year, y=bleaching)) + geom_point() + geom_smooth(aes(group = 1),
                                                                                 method = "lm",
                                                                                 color = "blue",
                                                                                 formula = y~ poly(x, 2),
                                                                                 se = FALSE)
SF + facet_grid(site_order ~ .) 
ggplotly()


# Site wise Bar graph for bluecorals bleaching over the years 
bluecorals$site_order = factor(bluecorals$site, levels=c('site06','site01','site05','site02','site08','site03','site07','site04'))
 ggplot(bluecorals, aes(year, bleaching)) + geom_bar(aes(fill = type), position = "dodge", stat = "identity") +
   facet_wrap(~site_order)+geom_smooth()
 
 # Site wise Bar graph for seafans bleaching over the years 
 seafans$site_order = factor(seafans$site, levels=c('site06','site01','site05','site02','site08','site03','site07','site04'))
 ggplot(seafans, aes(year, bleaching)) + geom_bar(aes(fill = type), position = "dodge", stat = "identity") +
   facet_wrap(~site_order)+geom_smooth()

 # Site wise Bar graph for seapens bleaching over the years 
 seapens$site_order = factor(seapens$site, levels=c('site06','site01','site05','site02','site08','site03','site07','site04'))
 ggplot(seapens, aes(year, bleaching)) + geom_bar(aes(fill = type), position = "dodge", stat = "identity") +
   facet_wrap(~site_order)+geom_smooth()
 
 # Site wise Bar graph for hardcorals bleaching over the years 
 hardcorals$site_order = factor(hardcorals$site, levels=c('site06','site01','site05','site02','site08','site03','site07','site04'))
 ggplot(hardcorals, aes(year, bleaching)) + geom_bar(aes(fill = type), position = "dodge", stat = "identity") +
   facet_wrap(~site_order)+geom_smooth()

 # Site wise Bar graph for softcorals bleaching over the years 
 softcorals$site_order = factor(softcorals$site, levels=c('site06','site01','site05','site02','site08','site03','site07','site04'))
 ggplot(softcorals, aes(year, bleaching)) + geom_bar(aes(fill = type), position = "dodge", stat = "identity") +
   facet_wrap(~site_order)+geom_smooth()


