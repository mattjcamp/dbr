
#' Delete Table
#'
#' Removes a table from a database.
#' @description If the specified tables exists, it will be deleted.
#' @param table_to_delete The table that you will delete. NOTE: if you are using the Research database you can only delete
#' tables associated with the schema you used to create conn (probably the services database, would have been in .renviron). NOTE
#' for Cornerstone you must specify the entire schema + table (sndbx__research.mc_temp) while for Research you only specify the table (mc_temp).
#' @param conn RODBC, RJDBC or other supported data connection
#' @keywords database
#' @export
#' @examples

drop_table <- function(table_to_delete, conn){

  stopifnot(class(conn) %in% c("RODBC", "JDBCConnection"))

  if (class(conn) %in% "RODBC")
    send_update(sprintf("IF object_id(N'%s', N'U') IS NOT NULL DROP TABLE %s;",
                                  table_to_delete, table_to_delete), conn)
  if (class(conn) %in% "JDBCConnection")
    send_update(sprintf("drop table if exists %s", table_to_delete), conn)

  if (class(conn) %in% "SQLiteConnection")
    send_update(sprintf("DROP TABLE IF EXISTS %s;",
                        table_to_delete), conn)

}
