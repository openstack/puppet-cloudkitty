require 'spec_helper'

describe 'cloudkitty::processor' do

  let :params do
    { :enabled        => true,
      :manage_service => true,
      :collector      => 'gnocchi',
      :period         => '60',
      :wait_periods   => '1',
      :window         => '3600',
      :region_name    => 'RegionOne',
      :interface      => 'publicURL',}
  end

  shared_examples_for 'cloudkitty-processor' do

    context 'when enabled' do
      it { is_expected.to contain_class('cloudkitty::params') }
      it { is_expected.to contain_class('cloudkitty::deps') }

      it { is_expected.to contain_cloudkitty_config('collect/collector').with_value( params[:collector] ) }
      it { is_expected.to contain_cloudkitty_config('collect/window').with_value( params[:window] ) }
      it { is_expected.to contain_cloudkitty_config('collect/period').with_value( params[:period] ) }
      it { is_expected.to contain_cloudkitty_config('collect/wait_periods').with_value( params[:wait_periods] ) }
      it { is_expected.to contain_cloudkitty_config('collector_gnocchi/auth_type').with_value('password') }
      it { is_expected.to contain_cloudkitty_config('collector_gnocchi/auth_section').with_value('keystone_authtoken') }
      it { is_expected.to contain_cloudkitty_config('collector_gnocchi/region_name').with_value( params[:region_name] ) }
      it { is_expected.to contain_cloudkitty_config('collector_gnocchi/interface').with_value( params[:interface] ) }

      it 'installs cloudkitty-processor package' do
        is_expected.to contain_package('cloudkitty-processor').with(
          :name   => platform_params[:processor_package_name],
          :ensure => 'present',
          :tag    => ['openstack', 'cloudkitty-package']
        )
      end

      it 'configures cloudkitty-processor service' do
        is_expected.to contain_service('cloudkitty-processor').with(
          :ensure     => 'running',
          :name       => platform_params[:processor_service_name],
          :enable     => true,
          :hasstatus  => true,
          :hasrestart => true,
          :tag        => 'cloudkitty-service',
        )
      end

    end

    context 'when disabled' do
      let :params do
        { :enabled => false }
      end

      # Catalog compilation does not crash for lack of cloudkitty::db
      it { is_expected.to compile }
      it 'configures cloudkitty-processor service' do
        is_expected.to contain_service('cloudkitty-processor').with(
          :ensure     => 'stopped',
          :name       => platform_params[:processor_service_name],
          :enable     => false,
          :hasstatus  => true,
          :hasrestart => true,
          :tag        => 'cloudkitty-service',
        )
      end
    end

    context 'when service management is disabled' do
      let :params do
        { :enabled        => false,
          :manage_service => false }
      end

      it 'configures cloudkitty-processor service' do
        is_expected.to contain_service('cloudkitty-processor').with(
          :ensure     => nil,
          :name       => platform_params[:processor_service_name],
          :enable     => false,
          :hasstatus  => true,
          :hasrestart => true,
          :tag        => 'cloudkitty-service',
        )
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

      let(:platform_params) do
        case facts[:osfamily]
        when 'Debian'
          { :processor_package_name => 'cloudkitty-processor',
            :processor_service_name => 'cloudkitty-processor' }
        when 'RedHat'
          { :processor_package_name => 'openstack-cloudkitty-processor',
            :processor_service_name => 'cloudkitty-processor' }
        end
      end
      it_configures 'cloudkitty-processor'
    end
  end

end
