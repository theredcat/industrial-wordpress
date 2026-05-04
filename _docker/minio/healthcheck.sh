#!/bin/bash
set -e
for i in ${BUCKET_TO_CREATE//,/ }
do
  mc ls local/"${i}"/healthcheckfile | grep healthcheckfile || exit 1
done
exit 0
