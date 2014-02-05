#
# Cookbook Name:: php
# Recipe:: php-fpm
#
# Copyright 2013, k-motoyan
#

php_path = node['php-fpm']['php_path']
php_fpm_conf_path = node['php-fpm']['php_fpm_conf_path']
php_fpm_bin_path = node['php-fpm']['php_fpm_bin_path']

template "#{php_fpm_conf_path}" do
  owner 'root'
  group 'root'
  mode '0644'
  source 'php-fpm.conf.erb'

  variables ({
    :listen => node['php-fpm']['listen'],
    :user   => node['php-fpm']['user'],
    :group  => node['php-fpm']['group']
  })
end

template "/etc/init.d/php-fpm" do
  owner 'root'
  group 'root'
  mode '0744'
  source 'php-fpm.erb'

  variables ({
    :bin  => php_fpm_bin_path,
    :conf => php_fpm_conf_path
  })
end

directory "#{php_path}www" do
  owner 'root'
  group 'root'
  mode 00755
  action :create
end

service 'php-fpm' do
  only_if 'ls /etc/init.d/php-fpm'
  action [ :enable, :restart ]
end
