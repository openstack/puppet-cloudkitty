require 'spec_helper'

describe 'cloudkitty::api' do

  let :params do
    { :enabled        => true,
      :manage_service => true,
      :host_ip        => '127.0.0.1',
      :port           => '8889',
      :pecan_debug    => false }
  end

  shared_examples_for 'cloudkitty-api' do
    let :pre_condition do
      "class { 'cloudkitty::keystone::authtoken':
           password => 'a_big_secret',
       }"
    end

    context 'config params' do

      it { is_expected.to contain_class('cloudkitty') }
      it { is_expected.to contain_class('cloudkitty::params') }
      it { is_expected.to contain_class('cloudkitty::deps') }
      it { is_expected.to contain_class('cloudkitty::policy') }

      it { is_expected.to contain_cloudkitty_config('api/host_ip').with_value( params[:host_ip] ) }
      it { is_expected.to contain_cloudkitty_config('api/port').with_value( params[:port] ) }
      it { is_expected.to contain_cloudkitty_config('api/pecan_debug').with_value( params[:pecan_debug] ) }

    end

    it 'installs cloudkitty-api package' do
      is_expected.to contain_package('cloudkitty-api').with(
        :ensure => 'present',
        :name   => platform_params[:api_package_name],
        :tag    => ['openstack', 'cloudkitty-package'],
      )
    end

    context 'when running cloudkitty-api in wsgi' do
      before do
        params.merge!({ :service_name => 'httpd' })
      end

      let :pre_condition do
        "include ::apache
         include ::cloudkitty::db
         class { 'cloudkitty': }
         class { '::cloudkitty::keystone::authtoken':
           password => 'a_big_secret',
         }"
      end

      it 'configures cloudkitty-api service with Apache' do
        is_expected.to contain_service('cloudkitty-api').with(
          :ensure => 'stopped',
          :name   => platform_params[:api_service_name],
          :enable => false,
          :tag    => 'cloudkitty-service',
        )
      end
    end

    context 'when service_name is not valid' do
      before do
        params.merge!({ :service_name => 'foobar' })
      end

      let :pre_condition do
        "include ::apache
         include ::cloudkitty::db
         class { 'cloudkitty': }
         class { '::cloudkitty::keystone::authtoken':
           password => 'a_big_secret',
         }"
      end

      it_raises 'a Puppet::Error', /Invalid service_name/
    end

    context 'with $sync_db set to false in ::cloudkitty' do
      before do
        params.merge!({
          :sync_db => false,
        })
      end
      let :pre_condition do
        "class { '::cloudkitty::keystone::authtoken':
           password => 'a_big_secret',
         }"
      end

      it 'configures cloudkitty-api service to not subscribe to the dbsync resource' do
        is_expected.to contain_service('cloudkitty-api').that_subscribes_to(nil)
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

      let :platform_params do
        case facts[:osfamily]
        when 'Debian'
          { :api_package_name => 'cloudkitty-api',
            :api_service_name => 'cloudkitty-api' }
        when 'RedHat'
          { :api_package_name => 'openstack-cloudkitty-api',
            :api_service_name => 'cloudkitty-api' }
        end
      end

      it_behaves_like 'cloudkitty-api'
    end
  end

end
