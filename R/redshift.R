
#' Redshift Database Connection
#'
#' Maintains a connection to an Amazon Redshift database that you can query
#' @param factory the redshift factory name
#' @param redshift_url the Amazon S3 URL where the Redshift instance is hosted
#' @param username your username, if you do not include this R will prompt you when the object is created
#' @param password your password, if you do not include this R will prompt you when the object is created
#' @return an object that maintains a connection to the server that you can query with SQL
#' @keywords SQL Server, database, SQL
#' @export
#' @examples
#'

redshift <- function(factory,
                     redshift_url,
                     username = "",
                     password = ""){

  me <- list()

  # PROMPT FOR CREDIENTIALS IF USER DID NOT INCLUDE
  # IN THE CONSTRUCTOR

  if (username == "")
    username <- readline(prompt = "Enter Redshift User Name: ")

  if (password == "")
    password <- readline(prompt = "Enter Redshift Password: ")

  jdbc_jar_loc <- system.file("Database_resources",
                              "RedshiftJDBC41-1.1.10.1010.jar",
                              package = "dbr")

  .jinit(classpath = jdbc_jar_loc, parameters = c("-Xms4g", "-Xmx4g", "-d64", "-server"), force.init = TRUE)
  redshift_drv_name <- "com.amazon.redshift.jdbc41.Driver"
  redshift_drv <- RJDBC::JDBC(redshift_drv_name, jdbc_jar_loc, identifier.quote = "\"")
  connection <- RJDBC::dbConnect(redshift_drv, redshift_url, user = username, password = password)

  me$query <- function(sql){

    r <- RJDBC::dbGetQuery(connection, sql)

    return(r)
  }

  me$send.update <- function(sql){

    r <- RJDBC::dbSendUpdate(connection, sql)

    return(r)
  }

  me$save <- function(df, table_name, append = FALSE){
    stop("reshift save function is not working yet")
    # RJDBC::dbWriteTable(connection, name = tablename, value = df, append = append)
  }
  me$drop <- function(table_name){

    # MUST INCLUDE DATABASE AND TABLENAME FOR RESHIFT

    if (RJDBC::dbExistsTable(connection, name = table_name))
      me$send.update(sprintf("DROP TABLE %s", table_name))

  }
  me$databases <- function(matching = ""){

    if (matching != "") {
      matching <- sprintf("%s%s%s", "%", matching, "%")
      filter_matching = sprintf("table_schema LIKE '%s'", matching)
    } else {
      filter_matching = NULL
    }

    sql <- coderr::code_sql_select(table_or_sql = "information_schema.tables",
                                   select.cols = "DISTINCT table_schema as database",
                                   filters = c(filter_matching),
                                   order.by.cols = c("table_schema"))

    me$query(sql)

  }
  me$tables <- function(database = "", matching = ""){

    if (database != "") {
      filter_database = sprintf("table_schema = '%s'", database)
    } else {
      filter_database = NULL
    }

    if (matching != "") {
      matching <- sprintf("%s%s%s", "%", matching, "%")
      filter_matching = sprintf("table_name LIKE '%s'", matching)
    } else {
      filter_matching = NULL
    }

    sql <- coderr::code_sql_select(table_or_sql = "information_schema.tables",
                                   select.cols = "DISTINCT table_name as table",
                                   filters = c(filter_database, filter_matching),
                                   order.by.cols = "table_name")

    me$query(sql)

  }
  me$close <- function(){
    RJDBC::dbDisconnect(connection)
  }

  class(me) <- append(class(me),"sql_database")
  class(me) <- append(class(me),"redshift")

  return(me)

}
