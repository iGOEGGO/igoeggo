# User Monitoring / Bookmarking

onBookmark(function(state) {
  # Wichtige Values abspeichern
  state$values$data <- values$data
  values$bm_dir <- state$dir
  #Exploration
  state$values$expl_num <- values$expl_num
  state$values$expl_selected_list <- values$expl_selected_list
  state$values$expl_data_list <- values$expl_data_list
  #Plotting
  state$values$plot_num <- values$plot_num
  state$values$plot_selected_list <- values$plot_selected_list
  state$values$plot_data_list <- values$plot_data_list
  #Model
  state$values$model_num <- values$model_num
  state$values$model_selected_list <- values$model_selected_list
  state$values$model_data_list <- values$model_data_list
  #cluster
  state$values$cluster_num <- values$cluster_num
  state$values$cluster_selected_list <- values$cluster_selected_list
  state$values$cluster_data_list <- values$cluster_data_list
  
  # Datensätze abspeichern
  state$values$datasets <- hash()
  for(i in keys(values$datasets)) {
    state$values$datasets[[i]] <- values$datasets[[i]]
  }
  
  state$values$root_datasets <- hash()
  for(i in keys(values$root_datasets)) {
    state$values$root_datasets[[i]] <- values$root_datasets[[i]]
  }
  
  state$values$current_dataset <- values$current_dataset
})

onBookmarked(function(url) {
  showModal(bookModal(url))
})

observeEvent(input$saveBM, {
  library(DBI)
  # Create an ephemeral in-memory RSQLite database
  tag <- c(input$bm_name)
  info <- c(input$bm_info)
  print(values$bm_url)
  url <- c(values$bm_url)
  time <- c(Sys.time())
  bookmark <- data.frame(tag, info, url, time)
  con <- dbConnect(RSQLite::SQLite(), "database/database.db")
  dbWriteTable(con, "bookmarks", bookmark, append=TRUE)
  dbReadTable(con, "bookmarks")
  # shinyalert(title = "Name", text = tag[1], type = "warning") 
  dbDisconnect(con)
  removeModal()
})

observeEvent(input$cancelBM, {
  unlink(values$bm_dir, recursive=TRUE)
  removeModal()
})

onRestore(function(state) {
  # Values für die Funktionalitäten wiederherstellen
  
  # Exploration
  values$expl_num <- state$values$expl_num
  values$expl_selected_list <- state$values$expl_selected_list
  values$expl_data_list <- state$values$expl_data_list
  #Plotting
  values$plot_num <- state$values$plot_num
  values$plot_selected_list <- state$values$plot_selected_list
  values$plot_data_list <- state$values$plot_data_list
  #Model
  values$model_num <- state$values$model_num
  values$model_selected_list <- state$values$model_selected_list
  values$model_data_list <- state$values$model_data_list
  #Cluster
  values$cluster_num <- state$values$cluster_num
  values$cluster_selected_list <- state$values$cluster_selected_list
  values$cluster_data_list <- state$values$cluster_data_list
  
  # Datensätze abspeichern
  values$data <- state$values$data
  values$datasets <- hash()
  for(i in keys(state$values$datasets)) {
    values$datasets[[i]] <- state$values$datasets[[i]]
  }
  
  values$root_datasets <- hash()
  for(i in keys(state$values$root_datasets)) {
    values$root_datasets[[i]] <- state$values$root_datasets[[i]]
  }
  
  values$current_dataset <- state$values$current_dataset
  
  updateSelectInput(session, "std", choices = keys(values$datasets), selected = values$current_dataset)
})


