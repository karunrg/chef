#
# Cookbook Name:: sre_tc_1a
# Recipe:: web
#
# Copyright (c) 2016 The Authors, All Rights Reserved.


# Create the document log directory.
directory node['sre_tc_1a']['git']['log_dir'] do
  recursive true
end

include_recipe 'nginx::default'

template "#{node['nginx']['dir']}/sites-available/git.conf" do
  source 'custom-site.erb'
  owner  'root'
  group  node['root_group']
  mode   '0644'
  notifies :reload, 'service[nginx]', :delayed
end


nginx_site 'git.conf' do
  enable node['nginx']['default_site_enabled']
end

