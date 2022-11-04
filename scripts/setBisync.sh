#!/bin/bash

HELPMSG="./setBisync.sh '/local/target/path/' 'rclone:/remote/path/' [1~60] # mins, default 30 mins"

if [[ $# -lt 2 || $# -gt 3 ]]; then
    echo $HELPMSG
    exit 1
else
    # echo $#
    LOCALPATH=$1
    REMOTEPATH=$2
    INTERVAL=${3:-30}
fi

mkdir -p $LOCALPATH
if [[ ! -d $1 ]]; then
    echo $HELPMSG "ERROR localpath"
    exit 1
fi

sizeMsg=$(rclone size $2)
if [ sizeMsg == *"Fail"* ]; then
    echo $HELPMSG "ERROR remotepath"
    exit 1
fi

if [[ $3 -lt 1 || $3 -gt 59 ]]; then
    echo $HELPMSG "ERROR interval"
    exit 1
fi

# make sure rclone latest installed and remote drive is properly set before running

echo "sync remote to local for the first time"
rclone sync $REMOTEPATH $LOCALPATH -v
rclone bisync $LOCALPATH $REMOTEPATH --resync -v

CRONJOB="*/$INTERVAL * * * * rclone bisync $LOCALPATH $REMOTEPATH >> ~/rclone-logseq-bisync.log 2>&1 "
echo "setting cron job: $CRONJOB"
# create cron rclone bisync job
crontab -l > mycron
echo "$CRONJOB" >> mycron
crontab mycron
rm mycron
