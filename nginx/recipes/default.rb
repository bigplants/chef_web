#
# Cookbook Name:: nginx
# Recipe:: default
#
# Copyright 2013, k-motoyan
#

execute 'install_nginx_repo' do
  not_if 'ls /etc/yum.repos.d/nginx.repo'
  command 'rpm -ivh http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm'
end

cookbook_file '/etc/yum.repos.d/nginx.repo' do
  not_if 'ls /etc/yum.repos.d/nginx.repo'
  owner 'root'
  group 'root'
  mode '0644'
  source 'nginx.repo'
end

package 'nginx' do
  :install
end

service 'nginx' do
  action [ :enable, :start ]
end
