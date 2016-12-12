require 'spec_helper_acceptance'

describe 'basic cloudkitty' do

  context 'default parameters' do

    it 'should work with no errors' do
      pp= <<-EOS
      include ::openstack_integration
      include ::openstack_integration::repos
      include ::openstack_integration::rabbitmq
      include ::openstack_integration::mysql
      include ::openstack_integration::keystone

      rabbitmq_user { 'cloudkitty':
        admin    => true,
        password => 'an_even_bigger_secret',
        provider => 'rabbitmqctl',
        require  => Class['rabbitmq'],
      }

      rabbitmq_user_permissions { 'cloudkitty@/':
        configure_permission => '.*',
        write_permission     => '.*',
        read_permission      => '.*',
        provider             => 'rabbitmqctl',
        require              => Class['rabbitmq'],
      }

      # Cloudkitty resources
      case $::osfamily {
        'Debian': {
          warning('Cloudkitty is not yet packaged on Debian systems.')
        }
        'RedHat': {
          class { '::cloudkitty::db':
            database_connection => 'mysql+pymysql://cloudkitty:a_big_secret@127.0.0.1/cloudkitty?charset=utf8',
          }
          class { '::cloudkitty::logging':
            debug => true,
          }
          class { '::cloudkitty':
            default_transport_url => 'rabbit://cloudkitty:an_even_bigger_secret@127.0.0.1:5672',
          }
          class { '::cloudkitty::keystone::auth':
            password => 'a_big_secret',
          }
          class { '::cloudkitty::keystone::authtoken':
            password  => 'a_big_secret',
          }
          class { '::cloudkitty::db::mysql':
            password => 'a_big_secret',
          }
          class { '::cloudkitty::api': }
          class { '::cloudkitty::processor': }
          class { '::cloudkitty::client': }
        }
        default: {
          fail("Unsupported osfamily (${::osfamily})")
        }
      }
      EOS


      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    if os[:family].casecmp('RedHat') == 0
      describe port(8889) do
        it { is_expected.to be_listening }
      end
    end

  end

end
