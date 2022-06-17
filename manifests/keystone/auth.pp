# == Class: cloudkitty::keystone::auth
#
# Configures cloudkitty user, service and endpoint in Keystone.
#
# === Parameters
#
# [*password*]
#   (Required) Password for cloudkitty user.
#
# [*auth_name*]
#   (Optional) Username for cloudkitty service.
#   Defaults to 'cloudkitty'.
#
# [*email*]
#   (Optional) Email for cloudkitty user.
#   Defaults to 'cloudkitty@localhost'.
#
# [*tenant*]
#   (Optional) Tenant for cloudkitty user.
#   Defaults to 'services'.
#
# [*roles*]
#   (Optional) List of roles assigned to cloudkitty user.
#   Defaults to ['admin']
#
# [*system_scope*]
#   (Optional) Scope for system operations.
#   Defaults to 'all'
#
# [*system_roles*]
#   (Optional) List of system roles assigned to cloudkitty user.
#   Defaults to []
#
# [*configure_endpoint*]
#   (Optional) Should cloudkitty endpoint be configured?
#   Defaults to true
#
# [*configure_user*]
#   (Optional) Should the service user be configured?
#   Defaults to true
#
# [*configure_user_role*]
#   (Optional) Should the admin role be configured for the service user?
#   Defaults to true
#
# [*service_type*]
#   (Optional) Type of service.
#   Defaults to 'rating'.
#
# [*region*]
#   (Optional) Region for endpoint.
#   Defaults to 'RegionOne'.
#
# [*service_name*]
#   (Optional) Name of the service.
#   Defaults to the value of 'cloudkitty'.
#
# [*service_description*]
#   (Optional) Description of the service.
#   Default to 'OpenStack Rating Service'
#
# [*public_url*]
#   (Optional) The endpoint's public url.
#   This url should *not* contain any trailing '/'.
#   Defaults to 'http://127.0.0.1:8889'
#
# [*admin_url*]
#   (Optional) The endpoint's admin url.
#   This url should *not* contain any trailing '/'.
#   Defaults to 'http://127.0.0.1:8889'
#
# [*internal_url*]
#   (Optional) The endpoint's internal url.
#   Defaults to 'http://127.0.0.1:8889'
#
# [*manage_rating_role*]
#   (Optional) If true, this will manage the Keystone role for $rating_role.
#   Defaults to true
#
# [*rating_role*]
#   (Optional) Keystone role for cloudkitty rating users.
#   Defaults to 'rating'.
#
class cloudkitty::keystone::auth (
  $password,
  $auth_name           = 'cloudkitty',
  $email               = 'cloudkitty@localhost',
  $tenant              = 'services',
  $roles               = ['admin'],
  $system_scope        = 'all',
  $system_roles        = [],
  $configure_endpoint  = true,
  $configure_user      = true,
  $configure_user_role = true,
  $service_name        = 'cloudkitty',
  $service_description = 'OpenStack Rating Service',
  $service_type        = 'rating',
  $region              = 'RegionOne',
  $public_url          = 'http://127.0.0.1:8889',
  $admin_url           = 'http://127.0.0.1:8889',
  $internal_url        = 'http://127.0.0.1:8889',
  $manage_rating_role  = true,
  $rating_role         = 'rating',
) {

  include cloudkitty::deps

  Keystone::Resource::Service_identity['cloudkitty'] -> Anchor['cloudkitty::service::end']

  keystone::resource::service_identity { 'cloudkitty':
    configure_user      => $configure_user,
    configure_user_role => $configure_user_role,
    configure_endpoint  => $configure_endpoint,
    service_name        => $service_name,
    service_type        => $service_type,
    service_description => $service_description,
    region              => $region,
    auth_name           => $auth_name,
    password            => $password,
    email               => $email,
    tenant              => $tenant,
    roles               => $roles,
    system_scope        => $system_scope,
    system_roles        => $system_roles,
    public_url          => $public_url,
    internal_url        => $internal_url,
    admin_url           => $admin_url,
  }

  if $manage_rating_role {
    keystone_role { $rating_role:
      ensure => present,
    }
  }

}
