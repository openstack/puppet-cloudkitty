Puppet::Type.type(:cloudkitty_config).provide(
  :openstackconfig,
  :parent => Puppet::Type.type(:openstack_config).provider(:ruby)
) do

  def self.file_path
    '/etc/cloudkitty/cloudkitty.conf'
  end

end
