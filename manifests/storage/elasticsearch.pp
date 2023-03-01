#
# Class to configure elasticsearch storage
#
# == Parameters
#
# [*host*]
#   Elasticsearch host, along with port and protocol. (string value)
# [*index_name*]
#   Elasticsearch index to use. (string value)
# [*insecure*]
#   Set to true to authorize insecure HTTPS connections to elasticsearch.
# [*cafile*]
#   Path of the CA certificate to trust for HTTPS connections (string value).
# [*scroll_duration*]
#   Duration (in seconds) for which the ES scroll contexts should be kept
#   alive. (interer value)
#
class cloudkitty::storage::elasticsearch(
  String                     $host            = $facts['os_service_default'],
  String                     $index_name      = $facts['os_service_default'],
  Variant[String[0],Boolean] $insecure        = $facts['os_service_default'],
  String                     $cafile          = $facts['os_service_default'],
  Variant[String[0],Integer] $scroll_duration = $facts['os_service_default'],
){

  include cloudkitty::deps

  cloudkitty_config {
    'storage_elasticsearch/host':            value => $host;
    'storage_elasticsearch/index_name':      value => $index_name;
    'storage_elasticsearch/insecure':        value => $insecure;
    'storage_elasticsearch/cafile':          value => $cafile;
    'storage_elasticsearch/scroll_duration': value => $scroll_duration;
  }
}
