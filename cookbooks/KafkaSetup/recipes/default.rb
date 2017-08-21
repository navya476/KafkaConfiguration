#
# Cookbook:: KafkaSetup
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

if node['platform_family'] == 'ebian'
  include_recipe 'KafkaSetup::dependencies'
  include_recipe 'KafkaSetup::install'
elsif node['platform_family'] == 'rhel'
  include_recipe 'KafkaSetup::dependencies-rhel'
  include_recipe 'KafkaSetup::install-rhel'
end

include_recipe 'KafkaSetup::configure'
