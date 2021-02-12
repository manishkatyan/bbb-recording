#!/bin/bash

DIRECTORY_TO_OBSERVE="/var/www/bbb-recording-server/recording-raw/"
DIRECTORT_FOR_RECORDING="/var/bigbluebutton/recording/raw/"

watch() {

  inotifywait -m -r -e create -e moved_to $DIRECTORY_TO_OBSERVE | while read path action file;do

    if [[ "$file" =~ .*gz$ ]]; then # Does the file end with .gz?
      echo "Change detected date $(date) in ${path} action ${action} in file ${file}" | systemd-cat -p debug -t bbb-cluster
      process_recording "${file}"      
    fi

  done

}

process_recording() {
    echo "Uncompressing $1" | systemd-cat -p debug -t bbb-cluster
    mv "$DIRECTORY_TO_OBSERVE$1" "$DIRECTORT_FOR_RECORDING"
    cd "$DIRECTORT_FOR_RECORDING" && tar -xf "$1"

    meeting_id="${1%%.*}"
    echo "Rebuilding $meeting_id"
    bbb-record --rebuild "$meeting_id"
}

# This script is called by the supervisor.
watch
#process_recording $1
