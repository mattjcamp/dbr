
# library(testthat)

context("SQLITE FUNCTIONS")

test_that("SQLite connection works", {

  library(magrittr)

  expect_silent({conn <- init_sqlite(database_file = "test.db")})

  expect_silent({
  "SELECT name
   FROM sqlite_master
   WHERE type = 'table'
   ORDER BY name" %>%
    pull_data(conn)})

  close_connection(conn)

  expect_error({
  "SELECT name
   FROM sqlite_master
   WHERE type = 'table'
   ORDER BY name" %>%
    pull_data(conn)})

})
