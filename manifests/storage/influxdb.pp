#
# Class to configure influxdb storage
#
# == Parameters
#
# [*username*]
#   InfluxDB username (string value)
# [*password*]
#   InfluxDB password (string value)
# [*database*]
#   InfluxDB database (string value)
# [*retention_policy*]
#   Retention policy to use (string value)
# [*host*]
#   InfluxDB host (string value)
# [*port*]
#   InfluxDB port (integer value)
# [*use_ssl*]
#   Set to true to use ssl for influxDB connection.
#   (boolean value)
# [*insecure*]
#   Set to true to authorize insecure HTTPS connections to influxDB.
# [*cafile*]
#   Path of the CA certificate to trust for HTTPS
#   connections (string value)
#
class cloudkitty::storage::influxdb(
  String                     $username         = $::os_service_default,
  String                     $password         = $::os_service_default,
  String                     $database         = $::os_service_default,
  String                     $retention_policy = $::os_service_default,
  String                     $host             = $::os_service_default,
  Variant[String[0],Integer] $port             = $::os_service_default,
  Variant[String[0],Boolean] $use_ssl          = $::os_service_default,
  Variant[String[0],Boolean] $insecure         = $::os_service_default,
  String                     $cafile           = $::os_service_default,
){

  include cloudkitty::deps

  cloudkitty_config {
    'storage_influxdb/username':         value => $username;
    'storage_influxdb/password':         value => $password, secret => true;
    'storage_influxdb/database':         value => $database;
    'storage_influxdb/retention_policy': value => $retention_policy;
    'storage_influxdb/host':             value => $host;
    'storage_influxdb/port':             value => $port;
    'storage_influxdb/use_ssl':          value => $use_ssl;
    'storage_influxdb/insecure':         value => $insecure;
    'storage_influxdb/cafile':           value => $cafile;
  }
}
