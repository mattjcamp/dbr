
#' SQLite Database Connection
#'
#' Maintains a connection to a SQLite database that you can query
#' @param database.file the full folder name of the SQLite database file
#' @return an object that maintains a connection to the database that you can query with SQL
#' @keywords SQLite, database, SQL
#' @export
#' @examples

sqlite <- function(database.file = ""){

  library(DBI)
  me <- list()

  if (database.file == "")
    database.file <- file.choose()

  connection <- dbConnect(RSQLite::SQLite(),
                                  dbname = database.file)

  me$query <- function(sql,
                       forceCharacters = FALSE){

    if (forceCharacters)
      r <- dbGetQuery(connection, sql, as.is = TRUE)
    else
      r <- dbGetQuery(connection, sql)

    return(r)
  }
  me$save <- function(df, tablename, append = FALSE){
      dbWriteTable(connection, name = tablename, value = df, append = append)
  }
  me$drop <- function(tablename){

    me$query(sprintf("DROP TABLE IF EXISTS %s;",
                     tablename))

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
    dbDisconnect(connection)
  }

  class(me) <- append(class(me),"Database")
  class(me) <- append(class(me),"sqlite")

  me

}


