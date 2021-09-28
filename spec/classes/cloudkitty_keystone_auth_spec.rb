#
# Unit tests for cloudkitty::keystone::auth
#

require 'spec_helper'

describe 'cloudkitty::keystone::auth' do
  shared_examples_for 'cloudkitty::keystone::auth' do
    context 'with default class parameters' do
      let :params do
        { :password => 'cloudkitty_password' }
      end

      it { is_expected.to contain_keystone__resource__service_identity('cloudkitty').with(
        :configure_user      => true,
        :configure_user_role => true,
        :configure_endpoint  => true,
        :service_name        => 'cloudkitty',
        :service_type        => 'rating',
        :service_description => 'OpenStack Rating Service',
        :region              => 'RegionOne',
        :auth_name           => 'cloudkitty',
        :password            => 'cloudkitty_password',
        :email               => 'cloudkitty@localhost',
        :tenant              => 'services',
        :public_url          => 'http://127.0.0.1:8889',
        :internal_url        => 'http://127.0.0.1:8889',
        :admin_url           => 'http://127.0.0.1:8889',
      ) }

      it { is_expected.to contain_keystone_role('rating').with_ensure('present') }
    end

    context 'when overriding parameters' do
      let :params do
        { :password            => 'cloudkitty_password',
          :auth_name           => 'alt_cloudkitty',
          :email               => 'alt_cloudkitty@alt_localhost',
          :tenant              => 'alt_service',
          :configure_endpoint  => false,
          :configure_user      => false,
          :configure_user_role => false,
          :service_description => 'Alternative OpenStack Rating Service',
          :service_name        => 'alt_service',
          :service_type        => 'alt_rating',
          :region              => 'RegionTwo',
          :public_url          => 'https://10.10.10.10:80',
          :internal_url        => 'http://10.10.10.11:81',
          :admin_url           => 'http://10.10.10.12:81',
          :rating_role         => 'alt_rating' }
      end

      it { is_expected.to contain_keystone__resource__service_identity('cloudkitty').with(
        :configure_user      => false,
        :configure_user_role => false,
        :configure_endpoint  => false,
        :service_name        => 'alt_service',
        :service_type        => 'alt_rating',
        :service_description => 'Alternative OpenStack Rating Service',
        :region              => 'RegionTwo',
        :auth_name           => 'alt_cloudkitty',
        :password            => 'cloudkitty_password',
        :email               => 'alt_cloudkitty@alt_localhost',
        :tenant              => 'alt_service',
        :public_url          => 'https://10.10.10.10:80',
        :internal_url        => 'http://10.10.10.11:81',
        :admin_url           => 'http://10.10.10.12:81',
      ) }
      it { is_expected.to contain_keystone_role('alt_rating').with_ensure('present') }
    end

    context 'when disabling rating role management' do
      let :params do
        { :password           => 'cloudkitty_password',
          :manage_rating_role => false }
      end

      it { is_expected.to_not contain_keystone_role('rating') }
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'cloudkitty::keystone::auth'
    end
  end
end
