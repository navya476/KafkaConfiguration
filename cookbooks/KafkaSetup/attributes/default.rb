#Dependency software to be installed in order to run Kafka
default['Kafka']['Dependencies'] = ['default-jdk','wget']
default['Kafka']['Dependenciesrhel'] = ['wget','java-1.8.0-openjdk-devel.x86_64']
default['Kafka']['Folders'] = ['kafka']

# Number of Kafka Brokers Required on a single node
default['Kafka']['Brokers'] = 1

# Kafka Broker ID from which the IDs should start
default['Kafka']['BrokerID'] = 0

#Topics to be created
default['Kafka']['Topics'] = [
                               { 
                                 'Name' => 'Navya',
                                 'RF' => 1,
                                 'Partitions' => 2 
                               },
                               { 
                                 'Name' => 'happy',
                                 'RF' => 1, 
                                 'Partitions' => 6
                               }
                             ]

#Topics to be altered, If there are no topics to alter give an empty array(eg., default['Kafka']['TopicAlter'] = [])
default['Kafka']['TopicAlter'] = [
                                   { 
                                      'Name' => 'Navya',
                                      'RF' => 1, 
                                      'Partitions' => 3 
                                   },
                                   {
                                      'Name' => 'happy',
                                      'RF' => 1, 
                                      'Partitions' => 8
                                   }
                                 ]
