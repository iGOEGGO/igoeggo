# R-Shiny Server mit Docker

**[HIER](https://github.com/iGOEGGO/diplomprojekt/blob/master/README.md) geht es zurück zum Haupt-README**

Die Skripts in diesem Ordner dienen dem Deployment des iGÖGGO. Im Folgenden finden Sie eine kurze Zusammenfassung jeder Datei und ihrer Funktion. Für eine genaue Erläuterung der Funktionsweise sehen sie bitte auf unserer offiziellen Seite nach. Diese ist [hier](https://igoeggo.github.io/#/./tutorials/deployment/index) zu finden.

## Dateien und ihre Funktion

Änderungen an diesen Dateien sollten mit Vorsicht vorgenommen werden, von jenen die wissen, was sie tun.

| Datei/Verzeichnis          | Beschreibung                                                 |
| -------------------------- | ------------------------------------------------------------ |
| `application.yaml`         | Konfigurationsparameter für ShinyProxy                       |
| `build.sh <port>`          | buildet das Dockerimage neu, setzt den Port des iGÖGGO auf \<port\> |
| `deploylocalproxy.sh`      | startet den iGÖGGO mit ShinyProxy, welcher im Browser auf Port `8080` zu erreichen ist |
| `deploylocal.sh <port>`    | startet den iGÖGGO standalone (nur ein Container), er ist im Browser unter dem gegebenen Port zu erreichen |
| `deploy.sh`                | pusht den iGÖGGO auf der Plattform Heroku (Sie müssen eventuell eine eigene Heroku-Applikation erstellen, mehr dazu [hier](https://igoeggo.github.io/#/./tutorials/deployment/index?id=cloud-deployment-mit-heroku)) |
| `Dockerfile`               | das Dockerfile für den iGÖGGO, kann mit `build.sh` gebuildet werden |
| `installdipl.R`            | die Installationsanleitungen für die benötigten R-Pakete     |
| `requirements.R`           | die Installationsanleitungen für das eigens entwickelte [ETL-Paket](https://github.com/iGOEGGO/dipl) |
| `reset.sh`                 | setzt die Bookmark-Datenbank und die Bookmarks selbst zurück (**Wichtig**: führen Sie diese Datei vor dem ersten Starten des iGÖGGO aus) |
| `shiny-customized.config`  | die Konfigurationsparameter für den R-Shiny-Server welcher im Container läuft |
| `shinyproxy-<version>.jar` | wird über `deploylocalproxy.sh` ausgeführt, startet ShinyProxy (**Achtung:** diese Datei ist nicht von Haus aus vorhanden, sondern wird initial von `deploylocalproxy.sh` heruntergeladen) |
| `docker-entrypoint.sh`                 | wird über das Dockerfile im Container gespeichert und enthält die Startanweisungen für den ShinyServer |
| `template.db`              | eine Muster-Datenbank für Bookmarks, welche von `reset.sh` für das (Re)Initialisieren verwendet wird |