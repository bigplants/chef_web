#
# Cookbook Name:: base
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
packages = %w{zsh vim-enhanced git subversion}
packages.each do |p|
	package p do
		action :install
	end
end

service 'iptables' do
  action [:disable,  :stop]
end