# openshift-soa
Fork of OracleSOASuite to try to run on OpenShift.

This is a fork of this git repo project:

https://github.com/oracle/docker-images/tree/master/OracleSOASuite

The project in the oracle docker-image repo has several issues that make it unsuitable for OpenShift:

1) it seems to rely on shared volumes between the Admin and ManagedServer containers
2) I could only make it work by building an admin server, commiting that container to a new image, and using that new image for the managed server container

This project attempts to create a configruation that will allow you to:

1) Create a SOA Metadata database container (using the OracleDatabase docker image in the same project above)
2) Create a SOA Admin container
3) Create a SOA Managed server and automatically register with the admin server

Prerequisites:
Oracle Database image built from the oracle docker-images
Oracle Java 8 image built from the same
Oracle FMW image 12.2.1.3 built from the same

Docker Example:

#create a docker network for the containers
docker network create soanet

#create a database for the SOA repository
#you can monitor via docker logs -f soadb
docker run -d --network soanet --name soadb --hostname soadb -e ORACLE_SID=ORCL -e ORACLE_PDB=SOADB -e ORACLE_PWD=dilbert99 oracle/database:12.1.0.2-ee

#create a SOA Admin server
#you must wait for the database container to complete
#you can monitor via docker logs -f soaadm
#should be able to reach
#http://localhost:7001/console
#http://localhost:7001/em
docker run -d --network soanet --name soaadm --hostname soadm -e DOMAIN_TYPE=soa -e CONNECTION_STRING=soadb:1521/SOADB -e DB_PASSWORD=dilbert99 -e DB_SCHEMA_PASSWORD=dilbert99 -e RCUPREFIX=SOA -e MANAGED_SERVER=soa_server1 -e ADMIN_HOST=soaadm -e ADMIN_PASSWORD=dilbert99 -p 7001:7001 oracle/soasuite:12.2.1.3

#create the managed server
#you must wait for the admin server to complete
#you can monitor via docker logs -f soams
docker run -d --network soanet --name soams --hostname soams -p 8001:8001 -p 8002:8002 -e DOMAIN_TYPE=soa -e ADMIN_HOST=soaadm -e ADMIN_PORT=7001 -e adminhostname=soaadm -e adminport=7001 -e ADMIN_PWD=dilbert99 -e MANAGED_SERVER=soa_server2  oracle/soasuite:12.2.1.3 "/u01/oracle/dockertools/startRemoteManagedServer.sh"

#to add another
docker run -d --network soanet --name soams2 --hostname soams2 -p 9001:8001 -p 9002:8002 -e DOMAIN_TYPE=soa -e ADMIN_HOST=soaadm -e ADMIN_PORT=7001 -e adminhostname=soaadm -e adminport=7001 -e ADMIN_PWD=dilbert99 -e MANAGED_SERVER=soa_server3  oracle/soasuite:12.2.1.3 "/u01/oracle/dockertools/startRemoteManagedServer.sh"
OpenShift setup:

TDB




