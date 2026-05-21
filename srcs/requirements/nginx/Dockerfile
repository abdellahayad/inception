FROM debian:bullseye

RUN apt-get update && apt-get upgrade && apt-get install nginx openssl

COPY conf/nginx.conf /etc/nginx/sites-available/default

COPY  tools/nginx.sh /usr/bin/nginx.sh

RUN chmod +x /usr/bin/nginx.sh

EXPOSE 443


ENTRYPOINT [ "nginx.sh" ]

