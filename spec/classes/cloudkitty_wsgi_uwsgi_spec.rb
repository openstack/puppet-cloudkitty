require 'spec_helper'

describe 'cloudkitty::wsgi::uwsgi' do

  shared_examples 'cloudkitty::wsgi::uwsgi' do
    context 'with default parameters' do
      it {
        should contain_class('cloudkitty::deps')
      }

      it {
        is_expected.to contain_cloudkitty_api_uwsgi_config('uwsgi/processes').with_value(facts[:os_workers])
        is_expected.to contain_cloudkitty_api_uwsgi_config('uwsgi/threads').with_value('32')
        is_expected.to contain_cloudkitty_api_uwsgi_config('uwsgi/listen').with_value('100')
      }
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts({
          :os_workers => 8,
        }))
      end
      it_behaves_like 'cloudkitty::wsgi::uwsgi'
    end
  end
end
