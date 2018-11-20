#!/usr/bin/env bash

cat <<EOT
My app connection string is:

username: "${DATABASE_CREDS_MYSQLROLE_USERNAME}"
password: "${DATABASE_CREDS_MYSQLROLE_PASSWORD}"
database: "MYWEBDBAPP"
EOT
