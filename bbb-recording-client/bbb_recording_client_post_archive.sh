#!/bin/bash

meeting_id=$1

recording_dir="/var/bigbluebutton/recording/raw/"

if [ -d "$recording_dir$meeting_id" ]
then
  echo "Got archieve: $meeting_id" |  systemd-cat -p debug -t bbb-cluster
  tar -zcf "$meeting_id.tar.gz" -C "$recording_dir" "$meeting_id"

  echo "Pushing archive: $meeting_id" | systemd-cat -p debug -t bbb-cluster
  rsync --remove-source-files -e "ssh -i /root/.ssh/.ssh_key"  "$meeting_id.tar.gz" root@148.251.131.28:/var/www/bbb-cluster/recording-raw/

else
  echo "No archieve" | systemd-cat -p debug -t bbb-cluster
fi
