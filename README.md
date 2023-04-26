# Databases for R

**dbr** provides a common interface for database connections and 
useful functions to make working with data a little bit easier.

**dbr** has connections for SQLite (local SQL database), MS SQL Server
and Amazon Redshift.

To use **dbr** you start with an initializer function that will always
begin with `init_` to create a data connection. Then you can use the provided
functions to send updates, get SQL query results and perform other types
of data related tasks.

Here is an example of how to do some of this with a built in example database
that I provide with this package. 

## Example

The database is a public dataset created by
WICHE that shows student enrollments for each state by grade level, race
and gender. This data is stored in a local SQLite database that is stored in the
external data directory for this package.

Here is how you can get the filename for this database (this will be needed to 
create the connection):

    db_file <- system.file("dbr_resources",
                           "example_database.db",
                           package = "dbr")

### Create Database Connection

Use the `init_sqlite` function to create a connection to the
database:

    conn <- init_sqlite(db_file)
    
>**NOTE** Other connections will require other types of information like username,
password and server locations.

### View Tables

One thing you can do is look at the tables that are already present in the
database:

    show_tables(conn)

Here is what would print out to the log:

    # A tibble: 1 × 1
                        name
                       <chr>
    1 wiche_projections_2013
    
**wiche_projections_2013** is the only table in this database right now.

### SQL Query

Most of the time, you will just want to query the database connection with
SQL. Use `pull_data` with a SQL string to get the first 5 rows of the 
**wiche_projections_2013**:

    pull_data("select * from wiche_projections_2013 limit 5;", conn)

You would get this result:

    # A tibble: 5 × 7
      location sector  race gender grade  year     n
         <chr>  <chr> <chr>  <chr> <chr> <int> <int>
    1       in public asian    all     8  2021  2306
    2       in public asian    all     9  2021  2407
    3       in public asian    all    10  2021  2314
    4       in public asian    all    11  2021  2801
    5       in public asian    all    12  2021  2578

### Other Functions

Look at the help pages to see other functions. You can drop tables, send updates and
post data to connections with this package.

## Differences from Version 1

This package is based on that I did last year when we started to use two
databases in addition to local SQLite databases. Basically, I wanted all data
connection related code to behave the same way. Version 1 did this by
creating heavy database *objects* that you could query.

This model didn't work out as flexibly as I had hoped. OOP doesn't seem to lend itself
well to R. This version is based on the idea of splitting up functions into simple
*verbs* that can be stacked to show a programming flow. This idea is taken from
the "tidyverse" family of packages and it is also the approached that I used with
**cohortr** and **datapointsr**. This seems to be the best way to approach code
reuse with R and so now **dbr** will work well with the other packages I've been using.

## Troubleshooting

See the document install-mac-drivers.md for notes on how to install the drivers
on Mac.
