library(shiny)
require(gridExtra)
library(dplyr)
library(ggplot2)
library(plotly)
library(broom)

#   _    __           _                     ______                 __  _                 
#  | |  / /___ ______(_)___  __  _______   / ____/_  ______  _____/ /_(_)___  ____  _____
#  | | / / __ `/ ___/ / __ \/ / / / ___/  / /_  / / / / __ \/ ___/ __/ / __ \/ __ \/ ___/
#  | |/ / /_/ / /  / / /_/ / /_/ (__  )  / __/ / /_/ / / / / /__/ /_/ / /_/ / / / (__  ) 
#  |___/\__,_/_/  /_/\____/\__,_/____/  /_/    \__,_/_/ /_/\___/\__/_/\____/_/ /_/____/  
#                                                                                     

cluster_generate <- function(data, col, mean_line = FALSE, xvar, yvar) {
  #print("hier")
  dataset <- select(data, xvar, yvar)
  multi.clust <- data.frame(k = 1:6) %>% group_by(k) %>% do(clust = kmeans(dataset, .$k))
  sumsq.clust <- multi.clust %>% group_by(k) %>% do(glance(.$clust[[1]]))
  p <- ggplot(sumsq.clust, aes(k, tot.withinss)) + geom_line() + geom_point()
  #print(typeof(p))
  p <- ggplotly(p)
  #print(typeof(p))
  #p
  return(p)
}

cluster_analysis_generate <- function(data, col, mean_line = FALSE, xvar, yvar, k) {
  print(k)
  dataset <- select(data, xvar, yvar)
  p.cluster <- dataset %>% kmeans(., k)
  p.cluster$cluster <- as.factor(p.cluster$cluster)
  
  plot <- ggplot(dataset, aes(dataset[,xvar], dataset[,yvar], label = rownames(dataset))) + 
    scale_fill_discrete(name = "Cluster") + 
    # xlim(9,35) +
    geom_label(aes(fill = p.cluster$cluster), colour = "white", fontface = "bold", size=2) +
    labs(x=xvar, y=yvar)
  return(plot)
}

cluster_analysis_generate_more <- function(data, col, mean_line = FALSE, xvar, yvar) {
  dataset <- select(data, xvar, yvar)
  multi.clust <- data.frame(k = 1:6) %>% group_by(k) %>% do(clust = kmeans(dataset, .$k))
  multi.k <- multi.clust %>% group_by(k) %>% do(augment(.$clust[[1]], dataset))
  
  p <- ggplot(multi.k, aes_string(xvar, yvar)) + geom_point(aes(color = .cluster)) + 
     facet_wrap(~k)
  #p <- ggplotly(p)
  return(p)
}