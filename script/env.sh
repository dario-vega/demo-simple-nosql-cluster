export KVROOT=/home/opc/nosql/kvroot
export KVDATA=/home/opc/nosql/data
export KVHOME=/home/opc/nosql/kv-22.1.16
export KVHOST=`hostname`
export KVXRS=/home/opc/nosql/xrshome
export KVSTORE=OUG


echo $KVROOT
echo $KVDATA
echo $KVHOME
echo $KVHOST
echo $KVXRS
echo $KVSTORE


alias kv_sql="java -jar $KVHOME/lib/sql.jar -helper-hosts $KVHOST:5000 -store $KVSTORE "
alias kv_admin="java -jar $KVHOME/lib/kvstore.jar runadmin -port 5000 -host $KVHOST"
alias kv_ping="java -jar $KVHOME/lib/kvstore.jar ping  -port 5000 -host $KVHOST"
alias kv_proxy="java -jar $KVHOME/lib/httpproxy.jar -helperHosts $KVHOST:5000 -storeName $KVSTORE -httpPort 80 -verbose true"
