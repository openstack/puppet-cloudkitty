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
#   Defaults to $facts['os_service_default'].
#
# [*port*]
#   (Optional) Host port serving the API.
#   Defaults to $facts['os_service_default'].
#
# [*pecan_debug*]
#   (Optional) Toggle Pecan Debug Middleware.
#   Defaults to $facts['os_service_default'].
#
# [*sync_db*]
#   (optional) Run cloudkitty-dbsync command on api nodes after installing the package.
#   Defaults to true.
#
# [*service_name*]
#   (optional) Name of the service that will be providing the
#   server functionality of cloudkitty-api.
#   If the value is 'httpd', this means cloudkitty-api will be a web
#   service, and you must use another class to configure that
#   web service. For example, use class { 'cloudkitty::wsgi::apache'...}
#   to make cloudkitty-api be a web app using apache mod_wsgi.
#   Defaults to 'httpd'
#
# [*enable_proxy_headers_parsing*]
#   (Optional) Enable paste middleware to handle SSL requests through
#   HTTPProxyToWSGI middleware.
#   Defaults to $facts['os_service_default'].
#
# [*max_request_body_size*]
#   (Optional) Set max request body size
#   Defaults to $facts['os_service_default'].
#
class cloudkitty::api (
  $package_ensure               = 'present',
  $manage_service               = true,
  $enabled                      = true,
  $host_ip                      = $facts['os_service_default'],
  $port                         = $facts['os_service_default'],
  $pecan_debug                  = $facts['os_service_default'],
  $sync_db                      = true,
  $service_name                 = 'httpd',
  $enable_proxy_headers_parsing = $facts['os_service_default'],
  $max_request_body_size        = $facts['os_service_default'],
) {

  include cloudkitty
  include cloudkitty::deps
  include cloudkitty::params
  include cloudkitty::policy

  package { 'cloudkitty-api':
    ensure => $package_ensure,
    name   => $::cloudkitty::params::api_package_name,
    tag    => ['openstack', 'cloudkitty-package'],
  }

  if $sync_db {
    include cloudkitty::db::sync
  }

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }

    if $service_name == $::cloudkitty::params::api_service_name {
      service { 'cloudkitty-api':
        enable     => $enabled,
        name       => 'cloudkitty-api',
        hasstatus  => true,
        hasrestart => true,
        tag        => 'cloudkitty-service',
      }
    } elsif $service_name == 'httpd' {
      service { 'cloudkitty-api':
        ensure => 'stopped',
        name   => $::cloudkitty::params::api_service_name,
        enable => false,
        tag    => 'cloudkitty-service',
      }
      Service <| title == 'httpd' |> { tag +> 'cloudkitty-service' }

      # we need to make sure cloudkitty-api/eventlet is stopped before trying to start apache
      Service['cloudkitty-api'] -> Service[$service_name]
    } else {
      fail('Invalid service_name. Only httpd for being run by a httpd server')
    }
  }

  cloudkitty_config {
    'api/host_ip':     value => $host_ip;
    'api/port':        value => $port;
    'api/pecan_debug': value => $pecan_debug;
  }

  oslo::middleware { 'cloudkitty_config':
    enable_proxy_headers_parsing => $enable_proxy_headers_parsing,
    max_request_body_size        => $max_request_body_size,
  }

}
