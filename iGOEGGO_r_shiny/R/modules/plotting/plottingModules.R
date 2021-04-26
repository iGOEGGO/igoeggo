source("./R/functions/plotting/plottingFunctions.R")

#     _____            __  __                  __      __ 
#    / ___/_________ _/ /_/ /____  _________  / /___  / /_
#    \__ \/ ___/ __ `/ __/ __/ _ \/ ___/ __ \/ / __ \/ __/
#   ___/ / /__/ /_/ / /_/ /_/  __/ /  / /_/ / / /_/ / /_  
#  /____/\___/\__,_/\__/\__/\___/_/  / .___/_/\____/\__/  
#                                   /_/                  
plotting_scatter_ui <- function(id, data) {
  ns <- NS(id)
  
  dcn = colnames(data)
  
  
  num_cols = dcn[unlist(lapply(data, is.numeric))]
  fac_cols = dcn[unlist(lapply(data, is.factor))]
  
  tags$div(class = "appended_module", id = id,
           fluidRow(
             column(4, 
                    h3("Scatterplot"),
                    selectInput(ns("scatter_x_var"), "X", choices = dcn),
                    selectInput(ns("scatter_y_var"), "Y", choices = dcn),
                    
                    
                    box(title = "Einstellungen", solidHeader = TRUE, collapsible = TRUE, collapsed = TRUE, width = "100%",
                        selectInput(ns("shape"), "Form", choices = append(NCS, fac_cols)),
                        selectInput(ns("color"), "Farbe", choices = append(NCS, fac_cols)),
                        selectInput(ns("size"), "Ausdehnung", choices = append(NCS, num_cols)),
                        checkboxInput(ns("logx"), "log x", value=FALSE),
                        checkboxInput(ns("logy"), "log y", value=FALSE),
                        sliderInput(ns("alpha"), "Deckkraft", min=0, max = 1, value = 1, step = 0.05)
                    ),
                    
                    actionButton(ns("delete_module"), "Löschen", icon = icon("trash"), class = "btn-danger"),
                    actionButton(ns("export_plot"), "Exportieren", icon = icon("file-export"), class = "btn-success"),
                    actionButton(ns("plot"), "Plot", class = "btn-success")
                    
             ),
  
             column(8, 
                    plotOutput(ns("scatter_plot")) %>% withSpinner(color="#0dc5c1")   
             )
           )
        )
}

plotting_scatter_server <- function(id, data) {
  data = data
  callModule(function(input, output, session) {
    
    observeEvent(input$plot, {
      
      xv = input$scatter_x_var
      yv = input$scatter_y_var
      shape = input$shape 
      color = input$color
      size = input$size
      alpha = input$alpha
      logx = input$logx
      logy = input$logy
      
      output$scatter_plot <- renderPlot({
        plotting_generate_scatterplot(data, xv, yv, shape, size, color, alpha, logx, logy)
      })
    })
    
    
    
    observeEvent(input$delete_module, {
      removeUI(selector = paste0("#",id))
    })
    
    export_modal <- function() {
      ns <- NS(id)
      modalDialog(title = "Exportieren Plot", easyClose = TRUE, 
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
      output$export_save_plot <- plot_downloader("scatterplot_exploration_from_igoeggo.png", plotting_generate_scatterplot(data, input$scatter_x_var, input$scatter_y_var, input$shape, input$size, input$color, input$alpha, input$logx, input$logy), input$export_width, input$export_height)
    })
    
    output$tw <- renderText(paste0("Breite: 16cm"))
    output$th <- renderText(paste0("Höhe: 9cm"))
    output$export_save_plot <- plot_downloader("scatterplot_exploration_from_igoeggo.png", plotting_generate_scatterplot(data, input$scatter_x_var, input$scatter_y_var, input$shape, input$size, input$color, input$alpha, input$logx, input$logy), input$export_width, input$export_height)
  }, id)
}


#      __  ___                 _         ____  __      __     
#     /  |/  /___  _________ _(_)____   / __ \/ /___  / /_    
#    / /|_/ / __ \/ ___/ __ `/ / ___/  / /_/ / / __ \/ __/    
#   / /  / / /_/ (__  ) /_/ / / /__   / ____/ / /_/ / /_      
#  /_/  /_/\____/____/\__,_/_/\___/  /_/   /_/\____/\__/      
#                                                             
plotting_mosaic_ui <- function(id, data) {
  ns <- NS(id)
  
  dcn = colnames(data)
  
  tags$div(class = "appended_module", id = id,
           fluidRow(
             column(4, 
                    h3("Mosaic"),
                    selectInput(ns("mosaic_vars"), "Mosaic Variablen (2-5)", choices = dcn, multiple = TRUE),
                    
                    actionButton(ns("delete_module"), "Löschen", icon = icon("trash"), class = "btn-danger"),
                    actionButton(ns("export_plot"), "Exportieren", icon = icon("file-export"), class = "btn-success"),
                    actionButton(ns("plot"), "Plot", class = "btn-success")
                    
             ),
             
             column(8, 
                    plotOutput(ns("mosaic_plot")) %>% withSpinner(color="#0dc5c1")  
             )
           )
  )
}

plotting_mosaic_server <- function(id, data) {
  data = data
  callModule(function(input, output, session) {
    
    observeEvent(input$plot, {
      
      cols = input$mosaic_vars
      
      output$mosaic_plot <- renderPlot({
        plotting_generate_mosaic(data, cols)
      })
    })
    
    
    
    observeEvent(input$delete_module, {
      removeUI(selector = paste0("#",id))
    })
    
    
    export_modal <- function() {
      ns <- NS(id)
      modalDialog(title = "Exportieren Plot", easyClose = TRUE, 
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
      output$export_save_plot <- plot_downloader("mosaicplot_from_igoeggo.png", plotting_generate_mosaic(data, input$mosaic_vars), input$export_width, input$export_height)
    })
    
    output$tw <- renderText(paste0("Breite: 16cm"))
    output$th <- renderText(paste0("Höhe: 9cm"))
    output$export_save_plot <- plot_downloader("mosaicplot_from_igoeggo.png", plotting_generate_mosaic(data, input$mosaic_vars), input$export_width, input$export_height)
  }, id)
}



