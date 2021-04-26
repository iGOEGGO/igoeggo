#UI-Elemente
sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem(TAB_0_NAME, tabName = TAB_0_TABNAME, icon = icon(TAB_0_ICON)),
    menuItem(TAB_1_NAME, tabName = TAB_1_TABNAME, icon = icon(TAB_1_ICON)),
    menuItem(TAB_2_NAME, tabName = TAB_2_TABNAME, icon = icon(TAB_2_ICON)),
    menuItem(TAB_3_NAME, tabName = TAB_3_TABNAME, icon = icon(TAB_3_ICON)),
    # menuItem(TAB_4_NAME, tabName = TAB_4_TABNAME, icon = icon(TAB_4_ICON)),
    menuItem(TAB_5_NAME, tabName = TAB_5_TABNAME, icon = icon(TAB_5_ICON))
    # menuItem("Transformation", tabName = "Transformation", icon = icon(TAB_0_ICON))
  )
)
# ----------------------------------------------------

dbHeader <- dashboardHeader(title = "test")
dbHeader$children[[2]]$children <-  tags$a("Test neu", href='http://www.google.com')

notificationItemWithAttr <- function(text, icon = shiny::icon("question-circle"), status = "success", href = NULL) {
  if (is.null(href)) 
    href <- "#"
  icon <- tagAppendAttributes(icon, class = paste0("text-", 
                                                   status))
  tags$li(a(href = href, icon, text, target="_blank"))
}

dropdownMenuCustom <- function (..., type = c("messages", "notifications", "tasks"), badgeStatus = "primary", icon = NULL, .list = NULL, customSentence = "Hallo") {
  type <- match.arg(type)
  if (!is.null(badgeStatus)) shinydashboard:::validateStatus(badgeStatus)
  items <- c(list(...), .list)
  lapply(items, shinydashboard:::tagAssert, type = "li")
  dropdownClass <- paste0("dropdown ", type, "-menu")
  #if (is.null(icon)) {
  #  icon <- switch(type, messages = shiny::icon(icon), 
  #                 notifications = shiny::icon("warning"), tasks = shiny::icon("tasks"))
  #}
  numItems <- length(items)
  if (is.null(badgeStatus)) {
    badge <- NULL
  }
  else {
    badge <- span(class = paste0("label label-", badgeStatus), 
                  numItems)
  }
  tags$li(
    class = dropdownClass, 
    a(
      href = "#", 
      class = "dropdown-toggle", 
      `data-toggle` = "dropdown", 
      shiny::icon(icon), 
      badge
    ), 
    tags$ul(
      class = "dropdown-menu", 
      tags$li(
        class = "header", 
        customSentence
      ), 
      tags$li(
        tags$ul(class = "menu", items)
      )
    )
  )
}

