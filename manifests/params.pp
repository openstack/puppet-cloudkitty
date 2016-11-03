# == Class: cloudkitty::params
#
# Parameters for puppet-cloudkitty
#
class cloudkitty::params {

  case $::osfamily {
    'RedHat': {
    # package names
    $api_package_name       = 'openstack-cloudkitty-api'
    $processor_package_name = 'openstack-cloudkitty-processor'
    $ui_package_name        = 'openstack-cloudkitty-ui'
    $common_package_name    = 'openstack-cloudkitty-common'
    $client_package_name    = 'python-cloudkittyclient'
    # service names
    $api_service_name       = 'cloudkitty-api'
    $processor_service_name = 'cloudkitty-processor'
    }
    'Debian': {
    # package names
    $api_package_name       = 'cloudkitty-api'
    $processor_package_name = 'cloudkitty-processor'
    $ui_package_name        = 'cloudkitty-dashboard'
    $common_package_name    = 'cloudkitty-common'
    $client_package_name    = 'python-cloudkittyclient'
    # service names
    $api_service_name       = 'cloudkitty-api'
    $processor_service_name = 'cloudkitty-processor'
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem")
    }

  }
}
