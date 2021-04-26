observeEvent(input[[MODEL_SHOW_PANEL]], {
  selected = input[[MODEL_OPTION]]
  
  # Für Monitoring
  values$model_num <- values$model_num + 1
  values$model_selected_list[values$model_num] <- input[[MODEL_OPTION]]
  values$model_data_list[values$model_num] <- values$current_dataset
  
  mod_id = paste0("model_mod", values$model_num)
  pos = paste0("#",TAB_3_NAME,"_heading")
  
  ref = values$data
  
  # lineares Modell
  if(selected == MODEL_FUNCTIONS[1]) {
    insertUI(selector = pos, where = "beforeEnd", ui = tagList(
      model_linear_ui(mod_id, ref)
    ))
    
    model_linear_server(mod_id, ref)        
  } 
  # nicht-lineares Modell
  if(selected == MODEL_FUNCTIONS[2]) {
    insertUI(selector = pos, where = "beforeEnd", ui = tagList(
      model_nonlinear_ui(mod_id, ref)
    ))
    
    model_nonlinear_server(mod_id, ref)        
  } 
  
  # exponential Modell
  if(selected == MODEL_FUNCTIONS[3]) {
    insertUI(selector = pos, where = "beforeEnd", ui = tagList(
      model_exponential_ui(mod_id, ref)
    ))
    
    model_exponential_server(mod_id, ref)        
  } 
  
  # exponential Modell
  if(selected == MODEL_FUNCTIONS[4]) {
    insertUI(selector = pos, where = "beforeEnd", ui = tagList(
      model_log_ui(mod_id, ref)
    ))
    
    model_log_server(mod_id, ref)        
  } 
})