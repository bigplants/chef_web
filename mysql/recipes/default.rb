#
# Cookbook Name:: mysql
# Recipe:: default
#
# Copyright 2013, k-motoyan
#

instruction  = node['mysql']['instruction']
version      = node['mysql']['version']
full_version = "#{version}.#{node['mysql']['minor_version']}"
my_cnf_path  = (version.to_s == '5.6')? '/usr/my.cnf' : '/etc/my.cnf'

bash 'remove_installed_mysql' do
  only_if 'yum list installed | grep mysql*'
  user 'root'

  code <<-EOL
    yum remove -y mysql*
  EOL
end

node['mysql']['rpms'].each do |name, rpm|
  if rpm['install?'] == true
    url = rpm['url'].gsub('{{version}}'     , version).gsub('{{full_version}}', full_version).gsub('{{instruction}}' , instruction)
    rpm_file = "/tmp/#{name}.rpm"

    remote_file "#{rpm_file}" do
      not_if "ls #{rpm_file}"
      user 'root'
      mode '0644'
      source "#{url}"
    end

    package "#{name}" do
      action :install
      source "#{rpm_file}"
      provider Chef::Provider::Package::Rpm
    end
  end
end

template "#{my_cnf_path}" do
  user 'root'
  group 'root'
  mode '0644'
  source 'my.cnf.erb'

  variables ({
    :server_charset                  => node['mysql']['server_charset'],
    :max_connections                 => node['mysql']['max_connections'],
    :query_cache_size                => node['mysql']['query_cache_size'],
    :table_cache_size                => node['mysql']['table_cache_size'],
    :thread_cache_size               => node['mysql']['thread_cache_size'],
    :join_buffer_size                => node['mysql']['join_buffer_size'],
    :sort_buffer_size                => node['mysql']['sort_buffer_size'],
    :read_rnd_buffer_size            => node['mysql']['read_rnd_buffer_size'],
    :innodb_file_per_table           => node['mysql']['innodb_file_per_table'],
    :innodb_data_file_path           => node['mysql']['innodb_data_file_path'],
    :innodb_autoextend_increment     => node['mysql']['innodb_autoextend_increment'],
    :innodb_buffer_pool_size         => node['mysql']['innodb_buffer_pool_size'],
    :innodb_additional_mem_pool_size => node['mysql']['innodb_additional_mem_pool_size'],
    :innodb_write_io_threads         => node['mysql']['innodb_write_io_threads'],
    :innodb_read_io_threads          => node['mysql']['innodb_read_io_threads'],
    :innodb_log_buffer_size          => node['mysql']['innodb_log_buffer_size'],
    :innodb_log_file_size            => node['mysql']['innodb_log_file_size'],
    :innodb_flush_log_at_trx_commit  => node['mysql']['innodb_flush_log_at_trx_commit']
  })
end

service 'mysql' do
  action [ :enable, :start ]
end

# version 5.6 over
if version.to_f >= 5.6
  package 'expect' do
    only_if 'ls /root/.mysql_secret'
    action :install
  end

  cookbook_file '/tmp/password_set' do
    only_if 'ls /root/.mysql_secret'
    source "password_set"
  end

  execute 'password_set' do
    only_if 'ls /root/.mysql_secret'
    user 'root'
    command 'chmod +x /tmp/password_set && /tmp/password_set && rm -f /tmp/password_set'
  end

  package 'expect' do
    action :remove
  end
end
