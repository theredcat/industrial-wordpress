FROM debian:13

USER root

RUN  apt-get update \
  && apt-get install -y curl \
  && rm -rf /var/lib/apt/lists/*

# Install minio server
RUN curl -fsSL https://dl.min.io/server/minio/release/linux-$(dpkg --print-architecture)/minio > /usr/local/bin/minio && \
    chmod +x /usr/local/bin/minio

# Install minio client
RUN curl -fsSL https://dl.min.io/client/mc/release/linux-$(dpkg --print-architecture)/mc > /usr/local/bin/mc && \
    chmod +x /usr/local/bin/mc

# Create data directory
RUN mkdir /data

# Copy starting script
COPY startup_script.sh /usr/local/bin/startup_script.sh

# Copy healthcheck and healtcheck file
COPY healthcheck.sh /usr/local/bin/healthcheck.sh
RUN touch /tmp/healthcheckfile

RUN chmod +x /usr/local/bin/startup_script.sh /usr/local/bin/healthcheck.sh

EXPOSE 9000
EXPOSE 9001

HEALTHCHECK --interval=5s --timeout=20s --retries=1 CMD healthcheck-entrypoint.sh healthcheck.sh

CMD ["startup_script.sh"]
