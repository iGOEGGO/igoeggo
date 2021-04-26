library(shiny)
require(gridExtra)
source("./R/functions/exploration/explorationFunctions.R")


# How to add a module
# Copy copy+pase one that exits and then
# - adjust ui and server name
# - add generate_plot function
# - update input and output names
# - update plot generating call in the export plot function
# - update var in reactive hv call


#      __  ___      __                                           
#     / / / (_)____/ /_____  ____ __________ _____ ___  ____ ___ 
#    / /_/ / / ___/ __/ __ \/ __ `/ ___/ __ `/ __ `__ \/ __ `__ \
#   / __  / (__  ) /_/ /_/ / /_/ / /  / /_/ / / / / / / / / / / /
#  /_/ /_/_/____/\__/\____/\__, /_/   \__,_/_/ /_/ /_/_/ /_/ /_/ 
#                         /____/                              
exploration_histogramm_ui <- function(id, data) {
  ns <- NS(id)
  
  tags$div(class = "appended_module", id = id,
    fluidRow(
      column(4, 
             h3("Histogramm"),
             selectInput(ns("hist_var"), "Auswahl der Spalte", choices = colnames(Filter(is.numeric, data))),
             box(title = "Einstellungen", solidHeader = TRUE, collapsible = TRUE, collapsed = TRUE, width = "100%",
                 sliderInput(ns("bin_count"), "Anzahl der Boxen", min = 1, max = 30, value = 15, step = 1),
                 checkboxInput(ns("mean_line"), "Linie am Mittelwert", value=FALSE),
                 checkboxInput(ns("median_line"), "Linie am Median", value=FALSE),
                 checkboxInput(ns("density"), "Density einblenden", value=FALSE)
             ),
             
             actionButton(ns("delete_module"), "Löschen", icon = icon("trash"), class = "btn-danger"),
             actionButton(ns("export_plot"), "Exportieren", icon = icon("file-export"), class = "btn-success"),
             actionButton(ns("plot"), "Plot", class = "btn-success")
             
      ),
      column(8, 
             plotOutput(ns("hist_plot")) %>% withSpinner(color="#0dc5c1")   
      )
    )
 )
  
                 
}

exploration_histogramm_server <- function(id, data) {
  data = data
  callModule(function(input, output, session) {
    
    observeEvent(input$plot, {
      
      bc = input$bin_count
      ml = input$mean_line
      medline = input$median_line
      density = input$density
      v = hv()
      
      output$hist_plot <- renderPlot({
        exploration_generate_hist(data, v, bc, ml, medline, density)
      })
    })
    
    hv <- reactive({
      input$hist_var
    })
  

    
    observeEvent(input$delete_module, {
      removeUI(selector = paste0("#",id))
    })
    
    export_modal <- function() {
      ns <- NS(id)
      modalDialog(title = "export Plot", easyClose = TRUE, 
                  numericInput(ns("export_width"), "Breite (cm) (max. 20)", min = 1, max = 20, value = 16),
                  numericInput(ns("export_height"), "Höhe (cm) (max. 20)", min = 1, max = 20, value = 9),
                  textOutput(ns("tw")),
                  textOutput(ns("th")),
                  actionButton(ns("update"), "Größe aktualisieren"),
                  downloadButton(ns("export_save_plot"), "Plot speichern", class = "btn-success", icon = icon("download"))
      )
    }
    observeEvent(input$export_plot, {
      showModal(export_modal())
    })
    
    observeEvent(input$update, {
      output$tw <- renderText(paste0("Breite: ", input$export_width, "cm"))
      output$th <- renderText(paste0("Höhe: ", input$export_height, "cm"))
      output$export_save_plot <- plot_downloader("histogram_from_igoeggo.png", exploration_generate_hist(data, hv(), input$bin_count, input$mean_line, input$median_line, input$density), input$export_width, input$export_height)
    })

    output$tw <- renderText(paste0("Breite: 16cm"))
    output$th <- renderText(paste0("Höhe: 9cm"))
    output$export_save_plot <- plot_downloader("histogram_from_igoeggo.png", exploration_generate_hist(data, hv(), input$bin_count, input$mean_line, input$median_line, input$density), input$export_width, input$export_height)
    
    
  }, id)
}

