# Declare local variables for resource allocation
locals {
  influxdb_cpu        = 1024  # CPU units for InfluxDB
  influxdb_memory     = 2048  # Memory in MB for InfluxDB
  grafana_cpu         = 512   # CPU units for Grafana
  grafana_memory      = 1024  # Memory in MB for Grafana
  fluxdbexporter_cpu  = 512   # CPU units for FluxDB Exporter
  fluxdbexporter_memory = 1024 # Memory in MB for FluxDB Exporter
}