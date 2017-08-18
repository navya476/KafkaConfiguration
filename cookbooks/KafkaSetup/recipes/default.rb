#
# Cookbook:: KafkaSetup
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

if node['platform_family'] == 'ebian'

  include_recipe 'KafkaSetup::dependencies'
  include_recipe 'KafkaSetup::install'
  include_recipe 'KafkaSetup::configure'

end

::Chef::Log.info(node['platform'])
::Chef::Log.info(node['Kafka']['Brokers'])
