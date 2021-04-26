library(shiny)
require(gridExtra)
source("./R/functions/modeling/modelingFunctions.R")

# Linear Model
model_linear_ui <- function(id, data) {
  ns <- NS(id)
  
  tags$div(class = "appended_module", id = id,
           fluidRow(
             column(4, 
                    h3("Lineare Regression"),
                    selectInput(ns("y_var"), "y-Variable", choices = colnames(Filter(is.numeric, data))),
                    #box(title = "Einstellungen", solidHeader = TRUE, collapsible = TRUE, collapsed = TRUE, width = "100%",
                    #    checkboxInput(ns("mean_line"), "Linie am Mittelwert", value=FALSE)
                    #),
                    selectInput(ns("x_var"), "x-Variable", choices = colnames(Filter(is.numeric, data))),
                    #box(title = "Einstellungen", solidHeader = TRUE, collapsible = TRUE, collapsed = TRUE, width = "100%",
                    #    checkboxInput(ns("mean_line"), "Linie am Mittelwert", value=FALSE)
                    #),
                    
                    actionButton(ns("delete_module"), "Löschen", icon = icon("trash"), class = "btn-danger"),
                    actionButton(ns("create_model"), "Modell erstellen", class = "btn-success")
                    
             ),
             column(8, 
                    plotlyOutput(ns("linear_model")) %>% withSpinner(color="#0dc5c1")   
             )
           ),
           fluidRow(
             column(1,
                    p("")
             )
           ),
           fluidRow(
             column(4, offset = 4, 
                    h2("Lineare Regression - Koeffizienten"),
                    # Hier
                    verbatimTextOutput(ns("linear_coef")) %>% withSpinner(color="#0dc5c1"),
             ),
             column(4, 
                    p(""),
                    p(""),
                    p(""),
                    withMathJax(uiOutput(ns("linear_formel"))) %>% withSpinner(color="#0dc5c1")
             )
           )
           
  )
  
  
}

model_linear_server <- function(id, data) {
  data = data
  callModule(function(input, output, session) {
    
    observeEvent(input$create_model, {
      
      print('echo')
      ml = input$mean_line
      v = hv()
      
      output$linear_model <- renderPlotly({
        model_generate_linear(data, v, TRUE, input$x_var, input$y_var)
      })
      
      fit <- model_linear_coef(data, input$x_var, input$y_var)
      
      output$linear_coef <- renderPrint({
        summary(fit)
      })
      
      output$linear_formel <- renderUI({
        withMathJax(paste0("Regressionsfunktion: $$\\verb|", input$y_var, "|(\\verb|", input$x_var, "|)=", round(fit$coefficients[1],digits=2),  "+", round(fit$coefficients[2],digits=2), " \\cdot \\verb|", input$x_var ,"|$$"))
      })
    })
    
    hv <- reactive({
      input$x_var
    })
    
    
    observeEvent(input$delete_module, {
      removeUI(selector = paste0("#",id))
    })
  }, id)
}

# nichtlineares Modell
model_nonlinear_ui <- function(id, data) {
  ns <- NS(id)
  
  tags$div(class = "appended_module", id = id,
           fluidRow(
             column(4, 
                    h3("Nichtlineare Regression"),
                    selectInput(ns("y_var_non"), "y-Variable", choices = colnames(Filter(is.numeric, data))),
                    #box(title = "Einstellungen", solidHeader = TRUE, collapsible = TRUE, collapsed = TRUE, width = "100%",
                    #    checkboxInput(ns("mean_line"), "Linie am Mittelwert", value=FALSE)
                    #),
                    selectInput(ns("x_var_non"), "x-Variable", choices = colnames(Filter(is.numeric, data))),
                    #box(title = "Einstellungen", solidHeader = TRUE, collapsible = TRUE, collapsed = TRUE, width = "100%",
                    #    checkboxInput(ns("mean_line"), "Linie am Mittelwert", value=FALSE)
                    #),
                    numericInput(ns("grad"), "Grad:", 1, min = 1, max = 5),
                    #box(title = "Einstellungen", solidHeader = TRUE, collapsible = TRUE, collapsed = TRUE, width = "100%",
                    #    checkboxInput(ns("mean_line"), "Linie am Mittelwert", value=FALSE)
                    #),
                    
                    actionButton(ns("delete_module"), "Löschen", icon = icon("trash"), class = "btn-danger"),
                    actionButton(ns("create_nonlinear_model"), "Modell erstellen", class = "btn-success")
                    
             ),
             column(8, 
                    plotlyOutput(ns("nonlinear_model")) %>% withSpinner(color="#0dc5c1")   
             )
           ),
           fluidRow(
             column(1,
                    p("")
             )
           ),
           fluidRow(
             column(4, offset = 4, 
                    h2("Nichtlineare Regression - Koeffizienten"),
                    # Hier
                    verbatimTextOutput(ns("nonlinear_coef")) %>% withSpinner(color="#0dc5c1"),
             ),
             column(4, 
                    p(""),
                    p(""),
                    p(""),
                    withMathJax(uiOutput(ns("nonlinear_formel"))) %>% withSpinner(color="#0dc5c1")
             )
           )
           
  )
  
  
}

