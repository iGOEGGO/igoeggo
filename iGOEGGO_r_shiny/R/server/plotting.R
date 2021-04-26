observeEvent(input$button_plotting_show, {
  selected = input[[PLOTTING_OPTION]]
  
  # Für Monitoring
  values$plot_num <- values$plot_num + 1
  values$plot_selected_list[values$plot_num] <- input[[PLOTTING_OPTION]]
  values$plot_data_list[values$plot_num] <- values$current_dataset
  
  mod_id = paste0("plotting_mod", values$plot_num)
  pos = paste0("#",TAB_2_NAME,"_heading")
  
  ref = values$data
  
  #Scatterplot-logic
  if(selected == "scatter") {
    insertUI(selector = pos, where = "beforeEnd", ui = tagList(
      plotting_scatter_ui(mod_id, ref)
    ))
    
    plotting_scatter_server(mod_id, ref)   
  }
  
  #TODO: Moasicplot
  if(selected == "mosaic") {
    insertUI(selector = pos, where = "beforeEnd", ui = tagList(
      plotting_mosaic_ui(mod_id, ref)
    ))
    
    plotting_mosaic_server(mod_id, ref)   
  }
  
  #Absolute, relative und Prozent Haufigkeiten
  if(selected == "haeufigkeiten") {
    insertUI(selector = pos, where = "beforeEnd", ui = tagList(
      plotting_haeufigkeiten_ui(mod_id, ref)
    ))
    
    plotting_haeufigkeiten_server(mod_id, ref)
  }
  
  #Lineplot
  if(selected == "lineplot") {
    insertUI(selector = pos, where = "beforeEnd", ui = tagList(
      plotting_lineplot_ui(mod_id, ref)
    ))
    
    plotting_lineplot_server(mod_id, ref)
  }
  
  #Lineplot
  if(selected == "corrplot") {
    insertUI(selector = pos, where = "beforeEnd", ui = tagList(
      plotting_corrplot_ui(mod_id, ref)
    ))
    
    plotting_corrplot_server(mod_id, ref)
  }
  
  
})