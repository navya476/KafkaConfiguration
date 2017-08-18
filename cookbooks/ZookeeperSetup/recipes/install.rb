# Creating the required folders
node['Kafka']['Folders'].each do |path|
  directory "/var/lib/#{path}" do
    mode '0700'
    action :create
  end
end

# Adding the gpg key to repo
execute 'Adding key to Apt repository' do
  command 'wget -qO - http://packages.confluent.io/deb/3.0/archive.key | sudo apt-key add -'
  not_if 'apt-key list | grep "confluent" | grep -v grep'
end

# Adding the source to source.list
execute 'Adding the source' do
  command 'add-apt-repository "deb [arch=amd64] http://packages.confluent.io/deb/3.0 stable main"'
  not_if 'cat /etc/apt/sources.list | grep "deb \[arch=amd64\] http\:\/\/packages\.confluent\.io\/deb\/3\.0 stable main" | grep -v grep'
  notifies :run, 'execute[AptUpdate]', :immediately
end

# Updating the apt repository
execute 'AptUpdate' do
  command 'apt-get update'
  action :nothing
end

# Installing the required package
apt_package 'confluent-platform-2.11' do
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

