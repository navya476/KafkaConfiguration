# If we have multiple zookeeper nodes, this zookeeperString is used to specify all the zookeeper nodes in the commands
# e.g., "kafka-topics --create --zookeeper 127.0.0.1:2181,127.0.0.1:2181 --replication-factor 2 --partitions 2 --topic sample-topic
i=1
zookeeperString = ""
node['Zookeeper']['Details'].each do |zookeeper|
  if i == 1 
    zookeeperString += zookeeper['IP'] 
    zookeeperString += ':' 
    zookeeperString += zookeeper['ClientPort'].to_s 
  else 
    zookeeperString += ',' 
    zookeeperString += zookeeper['IP'] 
    zookeeperString += ':' 
    zookeeperString += zookeeper['ClientPort'].to_s 
  end 
  i += 1 
end

# Creates all the topics listed in default['Kafka']['Topics'] attribute
node['Kafka']['Topics'].each do |topic|
  execute "Creating #{topic['Name']}" do
    command "kafka-topics --create --zookeeper #{zookeeperString} --replication-factor #{topic['RF']} --partitions #{topic['Partitions']} --topic #{topic['Name']}"
    not_if "kafka-topics --list --zookeeper #{zookeeperString} | grep #{topic['Name']} | grep -v grep "
  end
end

directory "/var/lib/kafka" do
  action :create
end

# Reassigning the Topics to the new nodes created
if !node['Kafka']['TopicAlter'].nil? && node['Kafka']['TopicAlter'].length > 0
  template "#{node['Kafka']['configFilesPath']}/reassign.json" do
    source "reassign.json.erb"
    notifies :run, "execute[Reassigning the topics]", :immediately
  end

  node['Kafka']['TopicAlter'].each do |topic|
    node['Kafka']['Topics'].each do |existingTopic|
      if existingTopic['Name'] == topic['Name'] && existingTopic['Partitions'] < topic['Partitions']
        execute "Increasing Partions" do
          command "kafka-topics --zookeeper #{zookeeperString} --alter --topic #{topic['Name']} --partitions #{topic['Partitions']}"
          not_if "kafka-topics --describe --zookeeper #{zookeeperString} --topic #{topic['Name']} | grep PartitionCount:#{topic['Partitions']}"
        end
      break
      end
    end
  end
  
  execute "Reassigning the topics" do
    command "kafka-reassign-partitions --zookeeper #{zookeeperString} --reassignment-json-file #{node['Kafka']['configFilesPath']}/reassign.json --execute"
    action :nothing
    notifies :run, "execute[Verifying the Reassignment of topics]", :immediately
  end
  
  execute "Verifying the Reassignment of topics" do
    command "kafka-reassign-partitions --zookeeper #{zookeeperString} --reassignment-json-file #{node['Kafka']['configFilesPath']}/reassign.json --verify"
    action :nothing
  end
end
