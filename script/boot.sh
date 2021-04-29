java -Xmx64m -Xms64m -jar $KVHOME/lib/kvclient.jar

java -jar $KVHOME/lib/kvstore.jar makebootconfig \
-root $KVROOT \
-port 5000 \
-host $KVHOST \
-harange 5010,5020 \
-servicerange 5021,5049 \
-admin-web-port 5999 \
-store-security none \
-mgmt jmx \
-capacity 1 \
-storagedir /home/opc/nosql/data/disk1 \
-storagedirsize 500-MB

nohup java -jar $KVHOME/lib/kvstore.jar start -root $KVROOT >/dev/null 2>&1 </dev/null &
sleep 5
sudo netstat -ntpl | grep 50

