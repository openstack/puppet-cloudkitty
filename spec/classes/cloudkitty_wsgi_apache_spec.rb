require 'spec_helper'

describe 'cloudkitty::wsgi::apache' do

  shared_examples_for 'apache serving cloudkitty with mod_wsgi' do
    context 'with default parameters' do
      it { is_expected.to contain_class('cloudkitty::params') }
      it { is_expected.to contain_openstacklib__wsgi__apache('cloudkitty_wsgi').with(
        :bind_port                   => 8889,
        :group                       => 'cloudkitty',
        :path                        => '/',
        :servername                  => facts[:fqdn],
        :ssl                         => false,
        :threads                     => 1,
        :user                        => 'cloudkitty',
        :workers                     => facts[:os_workers],
        :wsgi_daemon_process         => 'cloudkitty',
        :wsgi_process_group          => 'cloudkitty',
        :wsgi_script_dir             => platform_params[:wsgi_script_path],
        :wsgi_script_file            => 'app',
        :wsgi_script_source          => '/usr/bin/cloudkitty-api',
        :custom_wsgi_process_options => {},
        :access_log_file             => false,
        :access_log_format           => false,
      )}
    end

    context 'when overriding parameters using different ports' do
      let :params do
        {
          :servername                  => 'dummy.host',
          :bind_host                   => '10.42.51.1',
          :port                        => 12345,
          :ssl                         => true,
          :wsgi_process_display_name   => 'cloudkitty',
          :workers                     => 37,
          :custom_wsgi_process_options => {
            'python_path' => '/my/python/admin/path',
          },
          :access_log_file             => '/var/log/httpd/access_log',
          :access_log_format           => 'some format',
          :error_log_file              => '/var/log/httpd/error_log'
        }
      end
      it { is_expected.to contain_class('cloudkitty::params') }
      it { is_expected.to contain_openstacklib__wsgi__apache('cloudkitty_wsgi').with(
        :bind_host                   => '10.42.51.1',
        :bind_port                   => 12345,
        :group                       => 'cloudkitty',
        :path                        => '/',
        :servername                  => 'dummy.host',
        :ssl                         => true,
        :threads                     => 1,
        :user                        => 'cloudkitty',
        :workers                     => 37,
        :wsgi_daemon_process         => 'cloudkitty',
        :wsgi_process_display_name   => 'cloudkitty',
        :wsgi_process_group          => 'cloudkitty',
        :wsgi_script_dir             => platform_params[:wsgi_script_path],
        :wsgi_script_file            => 'app',
        :wsgi_script_source          => '/usr/bin/cloudkitty-api',
        :custom_wsgi_process_options => {
          'python_path'  => '/my/python/admin/path',
        },
        :access_log_file             => '/var/log/httpd/access_log',
        :access_log_format           => 'some format',
        :error_log_file              => '/var/log/httpd/error_log'
      )}
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts({
          :os_workers     => 42,
          :concat_basedir => '/var/lib/puppet/concat',
          :fqdn           => 'some.host.tld',
        }))
      end

      let(:platform_params) do
        case facts[:osfamily]
        when 'Debian'
          {
            :wsgi_script_path   => '/usr/lib/cgi-bin/cloudkitty',
          }
        when 'RedHat'
          {
            :wsgi_script_path   => '/var/www/cgi-bin/cloudkitty',
          }
        end
      end

      it_behaves_like 'apache serving cloudkitty with mod_wsgi'
    end
  end
end
