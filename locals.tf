##################################################
# Author: Majdi Dhissi
# Project: F1 Telemetry with AWS
# Description: 
# This Terraform configuration declares local variables to specify CPU and memory allocations for various ECS containers 
# used in the telemetry project. These variables are utilized in the ECS task definition to ensure adequate resources 
# are allocated for each container, improving performance and reliability.
##################################################
locals {
  influxdb_cpu        = 1024  # CPU units for InfluxDB
  influxdb_memory     = 2048  # Memory in MB for InfluxDB
  grafana_cpu         = 512   # CPU units for Grafana
  grafana_memory      = 1024  # Memory in MB for Grafana
  fluxdbexporter_cpu  = 512   # CPU units for FluxDB Exporter
  fluxdbexporter_memory = 1024 # Memory in MB for FluxDB Exporter
}