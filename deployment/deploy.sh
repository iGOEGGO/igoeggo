#!/bin/bash
NO_PORT_MESSAGE="# no port needed for heroku"

heroku login -i
cp -r ../iGOEGGO_r_shiny .
sed -i -e 's|<USER_EXPORT>|export OURUSER=$(whoami)|' docker-entrypoint.sh
sed -i -e 's|<PORT_EXPORT>|$NO_PORT_MESSAGE|' docker-entrypoint.sh
heroku container:login
heroku container:push web --app igoeggo
heroku container:release web --app igoeggo
until heroku logs --app igoeggo --source app | grep -q "shiny-server - Starting listener"; do
   sleep 10
   echo "Waiting for igoeggo to be ready......................."
done
curl igoeggo.herokuapp.com
sed -i -e 's|export OURUSER=$(whoami)|<USER_EXPORT>|' docker-entrypoint.sh
sed -i -e 's|$NO_PORT_MESSAGE|<PORT_EXPORT>|' docker-entrypoint.sh
rm -r iGOEGGO_r_shiny/
