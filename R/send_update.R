
#' Send an update to a Connection
#'
#' Updates the data connection.
#' @description Updates the data source. Provides a common interface. Used when no data table result is expected.
#' @param sql_code SQL code that updates the data source
#' @param conn RODBC, RJDBC or other supported data connection
#' @keywords database
#' @export
#' @examples

send_update <- function(sql_code, conn){

  stopifnot(class(conn) %in% c("RODBC", "JDBCConnection", "SQLiteConnection","Microsoft SQL Server"))

  if (class(conn) %in% "RODBC")
    RODBC::sqlQuery(conn, sql_code, as.is = TRUE)
  if (class(conn) %in% c("JDBCConnection"))
    RJDBC::dbSendUpdate(conn, sql_code)
  if (class(conn) %in% c("Microsoft SQL Server"))
    DBI::dbSendStatement(conn, sql_code)
  if (class(conn) %in% "SQLiteConnection")
    DBI::dbGetQuery(conn, sql_code, as.is = TRUE)

}
