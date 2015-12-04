
# Send given command via netcat
# 
wormhole_send_command() {
  if [ -z "$SSH_CLIENT" ]; then
    echo "No SSH_CLIENT environment variable found. Cannot send wormhole command.";
    return 1;
  fi

  REMOTEIP=$(awk '{print $1;}' <<< $SSH_CLIENT)
  echo "$@" | nc $REMOTEIP 5115 -q 0 -w 1
}

expl() {
  if [ $# -eq 0 ]; then
    echo "expl <path>";
    return 1;
  fi

  PAYLOAD=$(realpath "$@")
  wormhole_send_command "EXPLORE $PAYLOAD"
}

start() {
  if [ $# -eq 0 ]; then
    echo "start <path>";
    return 1;
  fi

  PAYLOAD=$(realpath "$@")
  wormhole_send_command "START $PAYLOAD"
}

term() {
  if [ $# -eq 0 ]; then
    echo "term <path>";
    return 1;
  fi

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