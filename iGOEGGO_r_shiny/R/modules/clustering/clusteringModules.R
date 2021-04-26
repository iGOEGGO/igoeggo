library(shiny)
require(gridExtra)
source("./R/functions/clustering/clusteringFunctions.R")

# How to add a module
# Copy copy+pase one that exits and then
# - adjust ui and server name
# - add generate_plot function
# - update input and output names
# - update plot generating call in the export plot function
# - update var in reactive hv call

cluster_ui <- function(id, data) {
  ns <- NS(id)
  
  tags$div(class = "appended_module", id = id,
           fluidRow(
             column(4, 
                    h3("Clusteranalyse"),
                    selectInput(ns("y_var"), "y-Variable", choices = colnames(Filter(is.numeric, data))),
                    #box(title = "Einstellungen", solidHeader = TRUE, collapsible = TRUE, collapsed = TRUE, width = "100%",
                    #    checkboxInput(ns("mean_line"), "Linie am Mittelwert", value=FALSE)
                    #),
                    selectInput(ns("x_var"), "x-Variable", choices = colnames(Filter(is.numeric, data))),
                    #box(title = "Einstellungen", solidHeader = TRUE, collapsible = TRUE, collapsed = TRUE, width = "100%",
                    #    checkboxInput(ns("mean_line"), "Linie am Mittelwert", value=FALSE)
                    #),
                    
                    actionButton(ns("delete_module"), "Löschen", icon = icon("trash"), class = "btn-danger"),
                    actionButton(ns("export_plot"), "Exportieren", icon = icon("file-export"), class = "btn-success"),
                    actionButton(ns("create_cluster"), "Modell erstellen", class = "btn-success")
                    
             ),
             column(8, 
                    plotlyOutput(ns("cluster")) %>% withSpinner(color="#0dc5c1")   
             )
           ),
           
  )
  
  
}

cluster_server <- function(id, data) {
  data = data
  callModule(function(input, output, session) {
    
    observeEvent(input$create_cluster, {
      
      print('echo')
      ml = input$mean_line
      v = hv()
      
      output$cluster <- renderPlotly({
        cluster_generate(data, v, TRUE, input$x_var, input$y_var)
      })
    })
    
    hv <- reactive({
      input$x_var
    })
    
    
    observeEvent(input$delete_module, {
      removeUI(selector = paste0("#",id))
    })
    
      export_modal <- function() {
      ns <- NS(id)
      modalDialog(title = "Export Plot", easyClose = TRUE, 
                  numericInput(ns("export_width"), "Breite (cm)", min = 1, max = 20, value = 16),
                  numericInput(ns("export_height"), "Höhe (cm)", min = 1, max = 20, value = 9),
                  downloadButton(ns("export_save_plot"), "Plot speichern", class = "btn-success", icon = icon("download"))
      )
    }
    observeEvent(input$export_plot, {
      showModal(export_modal())
    })
    output$export_save_plot <- plot_downloader("boxplot_from_igoeggo.png", exploration_generate_boxplot(data, hv(), input$mean_line), input$export_width, input$export_height)
    
  }, id)
}


## richtige Clusteranalyse
cluster_analysis_ui <- function(id, data) {
  ns <- NS(id)
  
  tags$div(class = "appended_module", id = id,
           fluidRow(
             column(4, 
                    h3("Clusteranalyse"),
                    selectInput(ns("y_var_analysis"), "y-Variable", choices = colnames(Filter(is.numeric, data))),
                    #box(title = "Einstellungen", solidHeader = TRUE, collapsible = TRUE, collapsed = TRUE, width = "100%",
                    #    checkboxInput(ns("mean_line"), "Linie am Mittelwert", value=FALSE)
                    #),
                    selectInput(ns("x_var_analysis"), "x-Variable", choices = colnames(Filter(is.numeric, data))),
                    #box(title = "Einstellungen", solidHeader = TRUE, collapsible = TRUE, collapsed = TRUE, width = "100%",
                    #    checkboxInput(ns("mean_line"), "Linie am Mittelwert", value=FALSE)
                    #),
                    numericInput(ns("k"), "Clusteranzahl:", 1, min = 1, max = 6),
                    
                    actionButton(ns("delete_module"), "Löschen", icon = icon("trash"), class = "btn-danger"),
                    actionButton(ns("export_plot"), "Exportieren", icon = icon("file-export"), class = "btn-success"),
                    actionButton(ns("create_cluster_analysis"), "Modell erstellen", class = "btn-success")
                    
             ),
             column(8, 
                    plotOutput(ns("cluster_analysis_2")) %>% withSpinner(color="#0dc5c1")   
             )
           ),
           fluidRow(
             column(1,
                    p("")
             )
           ),
           fluidRow(
             column(8, offset = 4, 
                    plotOutput(ns("cluster_analysis_1")) %>% withSpinner(color="#0dc5c1") 
             ),
             
           )
           
  )
  
  
}

cluster_analysis_server <- function(id, data) {
  data = data
  callModule(function(input, output, session) {
    
    observeEvent(input$create_cluster_analysis, {
      
      print('echo')
      ml = input$mean_line
      v = hv()
      
      output$cluster_analysis_1 <- renderPlot({
        cluster_analysis_generate(data, v, TRUE, input$x_var_analysis, input$y_var_analysis, input$k)
      })
      
      output$cluster_analysis_2 <- renderPlot({
        cluster_analysis_generate_more(data, v, TRUE, input$x_var_analysis, input$y_var_analysis)
      })
    })
    
    hv <- reactive({
      input$x_var
    })
    
    
    observeEvent(input$delete_module, {
      removeUI(selector = paste0("#",id))
    })
    
    export_modal <- function() {
      ns <- NS(id)
      modalDialog(title = "Export Plot", easyClose = TRUE, 
                  numericInput(ns("export_width"), "Breite (cm)", min = 1, max = 20, value = 16),
                  numericInput(ns("export_height"), "Höhe (cm)", min = 1, max = 20, value = 9),
                  downloadButton(ns("export_save_plot"), "Plot speichern", class = "btn-success", icon = icon("download"))
      )
    }
    observeEvent(input$export_plot, {
      showModal(export_modal())
    })
    output$export_save_plot <- plot_downloader("cluster_analyse_from_igoeggo.png", exploration_generate_boxplot(data, hv(), input$mean_line), input$export_width, input$export_height)
    
  }, id)
}




