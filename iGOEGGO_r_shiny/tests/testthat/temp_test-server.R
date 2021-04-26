context("app")

testServer(server, {
  cat("Initially, input$x is NULL, right?", is.null(input$user_input), "\n")
  
  # Give input$x a value.
  session$setInputs(user_input = 1)
})