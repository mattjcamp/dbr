
#' SQLite Database Connection
#'
#' Maintains a connection to a local SQLite database
#' @param database_file the full folder name of the SQLite database file
#' @return an object that maintains a connection to the database that you can query with SQL
#' @keywords SQLite, database, SQL
#' @export
#' @examples

init_sqlite <- function(database_file = NULL){

  if (is.null(database_file))
    database_file <- file.choose()

  conn <- DBI::dbConnect(RSQLite::SQLite(),
                         dbname = database_file)

  conn

}
