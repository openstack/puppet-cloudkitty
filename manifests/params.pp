# == Class: cloudkitty::params
#
# Parameters for puppet-cloudkitty
#
class cloudkitty::params {
  include ::openstacklib::defaults

  $client_package_name    = 'python-cloudkittyclient'
  $api_service_name       = 'cloudkitty-api'
  $processor_service_name = 'cloudkitty-processor'

  case $::osfamily {
    'RedHat': {
    # package names
    $api_package_name       = 'openstack-cloudkitty-api'
    $processor_package_name = 'openstack-cloudkitty-processor'
    $ui_package_name        = 'openstack-cloudkitty-ui'
    $common_package_name    = 'openstack-cloudkitty-common'
    }
    'Debian': {
    # package names
    $api_package_name       = 'cloudkitty-api'
    $processor_package_name = 'cloudkitty-processor'
    $ui_package_name        = 'cloudkitty-dashboard'
    $common_package_name    = 'cloudkitty-common'
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem")
    }

  }
}
