# == Class: cloudkitty::api
#
# Installs & configure the cloudkitty API service
#
# === Parameters
# [*package_ensure*]
#   (Optional) Ensure state for package.
#   Defaults to 'present'.
#
# [*enabled*]
#   (optional) Should the service be enabled.
#   Defaults to 'true'.
#
# [*manage_service*]
#   (optional) Whether the service should be managed by Puppet.
#   Defaults to 'true'.
#
# [*host_ip*]
#   (Optional) Host serving the API.
#   Defaults to $::os_service_default.
#
# [*port*]
#   (Optional) Host port serving the API.
#   Defaults to $::os_service_default.
#
# [*pecan_debug*]
#   (Optional) Toggle Pecan Debug Middleware.
#   Defaults to $::os_service_default.
#
# [*sync_db*]
#   (optional) Run cloudkitty-dbsync command on api nodes after installing the package.
#   Defaults to true.
#
class cloudkitty::api (
  $package_ensure = 'present',
  $manage_service = true,
  $enabled        = true,
  $host_ip        = $::os_service_default,
  $port           = $::os_service_default,
  $pecan_debug    = $::os_service_default,
  $sync_db        = true,
) {

  include ::cloudkitty
  include ::cloudkitty::deps
  include ::cloudkitty::params
  include ::cloudkitty::policy

  package { 'cloudkitty-api':
    ensure => $package_ensure,
    name   => $::cloudkitty::params::api_package_name,
    tag    => ['openstack', 'cloudkitty-package'],
  }

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }
  }

  if $sync_db {
    include ::cloudkitty::db::sync
  }

  service { 'cloudkitty-api':
    ensure     => $service_ensure,
    name       => $::cloudkitty::params::api_service_name,
    enable     => $enabled,
    hasstatus  => true,
    hasrestart => true,
    tag        => 'cloudkitty-service',
  }

  cloudkitty_config {
    'api/host_ip':     value => $host_ip;
    'api/port':        value => $port;
    'api/pecan_debug': value => $pecan_debug;
  }
}
