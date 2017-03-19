FROM nginx:latest

RUN apt-get update && apt-get install -y wget curl python python-yaml

RUN rm -f /etc/nginx/conf.d/default.conf
ADD ./app.conf /etc/nginx/conf.d/app.conf

RUN wget -O /wait-for-it.sh https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh
RUN chmod +x /wait-for-it.sh

COPY ./install_wp.py /

COPY ./run.sh /
RUN chmod +x /run.sh
CMD ["/run.sh"]
