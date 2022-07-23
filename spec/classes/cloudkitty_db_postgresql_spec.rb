require 'spec_helper'

describe 'cloudkitty::db::postgresql' do

  let :pre_condition do
    'include postgresql::server'
  end

  let :required_params do
    { :password => 'cloudkittypass' }
  end

  shared_examples_for 'cloudkitty::db::postgresql' do
    context 'with only required parameters' do
      let :params do
        required_params
      end

      it { is_expected.to contain_class('cloudkitty::deps') }

      it { is_expected.to contain_openstacklib__db__postgresql('cloudkitty').with(
        :user       => 'cloudkitty',
        :password   => 'cloudkittypass',
        :dbname     => 'cloudkitty',
        :encoding   => nil,
        :privileges => 'ALL',
      )}
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts({
          # puppet-postgresql requires the service_provider fact provided by
          # puppetlabs-postgresql.
          :service_provider => 'systemd'
        }))
      end

      it_behaves_like 'cloudkitty::db::postgresql'
    end
  end
end
