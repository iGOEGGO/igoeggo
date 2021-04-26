csplit <- function(cstr, at) {
  temp = str_split(cstr, at, simplify = TRUE)[1,]
  temp = unlist(lapply(temp, str_trim))
  return(temp) 
}

cols_from_user_input <- function(user_input) {return(csplit(user_input, ","))}
split_at_equal <- function(user_input) {return(csplit(user_input, "="))}

check_if_cols_match <- function(user_cols, data_cols) {
  for(col in user_cols) {
    if(col %in% data_cols) {} else {
      return(col)
    }
  }
  return(TRUE)
}

custom_message <- function(title, msg) {showModal(modalDialog(title = title, msg, easyClose = TRUE))}
does_not_contain_col_message <- function(col) {
  
  if(col != "") {
    custom_message("Fehler bei der Eingabe",  paste("Die Spalte", col, "konnte im Datensatz nicht gefunden werden. Das Kommando wurde nicht ausgeführt"))
  } else {
    custom_message("Fehler bei der Eingabe",  paste("Es fehlt die Angabe einer Spalte. Die Spalte muss einen Namen tragen. Das Kommando wurde nicht ausgeführt"))
  }
} 
