
#' Show Columns
#'
#' Quick way to see what columns are in a table
#' @description Shows the columns in the table you specify
#' @param conn RODBC, RJDBC or other supported data connection
#' @param table the table that you want to inspect
#' @export
#' 
show_columns <- function(conn, table) {
  
  sprintf("select top 1 * from %s", table) %>% 
    pull_data(conn) %>% 
    names()
  
}