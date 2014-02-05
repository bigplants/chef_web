#
# Cookbook Name:: nodejs
# Recipe:: default
#
# Copyright 2013, k-motoyan
#

version = node['nodejs']['version']
install_dir = node['nodejs']['nvm_install_dir']

git "#{install_dir}" do
  repository 'git://github.com/creationix/nvm.git'
  action :sync
  user 'root'
end

bash 'install_nvm' do
  user 'root'

  code <<-EOL
    source #{install_dir}nvm.sh
  EOL
end

bash 'install_nodejs' do
  not_if "ls #{install_dir}#{version}"
  user 'root'

  code <<-EOL
    source #{install_dir}nvm.sh
    nvm install #{version}
  EOL
end

bash 'change_version' do
  user 'root'

  code <<-EOL
    source #{install_dir}nvm.sh
    nvm use #{version}
    nvm alias default #{version}
  EOL
end
