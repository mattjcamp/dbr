
#' Show Columns
#'
#' Quick way to see what columns are in a table
#' @description Shows the columns in the table you specify
#' @param conn RODBC, RJDBC or other supported data connection
#' @param schema the schema or database that the tables are located in
#' @param tables the table that you want to inspect
#' @export
#'
#'
show_columns <- function(conn, schema, tables) {

    if (class(conn) %in% "JDBCConnection")
      sql <- "

select  table_name, table_schema, column_name, data_type,
        character_maximum_length as col_length, ordinal_position as column_order
from information_schema.columns
where table_name in INSPECT_TABLE and table_schema in ('INSPECT_SCHEMA')
order by table_schema, table_name, ordinal_position"

    if (class(conn) %in% "RODBC") {
      schema <- stringr::str_replace(schema, ".dbo", "")
      sql <- "

select  table_name, table_schema, column_name, data_type,
        character_maximum_length as col_length, ordinal_position as column_order
from INSPECT_SCHEMA.information_schema.columns
where table_name in INSPECT_TABLE and table_schema in ('dbo')
order by table_schema, table_name, ordinal_position"
    }

  d <-
    sql %>% str_replace("INSPECT_SCHEMA", schema) %>%
    str_replace("INSPECT_TABLE", code_vector_to_csv_list(tables,
                                                         add.quotes = TRUE,
                                                         enclose.in.parenthesis = TRUE)) %>%
  pull_data(conn) %>%
  mutate(table_name = str_to_lower(table_name),
         column_name = str_to_lower(column_name),
         col_length = as.numeric(col_length)) %>%
  mutate(data_type = ifelse(data_type %in% c("character varying","char"),
                            "varchar", data_type),
         data_type = ifelse(data_type %in% c("int", "tinyint", "smallint"),
                            "numeric", data_type),
         data_type = ifelse(data_type %in% c("datetime2", "datetime", "timestamp without time zone"),
                            "date", data_type))


  d

}
