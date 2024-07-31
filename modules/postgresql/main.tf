terraform {
  required_version = ">= 1.1.6"
  required_providers {
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = ">= 1.15.0"
    }
  }
}

provider "postgresql" {
  host     = "localhost"
  port     = 5432
  username = "ecommerce-postgres-admin"
  password = "mypassword"
}

resource "postgresql_database" "ecommerce-postgres-db" {
  name  = "ecommerce-postgres-db"
  owner = "ecommerce-postgres-admin"
}

resource "postgresql_role" "my-postgres-user" {
  name     = "ecommerce-postgres-admin"
  login    = true
  password = "mypassword"
}

resource "postgresql_schema" "my-postgres-schema" {
  name     = "my-postgres-schema"
  owner    = "ecommerce-postgres-admin"
  database = postgresql_database.ecommerce-postgres-db.name
}

resource "null_resource" "create_tables" {
  provisioner "local-exec" {
    command = <<EOT
      PGPASSWORD=mypassword psql -h localhost -U ecommerce-postgres-admin -d ecommerce-postgres-db <<SQL
      CREATE TABLE my-postgres-schema.products (
        id SERIAL PRIMARY KEY,
        name TEXT,
        price NUMERIC
      );
      CREATE TABLE my-postgres-schema.orders (
        id SERIAL PRIMARY KEY,
        product_id INTEGER,
        quantity INTEGER,
        total NUMERIC
      );
      CREATE TABLE my-postgres-schema.customers (
        id SERIAL PRIMARY KEY,
        name TEXT,
        email TEXT
      );
      CREATE TABLE my-postgres-schema.addresses (
        id SERIAL PRIMARY KEY,
        customer_id INTEGER,
        street TEXT,
        city TEXT,
        state TEXT,
        zip TEXT
      );
      CREATE TABLE my-postgres-schema.payments (
        id SERIAL PRIMARY KEY,
        order_id INTEGER,
        amount NUMERIC,
        payment_date DATE
      );
      SQL
    EOT
  }
}