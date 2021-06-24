rm -rf $KVROOT
rm -rf $KVDATA
rm -rf $KVXRS
mkdir -p ${KVROOT}
mkdir -p ${KVDATA}
mkdir -p ${KVDATA}/disk1
mkdir -p ${KVDATA}/disk2
mkdir -p ${KVDATA}/disk3
mkdir -p /home/opc/kvstore_export
mkdir -p $KVXRS

ls -lrtd $KVROOT
ls -lrt  $KVROOT
ls -lRtd $KVDATA
ls -lRt  $KVDATA
ls -lRt $KVXRS

java -Xmx64m -Xms64m -jar $KVHOME/lib/kvclient.jar


