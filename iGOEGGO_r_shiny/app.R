#Options
options(shiny.maxRequestSize=50*1024^2)

#Imports
library(shiny)
library(tools)
library(dplyr)
library(shinydashboard)
library(ggplot2)
library(plotly)
library(dipl)
library(shinyjs)
library(shinycssloaders)
library(broom)
library(tidyverse)
library(shiny.i18n)
library(DT)
library(hash)
library(shinybusy)
library(shinyalert)
library(DBI)
library(urltools)
library(psych)

# Module logic & imports
source("./R/util/plotDownloader.R")
source("./R/util/transformationUtil.R")

# constants 
source("./R/ui/constants.R")

# UI-Elements
# local -> for variables
source("./R/ui/uiElements.R", local=TRUE)

# Language stuff
i18n <- Translator$new(translation_json_path="./lang/translation.json")
i18n$set_translation_language("de")

# UI-parts
source("./R/modules/exploration/explorationModules.R")
source("./R/modules/plotting/plottingModules.R")
source("./R/modules/modeling/modelingModules.R")
source("./R/modules/clustering/clusteringModules.R")


# Server
## session for changes of input-fields
server <- function(session, input, output) {
  
  #Warning for users on page reload or close
  #runjs("window.onbeforeunload = function(event){return confirm('Refreshing will cause iGOEGGO to reset your progress');};")
  
  #Reactivity data
  values = reactiveValues()
  
  values$bm_url = ""
  values$bm_dir = ""
  values$dataformat = ""
  values$dataset_is_grouped = FALSE
  
  #Exploration
  values$expl_num <- 0
  values$expl_selected_list <- c()
  values$expl_data_list <- c()
  #Plotting
  values$plot_num <- 0
  values$plot_selected_list <- c()
  values$plot_data_list <- c()
  #Model
  values$model_num <- 0
  values$model_selected_list <- c()
  values$model_data_list <- c()
  #cluster
  values$cluster_num <- 0
  values$cluster_selected_list <- c()
  values$cluster_data_list <- c()
  
  #Dictionary für Datensätze
  values$datasets <- hash()
  values$root_datasets <- hash()
  values$current_dataset <- ""
  
  
  #Download Handler für das Dataset
  output$download_active_dataset <- downloadHandler(filename = "dataset_from_igoeggo.csv", 
                                                    content = function(file) {
                                                      write.csv(values$data, file, row.names = FALSE)
                                                    })
  ## Language-Dialog
  i18n_ss <- reactive({
    selected = input$goeggo_lang
    if(length(selected) > 0 && selected %in% i18n$get_languages()) {
      i18n$set_translation_language(selected)
    }
    i18n
  })
  
  langModal <- function(failed = FALSE) {
    modalDialog(
      selectInput("goeggo_lang", "Language", choices = i18n$get_languages(), selected = i18n$get_key_translation(), selectize=FALSE),
      
      footer = tagList(
        modalButton("Cancel"),
        actionButton("chLangOK", "OK")
      )
    )
  }
  
  observeEvent(input$goeggo_lang, {
    update_lang(session, input$goeggo_lang)
    # print(session$clientData$url_protocol)
    removeModal()
  })
  
  observeEvent(input$changeLang, {
    showModal(langModal())
  })
 
  # Exclude von unnötigen Dingen
  setBookmarkExclude(c("user_input","cDatatype","cNameNew","verb","file1","file2","changeDatatype","changeColumnName","cName","cColumn","apply_operation","button_exploration_show","button_model_show","button_plotting_show","button_cluster_show","._bookmark_","getbm","exploration_mod1-export_plot","cluster_mod1-export_plot","plotting_mod1-export_plot","model_mod1-export_plot"))
  
  correcttype <- function(x) {
    output <- class(x)[1]
    if (class(x)[1] == "numeric") {
      output <- typeof(x)
    } else {
      output <- class(x)[1]
    }
    output
  }
  
  output$testtable <- renderDataTable({
    sketch = htmltools::withTags(table(
      tableHeader(values$data),
      # class wäre besser -> typeof = Workaround 
      tableFooter(sapply(values$data, correcttype))
    ))
    DT::datatable(values$data, container = sketch, options = list(scrollX = TRUE, dom = 'tip', pageLength = 5, 
                  rowCallback = JS(c(
                      "function(row, data){",
                      "  for(var i=0; i<data.length; i++){",
                      "    if(data[i] === null){",
                      "      $('td:eq('+i+')', row).html('NA')",
                      "        .css({'color': 'rgb(151,151,151)', 'font-style': 'italic'});",
                      "    }",
                      "  }",
                      "}"  
                    )
                  )), rownames = FALSE)
  }, server=TRUE)
  
  ## Bookmarking
  etlModal <- function(name) {
    modalDialog(
      p(id="d_name", paste("Datensatz: ", name)),
      # p(dir),
      checkboxInput("etl_str", "String-Spalten entfernen", value = TRUE, width = NULL),
      checkboxInput("etl_emp", "leere Spalten entfernen", value = TRUE, width = NULL),
      checkboxInput("etl_date", "Daten umwandeln", value = TRUE, width = NULL),
      checkboxInput("etl_time", "Uhrzeiten umwandeln", value = TRUE, width = NULL),
      # checkboxInput("etl_str", "String-Spalten entfernen", value = TRUE, width = NULL),
      # checkboxInput("etl_str", "String-Spalten entfernen", value = TRUE, width = NULL),

      footer = tagList(
        modalButton("Cancel"),
        actionButton("etlDataset", "Datensatz importieren")
      )
    )
  }
  
  dateformatModal <- function() {
    modalDialog(
      p(id="d_name", paste("Datensatz")),
      # p(dir),
      selectInput("dateformat", "Datum auswählen:",
                  list('EUR' = list("DD-MM-YY", "DD-MM-YYYY", "YYYY-MM-DD", "YY-MM-DD"),
                       'US' = list("MM-DD-YY"),
                       'Midwest' = list("MN", "WI", "IA"))
      ),
      textOutput("result"),
      
      footer = tagList(
        modalButton("Cancel"),
        actionButton("dateformatok", "Datensatz importieren")
      )
    )
  }
  
  ## etl - process
  source("./R/server/etl.R", local=TRUE)
  
  ## exploration
  source("./R/server/exploration.R", local=TRUE)
  
  ## plotting
  source("./R/server/plotting.R", local=TRUE)
  
  ## Modeling    
  source("./R/server/modeling.R", local=TRUE)
  
  
  ## Clustering    
  source("./R/server/clustering.R", local=TRUE)
  
  
  ## Renaming
  observeEvent(input$changeColumnName, {
    newName <- input$cNameNew
    # newName <- 'NeuTest'
    daten <- values$data %>% 
      rename(
        !!newName := input$cName
        # !!newName := mpg
      )
    values$data = daten
    
    updateSelectInput(session, "cName", choices = colnames(daten))
  })
  
  ## Anderes
  dataModal <- function(failed = FALSE, available) {
    modalDialog(
      textInput("factors", "Zuordnung festlegen",
                placeholder = 'Rot, Grün, Blau'
      ),
      span('Folgende Faktoren sind verfügbar: \n', available),
      if (failed)
        div(tags$b("Invalid name of data object", style = "color: red;")),
      
      footer = tagList(
        modalButton("Cancel"),
        actionButton("ok", "OK")
      )
    )
  }
  
  observeEvent(input$changeDatatype, {
    
    # print('echo')
    column <- input$cColumn
    datatype <- input$cDatatype
    daten = values$data
    # print(daten[,column])
    
    if (datatype == "character") {
      daten[,column] = as.character(daten[,column])
    } else if (datatype == "integer") {
      print(column)
      daten[,column] = as.integer(daten[,column])
    } else if (datatype == "factor") {
      different <- unique(daten[,column])
      showModal(dataModal(available = paste(different, collapse=', ')))
      # daten[,column] = as.character.factor(daten[,column])
    } else if (datatype == "double") {
      daten[,column] = as.double(daten[,column])
    }
    
    values$data = daten
    
    updateSelectInput(session, "cName", choices = colnames(daten))
    
    
    
  })
  
  
  observeEvent(input$ok, {
    
    print(input$factors)
    removeModal()
    
    daten = values$data
    column <- input$cColumn
    different <- unique(daten[,column])

    temp <- input$factors
    factors <- str_split(temp, ", ")
    # print(factors)
    
    make = TRUE
    if (make == TRUE) {
      for(i in different) {
        daten[,column][daten[,column] == i] <- factors[[1]][which(different==i)]
      } 
      
      print(head(daten))

      daten[,column] = as.factor(daten[,column])
      print(class(daten[,column]))
      print(typeof(daten[,column]))
      
      values$data = daten
      
      print(head(values$data))
      
      print(class(values$data[,column]))
      
      updateSelectInput(session, "cName", choices = colnames(daten))
      
      
    }
    
  })
  
  observeEvent(input$changeColumnNames, {
      
    colNames <- read.csv(input$file2$datapath, fileEncoding = "latin1", sep = ';')
    daten <- values$data
    print(colnames(colNames))
    for(i in 1:nrow(colNames)) {
      daten <- daten %>% 
        rename(
          !!colNames[,'new'][i] := !!colNames[,'old'][i]
        )
    }
    
    print(colnames(daten))
    
    values$data = daten
    
    updateSelectInput(session, "cName", choices = colnames(daten))
    
  })
  
                                                                                                            
  ## Transformation with UI
  source("./R/server/transformOnServer.R", local=TRUE)
  
  ## Bookmarking
  bookModal <- function(url) {
    values$bm_url = url
    modalDialog(
      textInput("bm_name", i18n$t("Bookmark - Bezeichnung")),
      textInput("bm_info", i18n$t("Bookmark - Beschreibung")),
      
      #verbatimTextOutput("bm_url"),
      #output$bm_url <- renderPrint({
      #  url
      #}),
      p(id = "bm_url", url),
      
      footer = tagList(
        actionButton("cancelBM", "Cancel"),
        actionButton("saveBM", "OK")
      )
    )
  }
  
  ## Bookmarking
  getBookmark <- function() {
    values$bm_url = url
    modalDialog(
      if (TRUE) {
        DTOutput("data")
      } else {
        p("Fehler")
      },
      textOutput('myText'),
      
      footer = tagList(
        modalButton("Cancel"),
        modalButton("Ok"),
      )
    )
  }
  
  df <- function() {
    ok <- FALSE
    try({
      con <- dbConnect(RSQLite::SQLite(), "database/database.db")
      ok <- TRUE
      dbval <- dbReadTable(con, "bookmarks")
    })
      
    if(ok && nrow(dbval)>0){
      con <- dbConnect(RSQLite::SQLite(), "database/database.db")
      dbval <- dbReadTable(con, "bookmarks")
      # print(length(dbval))
      host = session$clientData$url_hostname
      path = session$clientData$url_pathname
      port = session$clientData$url_port
      prot = session$clientData$url_protocol
      # print(nrow(dbval))
      for(i in 1:nrow(dbval)) {
        url <- param_get(dbval[i,"url"], c("_state_id_")) %>% pull("_state_id_")
        dbval$buttons[i] <- as.character(actionButton(inputId = paste('button_',i), label="Abrufen", onclick = paste("window.open('", gsub(" ", "", paste(prot, "//", host, ":", port, path, "?_state_id_=", url)), "', '_blank')")))
        # print(dbval$buttons[i])
        print(url)
      }
      dbDisconnect(con)
      #print((dbval[,'tag']))
      #print(nrow(buttons))
      # dbval$buttons <- buttons
      tibble(
        
        bez = dbval[,'tag'],
        info = dbval[,'info'],
        # url = dbval[,'url'],
        time = lubridate::as_datetime(dbval[,'time']),
        button = dbval[,'buttons']
        
        # parameters here:
        #   * actionButton - type of input to create
        #   * 5 - how many we need
        #   * 'button_' - the ID prefix
        #   * label - label to show on the button
        #   * onclick - what to do when clicked
        #Actions = shinyInput(
        #  FUN = actionButton,
        #  n = nrow(dbval),
        #  id = 'button_',
        #  label = "Abrufen",
        #  onclick ="window.open('http://google.com', '_blank')"
        # onclick = 'Shiny.setInputValue(\"select_button\", this.id, {priority: \"event\"})'
        #)
      )
    } else {
      shiny::showNotification("Noch keine Einträge", type = "message")
      removeModal()
      NULL
    }
  }
  
  
  output$data <- DT::renderDT(
    df(), server = FALSE, escape = FALSE, selection = 'none'
  )
  
  
  observeEvent(input$getbm, {
    showModal(getBookmark())
  })
  
  employee <- eventReactive(input$select_button, {
    # take the value of input$select_button, e.g. "button_1"
    # get the button number (1) and assign to selectedRow
    selectedRow <- as.numeric(strsplit(input$select_button, "_")[[1]][2])
    # print(selectedRow)
    # get the value of the "Name" column in the data.frame for that row
    # paste('click on ',df()[selectedRow,"time"])
    # print(df()[selectedRow,"url"] %>% pull(url))
    browseURL(df()[selectedRow,"url"] %>% pull(url), browser = getOption("browser"))
  })
  
  # Show the name of the employee that has been clicked on
  output$myText <- renderText({
    
    # employee()
    # "neues Fenster geöffnet"
    
  })
  
  source("./R/server/bookmarking.R", local=TRUE)
  
}

#Start 
shinyApp(ui = ui, server = server, enableBookmarking = "server")
