#!/bin/bash
# Listen on a port, provide a 204 repose, print the entire request to stdout
# This works on mac, prob not on linux bc variations of netcat (nc)
PORT=3030
if [ ! -z "$1" ]
then
    PORT="$1"
fi
while { echo -e "HTTP/1.1 204 No Content\r\nContent-Length: 0\r\n\r\n" | nc -l -w 5 0.0.0.0 $PORT; }; do :; done