#Ui
ui <- function(request) {
  dashboardPage(
    dashboardHeader(title = HEADER_TITLE, 
                    # tags$li(actionLink("changeLang", label = "", icon = icon("globe")), class = "dropdown"),
                    dropdownMenuCustom(type = "messages", customSentence = "Language", badgeStatus = NULL, icon = "globe",
                                       tags$li(selectInput("goeggo_lang", "", choices = i18n$get_languages(), selected = i18n$get_key_translation(), selectize=FALSE, width=validateCssUnit("30%")))            
                    ),
                    # tags$li(actionLink("._bookmark_", label = "", icon = icon("book")), class = "dropdown"),
                    dropdownMenuCustom(type = "messages", customSentence = "Bookmark", badgeStatus = NULL, icon = "bookmark",
                                       tags$li(actionLink("._bookmark_", label = "Bookmark hinzufügen", icon = icon("plus"))),
                                       tags$li(actionLink("getbm", label = "Bookmarks abrufen", icon = icon("th-list")))                    
                    ),
                    # tags$li(a(href = "https://projekte.tgm.ac.at/igoeggo", icon("info"), target = "_blank"), class = "dropdown"),
                    dropdownMenuCustom(type = "messages", customSentence = "Dokumentation", badgeStatus = NULL, icon = "question-circle",
                                 notificationItemWithAttr("Dokumentation", href = "https://igoeggo.github.io", icon = shiny::icon("question-circle")) # ,
                                 # notificationItemWithAttr("Projektwebsite", href = "https://projekte.tgm.ac.at/igoeggo", icon = shiny::icon("info"))
                    )),
    #dbHeader,
    sidebar,
    dashboardBody(
      useShinyalert(),
      #Custom Styles
      shiny.i18n::usei18n(i18n),
      # tags$head(tags$script(src="bug.js")),
      tags$head(
        tags$style(HTML("
        
        .appended_module {
            font-size: 15px;
            margin-top: 20px;
        }
        
        .full_width  {
            width: 100%
        }
        
        .shiny-notification {
          height: 100px;
          width: 800px;
          position:fixed;
          top: calc(50% - 50px);
          left: calc(50% - 400px);
          font-size: 250%;
          text-align: center;
        }
        ")),
        tags$script(type = "text/x-mathjax-config", 
                    'MathJax.Hub.Config({
                      "HTML-CSS": { linebreaks: { automatic: true } },
                             SVG: { linebreaks: { automatic: true } }
                      });'
        ),

        tags$script(src = "bug.js")

      ),
      
      tabItems(
        tabItem(tabName = TAB_0_TABNAME,
                h2("Transformation"),
                fluidRow(
                  box(
                    title = i18n$t("Datensatz auswählen"), width = 2, status = "primary", solidHeader = FALSE,
                    collapsible = TRUE,
                    selectInput("std", i18n$t("Datensatz auswählen"), choices = c("mt"="mtcars","ir"="iris"), selectize = FALSE),
                    fileInput("file1", i18n$t("Wählen Sie eine CSV Datei"), buttonLabel = i18n$t("Durchsuchen"), accept = c(
                      "text/csv",
                      "text/comma-separated-values,text/plain",
                      ".csv"))
                  ),
                  box(
                    title = i18n$t("Datentyp ändern"), width = 2, status = "primary", solidHeader = FALSE,
                    collapsible = TRUE,
                    selectInput("cColumn", i18n$t("Spalte"), choices = c("test"), selectize=FALSE),
                    selectInput("cDatatype", i18n$t("Datentyp"), choices = c("character", "numeric", "integer", "logical", "factor", "double"), selectize = FALSE),
                    actionButton("changeDatatype", i18n$t("Datentyp ändern"), class = "btn-danger")
                  ),
                  tabBox(
                    # Title can include an icon
                    # title = tagList(shiny::icon("gear"), "change Columnname"),
                    title = i18n$t("Spaltennamen ändern"),
                    width = 3,
                    # status = "warning", solidHeader = TRUE,
                    tabPanel(i18n$t("Spalte"), 
                             selectInput("cName", i18n$t("Spalte"), choices = c("test"), selectize = FALSE),
                             textInput("cNameNew", i18n$t("Neuer Name"), value = "", width = NULL, placeholder = NULL),
                             actionButton("changeColumnName", i18n$t("Spaltennamen ändern"), class = "btn-danger")
                    ),
                    tabPanel(i18n$t("Datensatz"),
                             fileInput("file2", i18n$t("Wählen Sie eine CSV Datei"),  buttonLabel = i18n$t("Durchsuchen"), accept = c(
                               "text/csv",
                               "text/comma-separated-values,text/plain",
                               ".csv")),
                             actionButton("changeColumnNames", i18n$t("Spaltennamen ändern"), class = "btn-danger")
                    )
                  ), 
                  box(
                    title = i18n$t("Transformieren"), width = 3, status = "primary", solidHeader = FALSE,
                    collapsible = TRUE,
                    # selectInput("verb", "Select operation", c("select", "filter", "mutate", "group_by", "summarise"), selectize = FALSE),
                    selectInput("verb", i18n$t("Wählen Sie eine Operation"), c("select", "filter", "mutate", "group_by", "summarise")),
                    textInput("user_input", i18n$t("Geben Sie Ihr Kommando ein"), ""),
                    actionButton("apply_operation", i18n$t("Anwenden"), style = "margin-top: 25px"),
                    actionButton("delete_command_history", i18n$t("Alte Kommandos entfernen"), style = "margin-top: 25px"),
                    actionButton("revert_to_root", i18n$t("Datensatz zurücksetzen"), style = "margin-top: 25px")
                  )
                ),
                fluidRow(),
                useShinyjs(),
                dataTableOutput("testtable") %>% withSpinner(color="#0dc5c1"),
                # bookmarkButton(),
                downloadButton("download_active_dataset", i18n$t("Datensatz herunterladen"), style = "margin-top: 25px"),
        ),
        
        tabItem(tabName = TAB_1_TABNAME,
                h2("Exploration", id = paste0(TAB_1_NAME,"_heading")),
                selectInput(EXPLORATION_OPTION, "Wählen Sie eine Funktion", EXPLORATION_FUNCTIONS),
                actionButton(EXPLORATION_SHOW_PANEL, "Erstellen")
        ),
        
        tabItem(tabName = TAB_2_TABNAME,
                h2("Plotting",  id = paste0(TAB_2_NAME,"_heading")),
                selectInput(PLOTTING_OPTION, "Wählen Sie eine Funktion", PLOTTING_FUNCTIONS),
                actionButton("button_plotting_show", "Erstellen")
                
        ),
        
        tabItem(tabName = TAB_3_TABNAME,
                h2("Modelle",  id = paste0(TAB_3_NAME,"_heading")),
                selectInput(MODEL_OPTION, "Wählen Sie eine Funktion", MODEL_FUNCTIONS),
                actionButton("button_model_show", "Erstellen")
        ),
        
        tabItem(tabName = TAB_4_TABNAME,
                h2("Hypothesen Testing",  id = paste0(TAB_4_NAME,"_heading"))
        ),
        
        tabItem(tabName = TAB_5_TABNAME,
                h2("Clusteranalyse",  id = paste0(TAB_5_NAME,"_heading")),
                selectInput(CLUSTER_OPTION, "Wählen Sie eine Funktion", CLUSTER_FUNCTIONS),
                actionButton("button_cluster_show", "Erstellen")
        )
        
        # tabItem(tabName = "Transformation",
        #        h2("Transformation - Work in Progress, proceed with caution",  id = "Transformation_heading"),
        #        
        #        dataTableOutput("current_trans")
        #)
        
        )))
}
