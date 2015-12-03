#!/bin/bash
set -e 
set -u 

PIDFILE="/var/run/net-invoke.pid"
LOCK_FD=9 # arbitrary file descriptor

## Translation settings
# BASE - translate this:
BASE=${WORMHOLE_REMOTE:-"/home/$USER/"}

# TRNS - ... to that.
TRNS=${WORMHOLE_LOCAL:-"A:/"}

PORT=${WORMHOLE_PORT:-5115}

## NET_ - settings for external programs...
NET_VISUAL=${WORMHOLE_EDITOR:-'/cygdrive/c/Program Files/Sublime Text 3/sublime_text.exe'}
NET_TERM=${WORMHOLE_TERMINAL:-mintty}

lock() {
  local LOCKFILE=$1
  local FD=${2:-$LOCK_FD}

  # Create lockfile
  eval "exec ${FD}>${LOCKFILE}"

  # Acquire lock
  flock -n $FD || return 1

  trap "rm -f -- '${PIDFILE}'; echo; echo '> Caught SIGINT, exiting.' >&2" EXIT
  echo $$ >> ${LOCKFILE}

  return 0
}

eexit() {
  local msg="$@"

  echo $msg >&2
  exit 1
}

print_configuration() {
  echo "===> Wormhole startup options"

  echo "Remote base:    ${BASE}"
  echo "Local base:     ${TRNS}"
  echo "Local port:     ${PORT}"
  echo "Local editor:   ${NET_VISUAL}"
  echo "Local terminal: ${NET_TERM}"
  echo
}

main_loop() {
  while [ true ]; do
    echo -n "Listening @ "; date;

    (nc -p ${PORT} -l 127.0.0.1 || nc -l 127.0.0.1 ${PORT}) 2>/dev/null | while read -r -a 'RARG' ; do
      echo -n "<<< @ "; date;
      echo "<<< ${RARG[*]}"

      process_command $RARG
    done
  done
}

process_command() {
  local ARGS="$1"

  COMMAND=${ARGS[0]}
  unset ARGS[0]

  if [ ${#ARGS[@]} -lt 1 ]; then
    echo "You need to give at least one argument to a command...";
    continue;
  fi

  # Now translate to local filesystem path ...
  FILES=()
  for FILE in "${ARGS[@]}"; do

    FILES+=($(echo "$FILE" | sed -r "s|$BASE|$TRNS|g"));
  done

  case $COMMAND in
    EDIT)

      # Invoke editor
      echo "EDIT > ${FILES[@]}"
      "$NET_VISUAL" "${FILES[@]}" &
      ;;

    SHELL)
      LOCATION="${FILES[0]}"
      if [ ! -d "$LOCATION" ]; then
        echo "Not a directory: $LOCATION";
        continue;
      fi

      echo "SHELL > ${FILES[0]}"
      cd $LOCATION && $NET_TERM &
      ;;

    EXPLORE)
      LOCATION="${FILES[0]}"
      if [ ! -d "$LOCATION" ]; then
        echo "Not a directory: $LOCATION";
        continue;
      fi

      echo "EXPLORER > $LOCATION"
      cygstart $LOCATION &
      ;;

    START)
      LOCATION="${FILES[0]}"
      if [ ! -r "$LOCATION" ]; then
        echo "Not a file: $LOCATION";
        continue;
      fi

      echo "START > $LOCATION"
      cygstart $LOCATION &
      ;;

    *)
      echo "Unknown command $COMMAND";
      ;;
  esac

  echo

}

main() {
  lock $PIDFILE || eexit "Cannot acquire lock, giving up."

  print_configuration
  main_loop
}

main