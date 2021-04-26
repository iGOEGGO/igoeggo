plot_downloader <- function(name, plot, w, h) {
  return(downloadHandler(
    filename =name,
    content = function(file) {
      ggsave(file, 
             plot = plot,
             device = "png", 
             width = w, 
             height = h)
    }
  ))
}