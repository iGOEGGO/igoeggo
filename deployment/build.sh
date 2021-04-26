#!/bin/bash
PORT=$1 # der Port wird ueber ein Kommandozeilenargument uebergeben
USER=shiny
# R-Dateien in den aktuellen Ordner kopieren
cp -r ../iGOEGGO_r_shiny .
sed -i -e "s|<USER_EXPORT>|export OURUSER=$USER|" docker-entrypoint.sh
sed -i -e "s|<PORT_EXPORT>|export PORT=$PORT|" docker-entrypoint.sh
docker build . -t testshiny
sed -i -e "s|export OURUSER=$USER|<USER_EXPORT>|" docker-entrypoint.sh
sed -i -e "s|export PORT=$PORT|<PORT_EXPORT>|" docker-entrypoint.sh
rm -rf iGOEGGO_r_shiny/  