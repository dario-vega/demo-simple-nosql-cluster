# demo-simple-nosql-cluster

## Prerequisites 

Just before start an Oracle NoSQL installation, I recommend to read those links
- https://docs.oracle.com/en/database/other-databases/nosql-database/21.1/release-notes/overview.html
- https://docs.oracle.com/en/database/other-databases/nosql-database/21.1/admin/installation-prerequisites.html

### Open JDK

The client and server have been tested and certified against OpenJDK 11.0.2 (Oracle NoSQL 21.1 version)


I've tested with multiple Open JDK versions but it is currenlty working only with 11.0.2 as documented in the release notes
```
sudo yum -y install java-8-openjdk-devel
sudo yum -y install java-11-openjdk-devel
sudo yum -y install java-13-openjdk-devel
sudo yum -y install java-latest-openjdk-devel
#donwload openjdk-11.0.2_linux-x64_bin.tar.gz
```

### Oracle JDK

The Oracle NoSQL Database server is compatible with Java SE 8 (64-bit), and the client is compatible with Java SE 8. Both the client and the server require at least Java SE 8, and should work with more recent Java SE versions

I've tested with multiple Oracle JDK versions and it is working with all version as documented.

```
sudo yum install java
sudo yum install -y jdk1.8
# download the rmp 
sudo yum localinstall jdk-13.0.2_linux-x64_bin.rpm
```
sudo alternatives --config java


FYI, In this demo, I will install our cluster using a jdk1.8 version in order to have access jps - Java Virtual Machine Process Status Tool

## Download and unzip the binary and exemples
```
unzip kv-ee-21.1.12.zip -d nosql
unzip kv-examples-21.1.12.zip -d nosql
````

## Config & start agent 

Before you configure Oracle NoSQL Database, you should determine the following parameters for each Storage Node in the store. 
Each of these parameters are directives to use with the makebootconfig utility
[https://docs.oracle.com/en/database/other-databases/nosql-database/21.1/admin/installation-configuration-parameters.html#GUID-9E2B0453-A0CF-4F34-8A82-A6D801D6C929]

Start the Oracle NoSQL Database Storage Node Agent (SNA)
```
nohup java -jar $KVHOME/lib/kvstore.jar start -root $KVROOT >/dev/null 2>&1 </dev/null &
```


In our case, we will use the following scripts [clean.sh](./scripts/clean.sh) and [boot.sh](./scripts/boot.sh) 

TIP: run jps to validate that nothing is running from a previous test, if it is the case, just kill the processes. (NB If you are not using Oracle JDK, use ps command)
````
[opc@node1-nosql ~]$ jps
9060 ManagedService
9017 kvstore.jar
14633 Jps
````
Run the commands clean.sh and boot.sh

### Useful script

Source the following env variables and alias

cat env.sh

export KVROOT=/home/opc/nosql/kvroot
export KVDATA=/home/opc/nosql/data
export KVHOME=/home/opc/nosql/kv-21.1.12
export KVHOST=`hostname`

echo $KVROOT
echo $KVDATA
echo $KVHOME
echo $KVHOST


### Configuring the Firewall

Do not forget to configure all firewalls. To make sure your firewall works with Oracle NoSQL Database, you should set the ports specified by the servicerange parameter 
of the makebootconfig command. This parameter is used to constrain a store to a limited set of ports, usually for security or data center policy reasons. 
By default the services use anonymous ports. 

For demo purpose, I will stop the firewall in all my servers.

````
# Use the appropiate command, in my case I am using 5.4.17-2102.200.13.el7uek.x86_64 
sudo systemctl stop firewalld
````

## Deploy your cluster

We will deploy our cluster in multiple steps in order to illustrate multiple scenarios :
1) Create minimal store (1x1) - 1 server - for test only not for production that requires high availability and business continuity
2) Increase availability (1x3) - deployed on 3 servers but only 1 shard
3) Elastic Expansion and Rebalancing (3x3) - 3 disks on 3 servers - increase the capacity and rebalance in 3 shards


In our case, we will use the following scripts for each scenario
[config1x1.kvs](./scripts/config1x1.kvs) 
[config1x3.kvs](./scripts/config1x3.kvs) 
[config3x3.kvs](./scripts/config3x3.kvs) 

java -jar $KVHOME/lib/kvstore.jar runadmin -port 5000 -host node1-nosql load -file config1x1.kvs
java -jar $KVHOME/lib/kvstore.jar runadmin -port 5000 -host node1-nosql load -file config1x3.kvs
java -jar $KVHOME/lib/kvstore.jar runadmin -port 5000 -host node1-nosql load -file config3x3.kvs

## Validate your deployment

java -jar $KVHOME/lib/kvstore.jar ping  -port 5000 -host node1-nosql


## Fill the store with different tables

cd $KVHOME
javac -cp examples:lib/kvclient.jar examples/hadoop/table/LoadVehicleTable.java
java -classpath lib/kvclient.jar:examples   hadoop.table.LoadVehicleTable  -store OUG -host node1-nosql -port 5000 -nops 1000







