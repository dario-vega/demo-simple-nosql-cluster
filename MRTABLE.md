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
