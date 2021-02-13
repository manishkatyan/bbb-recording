#!/bin/bash

meeting_id=$1

bbb_recording_server_user=root
bbb_recording_server_ip=148.251.131.28
bbb_recording_server_path="/var/www/bbb-recording-server/recording-from-clients/"
bbb_recording_client_ssh_private_key="/root/.ssh/.ssh_key"

recording_dir="/var/bigbluebutton/recording/raw/"

if [ -d "$recording_dir$meeting_id" ]
then
  echo "Got archieve: $meeting_id" |  systemd-cat -p debug -t bbb-recording-client
  tar -zcf "$meeting_id.tar.gz" -C "$recording_dir" "$meeting_id"

  echo "Pushing archive: $meeting_id" | systemd-cat -p debug -t bbb-recording-client  rsync --remove-source-files -e "ssh -i bbb_recording_client_ssh_private_key"  "$meeting_id.tar.gz" "$bbb_recording_server_user@bbb_recording_server_ip:$bbb_recording_server_path"

else
  echo "No archieve" | systemd-cat -p debug -t bbb-recording-client
fi
