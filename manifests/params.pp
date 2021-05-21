# == Class: cloudkitty::params
#
# Parameters for puppet-cloudkitty
#
class cloudkitty::params {
  include openstacklib::defaults

  $client_package_name    = 'python3-cloudkittyclient'
  $api_service_name       = 'cloudkitty-api'
  $processor_service_name = 'cloudkitty-processor'
  $group                  = 'cloudkitty'
  $metrics_yaml           = '/etc/cloudkitty/metrics.yml'

  case $::osfamily {
    'RedHat': {
    # package names
    $api_package_name              = 'openstack-cloudkitty-api'
    $processor_package_name        = 'openstack-cloudkitty-processor'
    $ui_package_name               = 'openstack-cloudkitty-ui'
    $common_package_name           = 'openstack-cloudkitty-common'
    $cloudkitty_wsgi_script_source = '/usr/bin/cloudkitty-api'
    $cloudkitty_wsgi_script_path   = '/var/www/cgi-bin/cloudkitty'
    }
    'Debian': {
    # package names
    $api_package_name              = 'cloudkitty-api'
    $processor_package_name        = 'cloudkitty-processor'
    $ui_package_name               = 'cloudkitty-dashboard'
    $common_package_name           = 'cloudkitty-common'
    $cloudkitty_wsgi_script_source = '/usr/bin/cloudkitty-api'
    $cloudkitty_wsgi_script_path   = '/usr/lib/cgi-bin/cloudkitty'
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem")
    }

  }
}
