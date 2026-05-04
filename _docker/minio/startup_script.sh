#!/bin/bash
set -e

cwd="$(pwd -P)"

mkdir -p /etc/certs/minio
cd /etc/certs/minio
wget https://aka.re/localhost -O certs.zip
unzip -P IWillNotPutKeyFileInPublicAccessiblePlace.X1YKK certs.zip
mv localhost.direct.OP.crt public.crt
mv localhost.direct.OP.key private.key

minio server /data --console-address ":9001" --certs-dir /etc/minio/certs &
MINIO_PID=$!
until $(curl --output /dev/null --silent --head http://localhost:9001); do
    sleep 1
done

mc alias set local --api s3v4 http://localhost:9000 ${MINIO_ROOT_USER} ${MINIO_ROOT_PASSWORD}
for i in ${BUCKET_TO_CREATE//,/ }
do
  mc mb --ignore-existing local/"${i}"
  mc cp /tmp/healthcheckfile local/"${i}"
done

mc admin user add local ${MINIO_USER_ACCOUNT} ${MINIO_USER_PASSWORD}
mc admin user enable local ${MINIO_USER_ACCOUNT}
if [ "$(mc admin policy entities local --json -u ${MINIO_USER_ACCOUNT} | jq 'try .result.userMappings[0].policies catch [] | any(. == "readwrite")')" = false ]; then
    mc admin policy attach local readwrite --user ${MINIO_USER_ACCOUNT}
fi

while test -d /proc/$MINIO_PID; do
  sleep 1;
done
