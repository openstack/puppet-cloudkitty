require 'spec_helper'

describe 'cloudkitty::fetcher::gnocchi' do

  let :params do
    { :scope_attribute   => '<SERVICE DEFAULT>',
      :resource_types    => '<SERVICE DEFAULT>',
      :gnocchi_auth_type => '<SERVICE DEFAULT>',
      :gnocchi_user      => '<SERVICE DEFAULT>',
      :gnocchi_endpoint  => '<SERVICE DEFAULT>',
      :interface         => '<SERVICE DEFAULT>',
      :region_name       => '<SERVICE DEFAULT>',
      :auth_type         => '<SERVICE DEFAULT>',
      :auth_section      => '<SERVICE DEFAULT>',
    }
  end


  shared_examples_for 'cloudkitty::fetcher::gnocchi' do
    it { should contain_class('cloudkitty::deps') }

    it { is_expected.to contain_cloudkitty_config('fetcher_gnocchi/scope_attribute').with_value( params[:scope_attribute])}
    it { is_expected.to contain_cloudkitty_config('fetcher_gnocchi/resource_types').with_value( params[:resource_types])}
    it { is_expected.to contain_cloudkitty_config('fetcher_gnocchi/gnocchi_auth_type').with_value( params[:gnocchi_auth_type])}
    it { is_expected.to contain_cloudkitty_config('fetcher_gnocchi/gnocchi_user').with_value( params[:gnocchi_user])}
    it { is_expected.to contain_cloudkitty_config('fetcher_gnocchi/gnocchi_endpoint').with_value( params[:gnocchi_endpoint])}
    it { is_expected.to contain_cloudkitty_config('fetcher_gnocchi/interface').with_value( params[:interface])}
    it { is_expected.to contain_cloudkitty_config('fetcher_gnocchi/region_name').with_value( params[:region_name])}
    it { is_expected.to contain_cloudkitty_config('fetcher_gnocchi/auth_type').with_value( params[:auth_type])}
    it { is_expected.to contain_cloudkitty_config('fetcher_gnocchi/auth_section').with_value( params[:auth_section])}
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      context 'with default parameters' do
        it_behaves_like 'cloudkitty::fetcher::gnocchi'
      end

      context 'when overriding parameters' do
        before do
          params.merge!({
            :scope_attribute   => 'project_id',
            :resource_types    => 'some_types',
            :gnocchi_auth_type => 'basic',
            :gnocchi_user      => 'myuser',
            :gnocchi_endpoint  => 'https://somwhere/',
            :interface         => 'external',
            :region_name       => 'myregion',
            :auth_type         => 'typeA',
            :auth_section      => 'ks_auth',
          })
        end
        it_behaves_like 'cloudkitty::fetcher::gnocchi'
      end
    end
  end
end