#      ____                   __      __ 
#     / __ )____  _  ______  / /___  / /_
#    / __  / __ \| |/_/ __ \/ / __ \/ __/
#   / /_/ / /_/ />  </ /_/ / / /_/ / /_  
#  /_____/\____/_/|_/ .___/_/\____/\__/  
#                  /_/                
exploration_boxplot_ui <- function(id, data) {
  ns <- NS(id)
  tags$div(class = "appended_module", id = id,
           fluidRow(
             column(4, 
                    h3("Boxplot"),
                    selectInput(ns("box_var"), "Auswahl der Spalte", choices = colnames(Filter(is.numeric, data))),
                    box(title = "Einstellungen", solidHeader = TRUE, collapsible = TRUE, collapsed = TRUE, width = "100%",
                        checkboxInput(ns("mean_line"), "Linie am Mittelwert", value=FALSE)
                    ),
                    
                    actionButton(ns("delete_module"), "Löschen", icon = icon("trash"), class = "btn-danger"),
                    actionButton(ns("export_plot"), "Exportieren", icon = icon("file-export"), class = "btn-success"),
                    actionButton(ns("plot"), "Plot", class = "btn-success")
                    
             ),
             column(8, 
                    plotOutput(ns("box_plot")) %>% withSpinner(color="#0dc5c1")  
             )
           )
  )
  
  
}

exploration_boxplot_server <- function(id, data) {
  data = data
  callModule(function(input, output, session) {
    
    observeEvent(input$plot, {
      
      ml = input$mean_line
      v = hv()
      output$box_plot <- renderPlot({
        exploration_generate_boxplot(data, v, ml)
      })
    })
    
    hv <- reactive({
      input$box_var
    })
    
    
    observeEvent(input$delete_module, {
      removeUI(selector = paste0("#",id))
    })
    
    
    export_modal <- function() {
      ns <- NS(id)
      modalDialog(title = "export Plot", easyClose = TRUE, 
                  numericInput(ns("export_width"), "Breite (cm) (max. 20)", min = 1, max = 20, value = 16),
                  numericInput(ns("export_height"), "Höhe (cm) (max. 20)", min = 1, max = 20, value = 9),
                  textOutput(ns("tw")),
                  textOutput(ns("th")),
                  actionButton(ns("update"), "Größe aktualisieren"),
                  downloadButton(ns("export_save_plot"), "Plot speichern", class = "btn-success", icon = icon("download"))
      )
    }
    observeEvent(input$export_plot, {
      showModal(export_modal())
    })
    
    observeEvent(input$update, {
      output$tw <- renderText(paste0("Breite: ", input$export_width, "cm"))
      output$th <- renderText(paste0("Höhe: ", input$export_height, "cm"))
      output$export_save_plot <- plot_downloader("boxplot_from_igoeggo.png", exploration_generate_boxplot(data, hv(), input$mean_line), input$export_width, input$export_height)
    })
    
    output$tw <- renderText(paste0("Breite: 16cm"))
    output$th <- renderText(paste0("Höhe: 9cm"))
    output$export_save_plot <- plot_downloader("boxplot_from_igoeggo.png", exploration_generate_boxplot(data, hv(), input$mean_line), input$export_width, input$export_height)
  }, id)
}

#      __________  ____________
#     / ____/ __ \/ ____/ ____/
#    / __/ / / / / /   / /_    
#   / /___/ /_/ / /___/ __/    
#  /_____/_____/\____/_/       
#                         
exploration_ecdf_ui <- function(id, data, i18n) {
  ns <- NS(id)
  
  tags$div(class = "appended_module", id = id,
           fluidRow(
             column(4, 
                    h3("ECDF"),
                    selectInput(ns("ecdf_var"), "Bitte wählen Sie eine Spalte", choices = colnames(Filter(is.numeric, data))),
                    actionButton(ns("delete_module"), "Löschen", icon = icon("trash"), class = "btn-danger"),
                    actionButton(ns("export_plot"), "Exportieren", icon = icon("file-export"), class = "btn-success"),
                    actionButton(ns("plot"), "Plot", class = "btn-success")
                    
             ),
             column(8, 
                    plotOutput(ns("ecdf_plot")) %>% withSpinner(color="#0dc5c1")  
             )
           )
  )
  
  
}

