#!/bin/bash

wget http://soaadm:9999/managedServerTemplate.jar

$ORACLE_HOME/oracle_common/common/bin/unpack.sh -domain $DOMAIN_HOME -template managedServerTemplate.jar

/u01/oracle/dockertools/create-ms-prop.sh

/u01/oracle/oracle_common/common/bin/wlst.sh -skipWLSModuleScanning /u01/oracle/dockertools/create-managed-server.py -p ms.prop

mkdir -p $DOMAIN_HOME/servers/${MANAGED_SERVER}/security
cat <<EOF > $DOMAIN_HOME/servers/${MANAGED_SERVER}/security/boot.properties
username=${ADMIN_USER:-weblogic}
password=${ADMIN_PWD}
EOF

$DOMAIN_HOME/bin/startManagedWebLogic.sh ${MANAGED_SERVER} "http://"${ADMIN_HOST}:${ADMIN_PORT}


#
