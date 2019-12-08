# == Class cloudkitty::client
#
# Installs the cloudkitty client.
#
# == Parameters
#
#  [*ensure*]
#    (Optional) The state for the cloudkitty client package.
#    Defaults to 'present'.
#
class cloudkitty::client (
  $ensure = 'present'
) {

  include cloudkitty::deps
  include cloudkitty::params

  package { 'python-cloudkittyclient':
    ensure => $ensure,
    name   => $::cloudkitty::params::client_package_name,
    tag    => 'openstack',
  }

}
