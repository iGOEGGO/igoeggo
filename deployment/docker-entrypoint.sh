#!/bin/bash
DEBUG=true
<USER_EXPORT>
<PORT_EXPORT>
echo $OURUSER
echo $PORT
su - $OURUSER
sed -i -e "s|<HTTP_PORT>|$PORT|" /etc/shiny-server/shiny-server.conf
sed -i -e "s|<USER>|$OURUSER|" /etc/shiny-server/shiny-server.conf
# debug output | START
if [[ $DEBUG == true ]]
then
	cat /etc/shiny-server/shiny-server.conf
	whoami
	groups
	getent group
fi
# debug output | END
/usr/bin/shiny-server
