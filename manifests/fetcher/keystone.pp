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
#  Defaults to $::os_service_default.
#
# [*username*]
#  (Optional) The name of the service user
#  Defaults to $::os_service_default.
#
# [*password*]
#  (Optional) Password to create for the service user
#  Defaults to $::os_service_default.
#
# [*project_name*]
#  (Optional) Service project name
#  Defaults to $::os_service_default.
#
# [*user_domain_name*]
#  (Optional) Name of domain for $username
#  Defaults to $::os_service_default.
#
# [*project_domain_name*]
#  (Optional) Name of domain for $project_name
#  Defaults to $::os_service_default.
#
# [*auth_type*]
#  (Optional) An authentication type to use with an OpenStack Identity server.
#  Defaults to $::os_service_default.
#
# [*keystone_version*]
#  (Optional) Keystone version to use.
#  Defaults to $::os_service_default.
#
# [*ignore_rating_role*]
#  (Optional) Skip rating role check for cloudkitty user.
#  Defaults to $::os_service_default.
#
# [*ignore_disabled_tenants*]
#  (Optional) Stop rating disabled tenants.
#  Defaults to $::os_service_default.
#
class cloudkitty::fetcher::keystone (
  $auth_section            = undef,
  $auth_url                = $::os_service_default,
  $username                = $::os_service_default,
  $password                = $::os_service_default,
  $project_name            = $::os_service_default,
  $user_domain_name        = $::os_service_default,
  $project_domain_name     = $::os_service_default,
  $auth_type               = $::os_service_default,
  $keystone_version        = $::os_service_default,
  $ignore_rating_role      = $::os_service_default,
  $ignore_disabled_tenants = $::os_service_default,
) {

  include cloudkitty::deps

  if defined('$::cloudkitty::auth_section') and $::cloudkitty::auth_section {
    $auth_section_real = $::cloudkitty::auth_section
  } else {
    if $auth_section == undef {
      warning('Default of the auth_section parameter will be changed in a future release')
    }
    $auth_section_real = pick($auth_section, 'keystone_authtoken')
  }
  $keystone_version_real = pick($::cloudkitty::keystone_version, $keystone_version)

  cloudkitty_config {
    'fetcher_keystone/auth_section':            value => $auth_section_real;
    'fetcher_keystone/username':                value => $username;
    'fetcher_keystone/password':                value => $password, secret => true;
    'fetcher_keystone/project_name':            value => $project_name;
    'fetcher_keystone/user_domain_name':        value => $user_domain_name;
    'fetcher_keystone/project_domain_name':     value => $project_domain_name;
    'fetcher_keystone/auth_url':                value => $auth_url;
    'fetcher_keystone/keystone_version':        value => $keystone_version_real;
    'fetcher_keystone/ignore_rating_role':      value => $ignore_rating_role;
    'fetcher_keystone/ignore_disabled_tenants': value => $ignore_disabled_tenants;
  }
}