model_nonlinear_server <- function(id, data) {
  data = data
  callModule(function(input, output, session) {
    
    observeEvent(input$create_nonlinear_model, {
      
      print('echo')
      ml = input$mean_line
      v = hv()
      
      output$nonlinear_model <- renderPlotly({
        model_generate_nonlinear(data, v, TRUE, input$x_var_non, input$y_var_non, input$grad)
      })
      
      fit <- model_nonlinear_coef(data, input$x_var_non, input$y_var_non, input$grad)

      output$nonlinear_coef <- renderPrint({
        suppressWarnings(summary(fit))
      })
      
      output$nonlinear_formel <- renderUI({
        varstring <- ""
        for(i in 1:input$grad){
          varstring <- paste0(varstring, "+", round(fit$coefficients[i+1],digits=2), " \\cdot \\verb|", input$x_var_non, "|^", i)
        }
        withMathJax(paste0("Regressionsfunktion: $$\\verb|", input$y_var_non, "|(\\verb|", input$x_var_non, "|)=", round(fit$coefficients[1],digits=2), varstring ,"$$"))
      })
    })
    
    hv <- reactive({
      input$x_var
    })
    
    
    observeEvent(input$delete_module, {
      removeUI(selector = paste0("#",id))
    })
  }, id)
}

# exponentielles Modell
model_exponential_ui <- function(id, data) {
  ns <- NS(id)
  
  tags$div(class = "appended_module", id = id,
           fluidRow(
             column(4, 
                    h3("Exponentielle Regression"),
                    selectInput(ns("y_var_exp"), "y-Variable", choices = colnames(Filter(is.numeric, data))),
                    #box(title = "Einstellungen", solidHeader = TRUE, collapsible = TRUE, collapsed = TRUE, width = "100%",
                    #    checkboxInput(ns("mean_line"), "Linie am Mittelwert", value=FALSE)
                    #),
                    selectInput(ns("x_var_exp"), "x-Variable", choices = colnames(Filter(is.numeric, data))),
                    #box(title = "Einstellungen", solidHeader = TRUE, collapsible = TRUE, collapsed = TRUE, width = "100%",
                    #    checkboxInput(ns("mean_line"), "Linie am Mittelwert", value=FALSE)
                    #),
                    # numericInput(ns("grad"), "Grad:", 1, min = 1, max = 5),
                    #box(title = "Einstellungen", solidHeader = TRUE, collapsible = TRUE, collapsed = TRUE, width = "100%",
                    #    checkboxInput(ns("mean_line"), "Linie am Mittelwert", value=FALSE)
                    #),
                    
                    actionButton(ns("delete_module"), "Löschen", icon = icon("trash"), class = "btn-danger"),
                    actionButton(ns("create_exponential_model"), "Modell erstellen", class = "btn-success")
                    
             ),
             column(8, 
                    plotlyOutput(ns("exponential_model")) %>% withSpinner(color="#0dc5c1")   
             )
           ),
           fluidRow(
             column(1,
                    p("")
             )
           ),
           fluidRow(
             column(4, offset = 4, 
                    h2("Exponentielle Regression - Koeffizienten"),
                    # Hier
                    verbatimTextOutput(ns("exponential_coef")) %>% withSpinner(color="#0dc5c1"),
             ),
             column(4, 
                    p(""),
                    p(""),
                    p(""),
                    withMathJax(uiOutput(ns("exponential_formel"))) %>% withSpinner(color="#0dc5c1")
             )
           )
           
  )
  
  
}

