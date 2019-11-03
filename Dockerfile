FROM rocker/shiny

ADD app /srv/shiny-server/

RUN install2.r --error \
    jsonlite 

EXPOSE 3838

CMD ["/usr/bin/shiny-server.sh"]