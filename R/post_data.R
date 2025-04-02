
#' Post Data to a Connection
#'
#' Creates a database table from a dataframe
#' @description Posts data to your connection. NOTE For RODBC data connections don't use the fully qualified name when posting data. You can only have tables to the database you have specified in the connection string.
#' @param df The dataframe to post to the database
#' @param table_name the name of the database table that you would like to create
#' @param conn RODBC or SQLiteConnection data connection
#' @param append Do you want to post data to an existing data table?
#' @keywords database
#' @export
#' @examples

post_data <- function(df, table_name, conn, append = FALSE){

  stopifnot(class(conn) %in% c("PqConnection", "RPostgres", "RODBC", "SQLiteConnection","Microsoft SQL Server"))

  if (class(conn) %in% "RODBC")
    RODBC::sqlSave(conn, dat = df, tablename = table_name,
                   rownames = FALSE, fast = TRUE, append = append)
  if (class(conn) %in% c("PqConnection", "RPostgres", "SQLiteConnection","Microsoft SQL Server"))
    DBI::dbWriteTable(conn, name = table_name,
                      value = as.data.frame(df),
                      append = append)

}

