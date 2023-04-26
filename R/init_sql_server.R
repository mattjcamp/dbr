
#' SQL Server Database Connection
#'
#' Maintains a connection to a SQL Server database that you can query
#' @param server the server that hosts the database
#' @param database the name of the default database schema
#' @param username your username, if you do not include this R will prompt you when the object is created
#' @param password your password, if you do not include this R will prompt you when the object is created
#' @return an object that maintains a connection to the server that you can query with SQL
#' @keywords SQL Server, database, SQL
#' @export
#' @examples

init_sql_server <- function(server,
                            database,
                            username = NULL,
                            password = NULL){

  # PROMPT FOR CREDIENTIALS IF NEEDED

  if (is.null(username))
    username <- readline(prompt = "Enter SQL Server username: ")

  if (is.null(password))
    password <- readline(prompt = "Enter SQL Server password: ")

  # conn <- RODBC::odbcDriverConnect(sprintf("driver=SQL Server;server=%s;database=%s;Uid=%s;Pwd=%s;",
  #                                          server, database, username, password))
  #
  # conn

  conn <- DBI::dbConnect(odbc::odbc(),
                        .connection_string=
                          sprintf("Driver={ODBC Driver 17 for SQL Server};Server=%s;Database=%s;UID=%s;PWD=%s;TrustServerCertificate=yes;",
                                  server, database, username, password),
                        timeout = 10)
  conn

}
