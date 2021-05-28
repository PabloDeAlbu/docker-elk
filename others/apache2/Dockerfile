FROM httpd:latest

RUN apt update && apt install nano less
COPY httpd.conf /usr/local/apache2/conf/httpd.conf
#RUN sed -i "/CustomLog \"logs/access_log\" combined/s/^#//g" /usr/local/apache2/conf/httpd.conf
