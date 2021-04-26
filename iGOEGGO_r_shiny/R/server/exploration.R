observeEvent(input[[EXPLORATION_SHOW_PANEL]], {
  selected = input[[EXPLORATION_OPTION]]
  
  # Für Monitoring
  values$expl_num <- values$expl_num + 1
  values$expl_selected_list[values$expl_num] <- input[[EXPLORATION_OPTION]]
  values$expl_data_list[values$expl_num] <- values$current_dataset
  
  mod_id = paste0("exploration_mod", values$expl_num)
  pos = paste0("#",TAB_1_NAME,"_heading")
  
  ref = values$data
  
  # Boxplot
  if(selected == EXPLORATION_FUNCTIONS[1]) {
    insertUI(selector = pos, where = "beforeEnd", ui = tagList(
      exploration_boxplot_ui(mod_id, ref)
    ))
    
    exploration_boxplot_server(mod_id, ref)        
  } 
  
  # Histogram
  if(selected == EXPLORATION_FUNCTIONS[2]) {
    insertUI(selector = pos, where = "beforeEnd", ui = tagList(
      exploration_histogramm_ui(mod_id, ref)
    ))
    
    exploration_histogramm_server(mod_id, ref)
    print("Testboy")
  } 
  
  # ECDF
  if(selected == EXPLORATION_FUNCTIONS[3]) {
    insertUI(selector = pos, where = "beforeEnd", ui = tagList(
      exploration_ecdf_ui(mod_id, ref, i18n)
    ))
    
    exploration_ecdf_server(mod_id, ref)        
  } 
  
  # QQ
  if(selected == EXPLORATION_FUNCTIONS[4]) {
    insertUI(selector = pos, where = "beforeEnd", ui = tagList(
      exploration_qq_ui(mod_id, ref)
    ))
    
    exploration_qq_server(mod_id, ref)         
  } 

  # Four Plot View
  if(selected == EXPLORATION_FUNCTIONS[5]) {
    insertUI(selector = pos, where = "beforeEnd", ui = tagList(
      exploration_fp_ui(mod_id, ref)
    ))
    
    exploration_fp_server(mod_id, ref)          
  } 
})
