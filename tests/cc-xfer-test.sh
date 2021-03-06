#!/bin/bash

backf=`mktemp`
rm $backf
cd $CLOUD_CLIENT_HOME
./bin/grid-proxy-init.sh
./bin/cloud-client.sh --transfer --sourcefile $NIMBUS_SOURCE_TEST_IMAGE
if [ $? -ne 0 ]; then
    rm $backf
    echo "upload failed"
    exit 1
fi
./bin/cloud-client.sh --download --name $NIMBUS_TEST_IMAGE --localfile $backf
if [ $? -ne 0 ]; then
    rm $backf
    echo "download failed"
    exit 1
fi

diff $backf $NIMBUS_SOURCE_TEST_IMAGE
if [ $? -ne 0 ]; then
    rm $backf
    echo "diff failed, file corrupted in transfer"
    exit 1
fi

./bin/cloud-client.sh --delete --name $NIMBUS_TEST_IMAGE --localfile $backf
rm $backf
exit 0

