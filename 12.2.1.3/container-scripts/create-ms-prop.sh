cat <<EOF > ms.prop 
# AdminServer connection details.
admin.username=${ADMIN_USER:-weblogic}
admin.password=${ADMIN_PWD}
admin.url=t3://$ADMIN_HOST:$ADMIN_PORT

ms.name=$MANAGED_SERVER
ms.address=$(hostname -i)
ms.port=${MANAGED_PORT:-8001}
ms.cluster=${SOA_CLUSTER:-soa_cluster}
ms.sslport=${MANAGED_SSL_PORT:-8002}
ms.machine=$HOSTNAME
EOF
