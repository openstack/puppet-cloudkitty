# == Class: cloudkitty::db::postgresql
#
# Class that configures postgresql for cloudkitty
# Requires the Puppetlabs postgresql module.
#
# === Parameters
#
# [*password*]
#   (Required) Password to connect to the database.
#
# [*dbname*]
#   (Optional) Name of the database.
#   Defaults to 'cloudkitty'.
#
# [*user*]
#   (Optional) User to connect to the database.
#   Defaults to 'cloudkitty'.
#
#  [*encoding*]
#    (Optional) The charset to use for the database.
#    Default to undef.
#
#  [*privileges*]
#    (Optional) Privileges given to the database user.
#    Default to 'ALL'
#
class cloudkitty::db::postgresql(
  $password,
  $dbname     = 'cloudkitty',
  $user       = 'cloudkitty',
  $encoding   = undef,
  $privileges = 'ALL',
) {

  include cloudkitty::deps

  openstacklib::db::postgresql { 'cloudkitty':
    password   => $password,
    dbname     => $dbname,
    user       => $user,
    encoding   => $encoding,
    privileges => $privileges,
  }

  Anchor['cloudkitty::db::begin']
  ~> Class['cloudkitty::db::postgresql']
  ~> Anchor['cloudkitty::db::end']

}
