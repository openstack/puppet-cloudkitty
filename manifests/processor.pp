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
#   Defaults to 'ceilometer'.
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
  $collector         = 'ceilometer',
  $window            = $::os_service_default,
  $period            = $::os_service_default,
  $wait_periods      = $::os_service_default,
  $services          = $::os_service_default,
  $auth_type         = 'password',
  $auth_section      = 'keystone_authtoken',
) {

  include ::cloudkitty::deps
  include ::cloudkitty::params

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

  if $collector == 'ceilometer' {
    cloudkitty_config{
      'ceilometer_collector/auth_type':    value => $auth_type;
      'ceilometer_collector/auth_section': value => $auth_section
    }
    cloudkitty_config {
      'gnocchi_collector/auth_type': ensure => absent;
      'gnocchi_collector/auth_section': ensure => absent;
    }
    $collector_real = $collector
  } else{
    warning('Valid values of the collector option are ceilometer and gnocchi')
    cloudkitty_config{
      'gnocchi_collector/auth_type':    value => $auth_type;
      'gnocchi_collector/auth_section': value => $auth_section;
    }
    cloudkitty_config {
      'ceilometer_collector/auth_type':    ensure => absent;
      'ceilometer_collector/auth_section': ensure => absent;
    }
    $collector_real = 'gnocchi'
  }

  cloudkitty_config {
    'collect/collector': value => $collector_real;
  }
}
