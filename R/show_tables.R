
#' Show Database Tables
#'
#' Quick way to see what tables you have available to you
#' @description Shows the tables in your data connection
#' @param show_tables_matching
#' @param database
#' @param conn RODBC, RJDBC or other supported data connection
#' @export

show_tables <- function(conn, show_tables_matching = "", database = ""){

  stopifnot(class(conn) %in% c(
      "PqConnection"
      , "RPostgres"
      , "SQLiteConnection"
      , "Microsoft SQL Server"
    )
  )

  if (class(conn) %in% c("PqConnection", "RPostgres")) {

    if(show_tables_matching != ""){
      where <- paste0(" AND table_name LIKE '%", show_tables_matching, "%'")
    }else{
      where <- ""
    }

    sql <- paste0("SELECT table_schema, table_name
    FROM information_schema.tables
    WHERE table_schema NOT IN (
      'table_schema'
      , 'information_schema'
      , 'pg_catalog')", where, ";")

  }

  if (class(conn) %in% c("Microsoft SQL Server")) {

    if(show_tables_matching != ""){
      where <- paste0("WHERE TABLE_NAME LIKE '%", show_tables_matching, "%'")
    }else{
      where <- ""
    }

    sql <- sprintf("
    SELECT DISTINCT
        TABLE_NAME table_name
    FROM %s.INFORMATION_SCHEMA.TABLES
    %s
    ORDER BY TABLE_NAME;", database, where)

  }

  if (class(conn) %in% "SQLiteConnection") {

    if (!is.null(show_tables_matching))
      show_tables_matching <- sprintf("name LIKE '%s%s%s' and", "%", show_tables_matching, "%")
    else
      show_tables_matching <- ""

    sql <- sprintf("

                   SELECT name table_name
                   FROM sqlite_master
                   WHERE %s type = 'table'
                   ORDER BY name

                   ", show_tables_matching)

  }

  pull_data(sql, conn) %>% select(table_name)

}