#      __  ___   _       _____       __        _ __           
#     / / / (_)_(_)_  __/ __(_)___ _/ /_____  (_) /____  ____ 
#    / /_/ / __ `/ / / / /_/ / __ `/ //_/ _ \/ / __/ _ \/ __ \
#   / __  / /_/ / /_/ / __/ / /_/ / ,< /  __/ / /_/  __/ / / /
#  /_/ /_/\__,_/\__,_/_/ /_/\__, /_/|_|\___/_/\__/\___/_/ /_/ 
#                          /____/ 
plotting_haeufigkeiten_ui <- function(id, data) {
  ns <- NS(id)
  
  dcn = colnames(data)
  
  tags$div(class = "appended_module", id = id,
           fluidRow(
             column(4, 
                    h3("Häufigkeiten"),
                    selectInput(ns("kat"), "Kategorie", choices = dcn),
                    selectInput(ns("height"), "Wert", choices = dcn),
                    
                    box(title = "Einstellungen", solidHeader = TRUE, collapsible = TRUE, collapsed = TRUE, width = "100%",
                        radioButtons(ns("mode"), label = h3("Modus wählen"),
                                     choices = list("Absolut" = 1, "Prozent" = 2, "Relativ"= 3), 
                                     selected = 1),
                        checkboxInput(ns("pie"), "Als Kreisdiagramm darstellen", value = FALSE, width = NULL)
                        
                    ),
                    
                    actionButton(ns("delete_module"), "Löschen", icon = icon("trash"), class = "btn-danger"),
                    actionButton(ns("plot"), "Plot", class = "btn-success")
                    
             ),
             
             column(8, 
                    plotlyOutput(ns("haeufigkeiten_plot")) %>% withSpinner(color="#0dc5c1")   
             )
           )
  )
}

plotting_haeufigkeiten_server <- function(id, data) {
  data = data
  callModule(function(input, output, session) {
    
    observeEvent(input$pie, {
      if(input$pie) {
        disable("mode")
      } 
      
      if(!input$pie) {
        enable("mode")
      }
    })
    
    observeEvent(input$plot, {
      
      kat = input$kat
      val = input$height
      mode = input$mode 
      pie = input$pie
      
      output$haeufigkeiten_plot <- renderPlotly({
        plotting_generate_haeufigkeiten(data, kat, val, mode, pie)
      })
    })
    
    
    
    observeEvent(input$delete_module, {
      removeUI(selector = paste0("#",id))
    })
  }, id)
}

#      __    _                  __      __ 
#     / /   (_)___  ___  ____  / /___  / /_
#    / /   / / __ \/ _ \/ __ \/ / __ \/ __/
#   / /___/ / / / /  __/ /_/ / / /_/ / /_  
#  /_____/_/_/ /_/\___/ .___/_/\____/\__/  
#                    /_/  
plotting_lineplot_ui <- function(id, data) {
  ns <- NS(id)
  
  dcn = colnames(data)
  
  tags$div(class = "appended_module", id = id,
           fluidRow(
             column(4, 
                    h3("Lineplot"),
                    selectInput(ns("y"), "Y-Wert", choices = dcn),
                    selectInput(ns("time"), "Zeit", choices = dcn),
                    
                    
                    actionButton(ns("delete_module"), "Löschen", icon = icon("trash"), class = "btn-danger"),
                    actionButton(ns("plot"), "Plot", class = "btn-success")
                    
             ),
             
             column(8, 
                    plotlyOutput(ns("lineplot")) %>% withSpinner(color="#0dc5c1")   
             )
           )
  )
}

plotting_lineplot_server <- function(id, data) {
  data = data
  callModule(function(input, output, session) {
    
    observeEvent(input$plot, {
      
      y = input$y
      time = input$time
      
      output$lineplot <- renderPlotly({
        plotting_generate_lineplot(data, time, y)
      })
    })
    
    observeEvent(input$delete_module, {
      removeUI(selector = paste0("#",id))
    })
  }, id)
}




# Scatterplot Correlationplot
plotting_corrplot_ui <- function(id, data) {
  ns <- NS(id)
  
  #only numeric cols allowed
  dcn = colnames(data)[unlist(lapply(data, is.numeric))]
  
  tags$div(class = "appended_module", id = id,
           fluidRow(
             column(4, 
                    h3("Korrelogramm"),
                    selectInput(ns("corr_vars"), "Variablen", choices = dcn, multiple = TRUE),
                    
                    actionButton(ns("delete_module"), "Löschen", icon = icon("trash"), class = "btn-danger"),
                    actionButton(ns("plot"), "Plot", class = "btn-success")
                    
             ),
             
             column(8, 
                    plotOutput(ns("corrplot")) %>% withSpinner(color="#0dc5c1")   
             )
           )
  )
}

plotting_corrplot_server <- function(id, data) {
  data = data
  callModule(function(input, output, session) {
    
    observeEvent(input$plot, {
      
      corr_vars = input$corr_vars
      output$corrplot <- renderPlot({
        plotting_generate_corrplot(data, corr_vars)
      })
    })
    
    observeEvent(input$delete_module, {
      removeUI(selector = paste0("#",id))
    })
  }, id)
}


