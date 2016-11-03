require 'spec_helper'

describe 'cloudkitty::db::sync' do

  shared_examples_for 'cloudkitty-dbsync' do

    it 'runs cloudkitty-db-sync' do
      is_expected.to contain_exec('cloudkitty-db-sync').with(
        :command     => 'cloudkitty-dbsync upgrade ',
        :path        => [ '/bin', '/usr/bin', ],
        :refreshonly => 'true',
        :user        => 'cloudkitty',
        :logoutput   => 'on_failure'
      )
    end

  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts({
          :os_workers     => 8,
          :concat_basedir => '/var/lib/puppet/concat'
        }))
      end

      it_configures 'cloudkitty-dbsync'
    end
  end

end
