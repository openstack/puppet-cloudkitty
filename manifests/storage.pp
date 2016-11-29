#
# Class to execute cloudkitty-storage-init
#
# == Parameters
#
# [*extra_params*]
#   (optional) String of extra command line parameters to append
#   to the cloudkitty-storage-init command.
#   Defaults to '--config-file /etc/cloudkitty/cloudkitty.conf'
#
class cloudkitty::storage(
  $extra_params = '--config-file /etc/cloudkitty/cloudkitty.conf',
){

  include ::cloudkitty::deps

  exec { 'cloudkitty-storage-init':
    command     => "cloudkitty-storage-init ${extra_params}",
    path        => '/usr/bin',
    user        => 'cloudkitty',
    refreshonly => true,
    try_sleep   => 5,
    tries       => 10,
    logoutput   => on_failure,
    subscribe   => [
      Anchor['cloudkitty::install::end'],
      Anchor['cloudkitty::config::end'],
      Anchor['cloudkitty::dbsync::begin'],
      Anchor['cloudkitty::storageinit::begin']
    ],
    notify      => Anchor['cloudkitty::storageinit::end'],
  }
}
