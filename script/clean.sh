rm -rf $KVROOT
rm -rf $KVDATA
mkdir -p ${KVROOT}
mkdir -p ${KVDATA}
mkdir -p ${KVDATA}/disk1
mkdir -p ${KVDATA}/disk2
mkdir -p ${KVDATA}/disk3
mkdir -p /home/opc/kvstore_export


ls -lrtd $KVROOT
ls -lrt  $KVROOT
ls -lRtd $KVDATA
ls -lRt  $KVDATA

java -Xmx64m -Xms64m -jar $KVHOME/lib/kvclient.jar


