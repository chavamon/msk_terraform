# Output the Kafka broker URLs for connecting to the cluster
# output "kafka_broker_urls" {
output "kafka_broker_urls" {
    value = aws_msk_cluster.MyMSKCluster.bootstrap_brokers_tls
}