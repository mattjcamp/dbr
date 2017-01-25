
#' Pull Data from a Connection
#'
#' Gets data from a database connection and returns the result as a tibble
#' @description Gets data from a database connection and returns the result as a tibble. Provides a common interface.
#' @param sql_code SQL query that returns one data table
#' @param conn RODBC, RJDBC or other supported data connection
#' @keywords database
#' @export
#' @examples

pull_data <- function(sql_code, conn){

  stopifnot(class(conn) %in% c("RODBC", "JDBCConnection", "SQLiteConnection"))

  d <- NULL

  if (class(conn) %in% "RODBC")
    d <- tibble::as_tibble(RODBC::sqlQuery(conn, sql_code, as.is = TRUE))
  if (class(conn) %in% "JDBCConnection")
    d <- tibble::as_tibble(RJDBC::dbGetQuery(conn, sql_code))
  if (class(conn) %in% "SQLiteConnection")
    d <- tibble::as_tibble(DBI::dbGetQuery(conn, sql_code, as.is = TRUE))

  d

}
