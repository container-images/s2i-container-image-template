#!/bin/bash

SERVICE_CONFIG_PATH=/etc/service.conf

# If user provides own config file use it and do not generate new one
if [ ! -s $SERVICE_CONFIG_PATH ]; then
  # If no configuration is provided use template
  cp /files/service.conf $SERVICE_CONFIG_PATH
fi
[ -r "${APP_DATA}/service-config/service.conf" ] && cp "${APP_DATA}/service-config/service.conf" $SERVICE_CONFIG_PATH
