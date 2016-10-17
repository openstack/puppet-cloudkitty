# == Class: cloudkitty::policy
#
# Configure the cloudkitty policies
#
# === Parameters
#
# [*policies*]
#   (optional) Set of policies to configure for cloudkitty
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
#   (optional) Path to the nova policy.json file
#   Defaults to /etc/cloudkitty/policy.json
#
class cloudkitty::policy (
  $policies    = {},
  $policy_path = '/etc/cloudkitty/policy.json',
) {

  validate_hash($policies)

  Openstacklib::Policy::Base {
    file_path => $policy_path,
  }

  create_resources('openstacklib::policy::base', $policies)

  oslo::policy { 'cloudkitty_config': policy_file => $policy_path }

}
