#!/bin/bash
SHINY_PROXY_VERSION=2.5.0                   # shinyproxy version
FILE=shinyproxy-$SHINY_PROXY_VERSION.jar    # shinyproxy file

# aktuelle Version des Images bauen
if [[ $* == *--nobuild* ]]
then
   echo '[info] image will not be built'
else
   echo '[info] building image'
   sh build.sh 3838
   echo '[info] image built'
fi
# checken, ob die jar-Datei vorhanden ist
if test -f "$FILE"; then
    echo "$FILE exists."
else 
    # wenn nicht, lade sie herunter
    wget -O $FILE https://shinyproxy.io/downloads/$FILE
fi

# jar-Datei ausführen
java -jar $FILE
