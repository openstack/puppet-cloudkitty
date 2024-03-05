require 'spec_helper'

describe 'cloudkitty::storage' do

  shared_examples_for 'cloudkitty-storage-init' do

    it 'runs cloudkitty-storage-init' do
      is_expected.to contain_exec('cloudkitty-storage-init').with(
        :command     => 'cloudkitty-storage-init ',
        :path        => '/usr/bin',
        :refreshonly => 'true',
        :user        => 'cloudkitty',
        :logoutput   => 'on_failure',
        :subscribe   => ['Anchor[cloudkitty::install::end]',
                         'Anchor[cloudkitty::config::end]',
                         'Anchor[cloudkitty::dbsync::end]',
                         'Anchor[cloudkitty::storageinit::begin]'],
        :notify      => 'Anchor[cloudkitty::storageinit::end]',
      )
    end

  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts())
      end

      it_configures 'cloudkitty-storage-init'
    end
  end

end
