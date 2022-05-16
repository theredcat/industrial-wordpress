FROM nginx:latest

RUN apt-get update && apt-get install -y wget curl unzip

RUN rm -f /etc/nginx/conf.d/default.conf
RUN mkdir /etc/nginx/ssl && \
	cd /etc/nginx/ssl && \
	wget https://get.localhost.direct/localhost.direct.zip && \
	unzip -P localhost localhost.direct.zip && \
	rm localhost.direct.zip
ADD ./app.conf /etc/nginx/conf.d/app.conf
