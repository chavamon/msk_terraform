output "database_name" {
  description = "The name of the MySQL database"
  value       = mysql_database.ecommerce_db.name
}

output "database_user" {
  description = "The MySQL user with access to the database"
  value       = mysql_user.admin.user
}

output "database_host" {
  description = "The host from which the MySQL user can connect"
  value       = mysql_user.admin.host
}