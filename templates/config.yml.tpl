---
{{- with secret "database/creds/mysqlrole" }}
username: {{ .Data.username }}
password: {{ .Data.password }}
database: "MYWEBDBAPP"
{{- end }}
