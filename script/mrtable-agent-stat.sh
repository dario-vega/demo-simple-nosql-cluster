echo "connect store -name $KVSTORE -host localhost -port 5000" > mrtable-agent.kvs
echo "show mrtable-agent-statistics -agent 0 -json" >> mrtable-agent.kvs
java -jar $KVHOME/lib/kvstore.jar runadmin -port 5000 -host localhost  load -file  mrtable-agent.kvs | grep -v Connected | jq '. "returnValue"[]."statistics"."regionStat"[]."laggingMs"."max"'

