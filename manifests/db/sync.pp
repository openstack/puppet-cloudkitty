#
# Class to execute cloudkitty-manage db_sync
#
# == Parameters
#
# [*extra_params*]
#   (Optional) String of extra command line parameters to append
#   to the cloudkitty-dbsync command.
#   Defaults to undef
#
# [*db_sync_timeout*]
#   (Optional) Timeout for the execution of the db_sync
#   Defaults to 300
#
class cloudkitty::db::sync(
  $extra_params    = undef,
  $db_sync_timeout = 300,
) {

  include cloudkitty::deps
  include cloudkitty::params

  exec { 'cloudkitty-db-sync':
    command     => "cloudkitty-dbsync upgrade ${extra_params}",
    path        => [ '/bin', '/usr/bin', ],
    user        => $::cloudkitty::params::user,
    refreshonly => true,
    try_sleep   => 5,
    tries       => 10,
    timeout     => $db_sync_timeout,
    logoutput   => on_failure,
    subscribe   => [
      Anchor['cloudkitty::install::end'],
      Anchor['cloudkitty::config::end'],
      Anchor['cloudkitty::dbsync::begin']
    ],
    notify      => Anchor['cloudkitty::dbsync::end'],
    tag         => 'openstack-db',
  }
}
