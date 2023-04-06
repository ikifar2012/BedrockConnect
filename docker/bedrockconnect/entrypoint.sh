#!/bin/bash

COMMAND="java -Xms256M -Xmx256M -jar BedrockConnect-1.0-SNAPSHOT.jar"

# Add the users environment variables to the command
for env_var in mysql_host mysql_port mysql_user mysql_pass server_limit port bindip nodb generatedns kick_inactive custom_servers user_servers featured_servers whitelist fetch_featured_ips language
do
    if [ -n "${!env_var}" ]
    then
        COMMAND="${COMMAND} ${env_var}=${!env_var}"
    fi
done

eval "$COMMAND"