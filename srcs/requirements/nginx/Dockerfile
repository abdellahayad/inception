FROM debian:bullseye

RUN apt-get update && apt-get upgrade && apt-get install nginx openssl

COPY conf/nginx.conf /etc/nginx/sites-available/default
