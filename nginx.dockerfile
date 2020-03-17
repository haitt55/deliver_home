FROM nginx:1.13-alpine

ADD ./vhost.conf /etc/nginx/conf.d/default.conf

COPY ./public /var/www/public
