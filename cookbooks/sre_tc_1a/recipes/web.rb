#
# Cookbook Name:: sre_tc_1a
# Recipe:: web
#
# Copyright (c) 2016 The Authors, All Rights Reserved.


# Create the document log directory.

include_recipe 'nginx::default'

data_bag("vhosts").each do |site|
  site_data = data_bag_item("vhosts",site)
  site_name = site_data["id"]

directory "#{node['nginx']['log_dir']}/#{site_name}" do
  mode      node['nginx']['log_dir_perm']
  owner     node['nginx']['user']
  action    :create
  recursive true
end

directory "#{node['nginx']['default_root']}/#{site_name}" do
  mode      node['nginx']['log_dir_perm']
  owner     node['nginx']['user']
  action    :create
  recursive true
end

template "#{node['nginx']['dir']}/sites-available/#{site_name}.conf" do
  source 'custom-site.erb'
  owner  'root'
  group  node['root_group']
  mode   '0644'
  variables(
  :site_name => site_data["id"],
  :port => site_data["port"]
  )
  notifies :reload, 'service[nginx]', :delayed
end

template "#{node['nginx']['default_root']}/#{site_name}/index.html" do
  source 'index-site.erb'
  mode      node['nginx']['log_dir_perm']
  owner     node['nginx']['user']
  action    :create

  variables(
  :site_name => site_data["id"],
  :port => site_data["port"]
  )
end


nginx_site "#{site_name}.conf" do
  enable node['nginx']['default_site_enabled']
 end

end

