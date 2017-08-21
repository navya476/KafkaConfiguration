# Creating the required folders
node['Kafka']['Folders'].each do |path|
  directory "/var/lib/#{path}" do
    mode '0700'
    action :create
  end
end

# Adding the gpg key to repo
execute 'Adding key to Apt repository' do
  command 'rpm --import http://packages.confluent.io/rpm/3.0/archive.key'
  not_if 'rpm -qi gpg-pubkey-\* | grep "confluent" | grep -v grep'
end

#Adding the source to repos
template "/etc/yum.repos.d/confluent.repo" do
     source 'rhel7.repo.erb'
     notifies :run, "execute[clean cache]", :immediately
end

# Cleaning repo cache
execute 'clean cache' do
  command 'yum clean all'
  action :nothing
end

# Installing the required package
yum_package 'confluent-platform-2.11' do
  action :install
end

# Creating Kafka server properties file and starting the Kafka brokers.
j=node['Kafka']['BrokerID']
i=0
while i < node['Kafka']['Brokers']  do

   template "/etc/kafka/server#{i}.properties" do
     source 'server.properties.erb'
     mode '644'
     owner 'root'
     group 'root'
     variables( 
      BrokerID: "#{j}", 
      LogDir: "/var/lib/kafka#{j}",
      port: i+9092 
   ) 
   notifies :run, "execute[Stopping KafkaBrokers]", :immediately
   end

   execute "starting kafka broker #{j}" do
     command "kafka-server-start -daemon /etc/kafka/server#{j}.properties"
     not_if "ps -ef | grep \"server#{j}.properties\" | grep -v grep"
   end  
 
   i += 1
   j += 1
end

# stopping all Kafka-Brokers
execute 'Stopping KafkaBrokers' do
  command 'kafka-server-stop; while true; do sample=`ps -ef | grep server..properties | grep -v grep`; if [ -z "$sample" ]; then echo Kafka Brokers stopped;break; fi; done'
  only_if "ps -ef | grep \"server..properties\" | grep -v grep"
  action :nothing
end
