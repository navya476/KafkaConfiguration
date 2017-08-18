# Updating the apt repository
apt_update 'update'

# Installing the dependency software
node['Kafka']['Dependencies'].each do |dependency|
  apt_package "#{dependency}" do
    action :install
  end
end
