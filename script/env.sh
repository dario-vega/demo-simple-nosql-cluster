export KVROOT=/home/opc/nosql/kvroot
export KVDATA=/home/opc/nosql/data
export KVHOME=/home/opc/nosql/kv-21.1.12
export KVHOST=`hostname`

echo $KVROOT
echo $KVDATA
echo $KVHOME
echo $KVHOST

alias kv_sql="java -jar $KVHOME/lib/sql.jar -helper-hosts node1-nosql:5000 -store OUG "
alias kv_admin="java -jar $KVHOME/lib/kvstore.jar runadmin -port 5000 -host node1-nosql"
alias kv_ping="java -jar $KVHOME/lib/kvstore.jar ping  -port 5000 -host node1-nosql"
alias kv_proxy="java -jar $KVHOME/lib/httpproxy.jar -helperHosts node1-nosql:5000 -storeName OUG -httpPort 8080 -verbose true"
