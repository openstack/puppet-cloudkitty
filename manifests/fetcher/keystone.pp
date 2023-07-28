# == Class: cloudkitty::fetcher::keystone
#
# Configure the fetcher_keystone parameters
#
# === Parameters
#
# [*auth_section*]
#  Config Section from which to load plugin specific options (string value)
#  Defaults to 'keystone_authtoken'. The default will be changed in
#  a future release.
#
# [*auth_url*]
#  (Optional) The URL to use for authentication.
#  Defaults to $facts['os_service_default'].
#
# [*username*]
#  (Optional) The name of the service user
#  Defaults to $facts['os_service_default'].
#
# [*password*]
#  (Optional) Password to create for the service user
#  Defaults to $facts['os_service_default'].
#
# [*project_name*]
#  (Optional) Service project name
#  Defaults to $facts['os_service_default'].
#
# [*user_domain_name*]
#  (Optional) Name of domain for $username
#  Defaults to $facts['os_service_default'].
#
# [*project_domain_name*]
#  (Optional) Name of domain for $project_name
#  Defaults to $facts['os_service_default'].
#
# [*system_scope*]
#  (Optional) Scope for system operations.
#  Defaults to $facts['os_service_default']
#
# [*auth_type*]
#  (Optional) An authentication type to use with an OpenStack Identity server.
#  Defaults to $facts['os_service_default'].
#
# [*keystone_version*]
#  (Optional) Keystone version to use.
#  Defaults to $facts['os_service_default'].
#
# [*ignore_rating_role*]
#  (Optional) Skip rating role check for cloudkitty user.
#  Defaults to $facts['os_service_default'].
#
# [*ignore_disabled_tenants*]
#  (Optional) Stop rating disabled tenants.
#  Defaults to $facts['os_service_default'].
#
class cloudkitty::fetcher::keystone (
  $auth_section            = $facts['os_service_default'],
  $auth_url                = $facts['os_service_default'],
  $username                = $facts['os_service_default'],
  $password                = $facts['os_service_default'],
  $project_name            = $facts['os_service_default'],
  $user_domain_name        = $facts['os_service_default'],
  $project_domain_name     = $facts['os_service_default'],
  $system_scope            = $facts['os_service_default'],
  $auth_type               = $facts['os_service_default'],
  $keystone_version        = $facts['os_service_default'],
  $ignore_rating_role      = $facts['os_service_default'],
  $ignore_disabled_tenants = $facts['os_service_default'],
) {

  include cloudkitty::deps

  if is_service_default($system_scope) {
    $project_name_real = $project_name
    $project_domain_name_real = $project_domain_name
  } else {
    $project_name_real = $facts['os_service_default']
    $project_domain_name_real = $facts['os_service_default']
  }

  cloudkitty_config {
    'fetcher_keystone/auth_section':            value => $auth_section;
    'fetcher_keystone/username':                value => $username;
    'fetcher_keystone/password':                value => $password, secret => true;
    'fetcher_keystone/project_name':            value => $project_name_real;
    'fetcher_keystone/user_domain_name':        value => $user_domain_name;
    'fetcher_keystone/project_domain_name':     value => $project_domain_name_real;
    'fetcher_keystone/system_scope':            value => $system_scope;
    'fetcher_keystone/auth_url':                value => $auth_url;
    'fetcher_keystone/keystone_version':        value => $keystone_version;
    'fetcher_keystone/ignore_rating_role':      value => $ignore_rating_role;
    'fetcher_keystone/ignore_disabled_tenants': value => $ignore_disabled_tenants;
  }
}
