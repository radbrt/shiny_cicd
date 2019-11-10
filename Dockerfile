FROM rocker/shiny

ADD app /srv/shiny-server/

RUN install2.r --error \
    jsonlite \
    dplyr \
    ggplot2

EXPOSE 3838

CMD ["/usr/bin/shiny-server.sh"]