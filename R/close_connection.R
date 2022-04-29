
#' Clean up a Connection
#'
#' closes a connection
#' @description Disconnects from a database
#' @param conn RODBC, RJDBC or other supported data connection
#' @keywords database
#' @export
#' @examples

close_connection <- function(conn){

  stopifnot(class(conn) %in% c("RODBC", "JDBCConnection", "SQLiteConnection","Microsoft SQL Server"))

  if (class(conn) %in% "RODBC")
    close(conn)
  if (class(conn) %in% c("JDBCConnection","Microsoft SQL Server"))
    DBI::dbDisconnect(conn)
    # RJDBC::dbDisconnect(conn)
  if (class(conn) %in% "SQLiteConnection")
    DBI::dbDisconnect(conn)

}
