#!/usr/bin/env bash

# stop db and add skip grant tables option
# to be able to set a new root password
systemctl stop mysqld
systemctl set-environment MYSQLD_OPTS="--skip-grant-tables"
systemctl start mysqld

# set new password
# create webappdb database
# create vault user
# set vault user password
# set vault user grants
mysql -uroot <<EOF

# change root password
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY 'sup3rPw#';

# create db WEBAPPDB
DROP DATABASE IF EXISTS webappdb;
CREATE DATABASE webappdb;

# create vault user
DROP USER IF EXISTS vault;
CREATE USER 'vault'@'%' IDENTIFIED BY '1qaz@WSX3edc';
GRANT ALL PRIVILEGES ON webappdb.* TO 'vault'@'%' WITH GRANT OPTION;
GRANT CREATE USER ON *.* to 'vault'@'%';

quit
EOF

# set mysql back to normal
systemctl stop mysqld
systemctl unset-environment MYSQLD_OPTS
systemctl start mysqld
