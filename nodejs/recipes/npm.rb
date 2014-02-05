#
# Cookbook Name:: nginx
# Recipe:: npm
#
# Copyright 2013, k-motoyan
#

nvm_dir = node['nodejs']['nvm_install_dir']
packages = node['nodejs']['global_packages']

packages.each do |package|
  bash "global_install_#{package}" do
    user 'root'

    code <<-EOL
      source #{nvm_dir}nvm.sh
      npm install -g #{package}
    EOL
  end
end
