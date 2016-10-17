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
  exec { 'cloudkitty-db-sync':
    command     => "cloudkitty-manage db_sync ${extra_params}",
    path        => [ '/bin', '/usr/bin', ],
    user        => 'cloudkitty',
    refreshonly => true,
    try_sleep   => 5,
    tries       => 10,
    subscribe   => [Package['cloudkitty'], Cloudkitty_config['database/connection']],
  }

  Exec['cloudkitty-manage db_sync'] ~> Service<| title == 'cloudkitty' |>
}
