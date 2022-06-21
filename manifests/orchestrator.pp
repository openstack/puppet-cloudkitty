# == Class: cloudkitty::orchestrator
#
# Setup and configure Cloudkitty orchestrator settings.
#
# === Parameters
#
# [*coordination_url*]
#   (Optional) Coordination backend URL.
#   Defaults to $::os_service_default
#
# [*max_workers*]
#   (Optional) Maximal number of workers to run.
#   Defaults to $::os_service_default
#
# [*max_threads*]
#   (Optional) Maximal number of threads to use per worker.
#   Defaults to $::os_service_default
#
class cloudkitty::orchestrator (
  $coordination_url = $::os_service_default,
  $max_workers      = $::os_service_default,
  $max_threads      = $::os_service_default
) {

  include cloudkitty::deps

  $max_workers_real = pick($::cloudkitty::processor::max_workers, $max_workers)

  oslo::coordination{ 'cloudkitty_config':
    backend_url   => $coordination_url,
    manage_config => false,
  }

  cloudkitty_config {
    'orchestrator/coordination_url': value => $coordination_url;
    'orchestrator/max_workers':      value => $max_workers_real;
    'orchestrator/max_threads':      value => $max_threads;
  }
}
