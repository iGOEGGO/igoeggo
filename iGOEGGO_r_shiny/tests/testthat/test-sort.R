# Test the lexical_sort function from R/example.R
context("sort")

test_that("test", {
  app <- ShinyDriver$new("../../", loadTimeout = 1e+05)
  expect_equal(app$getTitle(), "iGÖGGO")
})

test_that("test", {
  app <- ShinyDriver$new("../../", loadTimeout = 1e+05)
  expect_equal(app$getTitle(), "iGÖGGO")
  app$setInputs(user_input="test")
  expect_equal(app$getValue("user_input"), "test")
  app$stop()
})
