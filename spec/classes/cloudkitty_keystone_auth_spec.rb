#
# Unit tests for cloudkitty::keystone::auth
#

require 'spec_helper'

describe 'cloudkitty::keystone::auth' do
  shared_examples_for 'cloudkitty-keystone-auth' do
    context 'with default class parameters' do
      let :params do
        { :password => 'cloudkitty_password',
          :tenant   => 'foobar' }
      end

      it { is_expected.to contain_keystone_user('cloudkitty').with(
        :ensure   => 'present',
        :password => 'cloudkitty_password',
      ) }

      it { is_expected.to contain_keystone_user_role('cloudkitty@foobar').with(
        :ensure  => 'present',
        :roles   => ['admin']
      )}

      it { is_expected.to contain_keystone_service('cloudkitty::FIXME').with(
        :ensure      => 'present',
        :description => 'cloudkitty FIXME Service'
      ) }

      it { is_expected.to contain_keystone_endpoint('RegionOne/cloudkitty::FIXME').with(
        :ensure       => 'present',
        :public_url   => 'http://127.0.0.1:FIXME',
        :admin_url    => 'http://127.0.0.1:FIXME',
        :internal_url => 'http://127.0.0.1:FIXME',
      ) }
    end

    context 'when overriding URL parameters' do
      let :params do
        { :password     => 'cloudkitty_password',
          :public_url   => 'https://10.10.10.10:80',
          :internal_url => 'http://10.10.10.11:81',
          :admin_url    => 'http://10.10.10.12:81', }
      end

      it { is_expected.to contain_keystone_endpoint('RegionOne/cloudkitty::FIXME').with(
        :ensure       => 'present',
        :public_url   => 'https://10.10.10.10:80',
        :internal_url => 'http://10.10.10.11:81',
        :admin_url    => 'http://10.10.10.12:81',
      ) }
    end

    context 'when overriding auth name' do
      let :params do
        { :password => 'foo',
          :auth_name => 'cloudkittyy' }
      end

      it { is_expected.to contain_keystone_user('cloudkittyy') }
      it { is_expected.to contain_keystone_user_role('cloudkittyy@services') }
      it { is_expected.to contain_keystone_service('cloudkitty::FIXME') }
      it { is_expected.to contain_keystone_endpoint('RegionOne/cloudkitty::FIXME') }
    end

    context 'when overriding service name' do
      let :params do
        { :service_name => 'cloudkitty_service',
          :auth_name    => 'cloudkitty',
          :password     => 'cloudkitty_password' }
      end

      it { is_expected.to contain_keystone_user('cloudkitty') }
      it { is_expected.to contain_keystone_user_role('cloudkitty@services') }
      it { is_expected.to contain_keystone_service('cloudkitty_service::FIXME') }
      it { is_expected.to contain_keystone_endpoint('RegionOne/cloudkitty_service::FIXME') }
    end

    context 'when disabling user configuration' do

      let :params do
        {
          :password       => 'cloudkitty_password',
          :configure_user => false
        }
      end

      it { is_expected.not_to contain_keystone_user('cloudkitty') }
      it { is_expected.to contain_keystone_user_role('cloudkitty@services') }
      it { is_expected.to contain_keystone_service('cloudkitty::FIXME').with(
        :ensure      => 'present',
        :description => 'cloudkitty FIXME Service'
      ) }

    end

    context 'when disabling user and user role configuration' do

      let :params do
        {
          :password            => 'cloudkitty_password',
          :configure_user      => false,
          :configure_user_role => false
        }
      end

      it { is_expected.not_to contain_keystone_user('cloudkitty') }
      it { is_expected.not_to contain_keystone_user_role('cloudkitty@services') }
      it { is_expected.to contain_keystone_service('cloudkitty::FIXME').with(
        :ensure      => 'present',
        :description => 'cloudkitty FIXME Service'
      ) }

    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'cloudkitty-keystone-auth'
    end
  end
end
