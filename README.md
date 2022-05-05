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


## [BigBlueButton Tech Support](https://higheredlab.com/bigbluebutton-support/)
### Are you facing difficulties with your BigBlueButton server?
Lean on our expertise to smoothly run your BigBlueButton server. We can: 
1. troubleshoot your BigBlueButton servers to improve audio and video performance,
1. install additional features such as streaming, mp4 recordings and attendance, and
1. provide managed BigBlueButton servers, starting at $12 per month

[Click here to learn more](https://higheredlab.com/bigbluebutton-support/)


## More on BigBlueButton

Check-out the following apps to further extend features of BBB.

### [bbb-jamboard](https://github.com/manishkatyan/bbb-jamboard)

The default whiteboard of BigBlueButton has limited features including no eraser. Many teachers wish to have a more features-rich whiteboard that would help them better in conducting online classes.

With BBB-Jamboard, you can easily integrate Google Jamboard into your BigBlueButton server.

Jamboard is a digital interactive whiteboard developed by Google and can be used in stead of the default BugBlueButton whiteboard. Google Jamboard has the eraser feature that has often been requested by BigBlueButton users.



### [bbb-twilio](https://github.com/manishkatyan/bbb-twilio)

Integrate Twilio into BigBlueButton so that users can join a meeting with a dial-in number. You can get local numbers for almost all the countries.

### [bbb-mp4](https://github.com/manishkatyan/bbb-mp4)

With this app, you can convert a BigBlueButton recording into MP4 video and upload to S3. You can covert multiple MP4 videos in parallel or automate the conversion process.

### [bbb-streaming](https://github.com/manishkatyan/bbb-streaming)

Livestream your BigBlueButton classes on Youtube or Facebook to thousands of your users.

### [bbb-optimize](https://github.com/manishkatyan/bbb-customize)

Better audio quality, increase recording processing speed, dynamic video profile, pagination, fix 1007/1020 errors and use apply-config.sh to manage your customizations are some key techniques for you to optimize and smoothly run your BigBlueButton servers.

### [bbb-admin](https://github.com/manishkatyan/bbb-admin)

Scripts for BigBlueButton admins including extracting IP of users joining, participants attendance, poll answers and many other analytics. 

### [100 Most Googled Questions on BigBlueButton](https://higheredlab.com/bigbluebutton-guide/)

Everything you need to know about BigBlueButton including pricing, comparison with Zoom, Moodle integrations, scaling, and dozens of troubleshooting.
