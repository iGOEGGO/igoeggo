
NCS = "W\u00E4hlen Sie eine Spalte"

plotting_generate_scatterplot <- function(data, x, y, shape, size, color, alpha, logx, logy) {
  
  g = ggplot(data, aes(x=data[, x], y=data[, y]))
  
  #If you break it you have to fix it ...
  if(shape == NCS && size == NCS && color == NCS) { 
    g = g + geom_point(alpha = alpha)
  } else if(shape == NCS && size == NCS && color != NCS) { 
    g = g + geom_point(aes(color = factor(data[ ,color])), alpha = alpha)
  } else if(shape == NCS && size != NCS && color == NCS) {
    g = g + geom_point(aes(size = data[ ,size]), alpha = alpha)
  } else if(shape == NCS && size != NCS && color != NCS) { 
    g = g + geom_point(aes(color = factor(data[, color]), size = data[, size]), alpha = alpha)
  } else if(shape != NCS && size == NCS && color == NCS) {
    g = g + geom_point(aes(shape = factor(data[, shape])), alpha = alpha)
  } else if(shape != NCS && size == NCS && color != NCS) {
    g = g + geom_point(aes(shape = factor(data[, shape]), color = factor(data[, color])), alpha = alpha)
  } else if(shape != NCS && size != NCS && color == NCS) {
    g = g + geom_point(aes(shape = factor(data[, shape]), size = data[, size]), alpha = alpha)
  } else if(shape != NCS && size != NCS && color != NCS) {
    g = g + geom_point(aes(shape = factor(data[, shape]), size = data[, size], color = factor(data[, color])), alpha = alpha)
  } 
  
  
  if(color != NCS) {
    g = g + labs(color = color)
  }
  
  if(shape != NCS) {
    g = g + labs(shape = shape)
  } 
  
  if(size != NCS) {
    g = g + labs(size = size)
  }
  
  #Labels
  g = g + xlab(x) + ylab(y)
  
  #Log axen
  g = plotting_add_log(g, logx, logy)
  
  return(g)
}



#Achsen Logarithmiren stuff
plotting_add_log <- function(plot, logx, logy) {
  
  if(logx) {
    plot = plot + scale_x_continuous(trans='log10')
  }
  
  if(logy) {
    plot = plot + scale_y_continuous(trans='log10')
  }
  
  return(plot)
}

plotting_generate_mosaic <- function(data, cols) {
  
  n <- length(cols)
  
  if(n %in% c(2,3,4,5)) {
    if(n == 2) {
      av <- data[[paste0("",cols[1])]]
      bv <- data[[paste0("",cols[2])]]
      
      g = mosaicplot(~ av + bv, data = data, color = TRUE, las = 1, main = "Mosaicplot", xlab = cols[1], ylab = cols[2],shade=TRUE)
    }
    
    if(n == 3) {
      av <- data[[paste0("",cols[1])]]
      bv <- data[[paste0("",cols[2])]]
      cv <- data[[paste0("",cols[3])]]
      
      g = mosaicplot(~ av + bv + cv, data = data, color = TRUE, las = 1, main = "Mosaicplot", xlab = cols[1], ylab = cols[2],shade=TRUE)
    }
    
    if(n == 4) {
      av <- data[[paste0("",cols[1])]]
      bv <- data[[paste0("",cols[2])]]
      cv <- data[[paste0("",cols[3])]]
      dv <- data[[paste0("",cols[4])]]
      
      g = mosaicplot(~ av + bv + cv + dv, data = data, color = TRUE, las = 1, main = "Mosaicplot", xlab = cols[1], ylab = cols[2],shade=TRUE)
    }
    
    if(n == 5) {
      av <- data[[paste0("",cols[1])]]
      bv <- data[[paste0("",cols[2])]]
      cv <- data[[paste0("",cols[3])]]
      dv <- data[[paste0("",cols[4])]]    
      ev <- data[[paste0("",cols[5])]]
      
      g = mosaicplot(~ av + bv + dv + dv + ev, data = data, color = TRUE, las = 1, main = "Mosaicplot", xlab = cols[1], ylab = cols[2], shade=TRUE)
    }
    return(g)
  } else {
    dat = data.frame(Leider = 1,Kein_Plot = 1)
    g = ggplot(dat, aes(x = Leider, y = Kein_Plot, label = "Sorry, das tut uns leid, aber beim Mosaicplot \n musst du zwischen 2 und 5 Variablen angeben")) + geom_text()
    return(g)
  }
}

plotting_generate_haeufigkeiten <- function(data, kat, height, mode, pie) {
  #solution without plotly, (in order for this to work the render- and the output function would need to be changed back from plotly)
  #p = ggplot(data, aes(x=data[,kat], y=data[,height])) + geom_bar(stat = "identity")
  x = pull(data, kat)
  y = pull(data, height)
  
  if(mode == 2) {
    y = y/sum(y)*100
  }
  
  if(mode == 3) {
    y = y/sum(y)
  }
  
  
  if(!pie) {
    p = plot_ly(
      x = x,
      y = y,
      name = "Barchart",
      type = "bar"
    )
  } 
  
  if(pie) {
    p = plot_ly(
      labels = x,
      values = y,
      name = "Piechart",
      type = "pie"
    )
  }
  
  return(p)
}


plotting_generate_lineplot <- function(data, time, y) {
  p = plot_ly(
      x = pull(data, time),
      y = pull(data, y),
      type = 'scatter',
      mode = 'lines'
  )
  
  return(p)
}

plotting_generate_corrplot <- function(data, corr_vars) {
  
  #g = ggcorrplot(data[,corr_vars], hc.order = TRUE, type = "lower",
  #           outline.col = "white")
  #return(g)
  return(corPlot(data[,corr_vars], main = "Korrelogram"))
}



