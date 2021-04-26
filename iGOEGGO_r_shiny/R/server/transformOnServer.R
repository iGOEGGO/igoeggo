output$current_trans <- renderDataTable({values$data})


observeEvent(input$apply_operation, {
  
  reference = values$data
  
  verb = input$verb
  user_input = input$user_input
  data_cols = colnames(reference)
  
  append_command_row = FALSE
  
  #ISSUE: Problematic if a column is named NOT
  if(verb == "select") {
    tryCatch({
      user_cols = cols_from_user_input(user_input)
      not_path = FALSE
      
      if(csplit(user_cols[1], " ")[1] == "NOT") {
        not_path = TRUE
        user_cols[1] = csplit(user_cols[1], " ")[2]
      }
      
      continue = check_if_cols_match(user_cols, data_cols)
      
      if(continue == TRUE) {
        if(!not_path) {
          values$data = select(reference, user_cols)
        } else {
          values$data = select(reference, !user_cols)
        }
        append_command_row = TRUE
      } else {
        does_not_contain_col_message(continue)
      }
    }, error = function(cond){
      custom_message("Sorry", i18n_ss()$t("Beim verarbeiten deiner Eingabe ist ein Fehler aufgetreten"))
    }, warning = function(cond) {
      custom_message("Sorry", i18n_ss()$t("Beim verarbeiten deiner Eingabe ist ein Fehler aufgetreten"))
    }, finally = {})
  }
  
  
  tryCatch({
    
  }, error = function(cond) {
    
  }, warning = function(cond) {
    
  }, finally = {})
  
  
  if(verb == "group_by") {
    tryCatch({
      user_cols = cols_from_user_input(user_input)
      continue = check_if_cols_match(user_cols, data_cols)
      
      #user_cols ist irgendein Vektor, sprich: user_cols <- c("Spalte1", "Spalte2") usw.
      
      if(continue == TRUE) {
        values$data = group_by(reference, .dots = user_cols)
        append_command_row = TRUE
        values$dataset_is_grouped = TRUE
      } else {
        does_not_contain_col_message(continue)
      }
    }, error = function(cond){
      custom_message("Sorry", i18n_ss()$t("Beim verarbeiten deiner Eingabe ist ein Fehler aufgetreten"))
    }, warning = function(cond) {
      custom_message("Sorry", i18n_ss()$t("Beim verarbeiten deiner Eingabe ist ein Fehler aufgetreten"))
    }, finally = {})
  }
  
  #So unsauber, da hilft nicht mal mehr Meister Popper    
  if(verb == "filter") {
    tryCatch({
      filter_str = parse(text = user_input)
      myd = filter(reference, eval(filter_str))
      values$data = myd
      append_command_row = TRUE
    }, error = function(cond){
      custom_message("Sorry", i18n_ss()$t("Beim verarbeiten deiner Eingabe ist ein Fehler aufgetreten"))
    }, warning = function(cond) {
      custom_message("Sorry", i18n_ss()$t("Beim verarbeiten deiner Eingabe ist ein Fehler aufgetreten"))
    }, finally = {})
  }
  
  #TODO: Formula needs to wrapped in a try catch
  if(verb == "mutate") {
    tryCatch({
      splat = split_at_equal(user_input)
      new_col_name = splat[1]
      user_formula = splat[2]
      
      
      print(new_col_name)
      print(user_formula)
      
      #Sowohl links als auch rechts vom = steht was ...
      if(!is.na(user_formula)) {
        #Spaltenname darf noch nicht vorhanden sein ...
        if(!(new_col_name %in% data_cols)) {
          
          satan = parse(text = user_formula)
          temp_df = mutate(reference, satans_evil_child = eval(satan))
          colnames(temp_df)[length(temp_df)] = new_col_name
          values$data = temp_df
          append_command_row = TRUE
        } else {
          custom_message("Fehler bei der Eingabe", paste("Der Spaltenname", new_col_name, "ist bereits im Datensatz vorhanden. Das Kommando wurde nicht ausgefüht."))
        }   
      } else {
        custom_message("Fehler bei der Eingabe", "Die angegebene Formel ist nicht korrekt. Das Kommando wurde nicht ausgeführt.")
      }
    }, error = function(cond){
      custom_message("Sorry", i18n_ss()$t("Beim verarbeiten deiner Eingabe ist ein Fehler aufgetreten"))
    }, warning = function(cond) {
      custom_message("Sorry", i18n_ss()$t("Beim verarbeiten deiner Eingabe ist ein Fehler aufgetreten"))
    }, finally = {})
    
  }
  
  #TODO: Error handling in case of none numeric col.
  if(verb == "summarise") {
    
    if(!values$dataset_is_grouped) {
      custom_message("Datensatz musst gruppiert sein", "Damit Sie den Datensatz 'summarisen' können müssen Sie Ihn zuerst nach einer Spalte gruppieren. Die Operation wurde nicht angewandt")
      return()
    }
     
    tryCatch({

      user_cols = cols_from_user_input(user_input)
      continue = check_if_cols_match(user_cols, data_cols)
      
      if(continue == TRUE) {
        
        #First col is given since it is the n col.
        myd = data.frame(summarise(reference, n = n()))
        
        for(col in user_cols) {
            #Fucking R ...
            #No touchy ...
            #Security risk (I think), but security through obscurity is bae
            #Update: I am sure, it is a security risk ...
          if(sapply(reference[, col], is.numeric)) {
            temp = data.frame(summarise(reference, 
                                        c_mean = mean(eval(parse(text = col)), na.rm = TRUE), 
                                        c_median = median(eval(parse(text = col)), na.rm = TRUE),
                                        c_min = min(eval(parse(text = col)), na.rm = TRUE),
                                        c_max = max(eval(parse(text = col)), na.rm = TRUE),
                                        c_sd = sd(eval(parse(text = col)), na.rm = TRUE),
                                        c_ndist = n_distinct(eval(parse(text = col)))))
            
            nc = ncol(temp)
            useless_cols_nr = nc-6+1
            temp = temp[,useless_cols_nr:nc]
            
            colnames(temp) <- c(paste0(col,"_mean"),
                                paste0(col,"_median"),
                                paste0(col,"_min"),
                                paste0(col,"_max"),
                                paste0(col,"_sd"),
                                paste0(col,"_ndist"))
            print(temp)
            myd = cbind(myd, temp)
            values$dataset_is_grouped = FALSE
          }
        }
        
        values$data = myd
        append_command_row = TRUE
        
      } else {
        does_not_contain_col_message(continue)
      }
    }, error = function(cond){
      custom_message("Sorry", i18n_ss()$t("Beim verarbeiten deiner Eingabe ist ein Fehler aufgetreten"))
    }, warning = function(cond) {
      custom_message("Sorry", i18n_ss()$t("Beim verarbeiten deiner Eingabe ist ein Fehler aufgetreten"))
    }, finally = {})
  }
  
  #TODO: Make them removable again.
  #Update: Its dodone.
  if(append_command_row) {
    insertUI(selector = "#verb", where = "beforeBegin", ui = tagList(
      p(verb, class = "ap_cmd_tr")
    ))
    
    insertUI(selector = "#user_input", where = "beforeBegin", ui = tagList(
      p(user_input, class = "ap_cmd_tr")
    ))
    
    #insertUI(selector = "#apply_operation", where = "beforeBegin", ui = tagList(p("", class = "ap_cmd_tr", style = "height: 20px")))
    #insertUI(selector = "#delete_command_history", where = "beforeBegin", ui = tagList(p("", class = "ap_cmd_tr", style = "height: 20px")))
    #insertUI(selector = "#revert_to_root", where = "beforeBegin", ui = tagList(p("", class = "ap_cmd_tr", style = "height: 20px")))
  }
  
  updateSelectInput(session, "cName", choices = colnames(values$data))
  updateSelectInput(session, "cColumn", choices = colnames(values$data))
})


observeEvent(input$delete_command_history, {
  removeOldCommands()
})

observeEvent(input$revert_to_root, {
  values$datasets[[values$current_dataset]] <- values$root_datasets[[values$current_dataset]]
  values$data <- values$datasets[[values$current_dataset]]
  removeOldCommands()
})


removeOldCommands <- function() {
  removeUI(
    selector = ".ap_cmd_tr", multiple = TRUE
  )
}