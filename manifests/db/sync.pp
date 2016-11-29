#
# Class to execute cloudkitty-manage db_sync
#
# == Parameters
#
# [*extra_params*]
#   (optional) String of extra command line parameters to append
#   to the cloudkitty-dbsync command.
#   Defaults to undef
#
class cloudkitty::db::sync(
  $extra_params  = undef,
) {

  include ::cloudkitty::deps

  exec { 'cloudkitty-db-sync':
    command     => "cloudkitty-dbsync upgrade ${extra_params}",
    path        => [ '/bin', '/usr/bin', ],
    user        => 'cloudkitty',
    refreshonly => true,
    try_sleep   => 5,
    tries       => 10,
    logoutput   => on_failure,
    subscribe   => [
      Anchor['cloudkitty::install::end'],
      Anchor['cloudkitty::config::end'],
      Anchor['cloudkitty::dbsync::begin']
    ],
    notify      => Anchor['cloudkitty::dbsync::end'],
  }
}