exploration_ecdf_server <- function(id, data) {
  data = data
  callModule(function(input, output, session) {
    
    observeEvent(input$plot, {
      
      v = hv()
      
      output$ecdf_plot <- renderPlot({
        exploration_generate_ecdf(data, v)
      })
    })
    
    
    hv <- reactive({
      input$ecdf_var
    })
    
    observeEvent(input$delete_module, {
      removeUI(selector = paste0("#",id))
    })
    
    export_modal <- function() {
      ns <- NS(id)
      modalDialog(title = "export Plot", easyClose = TRUE, 
                  numericInput(ns("export_width"), "Breite (cm) (max. 20)", min = 1, max = 20, value = 16),
                  numericInput(ns("export_height"), "Höhe (cm) (max. 20)", min = 1, max = 20, value = 9),
                  textOutput(ns("tw")),
                  textOutput(ns("th")),
                  actionButton(ns("update"), "Größe aktualisieren"),
                  downloadButton(ns("export_save_plot"), "Plot speichern", class = "btn-success", icon = icon("download"))
      )
    }
    observeEvent(input$export_plot, {
      showModal(export_modal())
    })
    
    observeEvent(input$update, {
      output$tw <- renderText(paste0("Breite: ", input$export_width, "cm"))
      output$th <- renderText(paste0("Höhe: ", input$export_height, "cm"))
      output$export_save_plot <- plot_downloader("ecdf_from_igoeggo.png", exploration_generate_ecdf(data, hv()), input$export_width, input$export_height)
    })
    
    output$tw <- renderText(paste0("Breite: 16cm"))
    output$th <- renderText(paste0("Höhe: 9cm"))
    output$export_save_plot <- plot_downloader("ecdf_from_igoeggo.png", exploration_generate_ecdf(data, hv()), input$export_width, input$export_height)
  }, id)
}


#     ____        ____        ____  __    ____  ______
#    / __ \      / __ \      / __ \/ /   / __ \/_  __/
#   / / / /_____/ / / /     / /_/ / /   / / / / / /   
#  / /_/ /_____/ /_/ /     / ____/ /___/ /_/ / / /    
#  \___\_\     \___\_\    /_/   /_____/\____/ /_/     
#                                                 
exploration_qq_ui <- function(id, data) {
  ns <- NS(id)
  
  tags$div(class = "appended_module", id = id,
           fluidRow(
             column(4, 
                    h3("QQ-Plot"),
                    selectInput(ns("qq_var"), "Auswahl der Spalte", choices = colnames(Filter(is.numeric, data))),
                    actionButton(ns("delete_module"), "Löschen", icon = icon("trash"), class = "btn-danger"),
                    actionButton(ns("export_plot"), "Exportieren", icon = icon("file-export"), class = "btn-success"),
                    actionButton(ns("plot"), "Plot", class = "btn-success")
                    
             ),
             column(8, 
                    plotOutput(ns("qq_plot")) %>% withSpinner(color="#0dc5c1")  
             )
           )
  )
  
  
}

exploration_qq_server <- function(id, data) {
  data = data
  callModule(function(input, output, session) {
    
    observeEvent(input$plot, {
      
      v = hv()
      
      output$qq_plot <- renderPlot({
        exploration_generate_qq(data, v)
      })
    })
    
    
    hv <- reactive({
      input$qq_var
    })

    
    observeEvent(input$delete_module, {
      removeUI(selector = paste0("#",id))
    })
    
    
    export_modal <- function() {
      ns <- NS(id)
      modalDialog(title = "export Plot", easyClose = TRUE, 
                  numericInput(ns("export_width"), "Breite (cm) (max. 20)", min = 1, max = 20, value = 16),
                  numericInput(ns("export_height"), "Höhe (cm) (max. 20)", min = 1, max = 20, value = 9),
                  textOutput(ns("tw")),
                  textOutput(ns("th")),
                  actionButton(ns("update"), "Größe aktualisieren"),
                  downloadButton(ns("export_save_plot"), "Plot speichern", class = "btn-success", icon = icon("download"))
      )
    }
    observeEvent(input$export_plot, {
      showModal(export_modal())
    })
    
    observeEvent(input$update, {
      output$tw <- renderText(paste0("Breite: ", input$export_width, "cm"))
      output$th <- renderText(paste0("Höhe: ", input$export_height, "cm"))
      output$export_save_plot <- plot_downloader("qqplot_from_igoeggo.png", exploration_generate_qq(data, hv()), input$export_width, input$export_height)
    })
    
    output$tw <- renderText(paste0("Breite: 16cm"))
    output$th <- renderText(paste0("Höhe: 9cm"))
    output$export_save_plot <- plot_downloader("qqplot_from_igoeggo.png", exploration_generate_qq(data, hv()), input$export_width, input$export_height)
  }, id)
}

