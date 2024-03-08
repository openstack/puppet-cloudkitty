#
# Class to execute cloudkitty-storage-init
#
# == Parameters
#
# [*extra_params*]
#   (optional) String of extra command line parameters to append
#   to the cloudkitty-storage-init command.
#   Defaults to ''
#
class cloudkitty::storage(
  $extra_params = ''
){

  include cloudkitty::deps
  include cloudkitty::params

  exec { 'cloudkitty-storage-init':
    command     => "cloudkitty-storage-init ${extra_params}",
    path        => '/usr/bin',
    user        => $::cloudkitty::params::user,
    refreshonly => true,
    try_sleep   => 5,
    tries       => 10,
    logoutput   => on_failure,
    subscribe   => [
      Anchor['cloudkitty::install::end'],
      Anchor['cloudkitty::config::end'],
      Anchor['cloudkitty::dbsync::end'],
      Anchor['cloudkitty::storageinit::begin']
    ],
    notify      => Anchor['cloudkitty::storageinit::end'],
  }
}
