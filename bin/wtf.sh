#!/bin/sh
sudo netstat -ntu | awk '{print }' | grep -e ^[0-9] | cut -d: -f1 | sort | uniq -c | sort -n
