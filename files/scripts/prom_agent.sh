#!/bin/bash
z=$(ps aux)
while read -r z
do
   var=$var$(awk '{print "cpu_usage{process=\""$11"\", pid=\""$2"\"}", $3z}');
done <<< "$z"
curl -X POST -H  "Content-Type: text/plain" --data "$var" http://192.168.11.14:9091/metrics/job/top/instance/machine