# Installing Mongodb
yum_package 'mongodb-org'

# Updating the mongod.conf
template "/etc/mongod.conf" do
  source "mongod.conf.erb"
  notifies :restart, "service[mongod_restart]", :immediately
end

# Starting the mongod service
service "mongod_start" do
  action [ :enable, :start ]
  service_name "mongod"
end

# Restarting the mongod service
service "mongod_restart" do
  action :nothing
  service_name "mongod"
end
