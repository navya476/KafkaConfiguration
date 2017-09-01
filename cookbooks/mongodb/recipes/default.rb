#
# Cookbook:: mongodb
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

if node['platform_family'] == 'rhel'
  include_recipe 'mongodb::dependencies-rhel'
  include_recipe 'mongodb::install-rhel'
end
