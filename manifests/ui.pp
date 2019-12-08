# == Class: cloudkitty::ui
#
# Installs & configure the cloudkitty ui component
#
# === Parameters
#
# [*package_ensure*]
#   (Optional) Ensure state for package.
#   Defaults to 'present'.
#
class cloudkitty::ui (
  $package_ensure = 'present',
) {

  include cloudkitty::deps
  include cloudkitty::params

  package { 'cloudkitty-ui':
    ensure => $package_ensure,
    name   => $::cloudkitty::params::ui_package_name,
    tag    => ['openstack', 'cloudkitty-package'],
  }

}
