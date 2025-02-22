#!/bin/bash

# Configure which ports to listen on here
PORTS=(3031 3032 3033)

# Function to handle CTRL+C
cleanup() {
    echo -e "\nShutting down listeners..."
    kill "${pids[@]}" 2>/dev/null
    exit 0
}

trap cleanup SIGINT

# Start listeners for each port in the background
pids=()
for PORT in "${PORTS[@]}"; do
    while { echo -e "HTTP/1.1 204 No Content\r\nContent-Length: 0\r\n\r\n" | nc -l -w 5 0.0.0.0 "$PORT"; }; do :; done &
    pids+=($!)
    echo "Started listener on port $PORT (PID: $!)"
done

# Wait for any process to finish (which shouldn't happen unless there's an error)
# or until we receive SIGINT (CTRL+C)
wait
