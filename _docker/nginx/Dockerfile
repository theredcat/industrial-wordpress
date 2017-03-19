FROM nginx:latest

RUN apt-get update && apt-get install -y wget curl

RUN rm -f /etc/nginx/conf.d/default.conf
ADD ./app.conf /etc/nginx/conf.d/app.conf
