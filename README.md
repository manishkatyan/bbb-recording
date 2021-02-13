# bbb-recording-server

With this app, you can process BigBlueButton recordings on a separate server, called BBB Recording Server. Separation of recordings from BigBlueButton (client) improves performance as all server resources are dedicated towards conducting live classes.

BBB Recording Server runs a BigBlueButton server that is used only for recording processing. 

BBB Recording Clients are regular BigBlueButton servers where classes are conducted. 

## How it works
After a class ends, a BigBlueButton server runs a three stage process (archive, process and publish) to create recording of the class. During process stage, it runs 'ffmpeg' to process audio and video, which takes significant amount of server resources. 

Hence, processing recording impacts performance of on-going live classes. 

One way, to fix it, is to schedule recording processing after classes as [detailed here](https://github.com/manishkatyan/bbb-optimize#change-processing-interval-for-recordings)

However, recording publishing gets delayed when you schedule recording prcoessing after classes.

Hence, in this project, we setup a separate BigBlueButton server (BBB Recording server) that only processes recordings. All client BigBlueButtons (BBB Recording client) will rsync raw recordings to BBB Recording server.

In its default installation, BigBlueButton runs a single recording process. On BBB Recording server we can increase number of recording processes to up to 10, as detaield below. 

This project also makes BBB Recording clients stateless, which means you can shut off BBB clients in AWS to lower your hosting costs. 

## How to use
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
3. Increase number of recording processes as [detailed here](https://github.com/manishkatyan/bbb-optimize#process-multiple-recordings). 


On each BigBlueButton Recording client:
1. Setup password-less SSH from BBB Recording client to BBB Recording server as [detailed here](https://linuxize.com/post/how-to-setup-passwordless-ssh-login/). 
2. Copy files in bbb-recording-client to BBB Recording client's `/usr/local/bigbluebutton/core/scripts/post_archive` directory and make `bbb_recording_client_post_archive.sh` executable.
3. Set appropriate configuration parameters in `bbb_recording_client_post_archive.sh`:
- bbb_recording_server_ip: IP of BBB Recording server
- bbb_recording_server_user: Username for which you have setup password-less SSH on BBB Recording server
- bbb_recording_server_path: Path where `bbb-recording-server` is installed on BBB Recording server
- bbb_recording_client_ssh_private_key: filename of SSH private key on BBB Recording client. SSH private key is used for password-less SSH login to BBB Recording server

4. Once you have setup BBB Recording server and client, following above steps, you are all set. As classes get completed on BBB Recording clinets, recordings would be rsync to BBB Recording server, who, in turn, would process and publish recordings.

5. Optionally, you can also enable BBB Recording server to convert recordings into MP4 as [detailed here](https://github.com/manishkatyan/bbb-mp4)
