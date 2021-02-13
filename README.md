# bbb-recording-server

With this app, you can process BigBlueButton recordings on a separate server, called BBB Recording Server. Separation of recordings from BigBlueButton (client) improves performance as all server resources are dedicated towards conducting live classes.

BBB Recording Server runs a BigBlueButton server that is used only for recording processing. 

BBB Recording Clients are regular BigBlueButton servers where classes are conducted. 

# How to use
On BigBlueButton Recording server
1. Clone the repository: https://github.com/manishkatyan/bbb-recording-server
2. Setup Supervisor
```sh
apt-get install supervisor
apt-get install inotify-tools
service supervisor restart
cp watch_recording_server.conf /etc/supervisor/conf.d/
supervisorctl reread
supervisorctl update
```
3. Increate number of recording processes as [detailed here](https://github.com/manishkatyan/bbb-optimize#process-multiple-recordings). 


On each BigBlueButton Recording client:
1. Setup password-less SSH from BBB Recording client to BBB Recording server
2. Copy files in bbb-recording-client to BBB Recording client's `/usr/local/bigbluebutton/core/scripts/post_archive` directory and make `bbb_recording_client_post_archive.sh` executable.
