#
# Class to configure the gnocchi tenant/project fetcher
#
# == Parameters
# [*scope_attribute*]
#   Attribute from which scope_ids should be collected. (string value)
#   Defaults to $facts['os_service_default'].
#
# [*resource_types*]
#   List of gnocchi resource types. All if left blank (list value)
#   Defaults to $facts['os_service_default'].
#
# [*gnocchi_auth_type*]
#   Gnocchi auth type (keystone or basic). Keystone credentials can be
#   specified through the "auth_section" parameter (string value)
#   Defaults to $facts['os_service_default'].
#
# [*gnocchi_user*]
#   Gnocchi user (for basic auth only) (string value)
#   Defaults to $facts['os_service_default'].
#
# [*gnocchi_endpoint*]
#   Gnocchi endpoint (for basic auth only) (string value)
#   Defaults to $facts['os_service_default'].
#
# [*interface*]
#   Endpoint URL type (for keystone auth only) (string value)
#   Defaults to $facts['os_service_default'].
#
# [*region_name*]
#   Region Name (string value)
#   Defaults to $facts['os_service_default'].
#
# [*auth_type*]
#   Authentication type to load (string value)
#   Defaults to $facts['os_service_default'].
#
# [*auth_section*]
#   Config Section from which to load plugin specific options (string
#   value)
#   Defaults to $facts['os_service_default'].
#
class cloudkitty::fetcher::gnocchi(
  String $scope_attribute   = $facts['os_service_default'],
  String $resource_types    = $facts['os_service_default'],
  String $gnocchi_auth_type = $facts['os_service_default'],
  String $gnocchi_user      = $facts['os_service_default'],
  String $gnocchi_endpoint  = $facts['os_service_default'],
  String $interface         = $facts['os_service_default'],
  String $region_name       = $facts['os_service_default'],
  String $auth_type         = $facts['os_service_default'],
  String $auth_section      = $facts['os_service_default'],
){
  include cloudkitty::deps

  cloudkitty_config {
    'fetcher_gnocchi/scope_attribute':   value => $scope_attribute;
    'fetcher_gnocchi/resource_types':    value => join(any2array($resource_types), ',');
    'fetcher_gnocchi/gnocchi_auth_type': value => $gnocchi_auth_type;
    'fetcher_gnocchi/gnocchi_user':      value => $gnocchi_user;
    'fetcher_gnocchi/gnocchi_endpoint':  value => $gnocchi_endpoint;
    'fetcher_gnocchi/interface':         value => $interface;
    'fetcher_gnocchi/region_name':       value => $region_name;
    'fetcher_gnocchi/auth_type':         value => $auth_type;
    'fetcher_gnocchi/auth_section':      value => $auth_section;
  }
}
