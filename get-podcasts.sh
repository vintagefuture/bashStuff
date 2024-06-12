#!/bin/sh

RSS_FEED_URL='https://www.spreaker.com/show/5773405/episodes/feed'

PODCAST_NAME="Il Mondo"

message="<!here> New episode of ${PODCAST_NAME} is available" 

slack_webhook_url=""

slack_channel="server-notifications"

cd /home/nedo/podcasts

rm -f ${PODCAST_NAME}.mp3

wget -q -O "${PODCAST_NAME}.mp3" $(wget -q -O - $RSS_FEED_URL | grep -Eo '<enclosure url="([^"]+)"' | awk -F'"' '{print $2}' | head -1)

echo "[$(date +%Y-%m-%d\ %H:%M:%S)] ${PODCAST_NAME}: download completed"

curl -X POST -H 'Content-type: application/json' \
    --data "{\"text\": \"${message}\", \"channel\": \"${slack_channel}\"}" \
    $slack_webhook_url >/dev/null 2>&1
