# == Class: cloudkitty::policy
#
# Configure the cloudkitty policies
#
# === Parameters
#
# [*policies*]
#   (Optional) Set of policies to configure for cloudkitty
#   Example :
#     {
#       'cloudkitty-context_is_admin' => {
#         'key' => 'context_is_admin',
#         'value' => 'true'
#       },
#       'cloudkitty-default' => {
#         'key' => 'default',
#         'value' => 'rule:admin_or_owner'
#       }
#     }
#   Defaults to empty hash.
#
# [*policy_path*]
#   (Optional) Path to the nova policy.yaml file
#   Defaults to /etc/cloudkitty/policy.yaml
#
class cloudkitty::policy (
  $policies    = {},
  $policy_path = '/etc/cloudkitty/policy.yaml',
) {

  include cloudkitty::deps
  include cloudkitty::params

  validate_legacy(Hash, 'validate_hash', $policies)

  Openstacklib::Policy::Base {
    file_path   => $policy_path,
    file_user   => 'root',
    file_group  => $::cloudkitty::params::group,
    file_format => 'yaml',
  }

  create_resources('openstacklib::policy::base', $policies)

  oslo::policy { 'cloudkitty_config': policy_file => $policy_path }

}