#   _    ___                       ____  __      __     ___               _      __    __ 
#  | |  / (_)__  _____            / __ \/ /___  / /_   /   |  ____  _____(_)____/ /_  / /_
#  | | / / / _ \/ ___/  ______   / /_/ / / __ \/ __/  / /| | / __ \/ ___/ / ___/ __ \/ __/
#  | |/ / /  __/ /     /_____/  / ____/ / /_/ / /_   / ___ |/ / / (__  ) / /__/ / / / /_  
#  |___/_/\___/_/              /_/   /_/\____/\__/  /_/  |_/_/ /_/____/_/\___/_/ /_/\__/
exploration_fp_ui <- function(id, data) {
  ns <- NS(id)
  
  tags$div(class = "appended_module", id = id,
           fluidRow(
             column(4, 
                    h3("Vierplotansicht"),
                    selectInput(ns("fp_var"), "Auswahl der Spalte", choices = colnames(Filter(is.numeric, data))),
                    actionButton(ns("delete_module"), "Löschen", icon = icon("trash"), class = "btn-danger"),
                    actionButton(ns("export_plot"), "Exportieren", icon = icon("file-export"), class = "btn-success"),
                    actionButton(ns("plot"), "Plot", class = "btn-success")
                    
             ),
             column(8, 
                    plotOutput(ns("fp_plot")) %>% withSpinner(color="#0dc5c1")  
             )
           )
  )
  
  
}

exploration_fp_server <- function(id, data) {
  data = data
  callModule(function(input, output, session) {
    
    observeEvent(input$plot, {
      
      v = hv()
      
      output$fp_plot <- renderPlot({
        exploration_generate_fp(data, v)
      })
    })
    
    
    hv <- reactive({
      input$fp_var
    })
    
    observeEvent(input$delete_module, {
      removeUI(selector = paste0("#",id))
    })
    
    
    export_modal <- function() {
      ns <- NS(id)
      modalDialog(title = "export Plot", easyClose = TRUE, 
                  numericInput(ns("export_width"), "Breite (cm) (max. 20)", min = 1, max = 20, value = 16),
                  numericInput(ns("export_height"), "Höhe (cm) (max. 20)", min = 1, max = 20, value = 9),
                  textOutput(ns("tw")),
                  textOutput(ns("th")),
                  actionButton(ns("update"), "Update size"),
                  downloadButton(ns("export_save_plot"), "Plot speichern", class = "btn-success", icon = icon("download"))
      )
    }
    observeEvent(input$export_plot, {
      showModal(export_modal())
    })
    
    observeEvent(input$update, {
      output$tw <- renderText(paste0("Breite: ", input$export_width, "cm"))
      output$th <- renderText(paste0("Höhe: ", input$export_height, "cm"))
      output$export_save_plot <- plot_downloader("four_plot_exploration_from_igoeggo.png", exploration_generate_fp(data, hv()), input$export_width, input$export_height)
    })
    
    output$tw <- renderText(paste0("Breite: 16cm"))
    output$th <- renderText(paste0("Höhe: 9cm"))
    output$export_save_plot <- plot_downloader("four_plot_exploration_from_igoeggo.png", exploration_generate_fp(data, hv()), input$export_width, input$export_height)
  }, id)
}







