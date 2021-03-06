# file run.sh
#!/bin/sh

if [ -d "/jsreport" ]; then
  # link data folder from mounted volume

  if [ ! -d "/jsreport/data" ]; then
    mkdir "/jsreport/data"
  fi

  ln -nsf "/jsreport/data" "/usr/src/app/data"

  # copy default config
  if [ ! -f "/jsreport/jsreport.config.json" ]; then
    cp "/usr/src/app/jsreport.config.json" "/jsreport/jsreport.config.json"
  fi

  
  ln -s "/jsreport/prod.config.json" "/usr/src/app/prod.config.json"
  ln -s "/jsreport/dev.config.json" "/usr/src/app/dev.config.json"
  ln -s "/jsreport/license-key.txt" "/usr/src/app/license-key.txt"
  ln -s "/jsreport/license.json" "/usr/src/app/license.json"

  rm -f "/usr/src/app/jsreport.config.json"
  ln -s "/jsreport/jsreport.config.json" "/usr/src/app/jsreport.config.json"

  chown -R jsreport:jsreport /jsreport
fi

su jsreport

echo Trying to remove the lock on display 99
rm /tmp/.X99-lock > /dev/null 2>&1

echo Running display 99
Xvfb :99 -screen 0 1024x768x24 > /dev/null 2>&1 &

echo Starting node.js
export DISPLAY=:99 && node "/usr/src/app/server.js"