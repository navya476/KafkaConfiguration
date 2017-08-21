# Installing the dependency software
node['Kafka']['Dependenciesrhel'].each do |dependency|
  yum_package "#{dependency}" do
    action :install
  end
end
