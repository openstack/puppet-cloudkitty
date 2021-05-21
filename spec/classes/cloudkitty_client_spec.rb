require 'spec_helper'

describe 'cloudkitty::client' do

  shared_examples_for 'cloudkitty client' do

    it { is_expected.to contain_class('cloudkitty::deps') }
    it { is_expected.to contain_class('cloudkitty::params') }

    it 'installs cloudkitty client package' do
      is_expected.to contain_package('python-cloudkittyclient').with(
        :ensure => 'present',
        :name   => platform_params[:client_package_name],
        :tag    => 'openstack',
      )
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
          { :client_package_name => 'python3-cloudkittyclient' }
        when 'RedHat'
          { :client_package_name => 'python3-cloudkittyclient' }
        end
      end

      it_configures 'cloudkitty client'
    end
  end

end
