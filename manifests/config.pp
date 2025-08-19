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
# [*cloudkitty_api_paste_ini*]
#   (optional) Allow configuration of /etc/cloudkitty/api_paste.ini options.
#
#   NOTE: The configuration MUST NOT be already handled by this module
#   or Puppet catalog compilation will fail with duplicate resources.
#
class cloudkitty::config (
  Hash $cloudkitty_config        = {},
  Hash $cloudkitty_api_paste_ini = {},
) {
  include cloudkitty::deps

  create_resources('cloudkitty_config', $cloudkitty_config)
  create_resources('cloudkitty_api_paste_ini', $cloudkitty_api_paste_ini)
}
