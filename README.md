# Use Vault to create dynamic logins to a mysql database so that an app will be able to use it for its database backend

### Prerequisites

* vagrant
* git
* virtualbox

## Start lab

```
git clone https://github.com/achuchulev/vault-mysql-dyn_logins.git
cd vault-mysql-dyn_logins
vagrant up
```

## Configure DB

#### Connect to DB box: 

`vagrant ssh db`

#### A temporary password is generated for the MySQL root user. Locate it in the mysqld.log with command:

`sudo grep 'temporary password' /var/log/mysqld.log`

#### Change MySQL root password with command:

`sudo mysql_secure_installation`

#### Craeate DB user for Vault to connect

Connect to db with root: `mysql -u root -p`

```
CREATE DATABASE webappdb;
CREATE USER 'vault'@'%' IDENTIFIED BY '1qaz@WSX3edc';
GRANT ALL PRIVILEGES ON webappdb.* TO 'vault'@'%' WITH GRANT OPTION;
GRANT CREATE USER ON *.* to 'vault'@'%';
```

## Configure Vault

#### Connect to Vault box: 

```
vagrant ssh vault
sudo su -
```

#### Enable vault database engine

`vault secrets enable database`

#### Configure Vault *mysql-database-plugin* to be able to talk to MySQL database

```
vault write database/config/webappdb \
plugin_name=mysql-database-plugin \
connection_url="{{username}}:{{password}}@tcp(192.168.2.20:3306)/" \
allowed_roles="mysqlrole" \
username="vault" \
password="1qaz@WSX3edc"
```

#### Configure the role that maps a name within Vault to a SQL statement to create the user within the mysql database

```
vault write database/roles/mysqlrole \
db_name=webappdb \
creation_statements="CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}';GRANT ALL PRIVILEGES ON webappdb.* TO '{{name}}'@'%';" \
default_ttl="1h" \
max_ttl="24h"
```

#### Tell Vault to give us a new login to MySQL database

`vault read database/creds/mysqlrole`

#### Test credentials

From db box, run: `mysql -u vaultnewuser -p` and provide the password that has been just genereted by Vault

