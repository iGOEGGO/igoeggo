etl <- function(datasetToETL, dateformat = "empty") {
  print("ETL-Prozess gestartet...")
  'withProgress(message = "ETL-Prozess", value = 0,detail="0%", {
    dataset <- datasetToETL
    incProgress(1/8,detail = "Faktorvariablen werden geprüft...")
    dataset <- resetFactors(dataset)
    incProgress(1/8,detail = "Daten werden konvertiert")
    dataset <- convertDate(dataset)
    #suppressWarnings(dataset <- convertTime(dataset))
    incProgress(1/8,detail = "Uhrzeiten werden konvertiert")
    dataset <- convertTime(dataset)
    incProgress(1/8,detail = "Daten mit Uhrzeiten werden konvertiert")
    dataset <- convertDateAndTime(dataset)
    incProgress(1/8,detail = "leere Felder werden geprüft")
    # dataset <- fillNAs(dataset)
    col1 <- colnames(dataset)
    incProgress(1/8,detail = "leere Spalten werden entfernt...")
    dataset <- removeNAColumns(dataset)
    col2 <- colnames(dataset)
    removed <- setdiff(col1,col2)
    incProgress(1/8,detail = "String-Spalten werden entfernt")
    dataset <- filterStrings(dataset)
    Sys.sleep(5)
  })'
  show_modal_progress_line(text="ETL-Prozess") # show the modal window
  
  dataset <- datasetToETL
  # update_modal_progress(value = 1 / 8, text = paste("Process1", "asdf"))
  update_modal_progress(1/8, text="Faktorvariablen werden geprüft...")
  dataset <- resetFactors(dataset)
  
  if (input$etl_date) {
    update_modal_progress(2/8, text="Daten werden konvertiert")
    dataset <- convertDate(dataset,dateformat)
  } else {
    update_modal_progress(2/8)
  }
  
  if (input$etl_time) {
    update_modal_progress(3/8, text="Uhrzeiten werden konvertiert")
    dataset <- convertTime(dataset)
  } else {
    update_modal_progress(3/8)
  }
  
  update_modal_progress(4/8, text="Daten mit Uhrzeiten werden konvertiert")
  dataset <- convertDateAndTime(dataset)
  update_modal_progress(5/8, text="leere Felder werden geprüft")
  
  if (input$etl_emp) {
    col1 <- colnames(dataset)
    update_modal_progress(6/8, text="leere Spalten werden entfernt...")
    dataset <- removeNAColumns(dataset)
    col2 <- colnames(dataset)
    removedNA <- setdiff(col1,col2)
  } else {
    update_modal_progress(6/8)
  }

  if (input$etl_str) {
    update_modal_progress(7/8, text= "String-Spalten werden entfernt")
    dataset <- filterStrings(dataset)
    col3 <- colnames(dataset)
    removedChar <- setdiff(col2,col3)
  } else {
    update_modal_progress(7/8)
  }
  
  update_modal_progress(8/8, text= "ETL-Prozess abgeschlossen")
  # unknown failure 
  for(i in colnames(dataset)) {
    dataset[,i] <- unlist(dataset[,i])
  }
  Sys.sleep(5)
  remove_modal_progress()
  #showNotification("Der ETL-Prozess wurde erfolgreich abgeschlossen.", duration=NULL, type = 'message')
  print("ETL-Prozess abgeschlossen...")
  print("gelöscht")
  #print(removedNA)
  #print(length(removedNA))
  #print(length(removedChar))
  fkt <- function() {
    shinyalert(title = "Textvariablen", text = paste("Es wurden ", length(removedChar), " Spalten entfernt, weil sie nur Textvariablen enthalten haben."), type = "info") 
  }
  if (length(removedNA)>0) {
    shinyalert(title = "leere Spalten", text = paste("Es wurden ", length(removedNA), " Spalten entfernt, weil sie leer waren."), type = "info",
      callbackR = function(wert = length(removedChar)) { 
        fkt()
      }
    )
  } else if(input$etl_str) { 
    if (length(removedChar)>0) {
      fkt()
    }
  }
  return(dataset)
}

## File-Upload
observeEvent(input$file1, {
  # print("new File")
  file = input$file1
  name = file_path_sans_ext(file$name)
  
  # read data and save in reactiveValues
  showModal(etlModal(name))
})

observeEvent(input$etlDataset, {
  removeModal()
  file = input$file1
  show("loading_page")
  print("hier1")
  name = file_path_sans_ext(file$name)
  df <- read.csv(file$datapath, fileEncoding = "latin1")
  show_modal_progress_line(text="Datensatz wird analysiert")
  if(checkDate(df)) {
    remove_modal_progress()
    showModal(dateformatModal())
  } else {
    remove_modal_progress()
    data_temp <- etl(df)
    values$datasets[[name]] <- data_temp
    values$root_datasets[[name]] <- data_temp
    hide("loading_page")
    print("hier2")
    updateSelectInput(session, "std", choices = keys(values$datasets), selected = name)
  }
})

observeEvent(input$dateformatok, {
  removeModal()
  file = input$file1
  show("loading_page")
  print("hier1")
  values$dateformat <- input$dateformat
  print(values$dateformat)
  print("print-ende")
  name = file_path_sans_ext(file$name)
  df <- read.csv(file$datapath, fileEncoding = "latin1")
  data_temp <- etl(df, input$dateformat)
  values$datasets[[name]] <- data_temp
  values$root_datasets[[name]] <- data_temp
  hide("loading_page")
  print("hier2")
  updateSelectInput(session, "std", choices = keys(values$datasets), selected = name)
})

observeEvent(input$std, {
  if(is.null(values$datasets[["mtcars"]])) {
    values$root_datasets[["mtcars"]] <- mtcars
    values$datasets[["mtcars"]] <- mtcars
  }
  if(is.null(values$datasets[["iris"]])) {
    values$root_datasets[["iris"]] <- iris
    values$datasets[["iris"]] <- iris
  }
  if(values$current_dataset!=""){
    values$datasets[[values$current_dataset]] = values$data
  }
  
  values$current_dataset <- input$std
  values$data <- values$datasets[[values$current_dataset]]
  
  updateSelectInput(session, "cName", choices = colnames(values$data))
  updateSelectInput(session, "cColumn", choices = colnames(values$data))
  
  removeOldCommands()
  
  #datatypes <- c()
  #for(i in 1:ncol(iris)) {
  #  datatypes <- c(datatypes, print(class(iris[,i])))
  #}
  
  # print(sapply(values$data, typeof))
  
  # output$testtable <- renderDataTable({values$data}, options = list(scrollX = TRUE))
})

output$selected <- renderText({
  input$std
})