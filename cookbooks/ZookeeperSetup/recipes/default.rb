#
# Cookbook:: ZookeeperSetup
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

if node['platform_family'] == 'debian'
  include_recipe 'ZookeeperSetup::dependencies'
  include_recipe 'ZookeeperSetup::install'
elsif node['platform_family'] == 'rhel'
  include_recipe 'ZookeeperSetup::dependencies-rhel'
  include_recipe 'ZookeeperSetup::install-rhel'
end
