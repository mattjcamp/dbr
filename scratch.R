# test code here
library(tidyverse)
library(dbr)

conn <- dbr::init_postgresql(user = "campbellm", password = "ZVBs]X7ZrH", database = "mydatabase")
dbListTables(conn)
class(conn)

dbr::show_tables(conn)

drop_table("state_x77", conn)

close_connection(conn)

state.x77

post_data(ds, table_name = "ds", conn)

pull_data("SELECT * FROM ds WHERE column1 = 'Row1_Col1'", conn)


"SELECT table_name
 FROM information_schema.tables
  --WHERE table_schema = 'public';" %>% pull_data(conn)


