# Creating a geographically distributed Oracle NoSQL database - 🚧 🚧 🚧 

Please read the following blog if you want to have more detailed information about [Multi-Region Table](https://blogs.oracle.com/nosql/oracle-nosql-database-multi-region-table-part1-v2)

In this workshop, 
* we will create 2 KV sotres with 2 differents StoreName (OUGFR, OUGCO) 
* we will Create 2 minimal store (1x1) - 1 server - for test only not for production that requires high availability and business continuity
* we will create 2 regions FR and CO. (harcoded values)
* the templates provided for the section Configure XRegion Service are hardcoded (see hosts)

It was my decision to deploy the KVStore in each region with a different store name but it is not mandatory, you can use the same name.

Review our first [workshop](./README.md) for detailed information about How to deploy an Oracle NoSQL Cluster.

## Deploy your clusters

In each region in the Multi-Region NoSQL Database setup, you must deploy its own KVStore independently.

Before execute, please modify the env.sh in order to provide the good storename for your region and validate the parameters (eg. export KVSTORE=OUGFR)

```
source env.sh
sh clean.sh
sh boot.sh
cp template_config1x1.kvs ${KVSTORE}_config1x1.kvs
sed -i "s/<HERE>/$KVSTORE/g" ${KVSTORE}_config1x1.kvs
sed -i "s/<HERE_HOST>/$KVHOST/g" ${KVSTORE}_config1x1.kvs
java -jar $KVHOME/lib/kvstore.jar runadmin -port 5000 -host localhost load -file ${KVSTORE}_config1x1.kvs
```

## Set up Multi-Region Environment

After building the 2 clusters

1- Configure and Start XRegion Service in each region
```
cp ${KVSTORE}_template.json $KVXRS/json.config
nohup java -Xms256m -Xmx2048m -jar $KVHOME/lib/kvstore.jar xrstart -config $KVXRS/json.config  > $KVXRS/nohup.out &
sleep 5
```
2- Set Local Region Name and Create Remote Regions
```
kv_admin load -file ${KVSTORE}.kvs
```

## Create Multi-Region Tables - 

You must create an MR Table on each KVStore in the connected graph, and specify the list of regions that the table should span. For the use case under discussion, you must create the users table as an MR Table at both the regions, in any order. 

````
CREATE TABLE Users(uid INTEGER, person JSON,PRIMARY KEY(uid))  IN REGIONS CO , FR;
````

After creating the MR Table, you can perform read or write operations on the table using the existing data access APIs or DML statements. There is no change to any existing
data access APIs or DML statements to work with the MR Tables. Perform DML operations on the users table in one region, and verify if the changes are replicated to the
other region. 

````
insert into users values(1,{"firstName":"jack","lastName":"ma","location":"FR"});
insert into users values(2, {"firstName":"foo","lastName":"bar","location":null});
update users u set u.person.location = "FR" where uid = 2;
update users u set u.person.location= "CO" where uid =1;
select * from users;
````

[In this blog](https://blogs.oracle.com/nosql/nosql-crdt), we discussed how vital conflict detection and resolution is in an active-active replication.
-    Oracle NoSQL Multi-Region solution enabling predictable low latency and response time from anywhere in the world
-    Oracle continues to improve the developer experience by introducing CRDTs that perform automatic merging and bookkeeping of value update across regions, alleviating the pain of multi-region reconciliation from your app development experience.

A Multi-Region table is a global logical table that eliminates the problematic and error-prone work of replicating data between regions, enabling developers to focus on application business logic.

Now it is time to test. Scripts are available [here](https://github.com/dario-vega/crdt-blog-nosql/blob/main/README.md)


# Backup using migrator Tool
The instructions below specify a manual procedure for creating a backup of a multi-region table and a procedure for restoring that table in the event of table level data loss or corruption. 

**NOTE** This exemple is provided for educational purposes only.

The  [migrator-export-users.json](./script/migrator-export-users.json) and [migrator-import-users.json](./script/migrator-import-users.json) show an exemple of scripts used to export/import data in a MR table configuration. In this case, we are exporting in a region, and we decided to do the import in the other region.

````
./runMigrator --config migrator-export-users.json
./runMigrator --config migrator-import-users.json
````
Use the multi-region statistics to find the most up to date region for the table that you wish to back up. Use the command `show mrtable-agent-statistics -agent 0 -json` to find the region that shows the smallest laggingMS value for the “max” attribute.  This region will contain the most up-to-date version of your table.

The shell script [mrtable-agent-stat.sh](script/ mrtable-agent-stat.sh) can you help you to compare the smallest laggingMS
````
sh mrtable-agent-stat.sh
````
To restore a multi-region table from an export, it is recommended that you stop all write activity to the multi-region table being restored.

**NB** The best is recreate the table in all regions before do the import.

And DO NOT FORGET to backup on remote storage (storage that is not local to a NoSQL storage node in the NoSQL topology).


# Backup using import/export
**NOTE** The import/export utility will be deprecated and replaced by the migrator utility.  But if you need retain your per-record TTL values in your backup. In that case, you must currently use export to **store your table in binary format**. migrator does not have this TTL support yet

````
java -jar $KVHOME/lib/kvtool.jar export -table users -store OUGCO -helper-hosts node2-nosql:5000  -config export_config -format BINARY
java -jar $KVHOME/lib/kvtool.jar import -table users -store OUGFR -helper-hosts node1-nosql:5000  -config import_config -status ./checkpoint_dir -format BINARY
````
