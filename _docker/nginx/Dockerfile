FROM nginx:latest

RUN apt-get update && apt-get install -y wget curl unzip

RUN rm -f /etc/nginx/conf.d/default.conf
RUN mkdir /etc/nginx/ssl && \
	cd /etc/nginx/ssl && \
	wget https://get.localhost.direct/localhost.direct.OP.zip && \
	unzip -P IWillNotPutKeyFileInPublicAccessiblePlace.X1YKK localhost.direct.OP.zip && \
	rm localhost.direct.OP.zip && \
	mv localhost.direct.OP.crt localhost.direct.crt && \
	mv localhost.direct.OP.key localhost.direct.key
ADD ./app.conf /etc/nginx/conf.d/app.conf
