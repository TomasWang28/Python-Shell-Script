#/bin/bash
SOURCE_DIR=/var/lib/jenkins/workspace/${JOB_NAME}
DEST_DIR=/usr/local/tomcat/webapps
REMOTE_IP=192.168.65.82
/usr/bin/rsync -avpgolr --delete-before $SOURCE_DIR $REMOTE_IP:$DEST_DIR