#!/bin/bash

apt update
apt -y install at zenity
curl -Lo - https://github.com/skydive-project/skydive-binaries/raw/jenkins-builds/skydive-latest.gz | gzip -d > skydive && chmod +x skydive && sudo mv skydive /usr/local/bin/
cp SkydiveCtrl /usr/local/bin
chmod +x /usr/local/bin/SkydiveCtrl