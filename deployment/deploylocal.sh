#!/bin/bash
PORT=$1 # der Port wird ueber ein Kommandozeilenargument uebergeben

# aktuelle Version des Images bauen
if [[ $* == *--nobuild* ]]
then
   echo '[info] image will not be built'
else
   echo '[info] building image'
   sh build.sh $1
   echo '[info] image built'
fi
# wenn der Container bereits laeuft, stoppe ihn
docker rm --force igoeggo
# Container starten
docker run --name=igoeggo -d -p $PORT:$PORT testshiny
# warten, bis der Container fertig hochgefahren ist
until docker logs igoeggo | grep -q "listener"; do
   sleep 10
   echo "Waiting for igoeggo to be ready......................."
done
# curl, um zu checken, dass alles funktioniert hat
curl -v --silent localhost:$1 --stderr - | grep '<header class="main-header">'