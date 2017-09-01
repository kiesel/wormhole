# Send given command via netcat
#
wormhole_send_command() {
  RESPONSE=$(echo "$@" | netcat 127.0.0.1 5115 -w 1)

  # if [ "[OK] " != "${RESPONSE:0:5}" ]; then
  echo $RESPONSE
  # fi
}

expl() {
  wh explore $@
}

start() {
  wh start $@
}

term() {
  wh shell $@
}

wh() {
  SUBCMD=$1
  shift

  PAYLOAD=""
  if [ $# -gt 0 ]; then
    PAYLOAD=$(realpath "$@")
  fi

  case $SUBCMD in
    version | reload | exit)
      wormhole_send_command "$SUBCMD"
      ;;

    *)
      wormhole_send_command "invoke $SUBCMD $PAYLOAD"
      ;;

  esac
}

wormhole_send_pathargs_command() {
  CMD=$1
  shift

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

  wormhole_send_command "invoke ${CMD} ${PAYLOAD[@]}"
}

s() {
  wormhole_send_pathargs_command sublime "$@"
}

code() {
  wormhole_send_pathargs_command code "$@"
}

# Publicly export functions
export -f wh expl start term s code >/dev/null
