# Test the lexical_sort function from R/example.R
context("backup")

test_that("testName", {
  app <- ShinyDriver$new("../../")
  expect_equal(app$getTitle(), "iGÖGGO")
})

test_that("bookmark", {
  app <- ShinyDriver$new("../../", loadTimeout = 1e+05)
  expect_equal(app$getTitle(), "iGÖGGO")
  app$findElement("#\\._bookmark_")$click()
  # app$waitForValue("bm_name")
  app$waitForShiny()
  url = app$getUrl()
  code = app$getSource()
  # print(code)
  expect_true(grepl(url, code, fixed = TRUE))
  # print(app$findElement("#bm_url")$getData())
  app$stop()
})