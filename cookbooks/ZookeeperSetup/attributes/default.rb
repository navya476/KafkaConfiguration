# Dependency software which are required for Zookeeper to run
default['Kafka']['Dependencies'] = ['default-jdk','wget']
default['Kafka']['Dependenciesrhel'] = ['wget','java-1.8.0-openjdk-devel.x86_64']

default['Kafka']['Folders'] = ['kafka']

# Zookeeper ID with with Zookeeper has to run
default['Zookeeper']['ID'] = 1

# Details of all the zookeeper services on all nodes
default['Zookeeper']['Details'] = [
                                     {
                                        'IP'=>'localhost',
                                        'ElectionPort'=>3666,
                                        'NodePort'=>2666,
                                        'ClientPort'=>2181
                                     }
                                  ]
