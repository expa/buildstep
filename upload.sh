#/bin/bash
read -s -n 1 -p "Are you sure you want to upload a new buildstep image? [yn] " confirm
echo ""
[[ "$confirm" = "y" ]] || exit 0

[[ -e '/root/.awsrc' ]] && source /root/.awsrc || echo "no awsrc found. upload may fail."

[[ -f /tmp/tgz ]] && rm /tmp/tgz
ID=$(docker run -d progrium/buildstep /bin/sh)
SHORTID=${ID:0:10}
if [ -e '/build/stack/.scipy' ];then
  DESTINATION=s3://expa-dokku/expa_scipy_buildstep_${SHORTID}.tgz
else
  DESTINATION=s3://expa-dokku/expa_buildstep_${SHORTID}.tgz
fi

echo "exporting $ID"
docker export $ID | gzip -9c > /tmp/tgz || exit 1

echo "uploading to $DESTINATION"
aws s3 cp /tmp/tgz $DESTINATION --acl public-read
