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

# Creating a properties file with which Zookeeper runs
template "/etc/kafka/zookeeper#{node['Zookeeper']['ID']}.properties" do
  source 'zookeeper.properties.erb'
    mode '644'
    owner 'root'
    group 'root'
    variables(
      dataDir: "/var/lib/zookeeper#{node['Zookeeper']['ID']}"
   )
  notifies :run, "execute[stopping zookeeper]", :immediately
end

# Creating a folder for zookeeper
directory "/var/lib/zookeeper#{node['Zookeeper']['ID']}" do
  mode '755'
end

# Creating a file to store zookeeper ID
file "/var/lib/zookeeper#{node['Zookeeper']['ID']}/myid" do
  mode '777'
  content "#{node['Zookeeper']['ID']}"
end

# Stops the Zookeeper instance if there is any changes made to properties file.
execute 'stopping zookeeper' do
  command "zookeeper-server-stop; while true; do sample=`ps -ef | grep zookeeper..properties | grep -v grep`; if [ -z \"$sample\" ]; then echo Zookeeper stopped;break; fi; done"
  only_if "ps -ef | grep \"zookeeper#{node['Zookeeper']['ID']}.properties\" | grep -v grep"
  action :nothing
end

# Starting the zookeeper service
execute 'starting zookeeper' do
  command "zookeeper-server-start -daemon /etc/kafka/zookeeper#{node['Zookeeper']['ID']}.properties"
  not_if "ps -ef | grep \"zookeeper#{node['Zookeeper']['ID']}.properties\" | grep -v grep"
end

