#!/bin/bash

SERVICE=1

case $SERVICE_NAME in
  server|scheduler) SERVICE=1;;
  *) SERVICE=0;;
esac

if [ "$SERVICE" -eq "0" ]; then
    /usr/local/bin/sccache-dist $@
else
    CONFIG=/$SERVICE_NAME.conf
    if [ -z "$SCHEDULER_ADDR" ]; then
        echo "Must provide \$SCHEDULER_ADDR"
        return 1
    fi
    if [ -z "$TOKEN" ]; then
        echo "Must provide \$TOKEN"
        return 1
    fi
    sed -i 's!\$\$SCHEDULER_ADDR\$\$!'"${SCHEDULER_ADDR}"'!g' $CONFIG
    sed -i 's!\$\$TOKEN\$\$!'"${TOKEN}"'!g' $CONFIG
    /usr/local/bin/sccache-dist $SERVICE_NAME --config $CONFIG
fi

