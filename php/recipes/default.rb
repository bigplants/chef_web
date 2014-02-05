#
# Cookbook Name:: php
# Recipe:: default
#
# Copyright 2013, k-motoyan
#

version = node['php']['version']

node['php']['packages'].each do |package_name|
  package "#{package_name}" do
    :install
  end
end

bash 'install_phpenv' do
  not_if 'ls ~/.phpenv/bin/phpenv'
  user 'root'

  code <<-EOL
    curl https://raw.github.com/CHH/phpenv/master/bin/phpenv-install.sh | sh
    echo 'export PATH="$HOME/.phpenv/bin:$PATH"' >> $HOME/.bashrc
    echo 'eval "$(phpenv init -)"' >> $HOME/.bashrc
    mkdir $HOME/.phpenv/plugins
  EOL
end

git '/root/.phpenv/plugins/php-build' do
  repository 'git://github.com/bigplants/php-build.git'
  reference 'master'
  action :sync
  user 'root'
end

cookbook_file '/root/.phpenv/plugins/php-build/share/php-build/default_configure_options' do
  not_if "php -v | grep #{version}"
  owner 'root'
  group 'root'
  mode '0644'
  source 'default_configure_options'
end

bash 'install_php' do
  not_if "php -v | grep #{version}"
  user 'root'

  code <<-EOL
    source /root/.bashrc
    phpenv install #{version}
    phpenv rehash
    phpenv global #{version}
  EOL
end
