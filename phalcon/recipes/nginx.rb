#
# Cookbook Name:: phalcon
# Recipe:: nginx
#
# Copyright 2013, k-motoyan
#

nginx_conf_path = node['phalcon']['nginx_conf_path']

pj_name = node['phalcon']['project_name']
pj_dir  = node['phalcon']['project_dir']
pj_type = node['phalcon']['project_type']

pj_conf_path = begin
  case pj_type
    when 'micro'  ; "#{pj_dir}#{pj_name}/config/config.php"
    when 'simple' ; "#{pj_dir}#{pj_name}/app/config/config.php"
    when 'modules'; "#{pj_dir}#{pj_name}/apps/frontend/config/config.php"
  end
end

template "#{nginx_conf_path}phalcon.conf" do
  owner 'root'
  group 'root'
  mode '0644'
  source 'phalcon_nginx.conf.erb'

  variables ({
    :listen        => node['phalcon']['listen'],
    :server_name   => node['phalcon']['server_name'],
    :document_root => node['phalcon']['document_root'],
    :cgi_pass      => node['phalcon']['cgi_pass'],
    :use_ssl       => node['phalcon']['use_ssl'],
    :crt_file      => node['phalcon']['crt_file'],
    :key_file      => node['phalcon']['key_file']
  })
end

%w{default.conf example_ssl.conf}.each do |conf_file|
  file "/etc/nginx/conf.d/#{conf_file}" do
    action :delete
  end
end

bash 'make_project' do
  not_if "ls #{node['phalcon']['document_root']}"
  user 'root'

  code <<-EOL
    export PATH="$HOME/.phpenv/bin:$PATH"
    eval "$(phpenv init -)"
    cd #{pj_dir}
    phalcon project #{pj_name} --type=#{pj_type} --enable-webtools
    chown -R nginx:nginx #{node['phalcon']['project_name']}
  EOL
end

template "#{pj_conf_path}" do
  owner 'nginx'
  group 'nginx'
  mode '0644'
  source "pj-#{pj_type}_config.php.erb"

  variables ({
    :db_host     => node['phalcon']['db_host'],
    :db_user     => node['phalcon']['db_user'],
    :db_password => node['phalcon']['db_password'],
    :db_name     => node['phalcon']['db_name'],
    :base_uri    => node['phalcon']['base_uri']
  })
end

template "#{node['phalcon']['document_root']}/webtools.config.php" do
  owner 'nginx'
  group 'nginx'
  mode '0644'
  source 'webtools.config.php.erb'

  variables ({
    :admin_ip => node['phalcon']['admin_ip']
  })
end

%w{nginx php-fpm}.each do |service_name|
  service "#{service_name}" do
    action [ :enable, :restart ]
  end
end

service 'iptables' do
  action [ :disable, :stop ]
end
