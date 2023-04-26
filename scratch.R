conn <- dbr::init_sql_server(
  server = "collproddbag.adminbucks.edu",
  database = "Tableau",
  username = "reporting_tableau",
  password = "Rt!B1gD@t@"
)


con <- DBI::dbConnect(odbc::odbc(),
                      Driver    = "SQL Server",
                      Server    = "collproddbag.adminbucks.edu",
                      Database  = "Tableau",
                      UID       = "reporting_tableau",
                      PWD       = "Rt!B1gD@t@",
                      Port      = 1433)

conn <- DBI::dbConnect(odbc::odbc(),
                       .connection_string=
                         sprintf("Driver={ODBC Driver 17 for SQL Server};Server=%s;Database=%s;UID=%s;PWD=%s;TrustServerCertificate=yes;",
                                 "collproddbag.adminbucks.edu", "Tableau", "reporting_tableau", "Rt!B1gD@t@"),
                       timeout = 10)
