# Test the lexical_sort function from R/example.R
context("language")

test_that("testName", {
  app <- ShinyDriver$new("../../", loadTimeout = 1e+05)
  expect_equal(app$getTitle(), "iGÖGGO")
})

test_that("change language", {
  app <- ShinyDriver$new("../../", loadTimeout = 1e+05)
  expect_equal(app$getTitle(), "iGÖGGO")
  app$findElement("#changeLang")$click()
  app$waitForValue("goeggo_lang")
  # print(app$getSource())
  # $setValue("en")
  app$setValue("goeggo_lang", "en")
  expect_equal(app$getValue("goeggo_lang"), "en")
  # print(app$findElement("#download_active_dataset")$findElement("span")$getValue("text"))
  app$findElement("#chLangOK")$click()
  needle <- "Download dataset"
  haystack <- app$getSource()
  # print(grepl(needle, haystack, fixed = TRUE))
  expect_true(grepl(needle, haystack, fixed = TRUE))
  # print(app$findElement("#download_active_dataset")$findElement("span")$getText())
  # expect_equal(app$getValue("goeggo_lang"), "en")
  # print(app$findElement("#bm_url")$getData())
  app$stop()
})