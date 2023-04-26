# Install SQL Server Drivers on Mac

This is tricky so you may need to play around with a different drivers etc. We 
need to install the drivers and make sure that they are available to be used in 
R. The odbc package is used. On the new Mac I had to use version 17 of the 
drivers.

## Install ODBC Drivers

Use instructions from the link to install the drivers using Homebrew:

```         
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
brew tap microsoft/mssql-release https://github.com/Microsoft/homebrew-mssql-release
brew update
HOMEBREW_ACCEPT_EULA=Y brew install msodbcsql17 mssql-tools
```

REF: [Install the Microsoft ODBC driver for SQL Server (macOS)](https://learn.microsoft.com/en-us/sql/connect/odbc/linux-mac/install-microsoft-odbc-driver-sql-server-macos)

Verify that the drivers were installed 

    odbcinst -q -d

## Install ODBC R Package

    install.packages("odbc")
    
Once you install the package you can see if R can locate your drivers:

```         
odbc::odbcListDrivers()
```

If the driver appears you can use code like this to connect to the database:

    con <- dbConnect(odbc(),
                     driver = "ODBC Driver 17 for SQL Server",
                     server = "your_server_name",
                     database = "your_database_name",
                     uid = "your_user_id",
                     pwd = "your_password")

Make sure to use the exact spelling.

## Update Renviron File

If R cannot yet see the driver, you will need to edit the Renviron file. 
Locate the file for your installation using this code in the R terminal:

    R.home("etc")

This gives you the location of your R installation. To edit the file you can
use vim (or any text editor, but it's a pain to navigate here). Here is how
to do this from Terminal:

    cd /Library/Frameworks/R.framework/Resources/etc
    vim Renviron
    
Add this line to your Renviron file:

    ODBCSYSINI=/opt/homebrew/etc

Make sure to save the file (ESC, :wq).

## Test Drivers

Restart R and use the odbc command above to test if you can see the drivers 
listed now. If so, you should be able to use the Connection Pane or code
to access the database.

# References

You can view the folder contents of your home directory with this command:

    ls -a ~/

<https://learn.microsoft.com/en-us/sql/connect/odbc/linux-mac/install-microsoft-odbc-driver-sql-server-macos>

<https://solutions.posit.co/connections/db/best-practices/drivers/>
