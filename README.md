# Raspy-Plexamp-Bluetooth

This is a walkthrough regarding how to install Plexamp on a Raspberry Pi 5 with Bluetooth support, with some personal notes on how to auto-connect a Bluetooth speaker, user a user-space services, and transform the Raspberry to a speaker/sink for Plex using Plexamp.

## Operative system

This guide assumes that you are using Raspbian OS, latest version.


## Install node

Plexamp is a NodeJS application. First, install NodeJS.

```bash
export NODE_MAJOR=20

sudo apt-get install -y ca-certificates curl gnupg && sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg

echo deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main | sudo tee /etc/apt/sources.list.d/nodesource.list

sudo chmod a+r /etc/apt/keyrings/nodesource.gpg

sudo apt-get update && sudo apt-get install -y nodejs

node -v 
```
## Install Plexamp Headless

```bash
export PLEXAMP_VERSION=v4.12.4

curl https://plexamp.plex.tv/headless/Plexamp-Linux-headless-$PLEXAMP_VERSION.tar.bz2 -o plexamp.$PLEXAMP_VERSION.tar.bz2

tar -xzvf plexamp.$PLEXAMP_VERSION.tar.bz2 ~/plexamp

node plexamp/js/index.js
```

At this point, claim the device with Plex, instructions should be on screen.

Install the service as a user-space service, because we need to access audio devices.

```bash
sudo cp plexamp/plexamp.service /etc/systemd/user/
systemctl --user enable plexamp.service 
systemctl --user daemon-reload
systemctl --user start plexamp.service 
```

## Setup Bluetooth audio (optional)

Frist of all, find the Bluetooth Mac Address of your Speaker device.

Then, install pulseaudio with bleutooth module.

```bash
sudo apt install pulseaudio pulseaudio-module-bluetooth
```

Edit the `/etc/bluetooth/main.conf` file and set these options:

```
[General]
DiscoverableTimeout = 0

[Policy]
AutoEnable=true
```

This will make the Raspberry discoverable.

Restart the service.

```bash
sudo systemctl restart bluetooth.service
```

Use the `bluetoothctl` utility to trust your Bluetooth device. This will permit to auto-connect to it.

Then create an autostart service that will connect automatically to the Bluetooth device when the system boots.

```bash
mkdir -p ~/bin ~/.config/autostart/
cp bluetooth/btautoconnect.sh ~/bin/btautoconnect.sh
cp bluetooth ~/.config/autostart/btautoconnect.desktop
chmod +x ~/bin/btautoconnect.sh 
```


## Extra

For a more generic (and better) solution see this repository: https://github.com/odinb/bash-plexamp-installer
