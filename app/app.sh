#!/usr/bin/env bash

cat <<EOT
My app connection string is:

username: "${DATABASE_CREDS_MYSQLROLE.USERNAME}"
password: "${DATABASE_CREDS_MYSQLROLE.PASSWORD}"
database: "MYWEBDBAPP"
EOT
