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
#   (Optional) Maximal number of workers to run.
#   Defaults to $facts['os_service_default']
#
# [*max_threads*]
#   (Optional) Maximal number of threads to use per worker.
#   Defaults to $facts['os_service_default']
#
class cloudkitty::orchestrator (
  $coordination_url = $facts['os_service_default'],
  $max_workers      = $facts['os_service_default'],
  $max_threads      = $facts['os_service_default']
) {

  include cloudkitty::deps

  oslo::coordination{ 'cloudkitty_config':
    backend_url   => $coordination_url,
    manage_config => false,
  }

  cloudkitty_config {
    'orchestrator/coordination_url': value => $coordination_url, secret => true;
    'orchestrator/max_workers':      value => $max_workers;
    'orchestrator/max_threads':      value => $max_threads;
  }
}
