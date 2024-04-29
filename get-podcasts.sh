#!/bin/sh

RSS_FEED_URL='https://www.spreaker.com/show/5773405/episodes/feed'

message="<!here> New episode of Il mondo is available" 

slack_webhook_url=""

slack_channel="server-notifications"

cd /home/nedo/podcasts

rm -f ilmondo.mp3

wget -q -O ilmondo_48k.mp3 $(wget -q -O - $RSS_FEED_URL | grep -Eo '<enclosure url="([^"]+)"' | awk -F'"' '{print $2}' | head -1)

sox ilmondo_48k.mp3 -r 44100 ilmondo.mp3

rm ilmondo_48k.mp3

echo "[$(date +%Y-%m-%d\ %H:%M:%S)] download completed"

curl -X POST -H 'Content-type: application/json' \
    --data "{\"text\": \"${message}\", \"channel\": \"${slack_channel}\"}" \
    $slack_webhook_url >/dev/null 2>&1