model_exponential_server <- function(id, data) {
  data = data
  callModule(function(input, output, session) {
    
    observeEvent(input$create_exponential_model, {
      
      print('echo')
      ml = input$mean_line
      v = hv()
      
      output$exponential_model <- renderPlotly({
        model_generate_exponential(data, v, TRUE, input$x_var_exp, input$y_var_exp)
      })
      
      fit <- model_exponential_coef(data, input$x_var_exp, input$y_var_exp)

      output$exponential_coef <- renderPrint({
        suppressWarnings(summary(fit))
      })
      
      output$exponential_formel <- renderUI({
        # print(fit$coefficients[1])
        withMathJax(paste0("Regressionsfunktion: $$\\verb|", input$y_var_exp, "|(\\verb|", input$x_var_exp, "|)= ", round(coef(fit)[1],digits=2), " \\cdot e^{\\verb|", input$x_var_exp, '| \\cdot ', round(coef(fit)[2],digits=2), "}$$"))
        # withMathJax(paste0("Regressionsfunktion:"))
      })
    })
    
    hv <- reactive({
      input$x_var
    })
    
    
    observeEvent(input$delete_module, {
      removeUI(selector = paste0("#",id))
    })
  }, id)
}

# log Modell
model_log_ui <- function(id, data) {
  ns <- NS(id)
  
  tags$div(class = "appended_module", id = id,
           fluidRow(
             column(4, 
                    h3("Logarithmische Regression"),
                    selectInput(ns("y_var_log"), "y-Variable", choices = colnames(Filter(is.numeric, data))),
                    #box(title = "Einstellungen", solidHeader = TRUE, collapsible = TRUE, collapsed = TRUE, width = "100%",
                    #    checkboxInput(ns("mean_line"), "Linie am Mittelwert", value=FALSE)
                    #),
                    selectInput(ns("x_var_log"), "x-Variable", choices = colnames(Filter(is.numeric, data))),
                    #box(title = "Einstellungen", solidHeader = TRUE, collapsible = TRUE, collapsed = TRUE, width = "100%",
                    #    checkboxInput(ns("mean_line"), "Linie am Mittelwert", value=FALSE)
                    #),
                    # numericInput(ns("grad"), "Grad:", 1, min = 1, max = 5),
                    #box(title = "Einstellungen", solidHeader = TRUE, collapsible = TRUE, collapsed = TRUE, width = "100%",
                    #    checkboxInput(ns("mean_line"), "Linie am Mittelwert", value=FALSE)
                    #),
                    
                    actionButton(ns("delete_module"), "Löschen", icon = icon("trash"), class = "btn-danger"),
                    actionButton(ns("create_log_model"), "Modell erstellen", class = "btn-success")
                    
             ),
             column(8, 
                    plotlyOutput(ns("log_model")) %>% withSpinner(color="#0dc5c1")   
             )
           ),
           fluidRow(
             column(1,
                    p("")
             )
           ),
           fluidRow(
             column(4, offset = 4, 
                    h2("Logarithmische Regression - Koeffizienten"),
                    # Hier
                    verbatimTextOutput(ns("log_coef")) %>% withSpinner(color="#0dc5c1"),
             ),
             column(4, 
                    p(""),
                    p(""),
                    p(""),
                    withMathJax(uiOutput(ns("log_formel"))) %>% withSpinner(color="#0dc5c1")
             )
           )
           
  )
  
  
}

model_log_server <- function(id, data) {
  data = data
  callModule(function(input, output, session) {
    
    observeEvent(input$create_log_model, {
      
      print('echo')
      ml = input$mean_line
      v = hv()
      
      output$log_model <- renderPlotly({
        model_generate_log(data, v, TRUE, input$x_var_log, input$y_var_log)
      })
      
      fit <- model_log_coef(data, input$x_var_log, input$y_var_log)
      
      output$log_coef <- renderPrint({
        suppressWarnings(summary(fit))
      })
      
      output$log_formel <- renderUI({
        # print(fit$coefficients[1])
        withMathJax(paste0("Regressionsfunktion: $$\\verb|", input$y_var_log, "|(\\verb|", input$x_var_log, "|)= ", round(coef(fit)[1],digits=2), " \\cdot log(\\verb|", input$x_var_log, '|) + ', round(coef(fit)[2],digits=2),"$$"))
        # withMathJax(paste0("Regressionsfunktion:"))
      })
    })
    
    hv <- reactive({
      input$x_var
    })
    
    
    observeEvent(input$delete_module, {
      removeUI(selector = paste0("#",id))
    })
  }, id)
}