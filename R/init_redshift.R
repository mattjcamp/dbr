
#' Amazon Redshift Database Connection
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

init_redshift <- function(factory,
                          redshift_url,
                          username = NULL,
                          password = NULL){

  # PROMPT FOR CREDIENTIALS IF NEEDED

  if (is.null(username))
    username <- readline(prompt = "Enter Amazon Redshift username: ")

  if (is.null(password))
    password <- readline(prompt = "Enter Amazon Redshift password: ")

  jdbc_jar_loc <- system.file("dbr_resources",
                              "RedshiftJDBC41-1.1.10.1010.jar",
                              package = "dbr")

  .jinit(classpath = jdbc_jar_loc, parameters = c("-Xms4g", "-Xmx4g", "-d64", "-server"), force.init = TRUE)
  redshift_drv_name <- "com.amazon.redshift.jdbc41.Driver"
  redshift_drv <- RJDBC::JDBC(redshift_drv_name, jdbc_jar_loc, identifier.quote = "\"")
  conn <- RJDBC::dbConnect(redshift_drv, redshift_url, user = username, password = password)

  conn

}
