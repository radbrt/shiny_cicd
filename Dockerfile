FROM rocker/shiny

ADD app /srv/shiny-server/

EXPOSE 3838

CMD ["/usr/bin/shiny-server.sh"]