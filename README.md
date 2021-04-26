[![Build Status](https://travis-ci.com/iGOEGGO/diplomprojekt.svg?token=sHpQspLqymz32HoPUpxz&branch=master)](https://travis-ci.com/iGOEGGO/diplomprojekt)
<!--[![CircleCI](https://circleci.com/gh/iGOEGGO/diplomprojekt.svg?style=svg&circle-token=18fc40d226ea9298fae8cc29e037758c09e71c1e)](https://app.circleci.com/pipelines/github/iGOEGGO/diplomprojekt)-->



**Heroku**

[![Heroku App Status](http://heroku-shields.herokuapp.com/igoeggo)](https://igoeggo.herokuapp.com) 

<!--

[//]: # "Boottime: ~ 3 min."
-->

# igoeggo

## Umsetzung 

### Deployment
Alles zum Thema Deployment kann [hier](https://igoeggo.github.io/#/./tutorials/deployment/index) nachgelesen werden 

## ToDo

### Skalierung

Es ist angedacht, dass die Skalierung unserer Applikation unter der Verwendung von Docker Swarm mittels Traefik und shinyproxy erfolgt. 

### Testing 

Das Testing unserer Applikation sowie den dahinterliegenden Funktionen erfolgt sowohl mit der Möglichkeit, die R mittels `testthat` zur Verfügung stellt also auch mit cypress.io in weiterer Folge.

Ausführen der cypress-Testcases: 
```shell
npm install cypress --save-dev
# ./node_modules/.bin/cypress run
./node_modules/.bin/cypress run --config baseUrl="<URL-of-Server>"
```

## Team

Teammitglieder

@jborensky-tgm, @tdegold-tgm, @chaslinger-tgm, @dzimmermann-tgm
