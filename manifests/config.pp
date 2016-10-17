# == Class: cloudkitty::config
#
# This class is used to manage arbitrary cloudkitty configurations.
#
# === Parameters
#
# [*cloudkitty_config*]
#   (optional) Allow configuration of arbitrary cloudkitty configurations.
#   The value is an hash of cloudkitty_config resources. Example:
#   { 'DEFAULT/foo' => { value => 'fooValue'},
#     'DEFAULT/bar' => { value => 'barValue'}
#   }
#   In yaml format, Example:
#   cloudkitty_config:
#     DEFAULT/foo:
#       value: fooValue
#     DEFAULT/bar:
#       value: barValue
#
#   NOTE: The configuration MUST NOT be already handled by this module
#   or Puppet catalog compilation will fail with duplicate resources.
#
class cloudkitty::config (
  $cloudkitty_config = {},
) {

  validate_hash($cloudkitty_config)

  create_resources('cloudkitty_config', $cloudkitty_config)
}
