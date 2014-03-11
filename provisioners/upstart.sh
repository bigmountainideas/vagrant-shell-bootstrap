if ! [ -n "$1" ]; then
  PROCESS_HOME=/home/app/
else
  PROCESS_HOME=$1
fi

if ! [ -n "$2" ]; then
  PROCESS_NAME=web
else
  PROCESS_NAME=$2
fi

CONF="start on (vagrant-mounted)
stop on shutdown
respawn

script
  cd ${PROCESS_HOME}${PROCESS_NAME};
  sudo -u app foreman start >> ${PROCESS_HOME}${PROCESS_NAME}/logs/app.log 2>&1
end script
"

sudo echo -e "$CONF" >> /etc/init/${PROCESS_NAME}.conf

sudo start $PROCESS_NAME
