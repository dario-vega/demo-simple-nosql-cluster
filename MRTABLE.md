# Creating a one-node cluster for tests with multi-region

```
source env.sh
sh clean.sh
sh boot.sh
cp template_config1x1.kvs $KVSTORE_config1x1.kvs
sed -i "s/<HERE>/$KVSTORE/g" $KVSTORE_config1x1.kvs; 
java -jar $KVHOME/lib/kvstore.jar runadmin -port 5000 -host localhost load -file $KVSTORE_config1x1.kvs

cp $KVSTORE_template.json $KVXRS/json.config
nohup java -Xms256m -Xmx2048m -jar $KVHOME/lib/kvstore.jar xrstart -config $KVXRS/json.config  > $KVXRS/nohup.out &
```

# Backup using import/export
The import/export utility will be deprecated and replaced by the migrator utility.  Suppose you need to retain your per-record TTL values in your backup. In that case, you must currently use export to store your table in binary  format

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