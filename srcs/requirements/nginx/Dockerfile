FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y && apt-get install -y nginx openssl \
    && rm -rf /var/lib/apt/lists/*

COPY conf/nginx.conf /etc/nginx/sites-available/default

COPY tools/nginx.sh /usr/bin/nginx.sh
RUN chmod +x /usr/bin/nginx.sh

EXPOSE 443

ENTRYPOINT [ "/usr/bin/nginx.sh" ]

CMD [ "nginx", "-g", "daemon off;" ]