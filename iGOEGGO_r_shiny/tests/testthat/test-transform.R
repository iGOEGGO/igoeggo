# Test the lexical_sort function from R/example.R
context("transform")

test_that("testName", {
  app <- ShinyDriver$new("../../", loadTimeout = 1e+05)
  expect_equal(app$getTitle(), "iGÖGGO")
})

test_that("changeColumnName", {
  app <- ShinyDriver$new("../../", loadTimeout = 1e+05)
  expect_equal(app$getTitle(), "iGÖGGO")
  app$setInputs(cNameNew="test")
  # app$click(._bookmark_)
  # print(app$getValue("cName"))
  expect_equal(app$getValue("cName"), "mpg")
  # expect_equal(app$getValue("bm_url"), "test")
  app$click("changeColumnName")
  # print(app$getValue("cName"))
  expect_equal(app$getValue("cName"), "test")
  app$stop()
})

test_that("changeDatatype", {
  app <- ShinyDriver$new("../../", loadTimeout = 1e+05)
  expect_equal(app$getTitle(), "iGÖGGO")
  # app$setInputs(cNameNew="test")
  # app$click(._bookmark_)
  # print(app$getValue("cName"))
  # expect_equal(app$getValue("cName"), "mpg")
  # expect_equal(app$getValue("bm_url"), "test")
  app$click("changeDatatype")
  # print(app$getValue("cName"))
  # expect_equal(app$getValue("cName"), "test")
  app$stop()
})

test_that("uploadFile", {
  app <- ShinyDriver$new("../../", loadTimeout = 1e+05)
  expect_equal(app$getTitle(), "iGÖGGO")
  app$uploadFile(file1="test.csv")
  #app$waitForValue(
  #  "d_name",
  #  ignore = list(NULL, ""),
  #  timeout = 10000,
  #  checkInterval = 400
  #)
  app$click("etlDataset")
  #app$findElement("confirm")
  # print(app$getValue("cName"))
  # expect_equal(app$getValue("cName"), "test")
  app$stop()
})