#/bin/bash
[[ -f /tmp/tgz ]] && rm /tmp/tgz
ID=$(docker run -d progrium/buildstep /bin/sh)
SHORTID=${ID:0:10}
DESTINATION=s3://expa-dokku/expa_scipy_buildstep_${SHORTID}.tgz

echo "exporting $ID"
docker export $ID | gzip -9c > /tmp/tgz || exit 1

echo "uploading to $DESTINATION"
aws s3 cp /tmp/tgz $DESTINATION --acl public-read
