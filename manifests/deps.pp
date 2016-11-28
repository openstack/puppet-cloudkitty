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

  # Installation or config changes will always restart services.
  Anchor['cloudkitty::install::end'] ~> Anchor['cloudkitty::service::begin']
  Anchor['cloudkitty::config::end']  ~> Anchor['cloudkitty::service::begin']

}
