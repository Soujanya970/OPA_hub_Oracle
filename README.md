# OPA_hub_Oracle

Demo for Installing Opa-hub on weblogic using Docker. This configuration need weblogic server,Docker installation and Oracle database with Oracle Linux 7

##Software Versions:

Docker version 19.03.6
Oracle 19/12/12.2.0.1 with Oracle Linux 6 or 7
Weblogic 12.2.1.3 (container-registry.oracle.com/middleware/weblogic:12.2.1.3 - 1.14 GB)
OPA 19D (12.2.17)

**Steps to be followed:**

Launch 1 EC2 instance.
Install Docker
Pull the Oracle Database with Oracle Linux 7 image
Pull the weblogic 12.2.1.3 image
Download the OPA 19D from Oracle Software Delivery Cloud

**Oracle Database:**
Login to Docker hub and search for Oracle database.
Pull the image from docker pull store/oracle/database-enterprise:12.2.0.1
To start the Oracle Database server instance - docker run -d -it --name <Oracle-DB> store/oracle/database-enterprise:12.2.0.1

Oracle Database Server 12c R2 is an industry leading relational database server. The Oracle Database Server Docker Image contains the Oracle Database Server 12.2.0.1 Enterprise Edition running on Oracle Linux 7. This image contains a default database in a multitenant configuration with one pdb.

**Weblogic:**
Sign up for Oracle Container Registry (https://container-registry.oracle.com)
Agree to the Weblogic Image Terms and Restrictions (Middleware / Weblogic / Continue)
Log in to Oracle Container Registry through Docker docker login container-registry.oracle.com using your Oracle login
To start the weblogic: docker run -it -p 7001:7001 -v $PWD:/u01/oracle/properties -e ADMINISTRATION_PORT_ENABLED=false --link oracle:oracle --health-cmd="curl -f http://localhost:7001/console || exit 1" -d container-registry.oracle.com/middleware/weblogic:12.2.1.3

**OPA:**
Download OPA Server 12.2.17 from Oracle Software Delivery Cloud

Unzip the OPA archive and move the contents of the opa directory into opa-hub-docker/weblogic/opa
Run the provided run.sh / .bat script on the command line from this directory opa-hub-docker\weblogic\
stop.sh to stop the containers
remove.sh to delete the containers
start.sh to start the containers if you haven't already deleted them

