# == Class: cloudkitty::orchestrator
#
# Setup and configure Cloudkitty orchestrator settings.
#
# === Parameters
#
# [*coordination_url*]
#   (Optional) Coordination backend URL.
#   Defaults to $facts['os_service_default']
#
# [*max_workers*]
#   (Optional) Maximum number of workers to execute the rating process.
#   Defaults to $facts['os_workers']
#
# [*max_workers_reprocessing*]
#   (Optional) Maximum number of workers to execute the reprocessing.
#   Defaults to $facts['os_workers']
#
# [*max_threads*]
#   (Optional) Maximum number of threads to use per worker.
#   Defaults to 16,
#
# [*manage_backend_package*]
#   (Optional) Whether to install the backend package.
#   Defaults to true.
#
# [*backend_package_ensure*]
#   (Optional) ensure state for backend package.
#   Defaults to 'present'
#
class cloudkitty::orchestrator (
  $coordination_url                               = $facts['os_service_default'],
  $max_workers                                    = $facts['os_workers'],
  $max_workers_reprocessing                       = $facts['os_workers'],
  $max_threads                                    = 16,
  Boolean $manage_backend_package                 = true,
  Stdlib::Ensure::Package $backend_package_ensure = present,
) {
  include cloudkitty::deps

  oslo::coordination { 'cloudkitty_config':
    backend_url            => $coordination_url,
    manage_backend_package => $manage_backend_package,
    package_ensure         => $backend_package_ensure,
    manage_config          => false,
  }

  # all coordination settings should be applied and all packages should be
  # installed before service startup
  Oslo::Coordination['cloudkitty_config'] -> Anchor['cloudkitty::service::begin']

  cloudkitty_config {
    'orchestrator/coordination_url':         value => $coordination_url, secret => true;
    'orchestrator/max_workers':              value => $max_workers;
    'orchestrator/max_workers_reprocessing': value => $max_workers_reprocessing;
    'orchestrator/max_threads':              value => $max_threads;
  }
}
