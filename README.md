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

Vagrant up will run `scripts/setup_mysql.sh` that will:

- stop db and add skip grant tables option
- to be able to set a new root password
- set new password
- create webappdb database
- create vault user
- set vault user password
- set vault user grants
- change root password
- create db WEBAPPDB
- create vault user
- set mysql back to normal


New password:
root - `sup3rPw#`
vault - `1qaz@WSX3edc`


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
creation_statements="CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}';GRANT ALL PRIVILEGES ON WEBAPPDB.* TO '{{name}}'@'%';" \
default_ttl="1h" \
max_ttl="24h"
```

#### Create new policies in Vault to control what a user can access

```
vault policy write mysql-policy -<<EOF
# Get credentials from database backend
path "database/creds/mysqlrole" {
  capabilities = ["read"]
}
EOF
```

## Tell Vault to generate a new login to MySQL database

From vagrant box, run:

`vault read database/creds/mysqlrole`

#### Test credentials

From db box, run: `mysql -u vaultnewuser -p` and provide the password that has been just genereted by Vault



## Direct application integration with consule-template and envconsul tools

### Consul-Template

#### It runs as a daemon which queries a Consul or Vault cluster and updates any number of specified templates on the file system

Create a template file based on your application connection string with extension `.tpl`

Example template `config.yml.tpl`

```
---
{{- with secret "database/creds/mysqlrole" }}
username: {{ .Data.username }}
password: {{ .Data.password }}
database: "MYWEBDBAPP"
{{- end }}
```

Create vault token for consule-template

```
vault token create -policy=mysql-policy
```

Run command for consule-teplate to create config.yml with filled in credentials

```
VAULT_TOKEN="h7bYwJfRw0uPf7QGTBXVmfws" consul-template -template="templates/config.yml.tpl:config.yml" -once
```

Result `config.yml` file should be similar to:

```
---
username: v-token-mysqlrole-17OOCVpiprxlon
password: A1a-47o3jbRX4hxmzsKg
database: "MYWEBDBAPP"
```

### Envconsul

#### The tool launches a subprocess with environment variables populated from HashiCorp Vault that are being populated dynamically and applications read them directly

Example of application with connection string:

```
#!/usr/bin/env bash

cat <<EOT
My app that has following connection string:
username: "${DATABASE_CREDS_MYSQLROLE_USERNAME}"
password: "${DATABASE_CREDS_MYSQLROLE_PASSWORD}"
database: "MYWEBDBAPP"
EOT
```

Create vault token for consule-template

```
vault token create -policy=mysql-policy
```

Run command for envconsul to launch a subprocess with environment variables populated from Vault which application read and use

```
VAULT_TOKEN="h7bYwJfRw0uPf7QGTBXVmfws" envconsul -upcase -secret database/creds/mysqlrole ./app/app.sh
```
