FROM rocker/shiny

COPY *.R .mapbox  /tmp/

ENV user shiny

RUN mkdir /srv/shiny-server/mapdecktest \
    && cp /tmp/app.R /srv/shiny-server/mapdecktest/app.R \
    && cp /tmp/.mapbox /home/shiny/.mapbox

RUN Rscript /tmp/install_packages.R \
