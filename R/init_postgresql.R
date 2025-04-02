
#' PostgreSQL Database Connection
#'
#' Maintains a connection to a local PostgreSQL database
#' @param user the username
#' @param user the password
#' @return an object that maintains a connection to the database that you can query with SQL
#' @keywords PostgreSQL, database, SQL
#' @export
#' @examples

init_postgresql <- function(user, password, database){

  library(DBI)
  library(RPostgres)

  conn <- dbConnect(
    RPostgres::Postgres(),
    dbname = database,      # Replace with your database name
    host = "localhost",         # Replace with your host (e.g., "localhost" or an IP address)
    port = 5432,                # Replace with your port (default is 5432)
    user = user,                # Replace with your username
    password = password         # Replace with your password
  )

  conn

}
