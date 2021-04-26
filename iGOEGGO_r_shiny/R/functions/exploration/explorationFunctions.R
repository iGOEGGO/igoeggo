library(shiny)
require(gridExtra)

#   _    __           _                     ______                 __  _                 
#  | |  / /___ ______(_)___  __  _______   / ____/_  ______  _____/ /_(_)___  ____  _____
#  | | / / __ `/ ___/ / __ \/ / / / ___/  / /_  / / / / __ \/ ___/ __/ / __ \/ __ \/ ___/
#  | |/ / /_/ / /  / / /_/ / /_/ (__  )  / __/ / /_/ / / / / /__/ /_/ / /_/ / / / (__  ) 
#  |___/\__,_/_/  /_/\____/\__,_/____/  /_/    \__,_/_/ /_/\___/\__/_/\____/_/ /_/____/  
#                                                                                     

exploration_generate_hist <- function(data, col, bin_count = 30, mean_line = FALSE, median_line = FALSE, density_line = FALSE) {
  
  #Denisty Histogramm oder normales Histogramm
  if(density_line) {
    p = ggplot(data, aes(x = data[, col])) + 
      geom_histogram(aes(y=..density..), binwidth = (max(data[, col])-min(data[, col]))/bin_count) +
      geom_density(colour = "magenta") + 
      ggtitle(paste("Histogramm (density) der Spalte", col)) + 
      xlab(col) 
  } else {
    p = ggplot(data, aes(x = data[, col])) + 
      geom_histogram(binwidth = (max(data[, col])-min(data[, col]))/bin_count)  + 
      ggtitle(paste("Histogramm der Spalte", col)) + 
      xlab(col)
  }
  
  #Linien hinzufügen
  if(mean_line) {
    p = p + geom_vline(aes(xintercept=mean(data[, col], na.rm = TRUE), color="mittelwert"), linetype="solid", size=1)
  }
  
  if(median_line) {
    p = p + geom_vline(aes(xintercept=median(data[, col], na.rm = TRUE), color="median"), linetype="solid", size=1)
  }
  
  
  #Legende für die Linien
  if(mean_line && median_line) {
    p = p + scale_color_manual(name = "Linien", values = c(mittelwert = "blue", median = "red"))

  }
  
  if(!mean_line && median_line) {
    p = p + scale_color_manual(name = "Linien", values = c(median = "red"))
  }
 
  if(mean_line && !median_line) {
    p = p + scale_color_manual(name = "Linien", values = c(mittelwert = "blue"))
  }
  
  return(p)
}


exploration_generate_boxplot <- function(data, col, mean_line = FALSE) {
  p = ggplot(data, aes(x = "", y = data[, col])) + 
    geom_boxplot() + 
    ggtitle(paste("Boxplot der Spalte", col)) + 
    ylab(col) + 
    coord_flip()
  
  if(mean_line) {
    p = p + geom_hline(yintercept = mean(data[, col], na.rm = TRUE), color="blue", linetype="dashed", size=1)
  }
  return(p)
}

exploration_generate_ecdf <- function(data, col) {
  return(
    ggplot(data, aes(data[, col])) + stat_ecdf(geom = "step") + ggtitle(paste("ECDF der Spalte",col)) + xlab(col) + ylab("Quantile")
  )
}


exploration_generate_qq <- function(data, col) {
  return(
    ggplot(data, aes(sample = data[, col])) + stat_qq() + coord_flip() + ggtitle(paste("QQ-Plot der Spalte",col)) + stat_qq_line(colour = "red")
  )
}


exploration_generate_fp <- function(data, col) {
  return(grid.arrange(
    exploration_generate_boxplot(data, col),
    exploration_generate_qq(data, col),
    exploration_generate_hist(data, col),
    exploration_generate_ecdf(data, col),
    ncol = 2
  ))
}

exploration_generate_cqq <- function(data, col) {
  return(exploration_generate_qq(data,col))
}
