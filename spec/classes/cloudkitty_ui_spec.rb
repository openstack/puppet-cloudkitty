require 'spec_helper'

describe 'cloudkitty::ui' do

  let :params do
    { :package_ensure => 'present' }
  end

  shared_examples_for 'cloudkitty-ui' do

    context 'when enabled' do
      it { is_expected.to contain_class('cloudkitty::params') }
      it { is_expected.to contain_class('cloudkitty::deps') }

      it 'installs cloudkitty-ui package' do
        is_expected.to contain_package('cloudkitty-ui').with(
          :name   => platform_params[:ui_package_name],
          :ensure => 'present',
          :tag    => ['openstack', 'cloudkitty-package']
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
          { :ui_package_name => 'cloudkitty-dashboard' }
        when 'RedHat'
          { :ui_package_name => 'openstack-cloudkitty-ui' }
        end
      end
      it_configures 'cloudkitty-ui'
    end
  end

end