onRestored(function(state) {
  # Datensatz wiederherstellen
  # test if different session
  # shinyalert("Oops!", session$token, type = "error")
  # shinyalert("Oops!", session$user, type = "error")
  # shinyalert("Oops!", session$clientData$url_port, type = "error")
  
  # Diagramme vom Tab Exploration wiederherstellen
  if(values$expl_num>0) {
    for (i in seq_len(values$expl_num))  {
      selected = values$expl_selected_list[i]
      
      mod_id = paste0("exploration_mod", i)
      pos = paste0("#",TAB_1_NAME,"_heading")
      ref <- values$datasets[[values$expl_data_list[i]]]
      
      # Boxplot
      if(selected == EXPLORATION_FUNCTIONS[1]) {
        insertUI(selector = pos, where = "beforeEnd", ui = tagList(
          exploration_boxplot_ui(mod_id, ref)
        ))
        exploration_boxplot_server(mod_id, ref)
      }
      if(selected == EXPLORATION_FUNCTIONS[2]) {
        insertUI(selector = pos, where = "beforeEnd", ui = tagList(
          exploration_histogramm_ui(mod_id, ref)
        ))
        
        exploration_histogramm_server(mod_id, ref)
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
    }
  }
  
  # Diagramme vom Tab Plotting wiederherstellen
  
  if(values$plot_num>0) {
    for (i in seq_len(values$plot_num))  {
      selected = values$plot_selected_list[i]
      
      mod_id = paste0("plotting_mod", i)
      pos = paste0("#",TAB_2_NAME,"_heading")
      
      ref = values$datasets[[values$plot_data_list[i]]]
      
      #Scatterplot-logic
      if(selected == PLOTTING_FUNCTIONS[1]) {
        insertUI(selector = pos, where = "beforeEnd", ui = tagList(
          plotting_scatter_ui(mod_id, ref)
        ))
        
        plotting_scatter_server(mod_id, ref)   
      }
      
      #TODO: Moasicplot
      if(selected == PLOTTING_FUNCTIONS[2]) {
        insertUI(selector = pos, where = "beforeEnd", ui = tagList(
          plotting_mosaic_ui(mod_id, ref)
        ))
        
        plotting_mosaic_server(mod_id, ref)   
      }
      
      #Absolute, relative und Prozent Haufigkeiten
      if(selected == PLOTTING_FUNCTIONS[3]) {
        insertUI(selector = pos, where = "beforeEnd", ui = tagList(
          plotting_haeufigkeiten_ui(mod_id, ref)
        ))
        
        plotting_haeufigkeiten_server(mod_id, ref)
      }
      
      #Lineplot
      if(selected == PLOTTING_FUNCTIONS[4]) {
        insertUI(selector = pos, where = "beforeEnd", ui = tagList(
          plotting_lineplot_ui(mod_id, ref)
        ))
        
        plotting_lineplot_server(mod_id, ref)
      }
      # korrelogramm
      if(selected == PLOTTING_FUNCTIONS[5]) {
        insertUI(selector = pos, where = "beforeEnd", ui = tagList(
          plotting_corrplot_ui(mod_id, ref)
        ))
        
        plotting_corrplot_server(mod_id, ref)
      }
    }
  }
  
  # Diagramme vom Modelle Plotting wiederherstellen
  
  if(values$model_num>0) {
    for (i in seq_len(values$model_num))  {
      
      selected = values$model_selected_list[i]
      
      mod_id = paste0("model_mod", i)
      pos = paste0("#",TAB_3_NAME,"_heading")
      
      ref = values$datasets[[values$model_data_list[i]]]
      
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
      # exp Modell
      if(selected == MODEL_FUNCTIONS[3]) {
        insertUI(selector = pos, where = "beforeEnd", ui = tagList(
          model_exponential_ui(mod_id, ref)
        ))
        
        model_exponential_server(mod_id, ref)        
      }
      # log Modell
      if(selected == MODEL_FUNCTIONS[4]) {
        insertUI(selector = pos, where = "beforeEnd", ui = tagList(
          model_log_ui(mod_id, ref)
        ))
        
        model_log_server(mod_id, ref)        
      }
    }
  }
  
  # Diagramme vom Cluster Plotting wiederherstellen
  if(values$cluster_num>0) {
    for (i in seq_len(values$cluster_num))  {
      
      selected = values$cluster_selected_list[i]
      
      mod_id = paste0("cluster_mod", i)
      pos = paste0("#",TAB_5_NAME,"_heading")
      
      ref = values$datasets[[values$cluster_data_list[i]]]
      
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
    }
  }
})