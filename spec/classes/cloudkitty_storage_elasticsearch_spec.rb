require 'spec_helper'

describe 'cloudkitty::storage::elasticsearch' do

  let :params do
    {
      :host            => '<SERVICE DEFAULT>',
      :index_name      => '<SERVICE DEFAULT>',
      :insecure        => '<SERVICE DEFAULT>',
      :cafile          => '<SERVICE DEFAULT>',
      :scroll_duration => '<SERVICE DEFAULT>',
    }
  end


  shared_examples_for 'cloudkitty::storage::elasticsearch' do
    it { should contain_class('cloudkitty::deps') }

    it { is_expected.to contain_cloudkitty_config('storage_elasticsearch/host').with_value( params[:host])}
    it { is_expected.to contain_cloudkitty_config('storage_elasticsearch/index_name').with_value( params[:index_name])}
    it { is_expected.to contain_cloudkitty_config('storage_elasticsearch/insecure').with_value( params[:insecure])}
    it { is_expected.to contain_cloudkitty_config('storage_elasticsearch/cafile').with_value( params[:cafile])}
    it { is_expected.to contain_cloudkitty_config('storage_elasticsearch/scroll_duration').with_value( params[:scroll_duration])}
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      context 'with default parameters' do
        it_behaves_like 'cloudkitty::storage::elasticsearch'
      end

      context 'when overriding parameters' do
        before do
          params.merge!({
            :host            => 'http://localhost:9200',
            :index_name      => 'cloudkitty',
            :insecure        => true,
            :cafile          => '/tmp/cafile.crt',
            :scroll_duration => 30,
          })
        end
        it_behaves_like 'cloudkitty::storage::elasticsearch'
      end
    end
  end
end
