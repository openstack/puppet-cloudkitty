require 'spec_helper'

describe 'cloudkitty::orchestrator' do

  shared_examples_for 'cloudkitty::orchestrator' do

    context 'with defaults' do
      it { is_expected.to contain_class('cloudkitty::deps') }

      it 'configures orchestrator' do
        is_expected.to contain_cloudkitty_config('orchestrator/coordination_url')\
          .with_value('<SERVICE DEFAULT>').with_secret(true)
        is_expected.to contain_oslo__coordination('cloudkitty_config').with(
          :backend_url   => '<SERVICE DEFAULT>',
          :manage_config => false,
        )
        is_expected.to contain_cloudkitty_config('orchestrator/max_workers').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cloudkitty_config('orchestrator/max_workers_reprocessing').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cloudkitty_config('orchestrator/max_threads').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'with parameters set' do
      let :params do
        {
          :coordination_url         => 'etcd3+http://127.0.0.1:2379',
          :max_workers              => 4,
          :max_workers_reprocessing => 5,
          :max_threads              => 20,
        }
      end

      it 'configures orchestrator' do
        is_expected.to contain_cloudkitty_config('orchestrator/coordination_url')\
          .with_value('etcd3+http://127.0.0.1:2379').with_secret(true)
        is_expected.to contain_oslo__coordination('cloudkitty_config').with(
          :backend_url   => 'etcd3+http://127.0.0.1:2379',
          :manage_config => false,
        )
        is_expected.to contain_cloudkitty_config('orchestrator/max_workers').with_value(4)
        is_expected.to contain_cloudkitty_config('orchestrator/max_workers_reprocessing').with_value(5)
        is_expected.to contain_cloudkitty_config('orchestrator/max_threads').with_value(20)
      end
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_configures 'cloudkitty::orchestrator'
    end
  end

end
