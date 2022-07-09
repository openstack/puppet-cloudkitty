Puppet::Type.type(:cloudkitty_api_paste_ini).provide(
  :ini_setting,
  :parent => Puppet::Type.type(:openstack_config).provider(:ini_setting)
) do

  def self.file_path
    '/etc/cloudkitty/api_paste.ini'
  end

end
