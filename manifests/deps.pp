# == Class: cloudkitty::deps
#
#  cloudkitty anchors and dependency management
#
class cloudkitty::deps {
  # Setup anchors for install, config and service phases of the module.  These
  # anchors allow external modules to hook the begin and end of any of these
  # phases. Package or service management can also be replaced by ensuring the
  # package is absent or turning off service management and having the
  # replacement depend on the appropriate anchors.  When applicable, end tags
  # should be notified so that subscribers can determine if installation,
  # config or service state changed and act on that if needed.
  anchor { 'cloudkitty::install::begin': }
  -> Package<| tag == 'cloudkitty-package'|>
  ~> anchor { 'cloudkitty::install::end': }
  -> anchor { 'cloudkitty::config::begin': }
  -> Cloudkitty_config<||>
  ~> anchor { 'cloudkitty::config::end': }
  -> anchor { 'cloudkitty::db::begin': }
  -> anchor { 'cloudkitty::db::end': }
  ~> anchor { 'cloudkitty::dbsync::begin': }
  -> anchor { 'cloudkitty::dbsync::end': }
  ~> anchor { 'cloudkitty::storageinit::begin': }
  -> anchor { 'cloudkitty::storageinit::end': }
  ~> anchor { 'cloudkitty::service::begin': }
  ~> Service<| tag == 'cloudkitty-service' |>
  ~> anchor { 'cloudkitty::service::end': }

  # paste-api.ini config should occur in the config block also.
  Anchor['cloudkitty::config::begin']
  -> Cloudkitty_api_paste_ini<||>
  ~> Anchor['cloudkitty::config::end']

  # all db settings should be applied and all packages should be installed
  # before dbsync starts
  Oslo::Db<||> -> Anchor['cloudkitty::dbsync::begin']

  # policy config should occur in the config block also.
  Anchor['cloudkitty::config::begin']
  -> Openstacklib::Policy<||>
  ~> Anchor['cloudkitty::config::end']

  # On any uwsgi config change, we must restart Cloudkitty API.
  Anchor['cloudkitty::config::begin']
  -> Cloudkitty_api_uwsgi_config<||>
  ~> Anchor['cloudkitty::config::end']

  # Ensure files are modified in the config block
  Anchor['cloudkitty::config::begin']
  -> File<| tag == 'cloudkitty-yamls' |>
  ~> Anchor['cloudkitty::config::end']

  # Installation or config changes will always restart services.
  Anchor['cloudkitty::install::end'] ~> Anchor['cloudkitty::service::begin']
  Anchor['cloudkitty::config::end']  ~> Anchor['cloudkitty::service::begin']

}
