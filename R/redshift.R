
#' Redshift Database Connection
#'
#' Maintains a connection to a SQLite database that you can query
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

  library(RJDBC)

  me <- list()

  # PROMPT FOR CREDIENTIALS IF USER DID NOT INCLUDE
  # IN THE CONSTRUCTOR

  if (username == "")
    username <- readline(prompt = "Enter SQL User Name: ")

  if (password == "")
    password <- readline(prompt = "Enter SQL Password: ")

  jdbc_jar_loc <- system.file("Database_resources",
                              "RedshiftJDBC41-1.1.10.1010.jar",
                              package = "Database")

  .jinit(classpath = jdbc_jar_loc, parameters = c("-Xms4g", "-Xmx4g", "-d64", "-server"), force.init = TRUE)
  redshift_drv_name <- "com.amazon.redshift.jdbc41.Driver"
  redshift_drv <- JDBC(redshift_drv_name, jdbc_jar_loc, identifier.quote = "\"")
  connection <- dbConnect(redshift_drv, redshift_url, user = username, password = password)

  me$query <- function(sql){

    r <- dbGetQuery(connection, sql)

    return(r)
  }

  me$send.update <- function(sqlCode){

    r <- dbSendUpdate(connection, sqlCode)

    return(r)
  }

  me$save <- function(df, tablename, append = FALSE){
    stop("STILL NEED TO IMPLEMENT REDSHIFT save FUNCTION")
  }
  me$drop <- function(tablename){
    stop("STILL NEED TO IMPLEMENT REDSHIFT drop FUNCTION")
  }
  me$tables <- function(matching){
    stop("STILL NEED TO IMPLEMENT REDSHIFT tables FUNCTION")
  }

  me$close <- function(){
    dbDisconnect(connection)
  }

  class(me) <- append(class(me),"Database")
  class(me) <- append(class(me),"redshift")

  return(me)

}
