#!/bin/bash

set -e -u 

# Determine IP to connect to by looking at
# the SSH_CLIENT environment variable
# 
# If not set, quits with error
function HOST_IP {
  echo $SSH_CLIENT | awk '{print $1;}'
}

# Send given command via netcat
# 
function SEND_COMMAND {
  local COMMAND=$1

  echo "$COMMAND" | nc $(HOST_IP) 5115 -q 0 -w 1
}

