
#' Show Database Tables
#'
#' Quick way to see what tables you have available to you
#' @description Shows the tables in your data connection
#' @param show_tables_matching
#' @param database
#' @param conn RODBC, RJDBC or other supported data connection
#' @keywords database
#' @export
#' @examples

show_tables <- function(conn, show_tables_matching = "", database = ""){

  stopifnot(class(conn) %in% c("RODBC", "JDBCConnection", "SQLiteConnection"))

  if (class(conn) %in% "RODBC") {

    show_tables_matching <- sprintf("%s%s%s", "%", show_tables_matching, "%")

    sql <- sprintf("

                   SELECT TABLE_NAME
                   FROM %s.information_schema.tables
                   WHERE TABLE_NAME LIKE '%s'
                   ORDER BY TABLE_NAME

                   ", database, show_tables_matching)

  }

  if (class(conn) %in% "JDBCConnection") {

    if (database != "") {
      filter_database = sprintf("table_schema = '%s'", database)
    } else {
      filter_database = NULL
    }

    if (show_tables_matching != "") {
      show_tables_matching <- sprintf("%s%s%s", "%", show_tables_matching, "%")
      filter_matching = sprintf("table_name LIKE '%s'", show_tables_matching)
    } else {
      filter_matching = NULL
    }

    filters = c(filter_database, filter_matching)

    if (!(length(filters) == 0)) {
      if (!filters[1] == "") {
        filters.logical <- sprintf(" %s ", " AND ")
        filters <- paste(filters, collapse = filters.logical)
        filters <- sprintf("WHERE %s", filters)
      }else
        filters <- ""
    }else
      filters <- ""

    sql <- sprintf("
      select distinct table_name as table
      from information_schema.tables
      %s
      order by table_name
      ", filters)

  }

  if (class(conn) %in% "SQLiteConnection") {

    if (!is.null(show_tables_matching))
      show_tables_matching <- sprintf("name LIKE '%s%s%s' and", "%", show_tables_matching, "%")
    else
      show_tables_matching <- ""

    sql <- sprintf("

                   SELECT name
                   FROM sqlite_master
                   WHERE %s type = 'table'
                   ORDER BY name

                   ", show_tables_matching)

  }

  pull_data(sql, conn)

}
