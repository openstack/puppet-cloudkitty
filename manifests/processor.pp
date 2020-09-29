# == Class: cloudkitty::processor
#
# Installs & configure the cloudkitty processor service
#
# === Parameters
#
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
# [*collector*]
#   (Optional) Data collector.
#   Defaults to 'gnocchi'.
#
# [*window*]
#   (Optional) Number of samples to collect per call.
#   Defaults to $::os_service_default.
#
# [*period*]
#   (Optional) Rating period in seconds.
#   Defaults to $::os_service_default.
#
# [*wait_periods*]
#   (optional) Wait for N periods before collecting new data.
#   Defaults to $::os_service_default.
#
# [*services*]
#   (optional) Services to monitor.
#   Defaults to $::os_service_default.
#
# [*auth_type*]
#   (optional) Authentication type to load.
#   Default to 'password'.
#
# [*auth_section*]
#   (optional) Config Section from which to load plugin specific options
#   Default to 'keystone_authtoken'.
#
class cloudkitty::processor (
  $package_ensure    = 'present',
  $manage_service    = true,
  $enabled           = true,
  $collector         = 'gnocchi',
  $window            = $::os_service_default,
  $period            = $::os_service_default,
  $wait_periods      = $::os_service_default,
  $services          = $::os_service_default,
  $auth_type         = 'password',
  $auth_section      = 'keystone_authtoken',
) {

  include cloudkitty::deps
  include cloudkitty::params

  package { 'cloudkitty-processor':
    ensure => $package_ensure,
    name   => $::cloudkitty::params::processor_package_name,
    tag    => ['openstack', 'cloudkitty-package'],
  }

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }
  }

  service { 'cloudkitty-processor':
    ensure     => $service_ensure,
    name       => $::cloudkitty::params::processor_service_name,
    enable     => $enabled,
    hasstatus  => true,
    hasrestart => true,
    tag        => 'cloudkitty-service',
  }

  cloudkitty_config {
    'collect/window':       value => $window;
    'collect/period':       value => $period;
    'collect/wait_periods': value => $wait_periods;
    'collect/services':     value => $services;
  }

  if $collector != 'gnocchi' {
    warning('Valid value of the collector option is gnocchi')
    $collector = 'gnocchi'
  }

  cloudkitty_config {
    'collect/collector':              value => $collector;
    'collector_gnocchi/auth_type':    value => $auth_type;
    'collector_gnocchi/auth_section': value => $auth_section
  }

}
