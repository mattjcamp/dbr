
#' SQLite Database Connection
#'
#' Maintains a connection to a SQLite database that you can query
#' @param database_file the full folder name of the SQLite database file
#' @return an object that maintains a connection to the database that you can query with SQL
#' @keywords SQLite, database, SQL
#' @export
#' @examples

sqlite <- function(database_file = ""){

  me <- list()

  if (database_file == "")
    database_file <- file.choose()

  connection <- DBI::dbConnect(RSQLite::SQLite(),
                               dbname = database_file)

  me$query <- function(sql,
                       return_as_text = FALSE){

    if (return_as_text)
      r <- DBI::dbGetQuery(connection, sql, as.is = TRUE)
    else
      r <- DBI::dbGetQuery(connection, sql)

    return(r)
  }

  me$send_update <- function(sql){me$query(sql)}

  me$save <- function(df, table_name, append = FALSE){
      DBI::dbWriteTable(connection, name = table_name, value = df, append = append)
  }

  me$drop <- function(table_name){

    me$query(sprintf("DROP TABLE IF EXISTS %s;",
                     table_name))

  }

  me$tables <- function(matching = NULL){

    if (!is.null(matching))
      matching <- sprintf("name LIKE '%s%s%s' and", "%", matching, "%")
    else
      matching <- ""

    sql <- sprintf("

                   SELECT name
                   FROM sqlite_master
                   WHERE %s type = 'table'
                   ORDER BY name

                   ", matching)

    me$query(sql)

  }

  me$close <- function(){
    DBI::dbDisconnect(connection)
  }

  class(me) <- append(class(me),"sql_database")
  class(me) <- append(class(me),"sqlite")

  me

}
