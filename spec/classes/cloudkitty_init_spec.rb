require 'spec_helper'

describe 'cloudkitty' do

  shared_examples 'cloudkitty' do

    context 'with default parameters' do

      it 'contains related class' do
        is_expected.to contain_class('cloudkitty::params')
        is_expected.to contain_class('cloudkitty::deps')
        is_expected.to contain_class('cloudkitty::db')
        is_expected.to contain_class('cloudkitty::storage')
      end

      it 'installs packages' do
        is_expected.to contain_package('cloudkitty-common').with(
          :name   => platform_params[:cloudkitty_common_package],
          :ensure => 'present',
          :tag    => ['openstack', 'cloudkitty-package']
        )
      end

      it 'configures rabbit' do
        is_expected.to contain_oslo__messaging__default('cloudkitty_config').with(
          :transport_url        => '<SERVICE DEFAULT>',
          :rpc_response_timeout => '<SERVICE DEFAULT>',
          :control_exchange     => '<SERVICE DEFAULT>'
        )
        is_expected.to contain_oslo__messaging__rabbit('cloudkitty_config').with(
          :rabbit_use_ssl                  => '<SERVICE DEFAULT>',
          :heartbeat_timeout_threshold     => '<SERVICE DEFAULT>',
          :heartbeat_rate                  => '<SERVICE DEFAULT>',
          :heartbeat_in_pthread            => nil,
          :kombu_reconnect_delay           => '<SERVICE DEFAULT>',
          :kombu_failover_strategy         => '<SERVICE DEFAULT>',
          :amqp_durable_queues             => '<SERVICE DEFAULT>',
          :amqp_auto_delete                => '<SERVICE DEFAULT>',
          :kombu_compression               => '<SERVICE DEFAULT>',
          :kombu_ssl_ca_certs              => '<SERVICE DEFAULT>',
          :kombu_ssl_certfile              => '<SERVICE DEFAULT>',
          :kombu_ssl_keyfile               => '<SERVICE DEFAULT>',
          :kombu_ssl_version               => '<SERVICE DEFAULT>',
          :rabbit_ha_queues                => '<SERVICE DEFAULT>',
          :rabbit_retry_interval           => '<SERVICE DEFAULT>',
          :rabbit_quorum_queue             => '<SERVICE DEFAULT>',
          :rabbit_transient_quorum_queue   => '<SERVICE DEFAULT>',
          :rabbit_transient_queues_ttl     => '<SERVICE DEFAULT>',
          :rabbit_quorum_delivery_limit    => '<SERVICE DEFAULT>',
          :rabbit_quorum_max_memory_length => '<SERVICE DEFAULT>',
          :rabbit_quorum_max_memory_bytes  => '<SERVICE DEFAULT>',
          :use_queue_manager               => '<SERVICE DEFAULT>',
          :rabbit_stream_fanout            => '<SERVICE DEFAULT>',
          :enable_cancel_on_failover       => '<SERVICE DEFAULT>',
        )
        is_expected.to contain_oslo__messaging__notifications('cloudkitty_config').with(
          :transport_url => '<SERVICE DEFAULT>',
          :driver        => '<SERVICE DEFAULT>',
          :topics        => '<SERVICE DEFAULT>',
          :retry         => '<SERVICE DEFAULT>',
        )
      end

      it 'configures storage' do
        is_expected.to contain_cloudkitty_config('storage/backend').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_cloudkitty_config('storage/version').with_value('<SERVICE DEFAULT>')
      end

      it 'passes purge to resource' do
        is_expected.to contain_resources('cloudkitty_config').with({
          :purge => false
        })
      end

    end

    context 'with overridden parameters' do
      let :params do
        {
          :rabbit_ha_queues                   => true,
          :rabbit_heartbeat_timeout_threshold => 60,
          :rabbit_heartbeat_rate              => 10,
          :rabbit_heartbeat_in_pthread        => true,
          :rabbit_quorum_queue                => true,
          :rabbit_transient_quorum_queue      => false,
          :rabbit_transient_queues_ttl        => 60,
          :rabbit_quorum_delivery_limit       => 3,
          :rabbit_quorum_max_memory_length    => 5,
          :rabbit_quorum_max_memory_bytes     => 1073741824,
          :rabbit_use_queue_manager           => true,
          :rabbit_stream_fanout               => true,
          :rabbit_enable_cancel_on_failover   => false,
          :kombu_reconnect_delay              => 5.0,
          :amqp_durable_queues                => true,
          :amqp_auto_delete                   => true,
          :kombu_compression                  => 'gzip',
          :package_ensure                     => '2012.1.1-15.el6',
          :default_transport_url              => 'rabbit://rabbit_user:password@localhost:5673',
          :rpc_response_timeout               => '120',
          :control_exchange                   => 'cloudkitty',
          :notification_transport_url         => 'rabbit://rabbit_user:password@localhost:5673',
          :notification_driver                => 'messagingv1',
          :notification_topics                => 'openstack',
          :notification_retry                 => 10,
          :storage_backend                    => 'gnocchi',
          :storage_version                    => '1',
        }
      end

      it 'configures rabbit' do
        is_expected.to contain_oslo__messaging__default('cloudkitty_config').with(
          :transport_url        => 'rabbit://rabbit_user:password@localhost:5673',
          :rpc_response_timeout => '120',
          :control_exchange     => 'cloudkitty'
        )
        is_expected.to contain_oslo__messaging__rabbit('cloudkitty_config').with(
          :heartbeat_timeout_threshold     => 60,
          :heartbeat_rate                  => 10,
          :heartbeat_in_pthread            => true,
          :kombu_reconnect_delay           => 5.0,
          :amqp_durable_queues             => true,
          :amqp_auto_delete                => true,
          :kombu_compression               => 'gzip',
          :rabbit_ha_queues                => true,
          :rabbit_quorum_queue             => true,
          :rabbit_transient_quorum_queue   => false,
          :rabbit_transient_queues_ttl     => 60,
          :rabbit_quorum_delivery_limit    => 3,
          :rabbit_quorum_max_memory_length => 5,
          :rabbit_quorum_max_memory_bytes  => 1073741824,
          :use_queue_manager               => true,
          :rabbit_stream_fanout            => true,
          :enable_cancel_on_failover       => false,
        )
        is_expected.to contain_oslo__messaging__notifications('cloudkitty_config').with(
          :transport_url => 'rabbit://rabbit_user:password@localhost:5673',
          :driver        => 'messagingv1',
          :topics        => 'openstack',
          :retry         => 10,
        )
      end

      it 'configures various things' do
        is_expected.to contain_cloudkitty_config('storage/backend').with_value('gnocchi')
        is_expected.to contain_cloudkitty_config('storage/version').with_value('1')
      end

    end

    context 'with rabbit ssl enabled with kombu' do
      let :params do
        { :rabbit_use_ssl     => true,
          :kombu_ssl_ca_certs => '/etc/ca.cert',
          :kombu_ssl_certfile => '/etc/certfile',
          :kombu_ssl_keyfile  => '/etc/key',
          :kombu_ssl_version  => 'TLSv1', }
      end

      it 'configures rabbit' do
        is_expected.to contain_oslo__messaging__rabbit('cloudkitty_config').with(
          :rabbit_use_ssl     => true,
          :kombu_ssl_ca_certs => '/etc/ca.cert',
          :kombu_ssl_certfile => '/etc/certfile',
          :kombu_ssl_keyfile  => '/etc/key',
          :kombu_ssl_version  => 'TLSv1',
        )
      end
    end

    context 'with rabbit ssl enabled without kombu' do
      let :params do
        { :rabbit_use_ssl => true, }
      end

      it 'configures rabbit' do
        is_expected.to contain_oslo__messaging__rabbit('cloudkitty_config').with(
          :rabbit_use_ssl     => true,
          :kombu_ssl_ca_certs => '<SERVICE DEFAULT>',
          :kombu_ssl_certfile => '<SERVICE DEFAULT>',
          :kombu_ssl_keyfile  => '<SERVICE DEFAULT>',
          :kombu_ssl_version  => '<SERVICE DEFAULT>',
        )
      end
    end

    context 'with metrics_config' do
      let :params do
        { :metrics_config => {'metrics' => {}},
        }
      end

      it 'configures metrics.yml' do
        is_expected.to contain_file('metrics.yml').with(
          :ensure => 'present',
          :path   => '/etc/cloudkitty/metrics.yml',
          :mode   => '0640',
          :owner  => 'root',
          :group  => 'cloudkitty',
          :tag    => 'cloudkitty-yamls'
        )
      end
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      let(:platform_params) do
        case facts[:os]['family']
        when 'Debian'
          { :cloudkitty_common_package => 'cloudkitty-common' }
        when 'RedHat'
          { :cloudkitty_common_package => 'openstack-cloudkitty-common' }
        end
      end
      it_behaves_like 'cloudkitty'
    end
  end


end
