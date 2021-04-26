observeEvent(input[[CLUSTER_SHOW_PANEL]], {
  selected = input[[CLUSTER_OPTION]]
  
  # Für Monitoring
  values$cluster_num <- values$cluster_num + 1
  values$cluster_selected_list[values$cluster_num] <- input[[CLUSTER_OPTION]]
  values$cluster_data_list[values$cluster_num] <- values$current_dataset
  
  mod_id = paste0("cluster_mod", values$cluster_num)
  pos = paste0("#",TAB_5_NAME,"_heading")
  
  ref = values$data
  
  # Clusteranzahl bestimmten
  if(selected == CLUSTER_FUNCTIONS[1]) {
    insertUI(selector = pos, where = "beforeEnd", ui = tagList(
      cluster_ui(mod_id, ref)
    ))
    
    cluster_server(mod_id, ref)        
  } 
  
  # Clusteranalyse
  if(selected == CLUSTER_FUNCTIONS[2]) {
    insertUI(selector = pos, where = "beforeEnd", ui = tagList(
      cluster_analysis_ui(mod_id, ref)
    ))
    
    cluster_analysis_server(mod_id, ref)        
  }
})