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
    $api_package_name              = 'openstack-cloudkitty-api'
    $processor_package_name        = 'openstack-cloudkitty-processor'
    $ui_package_name               = 'openstack-cloudkitty-ui'
    $common_package_name           = 'openstack-cloudkitty-common'
    $cloudkitty_wsgi_script_source = '/usr/lib/python2.7/site-packages/cloudkitty/api/app.wsgi'
    $cloudkitty_wsgi_script_path   = '/var/www/cgi-bin/cloudkitty'
    }
    'Debian': {
    # package names
    $api_package_name              = 'cloudkitty-api'
    $processor_package_name        = 'cloudkitty-processor'
    $ui_package_name               = 'cloudkitty-dashboard'
    $common_package_name           = 'cloudkitty-common'
    $cloudkitty_wsgi_script_source = '/usr/lib/python2.7/dist-packages/cloudkitty/api/app.wsgi'
    $cloudkitty_wsgi_script_path   = '/usr/lib/cgi-bin/cloudkitty'
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem")
    }

  }
}
