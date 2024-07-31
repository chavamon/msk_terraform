terraform {
  required_providers {
    mysql = {
      source  = "petoju/mysql"
      version = ">= 1.9.0"
    }
  }
}

provider "aws" {
  region = var.region
}

provider "mysql" {
  endpoint = format("%s:%d", "localhost", var.mysql_port)
  username = "admin"
  password = "chavamone"
}

resource "mysql_database" "ecommerce_db" {
  name = "ecommerce-db"
}

resource "mysql_user" "admin" {
  user     = "admin"
  host     = "%"
  plaintext_password = "chavamone"
}

resource "mysql_grant" "admin" {
  user       = mysql_user.admin.user
  host       = mysql_user.admin.host
  database   = mysql_database.ecommerce_db.name
  privileges = ["ALL PRIVILEGES"]
}