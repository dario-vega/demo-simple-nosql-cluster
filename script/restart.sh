java -Xmx64m -Xms64m -jar $KVHOME/lib/kvclient.jar
nohup java -jar $KVHOME/lib/kvstore.jar restart -disable-services -root $KVROOT >/dev/null 2>&1 </dev/null &
sleep 5
sudo netstat -ntpl | grep 50
