require 'spec_helper'

describe 'cloudkitty::fetcher::keystone' do

  shared_examples_for 'cloudkitty::fetcher::keystone' do
    context 'with defaults' do
      let :params do
        {}
      end

      it 'configures the fetcher_keystone parameters' do
        is_expected.to contain_cloudkitty_config('fetcher_keystone/auth_section').with_value('keystone_authtoken')
        is_expected.to contain_cloudkitty_config('fetcher_keystone/username').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cloudkitty_config('fetcher_keystone/password').with_value('<SERVICE DEFAULT>').with_secret(true)
        is_expected.to contain_cloudkitty_config('fetcher_keystone/project_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cloudkitty_config('fetcher_keystone/user_domain_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cloudkitty_config('fetcher_keystone/project_domain_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cloudkitty_config('fetcher_keystone/auth_url').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cloudkitty_config('fetcher_keystone/keystone_version').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'with parameters set' do
      let :params do
        {
          :auth_section        => '<SERVICE DEFAULT>',
          :username            => 'cloudkitty',
          :password            => 'cloudkitty_password',
          :project_name        => 'service',
          :user_domain_name    => 'Default',
          :project_domain_name => 'Default',
          :auth_url            => 'http://127.0.0.1:5000',
          :keystone_version    => 3,
        }
      end

      it 'configures the fetcher_keystone parameters' do
        is_expected.to contain_cloudkitty_config('fetcher_keystone/auth_section').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cloudkitty_config('fetcher_keystone/username').with_value('cloudkitty')
        is_expected.to contain_cloudkitty_config('fetcher_keystone/password').with_value('cloudkitty_password').with_secret(true)
        is_expected.to contain_cloudkitty_config('fetcher_keystone/project_name').with_value('service')
        is_expected.to contain_cloudkitty_config('fetcher_keystone/user_domain_name').with_value('Default')
        is_expected.to contain_cloudkitty_config('fetcher_keystone/project_domain_name').with_value('Default')
        is_expected.to contain_cloudkitty_config('fetcher_keystone/auth_url').with_value('http://127.0.0.1:5000')
        is_expected.to contain_cloudkitty_config('fetcher_keystone/keystone_version').with_value(3)
      end
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      context 'with default parameters' do
        it_behaves_like 'cloudkitty::fetcher::keystone'
      end
    end
  end
end
