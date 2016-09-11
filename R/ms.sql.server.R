
#' SQL Server Database Connection
#'
#' Maintains a connection to a SQLite database that you can query
#' @param server the server that hosts the database
#' @param database the name of the database
#' @param username your username, if you do not include this R will prompt you when the object is created
#' @param password your password, if you do not include this R will prompt you when the object is created
#' @return an object that maintains a connection to the server that you can query with SQL
#' @keywords SQL Server, database, SQL
#' @export
#' @examples
#'

ms.sql.server <- function(server,
                          database,
                          username = "",
                          password = ""){

  library(RODBC)

  me <- list()

  # PROMPT FOR CREDIENTIALS IF USER DID NOT INCLUDE
  # IN THE CONSTRUCTOR

  if (username == "")
    username <- readline(prompt = "Enter SQL User Name: ")

  if (password == "")
    password <- readline(prompt = "Enter SQL Password: ")

  connection <- odbcDriverConnect(sprintf("driver=SQL Server;server=%s;database=%s;Uid=%s;Pwd=%s;",
                                  server, database, username, password))

  me$query <- function(sql, forceCharacters = FALSE){

    if (forceCharacters)
      r <- sqlQuery(connection, sql, as.is = TRUE)
    else
      r <- sqlQuery(connection, sql)

    r

  }
  me$save <- function(df, tablename, append = FALSE){

    # NOTE don't use fully qualified name when saving
    # You can only have tables to the database you
    # have in the connection string

    sqlSave(connection, dat = df, tablename = tablename,
            rownames = FALSE, fast = TRUE, append = append)
  }
  me$drop <- function(tablename){

    # NOTE  don't use the fully qualified name here. You can
    #       only delete from the database you signed on to

    me$query(sprintf("IF object_id(N'%s', N'U') IS NOT NULL DROP TABLE %s;",
                    tablename, tablename))
  }
  me$tables <- function(matching, database){

    matching <- sprintf("%s%s%s", "%", matching, "%")

    sql <- sprintf("

                   SELECT TABLE_NAME
                   FROM %s.information_schema.tables
                   WHERE TABLE_NAME LIKE '%s'
                   ORDER BY TABLE_TYPE, TABLE_NAME

                   ", database, matching)

    me$query(sql)

  }
  me$close <- function(){
    close(connection)
  }

  class(me) <- append(class(me),"Database")
  class(me) <- append(class(me),"ms.sql.server")

  return(me)

}
