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
#   Defaults to $facts['os_service_default']
#
# [*max_workers_reprocessing*]
#   (Optional) Maximum number of workers to execute the reprocessing.
#   Defaults to $facts['os_service_default']
#
# [*max_threads*]
#   (Optional) Maximal number of threads to use per worker.
#   Defaults to $facts['os_service_default']
#
class cloudkitty::orchestrator (
  $coordination_url         = $facts['os_service_default'],
  $max_workers              = $facts['os_service_default'],
  $max_workers_reprocessing = $facts['os_service_default'],
  $max_threads              = $facts['os_service_default']
) {
  include cloudkitty::deps

  oslo::coordination { 'cloudkitty_config':
    backend_url   => $coordination_url,
    manage_config => false,
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
