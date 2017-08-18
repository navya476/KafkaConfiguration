#
# Cookbook:: KafkaSetup
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

if node['platform_family'] == 'ebian'

  include_recipe 'KafkaSetup::dependencies'
  include_recipe 'KafkaSetup::install'
  include_recipe 'KafkaSetup::configure'

elsif node['platform_family'] == 'rhel'
#  ::Chef::Log.info(node['platform'])
#  ::Chef::Log.info(node['Kafka']['Brokers'])

#  log 'message' do
#    message "#{node['platform_family']}"
#    level :info
#  end
  include_recipe 'KafkaSetup::dependencies-rhel'
end
