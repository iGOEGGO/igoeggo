FROM rocker/shiny-verse:4.0.1

COPY ./requirements.R /srv/shiny-server
COPY ./installdipl.R /srv/shiny-server
COPY iGOEGGO_r_shiny/ /srv/shiny-server
COPY ./shiny-customized.config /etc/shiny-server/shiny-server.conf
COPY ./template.db /srv/shiny-server/database/database.db
RUN chmod -R a+rw /srv/shiny-server/database/
COPY docker-entrypoint.sh .

RUN R -e "source('/srv/shiny-server/requirements.R')"
RUN R -e "source('/srv/shiny-server/installdipl.R')"

ENTRYPOINT ["./docker-entrypoint.sh"]
