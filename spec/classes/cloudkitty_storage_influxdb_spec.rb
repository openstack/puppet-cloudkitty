require 'spec_helper'

describe 'cloudkitty::storage::influxdb' do

  let :params do
    { :username         => '<SERVICE DEFAULT>',
      :password         => '<SERVICE DEFAULT>',
      :database         => '<SERVICE DEFAULT>',
      :retention_policy => '<SERVICE DEFAULT>',
      :host             => '<SERVICE DEFAULT>',
      :port             => '<SERVICE DEFAULT>',
      :use_ssl          => '<SERVICE DEFAULT>',
      :insecure         => '<SERVICE DEFAULT>',
      :cafile           => '<SERVICE DEFAULT>',
    }
  end


  shared_examples_for 'cloudkitty::storage::influxdb' do
    it { should contain_class('cloudkitty::deps') }

    it { is_expected.to contain_cloudkitty_config('storage_influxdb/username').with_value( params[:username])}
    it { is_expected.to contain_cloudkitty_config('storage_influxdb/password').with( value: params[:password], secret: true)}
    it { is_expected.to contain_cloudkitty_config('storage_influxdb/database').with_value( params[:database])}
    it { is_expected.to contain_cloudkitty_config('storage_influxdb/retention_policy').with_value( params[:retention_policy])}
    it { is_expected.to contain_cloudkitty_config('storage_influxdb/host').with_value( params[:host])}
    it { is_expected.to contain_cloudkitty_config('storage_influxdb/port').with_value( params[:port])}
    it { is_expected.to contain_cloudkitty_config('storage_influxdb/use_ssl').with_value( params[:use_ssl])}
    it { is_expected.to contain_cloudkitty_config('storage_influxdb/insecure').with_value( params[:insecure])}
    it { is_expected.to contain_cloudkitty_config('storage_influxdb/cafile').with_value( params[:cafile])}
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      context 'with default parameters' do
        it_behaves_like 'cloudkitty::storage::influxdb'
      end

      context 'when overriding parameters' do
        before do
          params.merge!({
            :username         => 'kittycloud',
            :password         => 'nice',
            :database         => 'kittycloud',
            :retention_policy => 'policy',
            :host             => 'kitty.heaven.org',
            :port             => 42,
            :use_ssl          => 'true',
            :insecure         => 'true',
            :cafile           => '/tmp/cafile.crt',
          })
        end
        it_behaves_like 'cloudkitty::storage::influxdb'
      end
    end
  end
end
