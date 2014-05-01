#/bin/bash
ID=$(docker run -d progrium/buildstep /bin/sh)
SHORTID=${ID:0:10}
docker export $ID | gzip -9c > /tmp/tgz
s3cmd put /tmp/tgz s3://expa-dokku/expa_buildstep_${SHORTID}.tgz
s3cmd setacl -P s3://expa-dokku/expa_buildstep_${SHORTID}.tgz