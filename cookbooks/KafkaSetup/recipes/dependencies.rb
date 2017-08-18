# Updating the apt repo
apt_update 'Updating the apt repository'

# Installing the dependency software
node['Kafka']['Dependencies'].each do |dependency|
  apt_package "#{dependency}" do
    action :install
  end
end
