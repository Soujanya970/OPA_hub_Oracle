#!/bin/bash
function waitForContainer {
    local container=$1

    until [ "`docker inspect -f {{.State.Running}} $container`" == "true" ]; do
        echo Waiting for container $container to start
        sleep 5
    done;
    echo $container is running

    until [ "`docker inspect -f {{.State.Health.Status}} $container`" == "healthy" ]; do
        echo Waiting for container $container to register as healthy
        sleep 5
    done;
    echo $container is healthy
}

echo Starting Oracle container
if ! docker run -d -it --name oracle store/oracle/database-enterprise:12.2.0.1; then
   exit 1
fi

echo Starting Weblogic container
if ! docker run -it -p 7001:7001 -v $PWD:/u01/oracle/properties -e ADMINISTRATION_PORT_ENABLED=false --link oracle:oracle --health-cmd="curl -f http://localhost:7001/console || exit 1" -d container-registry.oracle.com/middleware/weblogic:12.2.1.3; then   exit 1
fi

waitForContainer oracle
waitForContainer opa-weblogic-full
echo All containers running

echo Installing OPA
if ! ( docker cp opa opa-weblogic-full:/u01/oracle/opa \
    && docker exec --privileged --user root opa-weblogic-full chown oracle:oracle -R /u01/oracle/opa \
    && docker exec --user root opa-weblogic-full chmod +x -R /u01/oracle/opa/bin/install.sh \
    && docker exec opa-weblogic-full /u01/oracle/opa/bin/install.sh install -non-secure-cookie=true -name=dev -dbconn=172.17.0.2:1521/ORCLCDB.localdomain -dbuser=SATYA -dbpass=password -dbtype=oracle -hubpass=Passw0rd -key=12345678 -wladmin=AdminServer -wladminurl=t3://localhost:7001 -target=AdminServer -wldomain=/u01/oracle/user_projects/domains/base_domain -wlstdir=/u01/oracle/wlserver/common/bin ); then
    exit 1
fi

echo Your hub is now ready at http://localhost:7001/dev/opa-hub
echo WARNING: Take note of the generated admin password and encryption key in the log above.
