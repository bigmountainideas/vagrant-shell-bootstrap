NGX_HOME=/usr/local/nginx

for DOMAIN in "$@"
do

  DOMAIN_CONFIG="include /home/apps/${DOMAIN}/bin/nginx.conf;"

  if [ -a "${NGX_HOME}/sites-available/${DOMAIN}" ]; then
    sudo rm ${NGX_HOME}/sites-available/${DOMAIN}
  fi
  sudo echo -e "$DOMAIN_CONFIG" >> ${NGX_HOME}/sites-available/${DOMAIN}

  if ! [ -a "${NGX_HOME}/sites-enabled/${DOMAIN}" ]; then
    sudo ln -s ${NGX_HOME}/sites-available/${DOMAIN} ${NGX_HOME}/sites-enabled/${DOMAIN}
  fi

done


sudo nginx -s reload
