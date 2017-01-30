
# library(testthat)

context("SHOW TABLES")

test_that("show_tables function works with the example database", {

  library(magrittr)

  db_file <- system.file("dbr_resources", "example_database.db", package = "dbr")

  expect_silent({conn <- init_sqlite(database_file = db_file)})

  expect_type(show_tables(show_tables_matching = "wiche", conn = conn), "list")

  close_connection(conn)

})
