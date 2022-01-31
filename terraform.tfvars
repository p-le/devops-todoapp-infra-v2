service_name = "devops-demo"
project_id   = "phu-le-it"
region       = "asia-northeast1"
zone         = "asia-northeast1-b"

db_config = {
  is_enabled  = "true"
  db_version  = "MYSQL_8_0"
  db_tier     = "db-f1-micro"
  db_user     = "admin"
  db_password = "5WE&ladz"
  db_name     = "todoapp"
}

frontend_config = {
  is_enabled = "true"
}

backend_config = {
  is_enabled = "true"
}
