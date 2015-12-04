# Determine IP to connect to by looking at
# the SSH_CLIENT environment variable
# 
# If not set, quits with error
wormhole_host_ip() {
  echo $SSH_CLIENT | awk '{print $1;}'
}

# Send given command via netcat
# 
wormhole_send_command() {
  echo "$@" | nc $(HOST_IP) 5115 -q 0 -w 1
}

expl() {
  PAYLOAD=$(realpath "$@")
  wormhole_send_command "EXPLORE $PAYLOAD"
}

start() {
  PAYLOAD=$(realpath "$@")
  wormhole_send_command "START $PAYLOAD"
}

term() {
  PAYLOAD=$(realpath "$@")
  wormhole_send_command "SHELL $PAYLOAD"
}

s() {
  PAYLOAD=()
  for f in "$@"; do

    # If argument start with "-", treat is as option and keep unchanged
    if [ '-' = ${f:0:1} ]; then
      PAYLOAD+="$f"
      continue;
    fi

    if [ -r "$f" ]; then
      PAYLOAD+=($(realpath "$f"))
    elif [ -d $(dirname "$f") ]; then
      DIR=$(realpath $(dirname "$f"))
      PAYLOAD+=($DIR/$(basename "$f"))
    else
      PAYLOAD+=($(realpath "$f"))
    fi
  done

  wormhole_send_command "EDIT ${PAYLOAD[@]}" 
}

# Publicly export functions
export -f expl start term s