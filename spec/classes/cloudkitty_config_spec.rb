require 'spec_helper'

describe 'cloudkitty::config' do

  let(:config_hash) do {
    'DEFAULT/foo' => { 'value'  => 'fooValue' },
    'DEFAULT/bar' => { 'value'  => 'barValue' },
    'DEFAULT/baz' => { 'ensure' => 'absent' }
  }
  end

  shared_examples_for 'cloudkitty_config' do
    let :params do
      { :cloudkitty_config => config_hash }
    end

    it 'configures arbitrary cloudkitty-config configurations' do
      is_expected.to contain_cloudkitty_config('DEFAULT/foo').with_value('fooValue')
      is_expected.to contain_cloudkitty_config('DEFAULT/bar').with_value('barValue')
      is_expected.to contain_cloudkitty_config('DEFAULT/baz').with_ensure('absent')
    end
  end

  shared_examples_for 'cloudkitty_api_paste_ini' do
    let :params do
      { :cloudkitty_api_paste_ini => config_hash }
    end

    it 'configures arbitrary cloudkitty-api-paste-ini configurations' do
      is_expected.to contain_cloudkitty_api_paste_ini('DEFAULT/foo').with_value('fooValue')
      is_expected.to contain_cloudkitty_api_paste_ini('DEFAULT/bar').with_value('barValue')
      is_expected.to contain_cloudkitty_api_paste_ini('DEFAULT/baz').with_ensure('absent')
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_configures 'cloudkitty_config'
      it_configures 'cloudkitty_api_paste_ini'
    end
  end
end
