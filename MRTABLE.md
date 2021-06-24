# Creating a one-node cluster for tests with multi-region

Before to execute modify the env.sh in order to provide the good storename to your region

```
source env.sh
sh clean.sh
sh boot.sh
cp template_config1x1.kvs ${KVSTORE}_config1x1.kvs
sed -i "s/<HERE>/$KVSTORE/g" ${KVSTORE}_config1x1.kvs
sed -i "s/<HERE_HOST>/$KVHOST/g" ${KVSTORE}_config1x1.kvs
java -jar $KVHOME/lib/kvstore.jar runadmin -port 5000 -host localhost load -file ${KVSTORE}_config1x1.kvs
```
After building the 2 clusters - Configure XRegion Service
```
cp ${KVSTORE}_template.json $KVXRS/json.config
nohup java -Xms256m -Xmx2048m -jar $KVHOME/lib/kvstore.jar xrstart -config $KVXRS/json.config  > $KVXRS/nohup.out &
sleep 5

kv_admin load -file ${KVSTORE}.kvs
```

# Backup using import/export
**NOTE** The import/export utility will be deprecated and replaced by the migrator utility.  Suppose you need to retain your per-record TTL values in your backup. In that case, you must currently use export to store your table in binary  format

````
java  -jar $KVHOME/lib/kvtool.jar export -table users -store OUGCO -helper-hosts node2-nosql:5000  -config export_config -format BINARY
java -jar $KVHOME/lib/kvtool.jar import -table users -store OUGFR -helper-hosts node1-nosql:5000  -config import_config -status ./checkpoint_dir -format BINARY
````

# Backup using migrator Tool
The migrator-export-users.json and migrator-import-users.json are provide for educatiotal purposes

````
./runMigrator --config migrator-export-users.json
./runMigrator --config migrator-import-users.json
````
