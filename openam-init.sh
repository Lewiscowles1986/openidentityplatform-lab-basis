#!/bin/bash

/usr/local/tomcat/bin/catalina.sh run &
SERVER_PID=$!

# Wait for OpenAM to respond to isAlive.jsp
until curl -f http://localhost:8080/openam/isAlive.jsp; do
    echo "Waiting for OpenAM to fully initialize..."
    sleep 5
done

SEED_FLAG_FILE=/usr/local/tomcat/webapps/openam/.seeded
if [[ -f "$SEED_FLAG_FILE" ]]; then
    echo "No need for setup skipping..."
else
    echo "Setting up OpenAM..."
    java -jar /usr/openam/ssoconfiguratortools/openam-configurator-tool*.jar --file /usr/openam/config/config.properties --acceptLicense
    touch $SEED_FLAG_FILE
fi

wait $SERVER_PID
